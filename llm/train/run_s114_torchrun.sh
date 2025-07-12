log_file=log/pytorch_train_$(date +'%Y_%m_%d_%H_%M_%S')_log

export NCCL_DEBUG=0 # INFO | TRACE | 0
export NCCL_DEBUG_SUBSYS=ALL
#export NCCL_SOCKET_IFNAME=ens4f0np0 #mlx5
# export NCCL_SOCKET_IFNAME=ens4f0
export NCCL_IB_DISABLE=0
export NCCL_IB_TIMEOUT=24
export NCCL_P2P_LEVEL=NVL
export OMP_NUM_THREADS=1
export NCCL_NET=IB
export NCCL_IB_HCA=xtrdma_0
export NCCL_IB_GID_INDEX=1
export NCCL_IB_QPS_PER_CONNECTION=4
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

# xt
export LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib:$LD_LIBRARY_PATH
export HUGE_PAGE_NUM=100
# export HUGE_PAGE_NUM=0
export XT_CQ_INLINE_CQE=0
# export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnccl.so.2.8.3

# nproc_per_node: gpu_nums
# model_name_or_path deepseek-ai/deepseek-llm-7b-base, If it is a filepath on disc, it loads the model from that path. If it is not a path, it first tries to download a pre-trained SentenceTransformer model. If that fails, tries to construct a model from the Hugging Face Hub with that name
source ~/deepseek-env/bin/activate
torchrun \
  --nproc_per_node=1 \
  --nnodes=2 \
  --node_rank=0 \
  --master_addr=192.168.1.10 \
  --master_port=12345 \
  train.py \
  --model_name_or_path "/root/big/deepseek-llm-7b-base" \
  --deepspeed deepspeed_config.json \
  --output_dir /root/big/llm/ds-output \
  --fp16 > "$log_file" 2>&1

# python3 -m torch.distributed.launch \
#   --nproc_per_node=1 \
#   --nnodes=2 \
#   --node_rank=0 \
#   --master_addr=192.168.1.10 \
#   --master_port=12345 \
#   train3.py > "$log_file" 2>&1
