#!/bin/bash
# Detect host, set correct NIC name
if [[ $(hostname) == "s114" ]]; then
  export NCCL_SOCKET_IFNAME=enp129s0f0
  export NCCL_IB_HCA=enp137s0f0np0
elif [[ $(hostname) == "s116" ]]; then
  export NCCL_SOCKET_IFNAME=enp129s0f0
  export NCCL_IB_HCA=enp4s0f0np0
fi

export NCCL_DEBUG=TRACE
export NCCL_DEBUG_SUBSYS=NET
# export NCCL_DEBUG_SUBSYS=ALL
export NCCL_IB_GID_INDEX=3
export LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl/build/lib
cd /root/project/ai/nccl-tests
./build/all_gather_perf -b 8 -e 512M -f 2 -g 1
