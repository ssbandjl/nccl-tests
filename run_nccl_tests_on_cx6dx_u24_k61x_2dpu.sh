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
export NCCL_ALGO=Ring
export NCCL_PROTO=LL

-x NCCL_IB_AR_THRESHOLD=8388608 \
CUDA_VISIBLE_DEVICES=1
-x NCCL_P2P_LEVEL=SYS # SYS（默认）	尽可能启用系统内所有 GPU 间的 P2P（如 NVLink、PCIe P2P）
NCCL_DEBUG=INFO|TRACE
COMMENT


ALGO_LIST="all_gather_perf"
ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
ALGO_LIST="all_reduce_perf"
mkdir -p log/cx6dx/2dpu/
for algo in ${ALGO_LIST};do
  log_file=log/cx6dx/2dpu/nccl_tests_${algo}_cx6dx_nic_pix_gpu_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
	echo $algo
	echo $log_file
  mpirun -np 8 -H 192.168.1.10:2,192.168.1.11:2,192.168.2.10:2,192.168.2.11:2 -bind-to core -map-by node --report-bindings \
    --mca btl_ofi_verbose 100 \
    --mca btl_base_verbose 100 \
    -x NCCL_DEBUG=TRACE \
    -x FI_LOG_LEVEL=debug \
    -x NCCL_DEBUG=INFO \
    -x NCCL_DEBUG_SUBSYS=NET \
    -x NCCL_IB_DISABLE=0 \
    -x NCCL_NET=IB \
    -x NCCL_IB_HCA=mlx5_0:1,mlx5_2:1 \
    -x NCCL_IB_GID_INDEX=3 \
    -x NCCL_NET_GDR_LEVEL=SYS \
    -x NCCL_IB_QPS_PER_CONNECTION=4 \
    -x NCCL_GDR_FLUSH_DISABLE=1 \
    -x NCCL_MAX_NCHANNELS=4 \
    -x LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib \
    -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
    --allow-run-as-root \
    /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
done

# ALGO_LIST="all_gather_perf"
# ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
# ALGO_LIST="all_reduce_perf"
# mkdir -p log/cx6dx/2dpu/
# for algo in ${ALGO_LIST};do
#   log_file=log/cx6dx/2dpu/nccl_tests_${algo}_cx6dx_nic_pix_gpu_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
# 	echo $algo
# 	echo $log_file
#   mpirun -np 4 -H 192.168.1.10:2,192.168.1.11:2 -bind-to core -map-by node \
#     --mca btl_ofi_verbose 100 \
#     --mca btl_base_verbose 100 \
#     -x NCCL_DEBUG=TRACE \
#     -x FI_LOG_LEVEL=debug \
#     -x NCCL_DEBUG=INFO \
#     -x NCCL_DEBUG_SUBSYS=NET \
#     -x NCCL_IB_DISABLE=0 \
#     -x NCCL_NET=IB \
#     -x NCCL_IB_HCA=mlx5_0:1 \
#     -x NCCL_IB_GID_INDEX=3 \
#     -x NCCL_NET_GDR_LEVEL=SYS \
#     -x NCCL_IB_QPS_PER_CONNECTION=4 \
#     -x NCCL_GDR_FLUSH_DISABLE=1 \
#     -x NCCL_MAX_NCHANNELS=4 \
#     -x LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib \
#     -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
#     --allow-run-as-root \
#     /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
# done


# pass
# ALGO_LIST="all_gather_perf"
# ALGO_LIST="all_reduce_perf"
# ALGO_LIST="all_gather_perf all_reduce_perf alltoall_perf broadcast_perf gather_perf hypercube_perf reduce_perf reduce_scatter_perf scatter_perf sendrecv_perf"
# mkdir -p log/cx6dx/2dpu/
# for algo in ${ALGO_LIST};do
#   log_file=log/cx6dx/2dpu/nccl_tests_${algo}_cx6dx_nic_pix_gpu_u24_k61x_2dpu_$(date +'%Y_%m_%d_%H_%M_%S')_log
# 	echo $algo
# 	echo $log_file
#   mpirun -np 8 -H 192.168.1.10:2,192.168.1.11:2,192.168.2.10:2,192.168.2.11:2 -bind-to core -map-by node \
#     -x NCCL_DEBUG=INFO \
#     -x NCCL_DEBUG_SUBSYS=NET \
#     -x NCCL_IB_DISABLE=0 \
#     -x NCCL_NET=IB \
#     -x NCCL_IB_HCA=mlx5_2:1,mlx5_0:1 \
#     -x NCCL_IB_GID_INDEX=3 \
#     -x NCCL_NET_GDR_LEVEL=SYS \
#     -x NCCL_IB_QPS_PER_CONNECTION=4 \
#     -x NCCL_GDR_FLUSH_DISABLE=1 \
#     -x NCCL_MAX_NCHANNELS=4 \
#     -x LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib \
#     -x NCCL_TOPO_DUMP_FILE=topo_${algo}.xml \
#     --allow-run-as-root \
#     /root/project/ai/nccl-tests/build/${algo} -b 4 -e 64M -w 30 -f 2 -c 0 -g 1 -n 100 > "$log_file" 2>&1
# done

