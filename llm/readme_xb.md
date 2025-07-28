# DP/EP/TP并行配置参考
在大模型训练中，**DP（Data Parallel）、EP（Expert Parallel）、TP（Tensor Parallel）** 是常用的并行策略。若要“分离执行”这三者，通常是指：

* 每种并行度用不同的 rank 划分并分别调度；
* 合理使用框架（如 DeepSpeed、Megatron-LM、Colossal-AI）进行组合；
* 脚本层面上明晰不同 rank 的职责（哪部分负责 TP、哪部分负责 EP、哪部分负责 DP）；

下面我们以 **DeepSpeed + Megatron-LM** 为例，给出一个支持 DP/TP/EP 分离执行的训练脚本模板，并解释关键字段。

---

## ✅ 1. 概念关系

| 并行类型   | 作用                                     | 通常划分           |
| ------ | -------------------------------------- | -------------- |
| **DP** | 数据样本切分，负责梯度同步                          | 最外层并行度         |
| **TP** | 模型张量切分，处理 transformer 层内部矩阵计算          | Megatron-LM 支持 |
| **EP** | MoE 的 expert 分布在多个进程上，专门负责 MLP/MoE 子网络 | 通常与 DP 并列      |

---

## ✅ 2. 启动命令样例（DeepSpeed + Megatron）

```bash
#!/bin/bash

NNODES=2
GPUS_PER_NODE=8
WORLD_SIZE=$(($NNODES * $GPUS_PER_NODE))

TP=2
EP=4
DP=$(($WORLD_SIZE / $TP / $EP))

deepspeed --num_nodes $NNODES --num_gpus $GPUS_PER_NODE \
  --master_addr $MASTER_ADDR --master_port $MASTER_PORT \
  pretrain_gpt.py \
  --deepspeed \
  --deepspeed_config ds_config.json \
  --tensor-model-parallel-size $TP \
  --pipeline-model-parallel-size 1 \
  --moe-expert-parallel-size $EP \
  --micro-batch-size 2 \
  --global-batch-size 128 \
  --use-mcore-models \
  --num-layers 32 \
  --hidden-size 4096 \
  --num-attention-heads 32 \
  --seq-length 2048 \
  --max-position-embeddings 2048 \
  --train-iters 320000 \
  --data-path my_data \
  --vocab-file vocab.json \
  --merge-file merges.txt
```

---

## ✅ 3. 配置解释

| 参数                               | 说明                                              |
| -------------------------------- | ----------------------------------------------- |
| `--tensor-model-parallel-size`   | TP 大小，张量维度划分（如 2 表示横向拆成两部分）                     |
| `--moe-expert-parallel-size`     | EP 大小，MoE expert 会划分到不同 rank 上执行                |
| `--pipeline-model-parallel-size` | 如果不使用 PP，设置为 1                                  |
| `--micro-batch-size`             | 每个设备上的 batch size                               |
| `--global-batch-size`            | 总体 batch size，需满足：G = MB × DP × Accumulate step |

注意：**DP 数量 = 世界总进程数 ÷ TP ÷ EP**

---

## ✅ 4. 深度支持联合并行的框架

| 框架                     | 支持哪些组合                         |
| ---------------------- | ------------------------------ |
| **Megatron-DeepSpeed** | 支持 TP + EP + DP 完全分离           |
| **Colossal-AI**        | 支持 TP/PP/DP/MoE，并有自动分布 planner |
| **FairScale**          | 支持 ZeRO/TP                     |
| **FSDP + TP + MoE**    | 实验组合，一般不推荐                     |

---

## ✅ 5. 进阶建议

* **绑定映射**：使用 `hostfile` 或 `CUDA_VISIBLE_DEVICES` 精确绑定不同 rank 到不同 GPU，确保 TP/EP rank 不在同一个 NUMA 上。
* **日志排查**：可以设置 `--log-level DEBUG` 输出不同并行组（tensor group, expert group, data group）映射。
* **EP/TP通信优化**：用 NCCL 分组隔离通信，避免组间干扰。

---

## ✅ 6. 参考配置文件（ds\_config.json）

```json
{
  "train_batch_size": 128,
  "train_micro_batch_size_per_gpu": 2,
  "gradient_accumulation_steps": 8,
  "zero_optimization": {
    "stage": 1
  },
  "moe": {
    "enabled": true,
    "expert_parallel_size": 4,
    "num_experts": 16,
    "top_k": 2
  },
  "tensor_parallel": {
    "tp_size": 2
  },
  "fp16": {
    "enabled": true
  }
}
```

---

如果你现在是自己组网做分布式训练、或在 MoE 模型（如 DeepSeekMoE）上搞实验，我可以帮你生成你实际硬件（几台服务器、每台几张卡）的完整并行配置和脚本，要不要我继续帮你定制一份？



