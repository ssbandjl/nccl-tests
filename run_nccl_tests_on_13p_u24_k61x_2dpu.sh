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

NCCL_IB_HCA=xtrdma_0:1,xtrdma_4:1, Use ports 1 of cards
--oversubscribe
--mca btl ^vader,ofi
--mca btl_ofi_verbose 100 \
--mca btl_base_verbose 100 \
/usr/local/bin/mpirun
-x FI_PROVIDER=rxm
    --mca btl_tcp_if_include 192.168.1.0/24 \
COMMENT


export FI_LOG_LEVEL=debug
export LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib
export HUGE_PAGE_NUM=100
export XT_CQ_INLINE_CQE=0
export XT_CQ_INLINE_CQE=0

ALGO_LIST="all_reduce_perf"
ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
ALGO_LIST="all_reduce_perf"
mkdir -p log/13p/2dpu/
for algo in ${ALGO_LIST};do
  log_file=log/13p/2dpu/nccl_tests_${algo}_13p_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
	echo $algo
	echo $log_file
    mpirun -np 8 -H 192.168.1.10:2,192.168.1.11:2,192.168.2.10:2,192.168.2.11:2 -bind-to core -map-by node --report-bindings --allow-run-as-root \
    --mca btl ^vader,ofi \
    --mca btl_ofi_verbose 100 \
    --mca btl_base_verbose 100 \
    -x FI_PROVIDER_PATH=/usr/local \
    -x NCCL_DEBUG=TRACE \
    -x FI_GID_INDEX=1 \
    -mca btl_tcp_if_include 192.168.1.0/24,192.168.2.0/24 \
    -x FI_LOG_LEVEL=debug \
    -x NCCL_DEBUG_SUBSYS=INIT,NET \
    -x NCCL_IB_DISABLE=0 \
    -x NCCL_NET=IB \
    -x NCCL_IB_TIMEOUT=24 \
    -x NCCL_IB_HCA=xtrdma_0:1,xtrdma_1:1\
    -x NCCL_IB_GID_INDEX=1 \
    -x NCCL_NET_GDR_LEVEL=SYS \
    -x NCCL_IB_QPS_PER_CONNECTION=4 \
    -x NCCL_GDR_FLUSH_DISABLE=1 \
    -x NCCL_MAX_NCHANNELS=4 \
    -x NCCL_IB_TIMEOUT=22 \
    -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
    -x HUGE_PAGE_NUM=20 \
    -x XT_CQ_INLINE_CQE=0 \
    -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
    -x NCCL_DEBUG=INFO -x NCCL_DEBUG_SUBSYS=INIT \
    /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
done



#tcp测试成功
# mkdir -p log/13p/2dpu/
# for algo in ${ALGO_LIST};do
#   log_file=log/13p/2dpu/nccl_tests_${algo}_13p_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
# 	echo $algo
# 	echo $log_file
#     mpirun -np 8 -H 192.168.1.10:2,192.168.1.11:2,192.168.2.10:2,192.168.2.11:2  -bind-to core -map-by node  --report-bindings  --allow-run-as-root \
#     --mca btl ^vader,ofi \
#     --mca btl_ofi_verbose 100 \
#     --mca btl_base_verbose 100 \
#     -x NCCL_DEBUG=INFO \
#     -x FI_GID_INDEX=1 \
#     -mca btl_tcp_if_include 192.168.1.0/24,192.168.2.0/24 \
#     -x FI_LOG_LEVEL=debug \
#     -x NCCL_DEBUG_SUBSYS=INIT,NET \
#     -x NCCL_IB_DISABLE=0 \
#     -x NCCL_NET=IB \
#     -x NCCL_IB_TIMEOUT=24 \
#     -x NCCL_IB_HCA=xtrdma_0:1,xtrdma_1:1\
#     -x NCCL_IB_GID_INDEX=1 \
#     -x NCCL_NET_GDR_LEVEL=SYS \
#     -x NCCL_IB_QPS_PER_CONNECTION=2 \
#     -x NCCL_GDR_FLUSH_DISABLE=1 \
#     -x NCCL_MAX_NCHANNELS=4 \
#     -x NCCL_IB_TIMEOUT=22 \
#     -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#     -x HUGE_PAGE_NUM=20 \
#     -x XT_CQ_INLINE_CQE=0 \
#     -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
#     -x NCCL_DEBUG=INFO -x NCCL_DEBUG_SUBSYS=INIT \
#     /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
# done

# ALGO_LIST="all_reduce_perf"
# ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
# ALGO_LIST="all_reduce_perf"
# mkdir -p log/13p/2dpu/
# for algo in ${ALGO_LIST};do
#   log_file=log/13p/2dpu/nccl_tests_${algo}_13p_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
# 	echo $algo
# 	echo $log_file
#     mpirun -np 4 -H 192.168.1.10:1,192.168.2.10:1,192.168.1.11:1,192.168.2.11:1 -bind-to core --map-by core --mca btl ^tcp --report-bindings \
#     --mca btl_ofi_verbose 100 \
#     --mca btl_base_verbose 100 \
#     -x NCCL_DEBUG=TRACE \
#     -x FI_LOG_LEVEL=debug \
#     -x NCCL_DEBUG_SUBSYS=NET \
#     -x NCCL_IB_DISABLE=0 \
#     -x NCCL_NET=IB \
#     -x NCCL_IB_TIMEOUT=24 \
#     -x NCCL_IB_HCA=xtrdma_0:1,xtrdma_1:1 \
#     -x NCCL_IB_GID_INDEX=1 \
#     -x NCCL_NET_GDR_LEVEL=SYS \
#     -x NCCL_IB_QPS_PER_CONNECTION=2 \
#     -x NCCL_GDR_FLUSH_DISABLE=1 \
#     -x NCCL_MAX_NCHANNELS=4 \
#     -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#     -x HUGE_PAGE_NUM=20 \
#     -x XT_CQ_INLINE_CQE=0 \
#     -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
#     --allow-run-as-root \
#     /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
# done

