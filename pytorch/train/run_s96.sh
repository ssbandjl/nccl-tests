log_file=pytorch_train_$(date +'%Y_%m_%d_%H_%M_%S')_log

export NCCL_DEBUG=INFO
export NCCL_DEBUG_SUBSYS=ALL
export NCCL_SOCKET_IFNAME=ens4f0np0
export NCCL_IB_DISABLE=0
export NCCL_P2P_LEVEL=NVL
export OMP_NUM_THREADS=1


python3 -m torch.distributed.launch \
  --nproc_per_node=1 \
  --nnodes=2 \
  --node_rank=1 \
  --master_addr=192.168.1.10 \
  --master_port=12345 \
  train4.py > "$log_file" 2>&1
