log_file=log/cx6dx/pytorch_train_$(date +'%Y_%m_%d_%H_%M_%S')_log

export NCCL_DEBUG=0 # INFO | TRACE | 0
export NCCL_DEBUG_SUBSYS=ALL
#export NCCL_SOCKET_IFNAME=ens4f0np0 #mlx5
# export NCCL_SOCKET_IFNAME=ens4f0
export NCCL_IB_DISABLE=0
export NCCL_IB_TIMEOUT=24
export NCCL_P2P_LEVEL=NVL
export OMP_NUM_THREADS=1
export NCCL_NET=IB
export NCCL_IB_HCA=mlx5_0
export NCCL_IB_GID_INDEX=3
export NCCL_IB_QPS_PER_CONNECTION=4
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True,max_split_size_mb:64

# mlx
export LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib:$LD_LIBRARY_PATH

# nproc_per_node: gpu_nums
source ~/deepseek-env/bin/activate
torchrun \
  --nproc_per_node=4 \
  --nnodes=2 \
  --node_rank=1 \
  --master_addr=192.168.1.10 \
  --master_port=12345 \
  train.py \
  --model_name_or_path "/root/big/llm/deepseek-coder-1.3b-base" \
  --deepspeed deepspeed_config.json \
  --per_device_train_batch_size 1 \
  --gradient_accumulation_steps 2 \
  --output_dir /root/big/llm/ds-output_1_3b \
  --fp16 > "$log_file" 2>&1
