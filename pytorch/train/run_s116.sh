log_file=pytorch_train_$(date +'%Y_%m_%d_%H_%M_%S')_log

export NCCL_DEBUG=0
export NCCL_DEBUG_SUBSYS=ALL
# export NCCL_SOCKET_IFNAME=ens4f0np0
export NCCL_IB_DISABLE=0
export NCCL_P2P_LEVEL=NVL
export OMP_NUM_THREADS=1
export NCCL_NET=IB
export NCCL_IB_HCA=xtrdma_0
export NCCL_IB_GID_INDEX=1
export NCCL_IB_QPS_PER_CONNECTION=4
export LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib:$LD_LIBRARY_PATH
export HUGE_PAGE_NUM=100
# export HUGE_PAGE_NUM=0
export XT_CQ_INLINE_CQE=0

source ~/pytorch-venv/bin/activate
python3 -m torch.distributed.launch \
  --nproc_per_node=4 \
  --nnodes=2 \
  --node_rank=1 \
  --master_addr=192.168.1.10 \
  --master_port=12345 \
  train4.py > "$log_file" 2>&1
