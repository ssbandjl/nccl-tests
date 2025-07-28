你目前的训练已经**成功启动**，并且进入了 `Trainer` 的主循环。不过你遇到了两个核心问题需要注意：

---

### ✅ 当前状态总结

* ✅ DeepSpeed 初始化成功（NCCL 后端，FP16 启动正常）
* ✅ `fused_adam` 编译完成（30 秒加载正常）
* ✅ 模型开始迭代（可以看到进度条和每步耗时）
* ⚠️ 多次出现如下警告：

  ```bash
  [WARNING] [stage3.py:2164:step] 1 pytorch allocator cache flushes since last step.
  ```

---

## ⚠️ 主要警告解读及优化建议

### ⚠️ 1. `pytorch allocator cache flushes` 的警告

这说明 **你的 GPU 内存压力过大，PyTorch 被迫释放缓存以避免 OOM**，这对训练速度和稳定性非常不利。

#### 📌 原因可能是：

* 模型太大（1.3B + TP/DP 并行粒度不够细）
* `gradient_accumulation_steps` 不够大
* `train_micro_batch_size_per_gpu` 太大
* 你启用了 `zero_stage=3` 的参数 offload，但仍然内存紧张

#### ✅ 解决建议：

1. **降低 `train_micro_batch_size_per_gpu`**（比如从 4 → 2）

2. **提高 `gradient_accumulation_steps`**（如 4 → 8）

3. **在 Trainer 里加入内存同步清理：**

   ```python
   import torch
   from deepspeed.accelerator import get_accelerator

   def training_step(...):
       ...
       get_accelerator().empty_cache()  # 或 torch.cuda.empty_cache()
   ```

4. **确认你用的是 `bf16` or `fp16`**（你当前启用了 `fp16`，这很好）

---

### ⚠️ 2. `Gradient accumulation steps mismatch` 提示

```
Gradient accumulation steps mismatch: GradientAccumulationPlugin has 1, DeepSpeed config has 4. Using DeepSpeed's value.
```

这个不是报错，但意味着你在 `Trainer()` 初始化时传了 `gradient_accumulation_steps=1`，但 `deepspeed_config.json` 中设为 4。

✅ DeepSpeed 会覆盖 Trainer 的设置，所以只要你配置文件里是你期望的值，这个警告可以忽略。

---

### ⚠️ 3. `tokenizer` deprecated 警告

```
FutureWarning: `tokenizer` is deprecated and will be removed in version 5.0.0 for `Trainer.__init__`.
```

从 `transformers>=4.41` 开始，`Trainer(tokenizer=...)` 会被废弃。

✅ 建议改为传入 `preprocess_function` 或 `DataCollator`，但**不影响当前训练**。

---

## ✅ 建议你检查的内容

| 项目               | 检查项                 | 建议                 |
| ---------------- | ------------------- | ------------------ |
| 模型大小             | DeepSeek Coder 1.3B | TP/DP 并行策略是否合理？    |
| GPU 显存           | 显存是否充足？             | 推荐至少 24GB+ per GPU |
| micro batch size | 太大会引发 OOM           | 优先调小此项             |
| Zero Stage       | 你似乎用了 stage 3       | 看是否启用了 offload 参数  |
| 日志间隔             | `logging_steps` 频率？ | 设置较高值避免日志干扰        |
| 保存频率             | `save_steps`        | 避免频繁保存浪费资源         |

---

## ✅ 总结：当前没崩，但内存紧张

你训练是启动成功的，说明之前的 `tensor_parallel` 配置问题已解决，但：

* GPU 内存非常紧张
* 已触发 PyTorch 的缓存 flush
* 如果这种 flush 每步都出现，**训练速度会显著下降，甚至可能中途挂掉**

---

是否方便告诉我：

1. 使用的 GPU 型号和数量？
2. 你的 `deepspeed_config.json` 当前完整配置？
3. 想使用 DP、TP、ZeRO 的组合方式？

我可以帮你根据机器资源，出一个**最稳的分布式训练方案和配置文件**。要不要？