# ALGO_LIST="all_reduce_perf"
# ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
# ALGO_LIST="all_reduce_perf"
# mkdir -p log/13p/2dpu/
# for algo in ${ALGO_LIST};do
#   log_file=log/13p/2dpu/nccl_tests_${algo}_13p_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
# 	echo $algo
# 	echo $log_file
#     mpirun -np 8 -H 192.168.1.10:2,192.168.2.10:2,192.168.1.11:2,192.168.2.11:2 -bind-to core -map-by slot --mca btl ^vader --oversubscribe --mca btl_openib_cpc_include rdmacm --report-bindings \
#     --mca btl_ofi_verbose 100 \
#     --mca btl_base_verbose 100 \
#     -x NCCL_DEBUG=TRACE \
#     -x FI_LOG_LEVEL=debug \
#     -x NCCL_DEBUG_SUBSYS=NET \
#     -x NCCL_IB_DISABLE=0 \
#     -x NCCL_NET=IB \
#     -x NCCL_IB_TIMEOUT=24 \
#     -x NCCL_IB_HCA=xtrdma_0:1,xtrdma_4:1 \
#     -x NCCL_IB_GID_INDEX=1 \
#     -x NCCL_NET_GDR_LEVEL=SYS \
#     -x NCCL_IB_QPS_PER_CONNECTION=4 \
#     -x NCCL_GDR_FLUSH_DISABLE=1 \
#     -x NCCL_MAX_NCHANNELS=4 \
#     -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#     -x HUGE_PAGE_NUM=20 \
#     -x XT_CQ_INLINE_CQE=0 \
#     -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
#     --allow-run-as-root \
#     /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
# done


# ALGO_LIST="all_reduce_perf"
# ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
# ALGO_LIST="all_reduce_perf"
# mkdir -p log/13p/2dpu/
# for algo in ${ALGO_LIST};do
#   log_file=log/13p/2dpu/nccl_tests_${algo}_13p_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
# 	echo $algo
# 	echo $log_file
#   mpirun -np 8 -H 192.168.1.10:2,192.168.2.10:2,192.168.1.11:2,192.168.2.11:2 -bind-to core -map-by slot --oversubscribe --mca btl ^vader --report-bindings \
#     --mca btl_ofi_verbose 100 \
#     --mca btl_base_verbose 100 \
#     -x NCCL_DEBUG=TRACE \
#     -x NCCL_DEBUG_SUBSYS=NET \
#     -x NCCL_IB_DISABLE=0 \
#     -x NCCL_NET=IB \
#     -x NCCL_IB_TIMEOUT=24 \
#     -x NCCL_IB_HCA=xtrdma_0:1,xtrdma_4:1 \
#     -x NCCL_IB_GID_INDEX=1 \
#     -x NCCL_NET_GDR_LEVEL=SYS \
#     -x NCCL_IB_QPS_PER_CONNECTION=4 \
#     -x NCCL_GDR_FLUSH_DISABLE=1 \
#     -x NCCL_MAX_NCHANNELS=4 \
#     -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#     -x HUGE_PAGE_NUM=20 \
#     -x XT_CQ_INLINE_CQE=0 \
#     -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
#     --allow-run-as-root \
#     /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
# done


# ALGO_LIST="all_reduce_perf"
# ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
# ALGO_LIST="all_reduce_perf"
# mkdir -p log/13p/2dpu/
# for algo in ${ALGO_LIST};do
#   log_file=log/13p/2dpu/nccl_tests_${algo}_13p_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
# 	echo $algo
# 	echo $log_file
#   mpirun -np 8 -H 192.168.1.10:2,192.168.2.10:2,192.168.1.11:2:192.168.2.11:2 -bind-to core --map-by slot --oversubscribe  --mca btl ^vader --report-bindings \
#     -x NCCL_DEBUG=TRACE \
#     -x NCCL_DEBUG_SUBSYS=NET \
#     -x NCCL_IB_DISABLE=0 \
#     -x NCCL_NET=IB \
#     -x NCCL_IB_TIMEOUT=24 \
#     -x NCCL_IB_HCA=xtrdma_0:1,xtrdma_4:1 \
#     -x NCCL_IB_GID_INDEX=1 \
#     -x NCCL_NET_GDR_LEVEL=SYS \
#     -x NCCL_IB_QPS_PER_CONNECTION=4 \
#     -x NCCL_GDR_FLUSH_DISABLE=1 \
#     -x NCCL_MAX_NCHANNELS=4 \
#     -x LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib:/root/project/ai/nccl-tests/nccl/build/lib \
#     -x HUGE_PAGE_NUM=20 \
#     -x XT_CQ_INLINE_CQE=0 \
#     -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
#     --allow-run-as-root \
#     /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
# done
