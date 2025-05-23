clear
mpirun -np 4 -H 192.168.1.10:2,192.168.1.11:2 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=ALL \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1