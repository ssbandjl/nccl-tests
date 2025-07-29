: <<'COMMENT'
all_gather_perf
all_reduce_perf, slow and loss pkt
alltoall_perf, failed, need config small qps, NCCL_IB_QPS_PER_CONNECTION=1
broadcast_perf
gather_perf
hypercube_perf, failed, slow, retry
reduce_perf, failed, slow, 
reduce_scatter_perf, pass
scatter_perf
sendrecv_perf
总共np个MPI进程, 每个进程使用-g个GPU

unset DISPLAY
export HWLOC_PLUGINS_BLACKLIST="gl,nvml"

# Ref NCCL ENV
export NCCL_ALGO=Ring | Tree
export NCCL_PROTO=LL | Simple | LL128

CUDA_VISIBLE_DEVICES=1

COMMENT

ALGO_LIST="all_reduce_perf"
ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
ALGO_LIST="all_reduce_perf"
mkdir -p log/13p/2dpu/
for algo in ${ALGO_LIST};do
  log_file=log/13p/2dpu/nccl_tests_${algo}_13p_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
	echo $algo
	echo $log_file
  mpirun -np 4 -H 192.168.1.10:2,192.168.1.11:2,192.168.2.10:2,192.168.2.11:2 \
    -x NCCL_DEBUG=TRACE \
    -x NCCL_DEBUG_SUBSYS=NET \
    -x NCCL_IB_DISABLE=0 \
    -x NCCL_NET=IB \
    -x NCCL_IB_TIMEOUT=24 \
    -x NCCL_IB_HCA=xtrdma_0:1,xtrdma_4:1 \
    -x NCCL_IB_GID_INDEX=1 \
    -x NCCL_NET_GDR_LEVEL=SYS \
    -x NCCL_IB_QPS_PER_CONNECTION=4 \
    -x NCCL_ALGO=Ring \
    -x NCCL_PROTO=Simple \
    -x NCCL_GDR_FLUSH_DISABLE=1 \
    -x NCCL_MAX_NCHANNELS=1 \
    -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
    -x HUGE_PAGE_NUM=100 \
    -x XT_CQ_INLINE_CQE=0 \
    -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
    --allow-run-as-root \
    /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
done

# ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
# for algo in ${ALGO_LIST};do
#   log_file=log/13p/nccl_tests_${algo}_13p_u24_k61x_$(date +'%Y_%m_%d_%H_%M_%S')_log
# 	echo $algo
# 	echo $log_file
#   mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
#     -bind-to none -map-by slot \
#     -x NCCL_DEBUG=0 \
#     -x NCCL_IB_DISABLE=0 \
#     -x NCCL_NET=IB \
#     -x NCCL_IB_TIMEOUT=24 \
#     -x NCCL_IB_HCA=xtrdma_0 \
#     -x NCCL_IB_GID_INDEX=1 \
#     -x NCCL_NET_GDR_LEVEL=SYS \
#     -x NCCL_IB_QPS_PER_CONNECTION=2 \
#     -x NCCL_DEBUG_SUBSYS=ALL \
#     -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#     -x HUGE_PAGE_NUM=100 \
#     -x XT_CQ_INLINE_CQE=0 \
#     -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
#     --allow-run-as-root \
#     /root/project/ai/nccl-tests/build/${algo} -b 8 -e 1G -w 30 -f 2 -g 1 > "$log_file" 2>&1
# done


# single note test: 
# ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1

# mpirun -np 8 -H 192.168.1.10:4,192.168.1.11:4 \
#   -bind-to none -map-by slot \
#   -x NCCL_DEBUG=INFO \
#   -x NCCL_IB_DISABLE=0 \
#   -x NCCL_NET=IB \
#   -x NCCL_IB_HCA=xtrdma_0 \
#   -x NCCL_DEBUG_SUBSYS=ALL \
#   -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#   -x NCCL_IB_GID_INDEX=1 \
#   -x HUGE_PAGE_NUM=50 \
#   -x XT_CQ_INLINE_CQE=0 \
#   -x IB_QPS_PER_CONNECTION=8 \
#   --allow-run-as-root \
#   ./build/all_gather_perf -b 8 -e 1G -f 2 -g 1 > "$log_file" 2>&1


# mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
#   -bind-to none -map-by slot \
#   -x NCCL_DEBUG=0 \
#   -x NCCL_IB_DISABLE=0 \
#   -x NCCL_NET=IB \
#   -x NCCL_IB_HCA=xtrdma_0 \
#   -x NCCL_DEBUG_SUBSYS=ALL \
#   -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#   -x NCCL_IB_GID_INDEX=1 \
#   -x HUGE_PAGE_NUM=50 \
#   -x XT_CQ_INLINE_CQE=0 \
#   -x IB_QPS_PER_CONNECTION=1 \
#   --allow-run-as-root \
#   /root/project/ai/nccl-tests/build/all_reduce_perf -b 8 -e 64K -f 2 -g 1 > "$log_file" 2>&1

# mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
#   -bind-to none -map-by slot \
#   -x NCCL_DEBUG=0 \
#   -x NCCL_IB_DISABLE=0 \
#   -x NCCL_NET=IB \
#   -x NCCL_IB_HCA=xtrdma_0 \
#   -x NCCL_DEBUG_SUBSYS=ALL \
#   -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#   -x NCCL_IB_GID_INDEX=1 \
#   -x HUGE_PAGE_NUM=50 \
#   -x XT_CQ_INLINE_CQE=0 \
#   -x IB_QPS_PER_CONNECTION=1 \
#   --allow-run-as-root \
#   /root/project/ai/nccl-tests/build/all_gather_perf -b 8 -e 1G -f 2 -g 1 > "$log_file" 2>&1

# mpirun -np 8 -H 192.168.1.10:4,192.168.1.11:4 \
#   -bind-to none -map-by slot \
#   -x NCCL_DEBUG=INFO \
#   -x NCCL_IB_DISABLE=0 \
#   -x NCCL_NET=IB \
#   -x NCCL_IB_HCA=xtrdma_0 \
#   -x NCCL_DEBUG_SUBSYS=ALL \
#   -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#   -x NCCL_IB_GID_INDEX=1 \
#   -x HUGE_PAGE_NUM=50 \
#   -x XT_CQ_INLINE_CQE=0 \
#   -x IB_QPS_PER_CONNECTION=8 \
#   --allow-run-as-root \
#   ./build/alltoall_perf -b 8 -e 1G -f 2 -g 1 > "$log_file" 2>&1
