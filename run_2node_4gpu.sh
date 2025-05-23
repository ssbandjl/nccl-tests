export MASTER_ADDR=192.168.1.10
export MASTER_PORT=12345   # Must match on all processes
export WORLD_SIZE=4
export NCCL_LAUNCH_MODE=GROUP
export NCCL_SOCKET_IFNAME=enp129s0f0   # Or your network interface
export NCCL_IB_HCA=enp137s0f0np0
export NCCL_DEBUG=TRACE
# export NCCL_DEBUG_SUBSYS=ALL
export NCCL_DEBUG_SUBSYS=NET
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl/build/lib

# Start 2 processes, one for each GPU
CUDA_VISIBLE_DEVICES=0 \
RANK=0 \
./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1 &

CUDA_VISIBLE_DEVICES=1 \
RANK=1 \
./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1 &