# 2节点参考配置

你现在部署的是 **2 节点，每节点 4 GPU + 1 DPU** 的训练集群，总共 **8 GPU**。如果你要在这种架构上实现 **DP / EP / TP 并行分离执行**，我们可以通过合理配置 DeepSpeed + Megatron-LM 实现。以下是完整脚本和详细解释。

---

## ✅ 并行设计目标

我们总共有 **8 个 GPU**，目标是：

| 并行类型   | 值                                           | 说明                        |
| ------ | ------------------------------------------- | ------------------------- |
| TP     | 2                                           | 模型张量切分（比如 attention 的权重）  |
| EP     | 2                                           | MoE expert 分布在不同 rank 上执行 |
| DP     | 2                                           | 数据并行组（最终梯度同步）             |
| 总 rank | 2（DP）× 2（EP）× 2（TP） = **8 rank**，正好对应 8 GPU |                           |

你也可以改为 TP=4, EP=1, DP=2，或其他组合，原则是：
`总rank = TP × EP × DP = GPU 总数`

---

## ✅ 启动脚本（2节点，每节点4 GPU）

```bash
#!/bin/bash

NNODES=2
GPUS_PER_NODE=4
TP=2
EP=2
DP=$(( (NNODES * GPUS_PER_NODE) / (TP * EP) ))   # = 2

MASTER_ADDR="node0_ip"
MASTER_PORT=6000

deepspeed --num_nodes $NNODES --num_gpus $GPUS_PER_NODE \
  --master_addr $MASTER_ADDR --master_port $MASTER_PORT \
  pretrain_gpt.py \
  --deepspeed \
  --deepspeed_config ds_config.json \
  --tensor-model-parallel-size $TP \
  --pipeline-model-parallel-size 1 \
  --moe-expert-parallel-size $EP \
  --micro-batch-size 4 \
  --global-batch-size 32 \
  --num-layers 24 \
  --hidden-size 2048 \
  --num-attention-heads 16 \
  --seq-length 1024 \
  --max-position-embeddings 1024 \
  --train-iters 50000 \
  --data-path data-bin \
  --vocab-file vocab.json \
  --merge-file merges.txt \
  --use-mcore-models \
  --log-interval 10
```

---

## ✅ DeepSpeed 配置文件（`ds_config.json`）

```json
{
  "train_batch_size": 32,
  "train_micro_batch_size_per_gpu": 4,
  "gradient_accumulation_steps": 4,
  "fp16": {
    "enabled": true
  },
  "zero_optimization": {
    "stage": 1
  },
  "moe": {
    "enabled": true,
    "expert_parallel_size": 2,
    "num_experts": 8,
    "top_k": 2
  },
  "tensor_parallel": {
    "tp_size": 2
  }
}
```

---

## ✅ rank 分配逻辑

总 rank = 8，每个 rank 执行：

* 被分成 TP group（2个组 × 4 rank）：负责模型张量划分
* 被分成 EP group（2个组 × 4 rank）：负责 MoE expert 的分布式调度
* 被分成 DP group（2个组 × 4 rank）：执行全模型参数的同步更新

示意：

```
DP组0：
  Rank 0: TP0, EP0
  Rank 1: TP1, EP0
  Rank 2: TP0, EP1
  Rank 3: TP1, EP1

DP组1：
  Rank 4: TP0, EP0
  Rank 5: TP1, EP0
  Rank 6: TP0, EP1
  Rank 7: TP1, EP1
```

---

## ✅ 多节点运行建议

* 确保 `hostfile` 正确，或者通过环境变量设置主节点 IP（`MASTER_ADDR`）和端口。

* 每节点绑定 GPU，比如：

  节点0：

  ```bash
  CUDA_VISIBLE_DEVICES=0,1,2,3 bash run.sh
  ```

  节点1：

  ```bash
  CUDA_VISIBLE_DEVICES=0,1,2,3 bash run.sh
  ```

* 如果你使用 DPU 作为通信加速（如 BlueField/Mooncake），只要你正确设置了 NCCL\_SOCKET\_IFNAME 与路由，仍然可以无感知使用 NCCL over RoCE。

---

## ✅ 建议启用 NCCL 分组调试

可增加环境变量观察 DP/EP/TP 分组：

```bash
export NCCL_DEBUG=INFO
export NCCL_TOPO_DUMP_FILE=nccl_topo.xml
export NCCL_GRAPH_DUMP_FILE=nccl_graph.xml
```

---

## ✅ 进阶选项（MoE 模型）

