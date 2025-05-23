export NCCL_LAUNCH_MODE=PARALLEL
export NCCL_DEBUG=INFO
export NCCL_IB_DISABLE=0
export NCCL_NET=IB
export NCCL_DEBUG_SUBSYS=NET
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
export NCCL_NET_GDR_LEVEL=2


# On 192.168.1.10
CUDA_VISIBLE_DEVICES=0 NCCL_RANK=0 NCCL_LOCAL_RANK=0 NCCL_WORLD_SIZE=4 NCCL_UNIQUE_ID=$(cat /root/project/ai/nccl-tests/uid) \
./build/all_reduce_perf -b 8 -e 1G -f 2 -g 1 &

CUDA_VISIBLE_DEVICES=1 NCCL_RANK=1 NCCL_LOCAL_RANK=1 NCCL_WORLD_SIZE=4 NCCL_UNIQUE_ID=$NCCL_UNIQUE_ID \
./build/all_reduce_perf -b 8 -e 1G -f 2 -g 1 &
