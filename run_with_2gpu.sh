mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x NCCL_NET_GDR_LEVEL=2 \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  /root/project/ai/nccl-tests/build/all_gather_perf -b 8 -e 1G -f 2 -g 1 >> all_gather_perf_2gpu_log