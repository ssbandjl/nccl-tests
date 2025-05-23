# # export NCCL_SOCKET_IFNAME=enp137s0f0np0
# export NCCL_IB_GID_INDEX=3
# export NCCL_DEBUG=TRACE
# export NCCL_LAUNCH_MODE=GROUP
# export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
# export RANK=0
# export WORLD_SIZE=2
# export MASTER_ADDR=192.168.1.10
# export MASTER_PORT=12345
# export NCCL_IB_HCA=enp137s0f0np0
# cd /root/project/ai/nccl-tests
# ./build/all_reduce_perf -b 8 -e 512M -f 2 -g 1


export NCCL_DEBUG=TRACE
export NCCL_SOCKET_IFNAME=enp137s0f0np0
export NCCL_IB_HCA=enp137s0f0np0
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
/root/project/ai/nccl-tests/build/all_reduce_perf -b 8 -e 512M -f 2 -g 1