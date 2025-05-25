#!/bin/bash

export LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib
export HUGE_PAGE_NUM=100
export XT_CQ_INLINE_CQE=0

/root/project/ai/nccl-tests/build/all_gather_perf -b 8 -e 1G -f 2 -g 1
