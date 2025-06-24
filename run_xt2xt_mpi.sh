# clear
# log_file=log_old_version/xt2xt_$(date +'%Y_%m_%d_%H_%M_%S')_log
log_file=log_old_version/mlx2huawei_382_$(date +'%Y_%m_%d_%H_%M_%S')_log

# export OMPI_MCA_btl_base_verbose=100
# export OMPI_MCA_btl=openib,self,vader
#  --mca pml_base_verbose 100 \
#  --mca btl_base_verbose 100 \
#  --mca btl_openib_verbose 100 \


# mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
#   -bind-to none -map-by slot \
#   --mca mtl ^ofi \
#   --mca btl ^openib \
#   -x NCCL_DEBUG=0 \
#   -x NCCL_IB_DISABLE=0 \
#   -x NCCL_NET=IB \
#   -x IB_QPS_PER_CONNECTION=2 \
#   -x NCCL_DEBUG_SUBSYS=ALL \
#   -x LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib \
#   --allow-run-as-root \
#   /root/project/ai/nccl-tests/run_nccl_test.sh > "$log_file" 2>&1

mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
  -bind-to none -map-by slot \
  --mca mtl ^ofi \
  -x NCCL_DEBUG=0 \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x IB_QPS_PER_CONNECTION=2 \
  -x NCCL_DEBUG_SUBSYS=ALL \
  -x LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  /root/project/ai/nccl-tests/run_nccl_test.sh > "$log_file" 2>&1

# mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
#   -bind-to none -map-by slot \
#   --mca mtl ^ofi \
#   -x NCCL_DEBUG=TRACE \
#   -x NCCL_IB_DISABLE=0 \
#   -x NCCL_NET=IB \
#   -x IB_QPS_PER_CONNECTION=2 \
#   -x NCCL_DEBUG_SUBSYS=ALL \
#   -x LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib \
#   --allow-run-as-root \
#   nvprof /root/project/ai/nccl-tests/run_nccl_test.sh > "$log_file" 2>&1
