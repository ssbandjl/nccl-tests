#!/bin/bash

export LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
export HUGE_PAGE_NUM=100
export XT_CQ_INLINE_CQE=0

export NCCL_DEBUG=TRACE
export NCCL_IB_DISABLE=0
export NCCL_NET=IB
export NCCL_DEBUG_SUBSYS=ALL
export NCCL_IB_GID_INDEX=1

echo  'module xt_rdma +p' > /sys/kernel/debug/dynamic_debug/control

/root/project/ai/nccl-tests/build/all_gather_perf -b 8 -e 1G -f 2 -g 1
