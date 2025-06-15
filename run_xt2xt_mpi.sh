clear
log_file=log_old_version/xt2xt_$(date +'%Y_%m_%d_%H_%M_%S')_log
mpirun -np 2 -H 192.168.1.10:1,192.168.1.11:1 \
  -bind-to none -map-by slot \
  --mca mtl ^ofi \
  -x NCCL_DEBUG=TRACE \
  -x NCCL_IB_DISABLE=0 \
  -x NCCL_NET=IB \
  -x IB_QPS_PER_CONNECTION=2 \
  -x NCCL_DEBUG_SUBSYS=ALL \
  -x LD_LIBRARY_PATH=/root/project/ai/nccl-tests/nccl/build/lib \
  --allow-run-as-root \
  --mca pml_base_verbose 100 \
  /root/project/ai/nccl-tests/run_nccl_test.sh > "$log_file" 2>&1
