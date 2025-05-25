xt:
--mca btl_openib_use_eager_rdma 1 --mca btl_openib_max_inline_data 256


export LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib
ldd ./build/all_gather_perf 

mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
  -bind-to none -map-by slot \
  --mca mtl ^ofi \
  --mca btl_openib_use_eager_rdma 1 --mca btl_openib_max_inline_data 256 \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x IB_QPS_PER_CONNECTION=2 \
  -x NCCL_DEBUG_SUBSYS=ALL \
  -x LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  /root/project/ai/nccl-tests/run_nccl_test.sh

mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  --allow-run-as-root \
  /root/project/ai/nccl-tests/run_nccl_test.sh


mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib \
  --allow-run-as-root \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1

mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/all_reduce_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/alltoall_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/broadcast_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/gather_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/hypercube_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/reduce_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/reduce_scatter_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/scatter_perf -b 8 -e 1G -f 2 -g 1


clear;mpirun -np 4 -H 192.168.1.10:1,192.168.1.11:1,192.168.2.10:1,192.168.2.11:1 \
  -bind-to none -map-by slot \
  -x NCCL_DEBUG=INFO \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x NCCL_DEBUG_SUBSYS=NET \
  -x LD_LIBRARY_PATH=/root/project/rdma/rdma-core/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  ./build/sendrecv_perf -b 8 -e 1G -f 2 -g 1



