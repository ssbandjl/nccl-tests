#!/bin/bash

# mlx5
# export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib

# export NCCL_DEBUG=TRACE
# export NCCL_IB_DISABLE=0
# export NCCL_NET=IB
# export NCCL_DEBUG_SUBSYS=ALL

# echo  'module mlx5_ib +p' > /sys/kernel/debug/dynamic_debug/control
# echo  'module mlx5_core +p' > /sys/kernel/debug/dynamic_debug/control

# xt
# export LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
export HUGE_PAGE_NUM=100
# export HUGE_PAGE_NUM=0
export XT_CQ_INLINE_CQE=0

#mlx
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib

# export NCCL_DEBUG=TRACE
# export NCCL_DEBUG=0
# export NCCL_IB_DISABLE=0
# export NCCL_NET=IB
# export NCCL_DEBUG_SUBSYS=ALL
export NCCL_IB_GID_INDEX=1

echo  'module xt_rdma +p' > /sys/kernel/debug/dynamic_debug/control
#nvprof /root/project/ai/nccl-tests/build/all_gather_perf -b 8 -e 1G -f 2 -g 1 # pass

/root/project/ai/nccl-tests/build/all_gather_perf -b 8 -e 1G -f 2 -g 1 # pass
# /root/project/ai/nccl-tests/build/all_reduce_perf -b 8 -e 1G -f 2 -g 1 # fail
# /root/project/ai/nccl-tests/build/alltoall_perf -b 8 -e 1G -f 2 -g 1 # pass ./build/alltoall_perf: symbol lookup error: ./build/alltoall_perf: undefined symbol: ncclRecv, fix: update nccl 2.5.7 to 2.8.3
# /root/project/ai/nccl-tests/build/broadcast_perf -b 8 -e 1G -f 2 -g 1 # pass
# /root/project/ai/nccl-tests/build/reduce_perf -b 8 -e 1G -f 2 -g 1 # fail
# /root/project/ai/nccl-tests/build/reduce_scatter_perf -b 8 -e 1G -f 2 -g 1 # fail
