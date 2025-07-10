# 总共np个MPI进程, 每个进程使用-g个GPU

log_file=log/13p/nccl_tests_$(date +'%Y_%m_%d_%H_%M_%S')_log
mpirun -np 8 -H 192.168.1.10:2,192.168.1.11:2 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=ALL \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1 > "$log_file" 2>&1