* `--top_k`: 每个 token 选择几个 expert，一般为 2
* `--num-experts`: expert 总数可以大于 EP，按需划分
* `--moe-param-group`: 必须设置以避免 MoE 参数被错误归类

---

如果你告诉我你训练的是哪个模型（如 DeepSeekMoE, SwitchTransformer 等），我可以进一步定制具体的 `MoE 配置`、`模型结构参数` 和 `并行规划图`。是否继续？




# deepspeed 两节点启动参考

你有 2 个节点，每个节点配 1 个 DPU + 4 个 GPU，总共：

* **8 个 GPU**
* **2 个 DPU**
* 每个节点内可以进行 **Tensor Parallel（TP）**
* 节点间可以做 **Data Parallel（DP）**
* DPU 用于执行 **Embedding Parallel（EP）**（如放 embedding 层）

你想用 PyTorch + DeepSeek 模型做训练（可能是 `DeepSeek-V2` 或 `DeepSeek-Coder` 之类的大模型），并想实现 DP/EP/TP 并行混合，下面是完整方案：

---

## 🧠 分布式并行设计

| 并行方式   | 范围         | 作用                   |
| ------ | ---------- | -------------------- |
| **TP** | 节点内（4 GPU） | 加速 Transformer 前向和反向 |
| **DP** | 节点间（2 节点）  | 复制模型，处理不同数据          |
| **EP** | DPU 上运行    | Embedding 层处理（可选）    |

---

## 📦 硬件拓扑

```
Node-0:
  - DPU-0
  - GPU-0, GPU-1, GPU-2, GPU-3

Node-1:
  - DPU-1
  - GPU-4, GPU-5, GPU-6, GPU-7
```

---

## 🧰 使用 DeepSpeed + DeepSeek + PyTorch + NCCL + MPI

使用 DeepSpeed 启动训练时，结合 TP + DP + EP：

---

## 🧾 启动脚本（假设你在两节点上用 `hostfile` 或 MPI 启动）

### 1. `deepspeed` 启动命令（推荐 MPI 启动方式）

```bash
deepspeed --num_nodes=2 --num_gpus=8 \
    --hostfile ./hostfile \
    --module train \
    --deepspeed ds_config.json \
    --tp_size 4 \
    --ep_size 2 \
    --dp_size 2 \
    --use_dpu_embedding
```

其中：

* `tp_size=4`：每节点内使用 4-way TP
* `dp_size=2`：跨两个节点做 DP
* `ep_size=2`：两个 DPU 分别处理 Embedding（假设通过 EP-offload 实现）
* `--use_dpu_embedding`：控制 embedding 是否 offload 到 DPU（你可用自定义模块）

---

### 2. `ds_config.json` 示例（核心部分）

```json
{
  "train_batch_size": 64,
  "gradient_accumulation_steps": 1,
  "zero_optimization": {
    "stage": 3,
    "offload_param": {
      "device": "cpu"
    }
  },
  "fp16": {
    "enabled": true
  },
  "tensor_parallel": {
    "tp_size": 4
  },
  "embedding_parallel": {
    "ep_size": 2
  },
  "dpu_embedding": {
    "enabled": true,
    "backend": "custom_dpu",   // 可替换成你的自定义 DPU ep 实现名
    "device_map": {
      "node0": "dpu0",
      "node1": "dpu1"
    }
  }
}
```

---

### 3. DeepSeek 模型载入逻辑（参考）

```python
from deepseek.models import DeepseekModel

model = DeepseekModel.from_pretrained(
    "deepseek-ai/deepseek-coder-1.3b",
    tensor_parallel_size=4,
    embedding_parallel_size=2
)

model = deepspeed.initialize(model=model, config=ds_config)
```

---

## ⚙️ 工作原理解释

1. **TP (Tensor Parallel)**：

   * 4 GPU/节点并行前向 + 反向
   * 同步梯度，减少显存使用
2. **DP (Data Parallel)**：

   * 每个节点训练不同 batch 样本
   * 梯度平均
3. **EP (Embedding Parallel)**：

   * Embedding 层 offload 到 DPU（如 ID lookup、embedding gather、output scatter）
   * 可减少 embedding 参数拷贝/显存占用，且用 DPU 专用通信协议加速 embedding 交换

---

## 📌 注意事项

* 你需要 patch DeepSpeed/DeepSeek，支持自定义 EP backend（DPU）
* 两节点间 GPU 通信使用 NCCL，DPU 通信（EP）走 RoCE 或 DPA 网络
* DPU 上需运行 OpenRTOS 或你已有 firmware，支持 embedding 请求的处理

---

如果你希望我也提供一个 **简化 demo 脚本（不启用真正 DPU，仅模拟 EP 逻辑）**，我可以继续给出。

需要吗？




