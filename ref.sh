mpirun --allow-run-as-root   -hostfile hosts.txt --tune tune.txt /usr/local/bin//all_reduce_perf -b 4M -e 4M -f 2 -g 1 -n 10 -w 2

hosts.txt
20.20.20.2 slot=1
20.20.20.3 slot=1

tune.txt
-x NCCL_IB_DISABLE=0
-x NCCL_SOCKET_IFNAME=eth0
-x NCCL_IB_HCA=roce0
-x NCCL_IB_GID_INDEX=3
-x NCCL_DEBUG=TRACE
-x NCCL_DEBUG_SUBSYS=INIT,GRAPH,ENV,TUNING



Tool: nccl-tests (e.g., all_reduce_perf)
Topology: 8 GPUs per node
NCCL-Test command sample:

mpirun --oversubscribe -np 24 \
-H node1,node2,node3 \
--allow-run-as-root \
-mca plm_rsh_args "-p 22 -q -o StrictHostKeyChecking=no" \
-mca btl_tcp_if_include eth0 \
-x NCCL_IB_DISABLE=0 \
-x NCCL_P2P_DISABLE=0 \
-x NCCL_SOCKET_IFNAME=eth0 \
-x NCCL_IB_HCA=mlx5_0,mlx5_1,mlx5_2,mlx5_3,mlx5_4,mlx5_5,mlx5_6,mlx5_7 \
-x NCCL_IB_GID_INDEX=3 \
-x NCCL_IB_TC=184 \
-x NCCL_NVLS_ENABLE=1 \
-x NCCL_NET_GDR_LEVEL=3 \
-x NCCL_NET_GDR_READ=1 \
-x NCCL_DEBUG=WARN \
-x NCCL_ALGO=RING \
-x PATH \
/home/nccl-tests/build/all_reduce_perf -b 128M -e 8G -f 2 -g 1


root@gdr116:~/project/ai/nccl-tests# /root/project/ai/nccl-tests/build/all_reduce_perf -b 4 -e 1G -w 30 -f 2 -c 0 -g 4 -n 100
[gdr116] tid:21762, main(), common.cu:699, NCCL version: 22602, CUDA Runtime Version: 12.0, CUDA Driver Version: 12.4
Authorization required, but no authorization protocol specified

# nThread 1 nGpus 4 minBytes 4 maxBytes 1073741824 step: 2(factor) warmup iters: 30 iters: 100 agg iters: 1 validation: 0 graph: 0, parallel_init:0
#
#  Rank  0 Group  0 Pid  21762 on     gdr116 device  0 [0x05] Tesla V100-SXM2-16GB
#  Rank  1 Group  0 Pid  21762 on     gdr116 device  1 [0x09] Tesla V100-SXM2-16GB
#  Rank  2 Group  0 Pid  21762 on     gdr116 device  2 [0x88] Tesla V100-SXM2-16GB
#  Rank  3 Group  0 Pid  21762 on     gdr116 device  3 [0x89] Tesla V100-SXM2-16GB
#
#                                                              out-of-place                       in-place          
#       size         count      type   redop    root     time   algbw   busbw #wrong     time   algbw   busbw #wrong
#        (B)    (elements)                               (us)  (GB/s)  (GB/s)            (us)  (GB/s)  (GB/s)       
AllReduceRunColl
           4             1     float     sum      -1    23.50    0.00    0.00    N/A    23.10    0.00    0.00    N/A
           8             2     float     sum      -1    23.47    0.00    0.00    N/A    23.08    0.00    0.00    N/A
          16             4     float     sum      -1    23.01    0.00    0.00    N/A    23.04    0.00    0.00    N/A
          32             8     float     sum      -1    23.56    0.00    0.00    N/A    23.09    0.00    0.00    N/A
          64            16     float     sum      -1    23.99    0.00    0.00    N/A    23.56    0.00    0.00    N/A
         128            32     float     sum      -1    22.84    0.01    0.01    N/A    22.46    0.01    0.01    N/A
         256            64     float     sum      -1    22.43    0.01    0.02    N/A    22.50    0.01    0.02    N/A
         512           128     float     sum      -1    22.84    0.02    0.03    N/A    22.52    0.02    0.03    N/A
        1024           256     float     sum      -1    22.40    0.05    0.07    N/A    22.43    0.05    0.07    N/A
        2048           512     float     sum      -1    22.49    0.09    0.14    N/A    22.78    0.09    0.13    N/A
        4096          1024     float     sum      -1    23.06    0.18    0.27    N/A    22.53    0.18    0.27    N/A
        8192          2048     float     sum      -1    22.51    0.36    0.55    N/A    22.64    0.36    0.54    N/A
       16384          4096     float     sum      -1    23.02    0.71    1.07    N/A    22.60    0.72    1.09    N/A
       32768          8192     float     sum      -1    24.69    1.33    1.99    N/A    23.90    1.37    2.06    N/A
       65536         16384     float     sum      -1    39.85    1.64    2.47    N/A    39.84    1.65    2.47    N/A
      131072         32768     float     sum      -1    72.25    1.81    2.72    N/A    72.09    1.82    2.73    N/A
      262144         65536     float     sum      -1    97.21    2.70    4.05    N/A    96.90    2.71    4.06    N/A
      524288        131072     float     sum      -1    137.0    3.83    5.74    N/A    136.5    3.84    5.76    N/A
     1048576        262144     float     sum      -1    236.8    4.43    6.64    N/A    236.4    4.44    6.65    N/A
     2097152        524288     float     sum      -1    459.3    4.57    6.85    N/A    456.5    4.59    6.89    N/A
     4194304       1048576     float     sum      -1    892.3    4.70    7.05    N/A    889.9    4.71    7.07    N/A
     8388608       2097152     float     sum      -1   1739.0    4.82    7.24    N/A   1740.1    4.82    7.23    N/A
    16777216       4194304     float     sum      -1   3532.4    4.75    7.12    N/A   3529.4    4.75    7.13    N/A
    33554432       8388608     float     sum      -1   7035.8    4.77    7.15    N/A   7061.5    4.75    7.13    N/A
    67108864      16777216     float     sum      -1    14045    4.78    7.17    N/A    14040    4.78    7.17    N/A
   134217728      33554432     float     sum      -1    28279    4.75    7.12    N/A    28016    4.79    7.19    N/A
   268435456      67108864     float     sum      -1    55825    4.81    7.21    N/A    55810    4.81    7.21    N/A
   536870912     134217728     float     sum      -1   111507    4.81    7.22    N/A   111445    4.82    7.23    N/A
  1073741824     268435456     float     sum      -1   222838    4.82    7.23    N/A   223122    4.81    7.22    N/A
# Out of bounds values : 0 OK
# Avg bus bandwidth    : 3.35322 
#


mpirun --allow-run-as-root --mca plm_rsh_args "-p 22" -c 0 -np 1024 -x NCCL_SOCKET_NTHREADS=2 -x NCCL_NSOCKS_PERTHREAD=8 -mca btl_tcp_if_include manage -mca pml ob1 -mca btl ^openib -mca plm_rsh_num_concurrent 300 -mca routed_radix 600 -mca plm_rsh_no_tree_spawn 1 -x NCCL_DEBUG=INFO -x NCCL_DEBUG_FILE=/home/zgyd/debug0611.log -x NCCL_TOPO_DUMP_FILE=/home/zgyd/topo0611.xml -x NCCL_IB_GID_INDEX=3 -x NCCL_SOCKET_IFNAME=manage -x UCX_TLS=ud_x,shm -x LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH -x NCCL_ALGO=Ring -x NCCL_PROTO=LL128 -x NCCL_NET_GDR_LEVEL=SYS -x NCCL_MIN_NCHANNELS=32 -x NCCL_IB_QPS_PER_CONNECTION=2 -x NCCL_NVLS_ENABLE=0 --prefix /home/openmpi /home/nccl-tests/build/all_reduce_perf -b 1g -e 32g -f 2 -g 1


mpirun --allow-run-as-root --np 16 -H lccn09:8,lccn19:8 \
--mca btl_openib_warn_no_device_params_found 0 \
--mca btl ^openib --mca coll_hcoll_enable 0 --mca pml ob1 \
-x NCCL_DEBUG=VERSION \
-x NCCL_SOCKET_IFNAME=bond0 \
-x NCCL_NET_GDR_LEVEL=1 \
-x NCCL_P2P_LEVEL=NVL \
-x NCCL_IB_DISABLE=0 \
-x NCCL_IB_HCA=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_4:1,mlx5_5:1,mlx5_6:1,mlx5_7:1,mlx5_11:1 \
-x NCCL_IB_GID_INDEX=0 \
-x NCCL_IB_QPS_PER_CONNECTION=64 \
/opt/nccl-tests/build/all_reduce_perf -b 8 -e 16g -f 2 -g 1




mpirun --allow-run-as-root --np 16 -H lccn09:8,lccn19:8 \
--bind-to none  \
-x NCCL_ALGO=RING \
-x NCCL_DEBUG=INFO \
--mca btl_openib_warn_no_device_params_found 0 \
--mca btl ^openib --mca coll_hcoll_enable 0 --mca pml ob1 \
-x LD_LIBRARY_PATH -x PATH -x LIBRARY_PATH \
-x NCCL_SOCKET_IFNAME=bond0 \
-x NCCL_IB_DISABLE=0 \
-x NCCL_IB_HCA=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_4:1,mlx5_5:1,mlx5_6:1,mlx5_7:1,mlx5_11:1 \
-x NCCL_IB_GID_INDEX=0 \
-x NCCL_IB_QPS_PER_CONNECTION=64 \
/opt/nccl-tests/build/all_reduce_perf -b 8 -e 16g -f 2 -g 1
Warning: Permanently added '192.168.11.9' (ED25519) to the list of known hosts.
Warning: Permanently added '192.168.11.19' (ED25519) to the list of known hosts.
# nThread 1 nGpus 1 minBytes 8 maxBytes 17179869184 step: 2(factor) warmup iters: 5 iters: 20 agg iters: 1 validation: 1 graph: 0
#
# Using devices
#  Rank  0 Group  0 Pid 2520136 on     lccn09 device  0 [0000:18:00] NVIDIA H100 80GB HBM3
#  Rank  1 Group  0 Pid 2520137 on     lccn09 device  1 [0000:2a:00] NVIDIA H100 80GB HBM3
#  Rank  2 Group  0 Pid 2520138 on     lccn09 device  2 [0000:3a:00] NVIDIA H100 80GB HBM3
#  Rank  3 Group  0 Pid 2520139 on     lccn09 device  3 [0000:5d:00] NVIDIA H100 80GB HBM3
#  Rank  4 Group  0 Pid 2520140 on     lccn09 device  4 [0000:84:00] NVIDIA H100 80GB HBM3
#  Rank  5 Group  0 Pid 2520143 on     lccn09 device  5 [0000:8b:00] NVIDIA H100 80GB HBM3
#  Rank  6 Group  0 Pid 2520145 on     lccn09 device  6 [0000:91:00] NVIDIA H100 80GB HBM3
#  Rank  7 Group  0 Pid 2520148 on     lccn09 device  7 [0000:e4:00] NVIDIA H100 80GB HBM3
#  Rank  8 Group  0 Pid 2471267 on     lccn19 device  0 [0000:18:00] NVIDIA H100 80GB HBM3
#  Rank  9 Group  0 Pid 2471268 on     lccn19 device  1 [0000:2a:00] NVIDIA H100 80GB HBM3
#  Rank 10 Group  0 Pid 2471269 on     lccn19 device  2 [0000:3a:00] NVIDIA H100 80GB HBM3
#  Rank 11 Group  0 Pid 2471270 on     lccn19 device  3 [0000:5d:00] NVIDIA H100 80GB HBM3
#  Rank 12 Group  0 Pid 2471271 on     lccn19 device  4 [0000:84:00] NVIDIA H100 80GB HBM3
#  Rank 13 Group  0 Pid 2471272 on     lccn19 device  5 [0000:8b:00] NVIDIA H100 80GB HBM3
#  Rank 14 Group  0 Pid 2471274 on     lccn19 device  6 [0000:91:00] NVIDIA H100 80GB HBM3
#  Rank 15 Group  0 Pid 2471278 on     lccn19 device  7 [0000:e4:00] NVIDIA H100 80GB HBM3
lccn09:2520136:2520136 [0] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520136:2520136 [0] NCCL INFO Bootstrap: Using bond0:192.168.11.9<0>
lccn09:2520136:2520136 [0] NCCL INFO cudaDriverVersion 12080
lccn19:2471278:2471278 [7] NCCL INFO cudaDriverVersion 12080
lccn09:2520140:2520140 [4] NCCL INFO cudaDriverVersion 12080
lccn19:2471267:2471267 [0] NCCL INFO cudaDriverVersion 12080
lccn19:2471270:2471270 [3] NCCL INFO cudaDriverVersion 12080
lccn19:2471274:2471274 [6] NCCL INFO cudaDriverVersion 12080
lccn19:2471269:2471269 [2] NCCL INFO cudaDriverVersion 12080
lccn19:2471268:2471268 [1] NCCL INFO cudaDriverVersion 12080
lccn09:2520143:2520143 [5] NCCL INFO cudaDriverVersion 12080
lccn19:2471271:2471271 [4] NCCL INFO cudaDriverVersion 12080
lccn09:2520139:2520139 [3] NCCL INFO cudaDriverVersion 12080
lccn09:2520145:2520145 [6] NCCL INFO cudaDriverVersion 12080
lccn09:2520148:2520148 [7] NCCL INFO cudaDriverVersion 12080
lccn09:2520137:2520137 [1] NCCL INFO cudaDriverVersion 12080
lccn19:2471272:2471272 [5] NCCL INFO cudaDriverVersion 12080
lccn09:2520138:2520138 [2] NCCL INFO cudaDriverVersion 12080
lccn09:2520139:2520139 [3] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471269:2471269 [2] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520136:2520136 [0] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn09:2520140:2520140 [4] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471267:2471267 [0] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520137:2520137 [1] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471272:2471272 [5] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520143:2520143 [5] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471278:2471278 [7] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520145:2520145 [6] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471274:2471274 [6] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520148:2520148 [7] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471271:2471271 [4] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520138:2520138 [2] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471268:2471268 [1] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471270:2471270 [3] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520139:2520139 [3] NCCL INFO Bootstrap: Using bond0:192.168.11.9<0>
lccn09:2520139:2520139 [3] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn09:2520137:2520137 [1] NCCL INFO Bootstrap: Using bond0:192.168.11.9<0>
lccn09:2520137:2520137 [1] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn09:2520143:2520143 [5] NCCL INFO Bootstrap: Using bond0:192.168.11.9<0>
lccn09:2520143:2520143 [5] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn09:2520140:2520140 [4] NCCL INFO Bootstrap: Using bond0:192.168.11.9<0>
lccn09:2520140:2520140 [4] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn09:2520145:2520145 [6] NCCL INFO Bootstrap: Using bond0:192.168.11.9<0>
lccn09:2520145:2520145 [6] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn09:2520148:2520148 [7] NCCL INFO Bootstrap: Using bond0:192.168.11.9<0>
lccn09:2520148:2520148 [7] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn09:2520138:2520138 [2] NCCL INFO Bootstrap: Using bond0:192.168.11.9<0>
lccn09:2520138:2520138 [2] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn19:2471269:2471269 [2] NCCL INFO Bootstrap: Using bond0:192.168.11.19<0>
lccn19:2471269:2471269 [2] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn19:2471272:2471272 [5] NCCL INFO Bootstrap: Using bond0:192.168.11.19<0>
lccn19:2471272:2471272 [5] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn19:2471274:2471274 [6] NCCL INFO Bootstrap: Using bond0:192.168.11.19<0>
lccn19:2471274:2471274 [6] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn19:2471278:2471278 [7] NCCL INFO Bootstrap: Using bond0:192.168.11.19<0>
lccn19:2471278:2471278 [7] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn19:2471267:2471267 [0] NCCL INFO Bootstrap: Using bond0:192.168.11.19<0>
lccn19:2471267:2471267 [0] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn19:2471271:2471271 [4] NCCL INFO Bootstrap: Using bond0:192.168.11.19<0>
lccn19:2471271:2471271 [4] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn19:2471268:2471268 [1] NCCL INFO Bootstrap: Using bond0:192.168.11.19<0>
lccn19:2471268:2471268 [1] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn19:2471270:2471270 [3] NCCL INFO Bootstrap: Using bond0:192.168.11.19<0>
lccn19:2471270:2471270 [3] NCCL INFO NCCL version 2.26.2+cuda12.8
lccn09:2520148:2520240 [7] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn09:2520148:2520240 [7] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn09:2520148:2520240 [7] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn09:2520148:2520240 [7] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn09:2520148:2520240 [7] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn09:2520148:2520240 [7] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn09:2520148:2520240 [7] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn09:2520148:2520240 [7] NCCL INFO P2P plugin v8 IBext_v8
lccn09:2520148:2520240 [7] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520136:2520234 [0] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn09:2520136:2520234 [0] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn09:2520136:2520234 [0] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn09:2520136:2520234 [0] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn09:2520136:2520234 [0] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn09:2520136:2520234 [0] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn09:2520136:2520234 [0] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn09:2520136:2520234 [0] NCCL INFO P2P plugin v8 IBext_v8
lccn09:2520136:2520234 [0] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520143:2520235 [5] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn09:2520143:2520235 [5] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn09:2520143:2520235 [5] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn09:2520143:2520235 [5] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn09:2520143:2520235 [5] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn09:2520143:2520235 [5] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn09:2520143:2520235 [5] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn09:2520143:2520235 [5] NCCL INFO P2P plugin v8 IBext_v8
lccn09:2520143:2520235 [5] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520139:2520239 [3] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn09:2520139:2520239 [3] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn09:2520139:2520239 [3] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn09:2520139:2520239 [3] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn09:2520139:2520239 [3] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn09:2520139:2520239 [3] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn09:2520139:2520239 [3] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn09:2520139:2520239 [3] NCCL INFO P2P plugin v8 IBext_v8
lccn09:2520139:2520239 [3] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520137:2520236 [1] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn09:2520137:2520236 [1] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn09:2520137:2520236 [1] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn09:2520137:2520236 [1] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn09:2520137:2520236 [1] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn09:2520137:2520236 [1] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn09:2520137:2520236 [1] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn09:2520137:2520236 [1] NCCL INFO P2P plugin v8 IBext_v8
lccn09:2520137:2520236 [1] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520138:2520241 [2] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn09:2520138:2520241 [2] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn09:2520138:2520241 [2] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn09:2520138:2520241 [2] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn09:2520138:2520241 [2] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn09:2520138:2520241 [2] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn09:2520138:2520241 [2] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn09:2520138:2520241 [2] NCCL INFO P2P plugin v8 IBext_v8
lccn09:2520138:2520241 [2] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520140:2520237 [4] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn09:2520140:2520237 [4] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn09:2520140:2520237 [4] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn09:2520140:2520237 [4] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn09:2520140:2520237 [4] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn09:2520140:2520237 [4] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn09:2520140:2520237 [4] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn09:2520140:2520237 [4] NCCL INFO P2P plugin v8 IBext_v8
lccn09:2520140:2520237 [4] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520145:2520238 [6] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn09:2520145:2520238 [6] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn09:2520145:2520238 [6] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn09:2520145:2520238 [6] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn09:2520145:2520238 [6] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn09:2520148:2520240 [7] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.9<0>
lccn09:2520145:2520238 [6] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn09:2520145:2520238 [6] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn09:2520145:2520238 [6] NCCL INFO P2P plugin v8 IBext_v8
lccn09:2520145:2520238 [6] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520148:2520240 [7] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn09:2520148:2520240 [7] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471267:2471510 [0] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn19:2471267:2471510 [0] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn19:2471267:2471510 [0] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn19:2471267:2471510 [0] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn19:2471267:2471510 [0] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn19:2471267:2471510 [0] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn19:2471267:2471510 [0] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn19:2471267:2471510 [0] NCCL INFO P2P plugin v8 IBext_v8
lccn19:2471267:2471510 [0] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471274:2471515 [6] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn19:2471274:2471515 [6] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn19:2471274:2471515 [6] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn19:2471274:2471515 [6] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn19:2471274:2471515 [6] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn19:2471274:2471515 [6] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn19:2471274:2471515 [6] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn19:2471274:2471515 [6] NCCL INFO P2P plugin v8 IBext_v8
lccn19:2471274:2471515 [6] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471278:2471517 [7] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn19:2471278:2471517 [7] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn19:2471278:2471517 [7] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn19:2471278:2471517 [7] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn19:2471278:2471517 [7] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn19:2471278:2471517 [7] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn19:2471278:2471517 [7] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn19:2471278:2471517 [7] NCCL INFO P2P plugin v8 IBext_v8
lccn19:2471278:2471517 [7] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471271:2471513 [4] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn19:2471271:2471513 [4] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn19:2471271:2471513 [4] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn19:2471271:2471513 [4] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn19:2471271:2471513 [4] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn19:2471271:2471513 [4] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn19:2471271:2471513 [4] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn19:2471271:2471513 [4] NCCL INFO P2P plugin v8 IBext_v8
lccn19:2471271:2471513 [4] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471268:2471514 [1] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn19:2471268:2471514 [1] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn19:2471268:2471514 [1] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn19:2471268:2471514 [1] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn19:2471268:2471514 [1] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn19:2471268:2471514 [1] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn19:2471268:2471514 [1] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn19:2471268:2471514 [1] NCCL INFO P2P plugin v8 IBext_v8
lccn19:2471268:2471514 [1] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471272:2471512 [5] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn19:2471272:2471512 [5] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn19:2471272:2471512 [5] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn19:2471272:2471512 [5] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn19:2471272:2471512 [5] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn19:2471272:2471512 [5] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn19:2471272:2471512 [5] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn19:2471272:2471512 [5] NCCL INFO P2P plugin v8 IBext_v8
lccn19:2471272:2471512 [5] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471269:2471511 [2] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn19:2471269:2471511 [2] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn19:2471269:2471511 [2] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn19:2471269:2471511 [2] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn19:2471269:2471511 [2] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn19:2471269:2471511 [2] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn19:2471269:2471511 [2] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn19:2471269:2471511 [2] NCCL INFO P2P plugin v8 IBext_v8
lccn19:2471269:2471511 [2] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn19:2471270:2471516 [3] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v10 symbol.
lccn19:2471270:2471516 [3] NCCL INFO NET/Plugin: Failed to find ncclNetPlugin_v9 symbol.
lccn19:2471270:2471516 [3] NCCL INFO NET/Plugin: Loaded net plugin NCCL RDMA Plugin v8 (v8)
lccn19:2471270:2471516 [3] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v10 symbol.
lccn19:2471270:2471516 [3] NCCL INFO NET/Plugin: Failed to find ncclCollNetPlugin_v9 symbol.
lccn19:2471270:2471516 [3] NCCL INFO NET/Plugin: Loaded collnet plugin SHARP (v8)
lccn19:2471270:2471516 [3] NCCL INFO Plugin Path : /opt/hpcx/nccl_rdma_sharp_plugin/lib/libnccl-net.so
lccn19:2471270:2471516 [3] NCCL INFO P2P plugin v8 IBext_v8
lccn19:2471270:2471516 [3] NCCL INFO NCCL_SOCKET_IFNAME set by environment to bond0
lccn09:2520136:2520234 [0] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.9<0>
lccn09:2520136:2520234 [0] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn09:2520136:2520234 [0] NCCL INFO Using network NCCL RDMA Plugin v8
lccn09:2520138:2520241 [2] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.9<0>
lccn09:2520139:2520239 [3] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.9<0>
lccn09:2520138:2520241 [2] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn09:2520138:2520241 [2] NCCL INFO Using network NCCL RDMA Plugin v8
lccn09:2520139:2520239 [3] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn09:2520139:2520239 [3] NCCL INFO Using network NCCL RDMA Plugin v8
lccn09:2520143:2520235 [5] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.9<0>
lccn09:2520143:2520235 [5] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn09:2520143:2520235 [5] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471267:2471510 [0] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.19<0>
lccn19:2471267:2471510 [0] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn19:2471267:2471510 [0] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471278:2471517 [7] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.19<0>
lccn09:2520140:2520237 [4] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.9<0>
lccn19:2471278:2471517 [7] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn19:2471278:2471517 [7] NCCL INFO Using network NCCL RDMA Plugin v8
lccn09:2520137:2520236 [1] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.9<0>
lccn09:2520140:2520237 [4] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn09:2520140:2520237 [4] NCCL INFO Using network NCCL RDMA Plugin v8
lccn09:2520137:2520236 [1] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn09:2520137:2520236 [1] NCCL INFO Using network NCCL RDMA Plugin v8
lccn09:2520145:2520238 [6] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.9<0>
lccn09:2520145:2520238 [6] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn09:2520145:2520238 [6] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471274:2471515 [6] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.19<0>
lccn19:2471271:2471513 [4] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.19<0>
lccn19:2471274:2471515 [6] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn19:2471274:2471515 [6] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471271:2471513 [4] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn19:2471271:2471513 [4] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471270:2471516 [3] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.19<0>
lccn19:2471269:2471511 [2] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.19<0>
lccn19:2471272:2471512 [5] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.19<0>
lccn19:2471270:2471516 [3] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn19:2471270:2471516 [3] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471269:2471511 [2] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn19:2471269:2471511 [2] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471272:2471512 [5] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn19:2471272:2471512 [5] NCCL INFO Using network NCCL RDMA Plugin v8
lccn19:2471268:2471514 [1] NCCL INFO NET/IB : Using [0]mlx5_0:1/IB/SHARP [1]mlx5_1:1/IB/SHARP [2]mlx5_2:1/IB/SHARP [3]mlx5_4:1/IB/SHARP [4]mlx5_5:1/IB/SHARP [5]mlx5_6:1/IB/SHARP [6]mlx5_7:1/IB/SHARP [7]mlx5_11:1/IB/SHARP [RO]; OOB bond0:192.168.11.19<0>
lccn19:2471268:2471514 [1] NCCL INFO PROFILER/Plugin: Could not find: libnccl-profiler.so. 
lccn19:2471268:2471514 [1] NCCL INFO Using network NCCL RDMA Plugin v8
lccn09:2520148:2520240 [7] NCCL INFO ncclCommInitRank comm 0x559811bf9550 rank 7 nranks 16 cudaDev 7 nvmlDev 7 busId e4000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520136:2520234 [0] NCCL INFO ncclCommInitRank comm 0x5c2e9bbbb3f0 rank 0 nranks 16 cudaDev 0 nvmlDev 0 busId 18000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520139:2520239 [3] NCCL INFO ncclCommInitRank comm 0x5dc5981799b0 rank 3 nranks 16 cudaDev 3 nvmlDev 3 busId 5d000 commId 0x550eec01d7c8e9ff - Init START
lccn19:2471267:2471510 [0] NCCL INFO ncclCommInitRank comm 0x5ed881236770 rank 8 nranks 16 cudaDev 0 nvmlDev 0 busId 18000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520138:2520241 [2] NCCL INFO ncclCommInitRank comm 0x599183ef2180 rank 2 nranks 16 cudaDev 2 nvmlDev 2 busId 3a000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520145:2520238 [6] NCCL INFO ncclCommInitRank comm 0x63013cd95690 rank 6 nranks 16 cudaDev 6 nvmlDev 6 busId 91000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520148:2520240 [7] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn09:2520143:2520235 [5] NCCL INFO ncclCommInitRank comm 0x63f7a33c4720 rank 5 nranks 16 cudaDev 5 nvmlDev 5 busId 8b000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520145:2520238 [6] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn09:2520140:2520237 [4] NCCL INFO ncclCommInitRank comm 0x5ebf81a002d0 rank 4 nranks 16 cudaDev 4 nvmlDev 4 busId 84000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520137:2520236 [1] NCCL INFO ncclCommInitRank comm 0x56de325943a0 rank 1 nranks 16 cudaDev 1 nvmlDev 1 busId 2a000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520139:2520239 [3] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn09:2520143:2520235 [5] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn09:2520140:2520237 [4] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn09:2520138:2520241 [2] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn09:2520137:2520236 [1] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471278:2471517 [7] NCCL INFO ncclCommInitRank comm 0x5ace7c6af6a0 rank 15 nranks 16 cudaDev 7 nvmlDev 7 busId e4000 commId 0x550eec01d7c8e9ff - Init START
lccn09:2520136:2520234 [0] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471271:2471513 [4] NCCL INFO ncclCommInitRank comm 0x6047aeda0e40 rank 12 nranks 16 cudaDev 4 nvmlDev 4 busId 84000 commId 0x550eec01d7c8e9ff - Init START
lccn19:2471269:2471511 [2] NCCL INFO ncclCommInitRank comm 0x570fd3fab090 rank 10 nranks 16 cudaDev 2 nvmlDev 2 busId 3a000 commId 0x550eec01d7c8e9ff - Init START
lccn19:2471268:2471514 [1] NCCL INFO ncclCommInitRank comm 0x636c17517270 rank 9 nranks 16 cudaDev 1 nvmlDev 1 busId 2a000 commId 0x550eec01d7c8e9ff - Init START
lccn19:2471272:2471512 [5] NCCL INFO ncclCommInitRank comm 0x5664a0a62880 rank 13 nranks 16 cudaDev 5 nvmlDev 5 busId 8b000 commId 0x550eec01d7c8e9ff - Init START
lccn19:2471274:2471515 [6] NCCL INFO ncclCommInitRank comm 0x5fb68943cc30 rank 14 nranks 16 cudaDev 6 nvmlDev 6 busId 91000 commId 0x550eec01d7c8e9ff - Init START
lccn19:2471267:2471510 [0] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471270:2471516 [3] NCCL INFO ncclCommInitRank comm 0x59b8f7d12a50 rank 11 nranks 16 cudaDev 3 nvmlDev 3 busId 5d000 commId 0x550eec01d7c8e9ff - Init START
lccn19:2471268:2471514 [1] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471272:2471512 [5] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471278:2471517 [7] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471274:2471515 [6] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471269:2471511 [2] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471270:2471516 [3] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471271:2471513 [4] NCCL INFO RAS client listening socket at 127.0.0.1<28028>
lccn19:2471267:2471510 [0] NCCL INFO Bootstrap timings total 0.160902 (create 0.000085, send 0.000612, recv 0.155400, ring 0.004313, delay 0.000001)
lccn19:2471268:2471514 [1] NCCL INFO Bootstrap timings total 0.006440 (create 0.000078, send 0.000596, recv 0.001343, ring 0.003517, delay 0.000001)
lccn09:2520148:2520240 [7] NCCL INFO Bootstrap timings total 0.865195 (create 0.000078, send 0.000632, recv 0.704641, ring 0.108239, delay 0.000001)
lccn19:2471269:2471511 [2] NCCL INFO Bootstrap timings total 0.021891 (create 0.000082, send 0.000419, recv 0.018600, ring 0.001911, delay 0.000001)
lccn09:2520145:2520238 [6] NCCL INFO Bootstrap timings total 0.109209 (create 0.000039, send 0.000249, recv 0.000305, ring 0.098419, delay 0.000000)
lccn19:2471270:2471516 [3] NCCL INFO Bootstrap timings total 0.003956 (create 0.000078, send 0.000466, recv 0.000894, ring 0.001617, delay 0.000001)
lccn09:2520143:2520235 [5] NCCL INFO Bootstrap timings total 0.099835 (create 0.000076, send 0.000546, recv 0.000246, ring 0.081998, delay 0.000001)
lccn19:2471271:2471513 [4] NCCL INFO Bootstrap timings total 0.022952 (create 0.000080, send 0.000589, recv 0.016989, ring 0.001648, delay 0.000001)
lccn09:2520140:2520237 [4] NCCL INFO Bootstrap timings total 0.084197 (create 0.000078, send 0.000608, recv 0.000713, ring 0.081960, delay 0.000001)
lccn19:2471278:2471517 [7] NCCL INFO Bootstrap timings total 0.067914 (create 0.000079, send 0.000591, recv 0.000681, ring 0.002716, delay 0.000001)
lccn09:2520139:2520239 [3] NCCL INFO Bootstrap timings total 0.187989 (create 0.000038, send 0.000265, recv 0.104399, ring 0.082838, delay 0.000000)
lccn19:2471272:2471512 [5] NCCL INFO Bootstrap timings total 0.006466 (create 0.000080, send 0.000436, recv 0.002241, ring 0.002786, delay 0.000001)
lccn09:2520138:2520241 [2] NCCL INFO Bootstrap timings total 0.121813 (create 0.000078, send 0.000603, recv 0.000351, ring 0.081332, delay 0.000001)
lccn19:2471274:2471515 [6] NCCL INFO Bootstrap timings total 0.004846 (create 0.000089, send 0.000499, recv 0.000880, ring 0.002416, delay 0.000001)
lccn09:2520137:2520236 [1] NCCL INFO Bootstrap timings total 0.083494 (create 0.000081, send 0.000557, recv 0.000855, ring 0.081215, delay 0.000001)
lccn19:2471267:2471510 [0] NCCL INFO MNNVL busId 0x18000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520136:2520234 [0] NCCL INFO Bootstrap timings total 0.363082 (create 0.000076, send 0.000606, recv 0.280064, ring 0.065835, delay 0.000001)
lccn19:2471268:2471514 [1] NCCL INFO MNNVL busId 0x2a000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520148:2520240 [7] NCCL INFO MNNVL busId 0xe4000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn19:2471270:2471516 [3] NCCL INFO MNNVL busId 0x5d000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520145:2520238 [6] NCCL INFO MNNVL busId 0x91000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn19:2471269:2471511 [2] NCCL INFO MNNVL busId 0x3a000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520140:2520237 [4] NCCL INFO MNNVL busId 0x84000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn19:2471271:2471513 [4] NCCL INFO MNNVL busId 0x84000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520143:2520235 [5] NCCL INFO MNNVL busId 0x8b000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn19:2471278:2471517 [7] NCCL INFO MNNVL busId 0xe4000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520139:2520239 [3] NCCL INFO MNNVL busId 0x5d000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn19:2471272:2471512 [5] NCCL INFO MNNVL busId 0x8b000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520137:2520236 [1] NCCL INFO MNNVL busId 0x2a000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn19:2471274:2471515 [6] NCCL INFO MNNVL busId 0x91000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520138:2520241 [2] NCCL INFO MNNVL busId 0x3a000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520136:2520234 [0] NCCL INFO MNNVL busId 0x18000 fabric UUID 0.0 cliqueId 0x0 state 3 healthMask 0x0
lccn09:2520148:2520240 [7] NCCL INFO Setting affinity for GPU 7 to ffffffff,ffff0000,00000000,ffffffff,ffff0000,00000000
lccn09:2520148:2520240 [7] NCCL INFO NVLS multicast support is available on dev 7
lccn09:2520140:2520237 [4] NCCL INFO Setting affinity for GPU 4 to ffffffff,ffff0000,00000000,ffffffff,ffff0000,00000000
lccn09:2520139:2520239 [3] NCCL INFO Setting affinity for GPU 3 to ffff,ffffffff,00000000,0000ffff,ffffffff
lccn09:2520139:2520239 [3] NCCL INFO NVLS multicast support is available on dev 3
lccn09:2520140:2520237 [4] NCCL INFO NVLS multicast support is available on dev 4
lccn09:2520136:2520234 [0] NCCL INFO Setting affinity for GPU 0 to ffff,ffffffff,00000000,0000ffff,ffffffff
lccn09:2520136:2520234 [0] NCCL INFO NVLS multicast support is available on dev 0
lccn09:2520137:2520236 [1] NCCL INFO Setting affinity for GPU 1 to ffff,ffffffff,00000000,0000ffff,ffffffff
lccn09:2520145:2520238 [6] NCCL INFO Setting affinity for GPU 6 to ffffffff,ffff0000,00000000,ffffffff,ffff0000,00000000
lccn09:2520145:2520238 [6] NCCL INFO NVLS multicast support is available on dev 6
lccn09:2520137:2520236 [1] NCCL INFO NVLS multicast support is available on dev 1
lccn09:2520138:2520241 [2] NCCL INFO Setting affinity for GPU 2 to ffff,ffffffff,00000000,0000ffff,ffffffff
lccn09:2520143:2520235 [5] NCCL INFO Setting affinity for GPU 5 to ffffffff,ffff0000,00000000,ffffffff,ffff0000,00000000
lccn09:2520143:2520235 [5] NCCL INFO NVLS multicast support is available on dev 5
lccn09:2520138:2520241 [2] NCCL INFO NVLS multicast support is available on dev 2
lccn19:2471271:2471513 [4] NCCL INFO Setting affinity for GPU 4 to ffffffff,ffff0000,00000000,ffffffff,ffff0000,00000000
lccn19:2471271:2471513 [4] NCCL INFO NVLS multicast support is available on dev 4
lccn19:2471267:2471510 [0] NCCL INFO Setting affinity for GPU 0 to ffff,ffffffff,00000000,0000ffff,ffffffff
lccn19:2471267:2471510 [0] NCCL INFO NVLS multicast support is available on dev 0
lccn19:2471269:2471511 [2] NCCL INFO Setting affinity for GPU 2 to ffff,ffffffff,00000000,0000ffff,ffffffff
lccn19:2471269:2471511 [2] NCCL INFO NVLS multicast support is available on dev 2
lccn19:2471278:2471517 [7] NCCL INFO Setting affinity for GPU 7 to ffffffff,ffff0000,00000000,ffffffff,ffff0000,00000000
lccn19:2471278:2471517 [7] NCCL INFO NVLS multicast support is available on dev 7
lccn19:2471270:2471516 [3] NCCL INFO Setting affinity for GPU 3 to ffff,ffffffff,00000000,0000ffff,ffffffff
lccn19:2471274:2471515 [6] NCCL INFO Setting affinity for GPU 6 to ffffffff,ffff0000,00000000,ffffffff,ffff0000,00000000
lccn19:2471274:2471515 [6] NCCL INFO NVLS multicast support is available on dev 6
lccn19:2471270:2471516 [3] NCCL INFO NVLS multicast support is available on dev 3
lccn19:2471272:2471512 [5] NCCL INFO Setting affinity for GPU 5 to ffffffff,ffff0000,00000000,ffffffff,ffff0000,00000000
lccn19:2471272:2471512 [5] NCCL INFO NVLS multicast support is available on dev 5
lccn19:2471268:2471514 [1] NCCL INFO Setting affinity for GPU 1 to ffff,ffffffff,00000000,0000ffff,ffffffff
lccn19:2471268:2471514 [1] NCCL INFO NVLS multicast support is available on dev 1
lccn19:2471268:2471514 [1] NCCL INFO comm 0x636c17517270 rank 9 nRanks 16 nNodes 2 localRanks 8 localRank 1 MNNVL 0
lccn19:2471274:2471515 [6] NCCL INFO comm 0x5fb68943cc30 rank 14 nRanks 16 nNodes 2 localRanks 8 localRank 6 MNNVL 0
lccn19:2471274:2471515 [6] NCCL INFO Trees [0] 15/-1/-1->14->13 [1] 15/-1/-1->14->13 [2] 15/-1/-1->14->13 [3] 15/-1/-1->14->13 [4] 15/-1/-1->14->13 [5] 15/-1/-1->14->13 [6] 15/-1/-1->14->6 [7] -1/-1/-1->14->13 [8] 15/-1/-1->14->13 [9] 15/-1/-1->14->13 [10] 15/-1/-1->14->13 [11] 15/-1/-1->14->13 [12] 15/-1/-1->14->13 [13] 15/-1/-1->14->13 [14] 15/6/-1->14->-1 [15] -1/-1/-1->14->13
lccn19:2471274:2471515 [6] NCCL INFO P2P Chunksize set to 131072
lccn19:2471272:2471512 [5] NCCL INFO comm 0x5664a0a62880 rank 13 nRanks 16 nNodes 2 localRanks 8 localRank 5 MNNVL 0
lccn19:2471272:2471512 [5] NCCL INFO Trees [0] 14/-1/-1->13->12 [1] 14/-1/-1->13->12 [2] 14/-1/-1->13->12 [3] 14/-1/-1->13->12 [4] 14/-1/-1->13->12 [5] 14/-1/-1->13->5 [6] -1/-1/-1->13->12 [7] 14/-1/-1->13->12 [8] 14/-1/-1->13->12 [9] 14/-1/-1->13->12 [10] 14/-1/-1->13->12 [11] 14/-1/-1->13->12 [12] 14/-1/-1->13->12 [13] 14/5/-1->13->-1 [14] -1/-1/-1->13->12 [15] 14/-1/-1->13->12
lccn19:2471272:2471512 [5] NCCL INFO P2P Chunksize set to 131072
lccn09:2520148:2520240 [7] NCCL INFO comm 0x559811bf9550 rank 7 nRanks 16 nNodes 2 localRanks 8 localRank 7 MNNVL 0
lccn09:2520145:2520238 [6] NCCL INFO comm 0x63013cd95690 rank 6 nRanks 16 nNodes 2 localRanks 8 localRank 6 MNNVL 0
lccn09:2520145:2520238 [6] NCCL INFO NVLS Head  0:  0  8
lccn09:2520145:2520238 [6] NCCL INFO NVLS Head  1:  1  9
lccn09:2520145:2520238 [6] NCCL INFO NVLS Head  2:  2 10
lccn09:2520145:2520238 [6] NCCL INFO NVLS Head  3:  3 11
lccn09:2520145:2520238 [6] NCCL INFO NVLS Head  4:  4 12
lccn09:2520145:2520238 [6] NCCL INFO NVLS Head  5:  5 13
lccn09:2520145:2520238 [6] NCCL INFO NVLS Head  6:  6 14
lccn09:2520145:2520238 [6] NCCL INFO NVLS Head  7:  7 15
lccn19:2471278:2471517 [7] NCCL INFO comm 0x5ace7c6af6a0 rank 15 nRanks 16 nNodes 2 localRanks 8 localRank 7 MNNVL 0
lccn19:2471278:2471517 [7] NCCL INFO Trees [0] -1/-1/-1->15->14 [1] 8/-1/-1->15->14 [2] 8/-1/-1->15->14 [3] 8/-1/-1->15->14 [4] 8/-1/-1->15->14 [5] 8/-1/-1->15->14 [6] 8/-1/-1->15->14 [7] 8/-1/-1->15->7 [8] -1/-1/-1->15->14 [9] 8/-1/-1->15->14 [10] 8/-1/-1->15->14 [11] 8/-1/-1->15->14 [12] 8/-1/-1->15->14 [13] 8/-1/-1->15->14 [14] 8/-1/-1->15->14 [15] 8/7/-1->15->-1
lccn19:2471278:2471517 [7] NCCL INFO P2P Chunksize set to 131072
lccn19:2471271:2471513 [4] NCCL INFO comm 0x6047aeda0e40 rank 12 nRanks 16 nNodes 2 localRanks 8 localRank 4 MNNVL 0
lccn19:2471271:2471513 [4] NCCL INFO Trees [0] 13/-1/-1->12->11 [1] 13/-1/-1->12->11 [2] 13/-1/-1->12->11 [3] 13/-1/-1->12->11 [4] 13/-1/-1->12->4 [5] -1/-1/-1->12->11 [6] 13/-1/-1->12->11 [7] 13/-1/-1->12->11 [8] 13/-1/-1->12->11 [9] 13/-1/-1->12->11 [10] 13/-1/-1->12->11 [11] 13/-1/-1->12->11 [12] 13/4/-1->12->-1 [13] -1/-1/-1->12->11 [14] 13/-1/-1->12->11 [15] 13/-1/-1->12->11
lccn19:2471271:2471513 [4] NCCL INFO P2P Chunksize set to 131072
lccn09:2520143:2520235 [5] NCCL INFO comm 0x63f7a33c4720 rank 5 nRanks 16 nNodes 2 localRanks 8 localRank 5 MNNVL 0
lccn09:2520143:2520235 [5] NCCL INFO NVLS Head  0:  0  8
lccn09:2520143:2520235 [5] NCCL INFO NVLS Head  1:  1  9
lccn09:2520143:2520235 [5] NCCL INFO NVLS Head  2:  2 10
lccn09:2520143:2520235 [5] NCCL INFO NVLS Head  3:  3 11
lccn09:2520143:2520235 [5] NCCL INFO NVLS Head  4:  4 12
lccn09:2520143:2520235 [5] NCCL INFO NVLS Head  5:  5 13
lccn09:2520143:2520235 [5] NCCL INFO NVLS Head  6:  6 14
lccn09:2520143:2520235 [5] NCCL INFO NVLS Head  7:  7 15
lccn09:2520143:2520235 [5] NCCL INFO Trees [0] 6/-1/-1->5->4 [1] 6/-1/-1->5->4 [2] 6/-1/-1->5->4 [3] 6/-1/-1->5->4 [4] 6/-1/-1->5->4 [5] 6/13/-1->5->-1 [6] -1/-1/-1->5->4 [7] 6/-1/-1->5->4 [8] 6/-1/-1->5->4 [9] 6/-1/-1->5->4 [10] 6/-1/-1->5->4 [11] 6/-1/-1->5->4 [12] 6/-1/-1->5->4 [13] 6/-1/-1->5->13 [14] -1/-1/-1->5->4 [15] 6/-1/-1->5->4
lccn09:2520143:2520235 [5] NCCL INFO P2P Chunksize set to 131072
lccn19:2471267:2471510 [0] NCCL INFO comm 0x5ed881236770 rank 8 nRanks 16 nNodes 2 localRanks 8 localRank 0 MNNVL 0
lccn19:2471267:2471510 [0] NCCL INFO Trees [0] 9/-1/-1->8->0 [1] -1/-1/-1->8->15 [2] 9/-1/-1->8->15 [3] 9/-1/-1->8->15 [4] 9/-1/-1->8->15 [5] 9/-1/-1->8->15 [6] 9/-1/-1->8->15 [7] 9/-1/-1->8->15 [8] 9/0/-1->8->-1 [9] -1/-1/-1->8->15 [10] 9/-1/-1->8->15 [11] 9/-1/-1->8->15 [12] 9/-1/-1->8->15 [13] 9/-1/-1->8->15 [14] 9/-1/-1->8->15 [15] 9/-1/-1->8->15
lccn19:2471267:2471510 [0] NCCL INFO P2P Chunksize set to 131072
lccn09:2520136:2520234 [0] NCCL INFO comm 0x5c2e9bbbb3f0 rank 0 nRanks 16 nNodes 2 localRanks 8 localRank 0 MNNVL 0
lccn09:2520136:2520234 [0] NCCL INFO NVLS Head  0:  0  8
lccn09:2520136:2520234 [0] NCCL INFO NVLS Head  1:  1  9
lccn09:2520136:2520234 [0] NCCL INFO NVLS Head  2:  2 10
lccn09:2520136:2520234 [0] NCCL INFO NVLS Head  3:  3 11
lccn09:2520136:2520234 [0] NCCL INFO NVLS Head  4:  4 12
lccn09:2520136:2520234 [0] NCCL INFO NVLS Head  5:  5 13
lccn09:2520136:2520234 [0] NCCL INFO NVLS Head  6:  6 14
lccn09:2520136:2520234 [0] NCCL INFO NVLS Head  7:  7 15
lccn09:2520136:2520234 [0] NCCL INFO Channel 00/16 :  0  7  6  5  4  3  2  1  9 10 11 12 13 14 15  8
lccn09:2520136:2520234 [0] NCCL INFO Channel 01/16 :  0  8 15 14 13 12 11 10  9  1  2  3  4  5  6  7
lccn09:2520136:2520234 [0] NCCL INFO Channel 02/16 :  0  7  6  5  4  3 11 12 13 14 15  8  9 10  2  1
lccn09:2520136:2520234 [0] NCCL INFO Channel 03/16 :  0  1  2 10  9  8 15 14 13 12 11  3  4  5  6  7
lccn09:2520136:2520234 [0] NCCL INFO Channel 04/16 :  0  7  6  5 13 14 15  8  9 10 11 12  4  3  2  1
lccn09:2520136:2520234 [0] NCCL INFO Channel 05/16 :  0  1  2  3  4 12 11 10  9  8 15 14 13  5  6  7
lccn09:2520136:2520234 [0] NCCL INFO Channel 06/16 :  0  7 15  8  9 10 11 12 13 14  6  5  4  3  2  1
lccn09:2520136:2520234 [0] NCCL INFO Channel 07/16 :  0  1  2  3  4  5  6 14 13 12 11 10  9  8 15  7
lccn09:2520136:2520234 [0] NCCL INFO Channel 08/16 :  0  7  6  5  4  3  2  1  9 10 11 12 13 14 15  8
lccn09:2520136:2520234 [0] NCCL INFO Channel 09/16 :  0  8 15 14 13 12 11 10  9  1  2  3  4  5  6  7
lccn09:2520136:2520234 [0] NCCL INFO Channel 10/16 :  0  7  6  5  4  3 11 12 13 14 15  8  9 10  2  1
lccn09:2520136:2520234 [0] NCCL INFO Channel 11/16 :  0  1  2 10  9  8 15 14 13 12 11  3  4  5  6  7
lccn09:2520136:2520234 [0] NCCL INFO Channel 12/16 :  0  7  6  5 13 14 15  8  9 10 11 12  4  3  2  1
lccn09:2520136:2520234 [0] NCCL INFO Channel 13/16 :  0  1  2  3  4 12 11 10  9  8 15 14 13  5  6  7
lccn09:2520136:2520234 [0] NCCL INFO Channel 14/16 :  0  7 15  8  9 10 11 12 13 14  6  5  4  3  2  1
lccn09:2520136:2520234 [0] NCCL INFO Channel 15/16 :  0  1  2  3  4  5  6 14 13 12 11 10  9  8 15  7
lccn19:2471270:2471516 [3] NCCL INFO comm 0x59b8f7d12a50 rank 11 nRanks 16 nNodes 2 localRanks 8 localRank 3 MNNVL 0
lccn19:2471270:2471516 [3] NCCL INFO Trees [0] 12/-1/-1->11->10 [1] 12/-1/-1->11->10 [2] 12/-1/-1->11->10 [3] 12/-1/-1->11->3 [4] -1/-1/-1->11->10 [5] 12/-1/-1->11->10 [6] 12/-1/-1->11->10 [7] 12/-1/-1->11->10 [8] 12/-1/-1->11->10 [9] 12/-1/-1->11->10 [10] 12/-1/-1->11->10 [11] 12/3/-1->11->-1 [12] -1/-1/-1->11->10 [13] 12/-1/-1->11->10 [14] 12/-1/-1->11->10 [15] 12/-1/-1->11->10
lccn19:2471270:2471516 [3] NCCL INFO P2P Chunksize set to 131072
lccn09:2520138:2520241 [2] NCCL INFO comm 0x599183ef2180 rank 2 nRanks 16 nNodes 2 localRanks 8 localRank 2 MNNVL 0
lccn09:2520138:2520241 [2] NCCL INFO NVLS Head  0:  0  8
lccn09:2520138:2520241 [2] NCCL INFO NVLS Head  1:  1  9
lccn09:2520138:2520241 [2] NCCL INFO NVLS Head  2:  2 10
lccn09:2520138:2520241 [2] NCCL INFO NVLS Head  3:  3 11
lccn09:2520138:2520241 [2] NCCL INFO NVLS Head  4:  4 12
lccn09:2520138:2520241 [2] NCCL INFO NVLS Head  5:  5 13
lccn09:2520138:2520241 [2] NCCL INFO NVLS Head  6:  6 14
lccn09:2520138:2520241 [2] NCCL INFO NVLS Head  7:  7 15
lccn09:2520138:2520241 [2] NCCL INFO Trees [0] 3/-1/-1->2->1 [1] 3/-1/-1->2->1 [2] 3/10/-1->2->-1 [3] -1/-1/-1->2->1 [4] 3/-1/-1->2->1 [5] 3/-1/-1->2->1 [6] 3/-1/-1->2->1 [7] 3/-1/-1->2->1 [8] 3/-1/-1->2->1 [9] 3/-1/-1->2->1 [10] 3/-1/-1->2->10 [11] -1/-1/-1->2->1 [12] 3/-1/-1->2->1 [13] 3/-1/-1->2->1 [14] 3/-1/-1->2->1 [15] 3/-1/-1->2->1
lccn09:2520138:2520241 [2] NCCL INFO P2P Chunksize set to 131072
lccn19:2471269:2471511 [2] NCCL INFO comm 0x570fd3fab090 rank 10 nRanks 16 nNodes 2 localRanks 8 localRank 2 MNNVL 0
lccn19:2471269:2471511 [2] NCCL INFO Trees [0] 11/-1/-1->10->9 [1] 11/-1/-1->10->9 [2] 11/-1/-1->10->2 [3] -1/-1/-1->10->9 [4] 11/-1/-1->10->9 [5] 11/-1/-1->10->9 [6] 11/-1/-1->10->9 [7] 11/-1/-1->10->9 [8] 11/-1/-1->10->9 [9] 11/-1/-1->10->9 [10] 11/2/-1->10->-1 [11] -1/-1/-1->10->9 [12] 11/-1/-1->10->9 [13] 11/-1/-1->10->9 [14] 11/-1/-1->10->9 [15] 11/-1/-1->10->9
lccn19:2471269:2471511 [2] NCCL INFO P2P Chunksize set to 131072
lccn09:2520140:2520237 [4] NCCL INFO comm 0x5ebf81a002d0 rank 4 nRanks 16 nNodes 2 localRanks 8 localRank 4 MNNVL 0
lccn09:2520140:2520237 [4] NCCL INFO NVLS Head  0:  0  8
lccn09:2520140:2520237 [4] NCCL INFO NVLS Head  1:  1  9
lccn09:2520140:2520237 [4] NCCL INFO NVLS Head  2:  2 10
lccn09:2520140:2520237 [4] NCCL INFO NVLS Head  3:  3 11
lccn09:2520140:2520237 [4] NCCL INFO NVLS Head  4:  4 12
lccn09:2520140:2520237 [4] NCCL INFO NVLS Head  5:  5 13
lccn09:2520140:2520237 [4] NCCL INFO NVLS Head  6:  6 14
lccn09:2520140:2520237 [4] NCCL INFO NVLS Head  7:  7 15
lccn09:2520140:2520237 [4] NCCL INFO Trees [0] 5/-1/-1->4->3 [1] 5/-1/-1->4->3 [2] 5/-1/-1->4->3 [3] 5/-1/-1->4->3 [4] 5/12/-1->4->-1 [5] -1/-1/-1->4->3 [6] 5/-1/-1->4->3 [7] 5/-1/-1->4->3 [8] 5/-1/-1->4->3 [9] 5/-1/-1->4->3 [10] 5/-1/-1->4->3 [11] 5/-1/-1->4->3 [12] 5/-1/-1->4->12 [13] -1/-1/-1->4->3 [14] 5/-1/-1->4->3 [15] 5/-1/-1->4->3
lccn09:2520140:2520237 [4] NCCL INFO P2P Chunksize set to 131072
lccn19:2471268:2471514 [1] NCCL INFO Trees [0] 10/-1/-1->9->8 [1] 10/-1/-1->9->1 [2] -1/-1/-1->9->8 [3] 10/-1/-1->9->8 [4] 10/-1/-1->9->8 [5] 10/-1/-1->9->8 [6] 10/-1/-1->9->8 [7] 10/-1/-1->9->8 [8] 10/-1/-1->9->8 [9] 10/1/-1->9->-1 [10] -1/-1/-1->9->8 [11] 10/-1/-1->9->8 [12] 10/-1/-1->9->8 [13] 10/-1/-1->9->8 [14] 10/-1/-1->9->8 [15] 10/-1/-1->9->8
lccn19:2471268:2471514 [1] NCCL INFO P2P Chunksize set to 131072
lccn09:2520148:2520240 [7] NCCL INFO NVLS Head  0:  0  8
lccn09:2520148:2520240 [7] NCCL INFO NVLS Head  1:  1  9
lccn09:2520148:2520240 [7] NCCL INFO NVLS Head  2:  2 10
lccn09:2520148:2520240 [7] NCCL INFO NVLS Head  3:  3 11
lccn09:2520148:2520240 [7] NCCL INFO NVLS Head  4:  4 12
lccn09:2520148:2520240 [7] NCCL INFO NVLS Head  5:  5 13
lccn09:2520148:2520240 [7] NCCL INFO NVLS Head  6:  6 14
lccn09:2520148:2520240 [7] NCCL INFO NVLS Head  7:  7 15
lccn09:2520148:2520240 [7] NCCL INFO Trees [0] -1/-1/-1->7->6 [1] 0/-1/-1->7->6 [2] 0/-1/-1->7->6 [3] 0/-1/-1->7->6 [4] 0/-1/-1->7->6 [5] 0/-1/-1->7->6 [6] 0/-1/-1->7->6 [7] 0/15/-1->7->-1 [8] -1/-1/-1->7->6 [9] 0/-1/-1->7->6 [10] 0/-1/-1->7->6 [11] 0/-1/-1->7->6 [12] 0/-1/-1->7->6 [13] 0/-1/-1->7->6 [14] 0/-1/-1->7->6 [15] 0/-1/-1->7->15
lccn09:2520148:2520240 [7] NCCL INFO P2P Chunksize set to 131072
lccn19:2471267:2471594 [0] NCCL INFO [Proxy Service] Device 0 CPU core 12
lccn09:2520137:2520236 [1] NCCL INFO comm 0x56de325943a0 rank 1 nRanks 16 nNodes 2 localRanks 8 localRank 1 MNNVL 0
lccn09:2520137:2520236 [1] NCCL INFO NVLS Head  0:  0  8
lccn09:2520137:2520236 [1] NCCL INFO NVLS Head  1:  1  9
lccn09:2520137:2520236 [1] NCCL INFO NVLS Head  2:  2 10
lccn09:2520137:2520236 [1] NCCL INFO NVLS Head  3:  3 11
lccn09:2520137:2520236 [1] NCCL INFO NVLS Head  4:  4 12
lccn09:2520137:2520236 [1] NCCL INFO NVLS Head  5:  5 13
lccn09:2520137:2520236 [1] NCCL INFO NVLS Head  6:  6 14
lccn09:2520137:2520236 [1] NCCL INFO NVLS Head  7:  7 15
lccn09:2520137:2520236 [1] NCCL INFO Trees [0] 2/-1/-1->1->0 [1] 2/9/-1->1->-1 [2] -1/-1/-1->1->0 [3] 2/-1/-1->1->0 [4] 2/-1/-1->1->0 [5] 2/-1/-1->1->0 [6] 2/-1/-1->1->0 [7] 2/-1/-1->1->0 [8] 2/-1/-1->1->0 [9] 2/-1/-1->1->9 [10] -1/-1/-1->1->0 [11] 2/-1/-1->1->0 [12] 2/-1/-1->1->0 [13] 2/-1/-1->1->0 [14] 2/-1/-1->1->0 [15] 2/-1/-1->1->0
lccn09:2520137:2520236 [1] NCCL INFO P2P Chunksize set to 131072
lccn19:2471272:2471592 [5] NCCL INFO [Proxy Service] Device 5 CPU core 84
lccn09:2520139:2520239 [3] NCCL INFO comm 0x5dc5981799b0 rank 3 nRanks 16 nNodes 2 localRanks 8 localRank 3 MNNVL 0
lccn09:2520139:2520239 [3] NCCL INFO NVLS Head  0:  0  8
lccn09:2520139:2520239 [3] NCCL INFO NVLS Head  1:  1  9
lccn09:2520139:2520239 [3] NCCL INFO NVLS Head  2:  2 10
lccn09:2520139:2520239 [3] NCCL INFO NVLS Head  3:  3 11
lccn09:2520139:2520239 [3] NCCL INFO NVLS Head  4:  4 12
lccn09:2520139:2520239 [3] NCCL INFO NVLS Head  5:  5 13
lccn09:2520139:2520239 [3] NCCL INFO NVLS Head  6:  6 14
lccn09:2520139:2520239 [3] NCCL INFO NVLS Head  7:  7 15
lccn09:2520139:2520239 [3] NCCL INFO Trees [0] 4/-1/-1->3->2 [1] 4/-1/-1->3->2 [2] 4/-1/-1->3->2 [3] 4/11/-1->3->-1 [4] -1/-1/-1->3->2 [5] 4/-1/-1->3->2 [6] 4/-1/-1->3->2 [7] 4/-1/-1->3->2 [8] 4/-1/-1->3->2 [9] 4/-1/-1->3->2 [10] 4/-1/-1->3->2 [11] 4/-1/-1->3->11 [12] -1/-1/-1->3->2 [13] 4/-1/-1->3->2 [14] 4/-1/-1->3->2 [15] 4/-1/-1->3->2
lccn09:2520139:2520239 [3] NCCL INFO P2P Chunksize set to 131072
lccn19:2471274:2471599 [6] NCCL INFO [Proxy Service UDS] Device 6 CPU core 57
lccn19:2471274:2471593 [6] NCCL INFO [Proxy Service] Device 6 CPU core 150
lccn09:2520145:2520238 [6] NCCL INFO Trees [0] 7/-1/-1->6->5 [1] 7/-1/-1->6->5 [2] 7/-1/-1->6->5 [3] 7/-1/-1->6->5 [4] 7/-1/-1->6->5 [5] 7/-1/-1->6->5 [6] 7/14/-1->6->-1 [7] -1/-1/-1->6->5 [8] 7/-1/-1->6->5 [9] 7/-1/-1->6->5 [10] 7/-1/-1->6->5 [11] 7/-1/-1->6->5 [12] 7/-1/-1->6->5 [13] 7/-1/-1->6->5 [14] 7/-1/-1->6->14 [15] -1/-1/-1->6->5
lccn09:2520145:2520238 [6] NCCL INFO P2P Chunksize set to 131072
lccn19:2471267:2471597 [0] NCCL INFO [Proxy Service UDS] Device 0 CPU core 109
lccn09:2520136:2520234 [0] NCCL INFO Trees [0] 1/8/-1->0->-1 [1] -1/-1/-1->0->7 [2] 1/-1/-1->0->7 [3] 1/-1/-1->0->7 [4] 1/-1/-1->0->7 [5] 1/-1/-1->0->7 [6] 1/-1/-1->0->7 [7] 1/-1/-1->0->7 [8] 1/-1/-1->0->8 [9] -1/-1/-1->0->7 [10] 1/-1/-1->0->7 [11] 1/-1/-1->0->7 [12] 1/-1/-1->0->7 [13] 1/-1/-1->0->7 [14] 1/-1/-1->0->7 [15] 1/-1/-1->0->7
lccn09:2520136:2520234 [0] NCCL INFO P2P Chunksize set to 131072
lccn09:2520136:2520234 [0] NCCL INFO Check P2P Type intraNodeP2pSupport 1 directMode 0
lccn19:2471272:2471596 [5] NCCL INFO [Proxy Service UDS] Device 5 CPU core 88
lccn09:2520136:2520322 [0] NCCL INFO [Proxy Service] Device 0 CPU core 19
lccn09:2520136:2520326 [0] NCCL INFO [Proxy Service UDS] Device 0 CPU core 121
lccn19:2471270:2471602 [3] NCCL INFO [Proxy Service] Device 3 CPU core 5
lccn19:2471270:2471606 [3] NCCL INFO [Proxy Service UDS] Device 3 CPU core 6
lccn09:2520148:2520318 [7] NCCL INFO [Proxy Service] Device 7 CPU core 147
lccn09:2520148:2520323 [7] NCCL INFO [Proxy Service UDS] Device 7 CPU core 52
lccn19:2471268:2471598 [1] NCCL INFO [Proxy Service UDS] Device 1 CPU core 100
lccn19:2471268:2471595 [1] NCCL INFO [Proxy Service] Device 1 CPU core 3
lccn09:2520145:2520317 [6] NCCL INFO [Proxy Service] Device 6 CPU core 190
lccn09:2520145:2520321 [6] NCCL INFO [Proxy Service UDS] Device 6 CPU core 95
lccn19:2471269:2471603 [2] NCCL INFO [Proxy Service] Device 2 CPU core 101
lccn19:2471269:2471607 [2] NCCL INFO [Proxy Service UDS] Device 2 CPU core 7
lccn09:2520143:2520320 [5] NCCL INFO [Proxy Service UDS] Device 5 CPU core 182
lccn09:2520143:2520316 [5] NCCL INFO [Proxy Service] Device 5 CPU core 71
lccn19:2471278:2471600 [7] NCCL INFO [Proxy Service] Device 7 CPU core 154
lccn19:2471278:2471604 [7] NCCL INFO [Proxy Service UDS] Device 7 CPU core 156
lccn09:2520137:2520327 [1] NCCL INFO [Proxy Service] Device 1 CPU core 97
lccn09:2520137:2520329 [1] NCCL INFO [Proxy Service UDS] Device 1 CPU core 5
lccn19:2471271:2471605 [4] NCCL INFO [Proxy Service UDS] Device 4 CPU core 155
lccn19:2471271:2471601 [4] NCCL INFO [Proxy Service] Device 4 CPU core 154
lccn09:2520140:2520325 [4] NCCL INFO [Proxy Service UDS] Device 4 CPU core 169
lccn09:2520140:2520319 [4] NCCL INFO [Proxy Service] Device 4 CPU core 72
lccn09:2520138:2520328 [2] NCCL INFO [Proxy Service UDS] Device 2 CPU core 122
lccn09:2520138:2520324 [2] NCCL INFO [Proxy Service] Device 2 CPU core 113
lccn09:2520139:2520331 [3] NCCL INFO [Proxy Service UDS] Device 3 CPU core 104
lccn09:2520139:2520330 [3] NCCL INFO [Proxy Service] Device 3 CPU core 7
lccn09:2520137:2520236 [1] NCCL INFO NCCL_ALGO set by environment to RING
lccn09:2520137:2520236 [1] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn09:2520137:2520236 [1] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn09:2520138:2520241 [2] NCCL INFO NCCL_ALGO set by environment to RING
lccn09:2520138:2520241 [2] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn09:2520138:2520241 [2] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn09:2520139:2520239 [3] NCCL INFO NCCL_ALGO set by environment to RING
lccn09:2520139:2520239 [3] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn09:2520139:2520239 [3] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn09:2520140:2520237 [4] NCCL INFO NCCL_ALGO set by environment to RING
lccn09:2520140:2520237 [4] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn09:2520140:2520237 [4] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn09:2520143:2520235 [5] NCCL INFO NCCL_ALGO set by environment to RING
lccn09:2520143:2520235 [5] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn09:2520143:2520235 [5] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn09:2520145:2520238 [6] NCCL INFO NCCL_ALGO set by environment to RING
lccn09:2520145:2520238 [6] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn09:2520145:2520238 [6] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn09:2520136:2520234 [0] NCCL INFO NCCL_ALGO set by environment to RING
lccn09:2520136:2520234 [0] NCCL INFO Enabled NCCL Func/Proto/Algo Matrix:
     Function |       LL     LL128    Simple   |          Tree           Ring  CollNetDirect   CollNetChain           NVLS       NVLSTree            PAT  
    Broadcast |        1         2         1   |             0              1              0              0              0              0              0  
       Reduce |        1         2         1   |             0              1              0              0              0              0              0  
    AllGather |        1         2         1   |             0              1              0              0              0              0              0  
ReduceScatter |        1         2         1   |             0              1              0              0              0              0              0  
    AllReduce |        1         2         1   |             0              1              0              0              0              0              0  

lccn09:2520148:2520240 [7] NCCL INFO NCCL_ALGO set by environment to RING
lccn09:2520148:2520240 [7] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn09:2520148:2520240 [7] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn09:2520136:2520234 [0] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn09:2520136:2520234 [0] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn09:2520136:2520234 [0] NCCL INFO CC Off, workFifoBytes 1048576
lccn09:2520148:2520240 [7] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn09:2520148:2520240 [7] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn09:2520148:2520240 [7] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn09:2520148:2520240 [7] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn09:2520148:2520240 [7] NCCL INFO ncclCommInitRank comm 0x559811bf9550 rank 7 nranks 16 cudaDev 7 nvmlDev 7 busId e4000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn09:2520148:2520240 [7] NCCL INFO Init timings - ncclCommInitRank: rank 7 nranks 16 total 1.99 (kernels 0.27, alloc 0.54, bootstrap 0.87, allgathers 0.03, topo 0.06, graphs 0.02, connections 0.20, rest 0.00)
lccn09:2520143:2520235 [5] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn09:2520143:2520235 [5] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn09:2520143:2520235 [5] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn09:2520143:2520235 [5] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn09:2520143:2520235 [5] NCCL INFO ncclCommInitRank comm 0x63f7a33c4720 rank 5 nranks 16 cudaDev 5 nvmlDev 5 busId 8b000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn09:2520143:2520235 [5] NCCL INFO Init timings - ncclCommInitRank: rank 5 nranks 16 total 1.99 (kernels 0.33, alloc 1.25, bootstrap 0.10, allgathers 0.03, topo 0.07, graphs 0.01, connections 0.20, rest 0.00)
lccn09:2520137:2520236 [1] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn09:2520137:2520236 [1] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn09:2520137:2520236 [1] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn09:2520137:2520236 [1] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn09:2520137:2520236 [1] NCCL INFO ncclCommInitRank comm 0x56de325943a0 rank 1 nranks 16 cudaDev 1 nvmlDev 1 busId 2a000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn09:2520137:2520236 [1] NCCL INFO Init timings - ncclCommInitRank: rank 1 nranks 16 total 1.99 (kernels 0.33, alloc 1.26, bootstrap 0.08, allgathers 0.02, topo 0.07, graphs 0.02, connections 0.20, rest 0.00)
lccn09:2520139:2520239 [3] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn09:2520139:2520239 [3] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn09:2520139:2520239 [3] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn09:2520139:2520239 [3] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn09:2520139:2520239 [3] NCCL INFO ncclCommInitRank comm 0x5dc5981799b0 rank 3 nranks 16 cudaDev 3 nvmlDev 3 busId 5d000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn09:2520139:2520239 [3] NCCL INFO Init timings - ncclCommInitRank: rank 3 nranks 16 total 1.99 (kernels 0.33, alloc 1.16, bootstrap 0.19, allgathers 0.03, topo 0.07, graphs 0.02, connections 0.20, rest 0.00)
lccn09:2520145:2520238 [6] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn09:2520145:2520238 [6] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn09:2520145:2520238 [6] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn09:2520145:2520238 [6] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn09:2520145:2520238 [6] NCCL INFO ncclCommInitRank comm 0x63013cd95690 rank 6 nranks 16 cudaDev 6 nvmlDev 6 busId 91000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn09:2520145:2520238 [6] NCCL INFO Init timings - ncclCommInitRank: rank 6 nranks 16 total 1.99 (kernels 0.33, alloc 1.23, bootstrap 0.11, allgathers 0.03, topo 0.07, graphs 0.01, connections 0.20, rest 0.00)
lccn09:2520138:2520241 [2] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn09:2520138:2520241 [2] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn09:2520138:2520241 [2] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn09:2520138:2520241 [2] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn09:2520138:2520241 [2] NCCL INFO ncclCommInitRank comm 0x599183ef2180 rank 2 nranks 16 cudaDev 2 nvmlDev 2 busId 3a000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn09:2520138:2520241 [2] NCCL INFO Init timings - ncclCommInitRank: rank 2 nranks 16 total 1.99 (kernels 0.33, alloc 1.22, bootstrap 0.12, allgathers 0.03, topo 0.07, graphs 0.01, connections 0.20, rest 0.00)
lccn09:2520136:2520234 [0] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn09:2520136:2520234 [0] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn09:2520136:2520234 [0] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn09:2520136:2520234 [0] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn09:2520136:2520234 [0] NCCL INFO ncclCommInitRank comm 0x5c2e9bbbb3f0 rank 0 nranks 16 cudaDev 0 nvmlDev 0 busId 18000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn09:2520136:2520234 [0] NCCL INFO Init timings - ncclCommInitRank: rank 0 nranks 16 total 2.00 (kernels 0.32, alloc 1.00, bootstrap 0.36, allgathers 0.03, topo 0.07, graphs 0.01, connections 0.20, rest 0.00)
#
#                                                              out-of-place                       in-place          
#       size         count      type   redop    root     time   algbw   busbw #wrong     time   algbw   busbw #wrong
#        (B)    (elements)                               (us)  (GB/s)  (GB/s)            (us)  (GB/s)  (GB/s)       
lccn09:2520140:2520237 [4] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn09:2520140:2520237 [4] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn09:2520140:2520237 [4] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn09:2520140:2520237 [4] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn09:2520140:2520237 [4] NCCL INFO ncclCommInitRank comm 0x5ebf81a002d0 rank 4 nranks 16 cudaDev 4 nvmlDev 4 busId 84000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn09:2520140:2520237 [4] NCCL INFO Init timings - ncclCommInitRank: rank 4 nranks 16 total 1.99 (kernels 0.33, alloc 1.26, bootstrap 0.08, allgathers 0.03, topo 0.07, graphs 0.01, connections 0.20, rest 0.00)
lccn19:2471270:2471516 [3] NCCL INFO NCCL_ALGO set by environment to RING
lccn19:2471270:2471516 [3] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn19:2471270:2471516 [3] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn19:2471268:2471514 [1] NCCL INFO NCCL_ALGO set by environment to RING
lccn19:2471268:2471514 [1] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn19:2471268:2471514 [1] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn19:2471269:2471511 [2] NCCL INFO NCCL_ALGO set by environment to RING
lccn19:2471269:2471511 [2] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn19:2471269:2471511 [2] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn19:2471271:2471513 [4] NCCL INFO NCCL_ALGO set by environment to RING
lccn19:2471271:2471513 [4] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn19:2471271:2471513 [4] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn19:2471272:2471512 [5] NCCL INFO NCCL_ALGO set by environment to RING
lccn19:2471272:2471512 [5] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn19:2471272:2471512 [5] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn19:2471274:2471515 [6] NCCL INFO NCCL_ALGO set by environment to RING
lccn19:2471274:2471515 [6] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn19:2471274:2471515 [6] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn19:2471267:2471510 [0] NCCL INFO NCCL_ALGO set by environment to RING
lccn19:2471267:2471510 [0] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn19:2471267:2471510 [0] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn19:2471278:2471517 [7] NCCL INFO NCCL_ALGO set by environment to RING
lccn19:2471278:2471517 [7] NCCL INFO threadThresholds 8/8/64 | 128/8/64 | 512 | 512
lccn19:2471278:2471517 [7] NCCL INFO 16 coll channels, 16 collnet channels, 16 nvls channels, 16 p2p channels, 2 p2p channels per peer
lccn19:2471272:2471512 [5] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn19:2471272:2471512 [5] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn19:2471272:2471512 [5] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn19:2471272:2471512 [5] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn19:2471272:2471512 [5] NCCL INFO ncclCommInitRank comm 0x5664a0a62880 rank 13 nranks 16 cudaDev 5 nvmlDev 5 busId 8b000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn19:2471270:2471516 [3] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn19:2471270:2471516 [3] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn19:2471270:2471516 [3] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn19:2471270:2471516 [3] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn19:2471270:2471516 [3] NCCL INFO ncclCommInitRank comm 0x59b8f7d12a50 rank 11 nranks 16 cudaDev 3 nvmlDev 3 busId 5d000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn19:2471270:2471516 [3] NCCL INFO Init timings - ncclCommInitRank: rank 11 nranks 16 total 2.01 (kernels 0.34, alloc 1.33, bootstrap 0.00, allgathers 0.00, topo 0.09, graphs 0.02, connections 0.22, rest 0.00)
lccn19:2471267:2471510 [0] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn19:2471267:2471510 [0] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn19:2471267:2471510 [0] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn19:2471267:2471510 [0] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn19:2471267:2471510 [0] NCCL INFO ncclCommInitRank comm 0x5ed881236770 rank 8 nranks 16 cudaDev 0 nvmlDev 0 busId 18000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn19:2471267:2471510 [0] NCCL INFO Init timings - ncclCommInitRank: rank 8 nranks 16 total 2.01 (kernels 0.34, alloc 1.17, bootstrap 0.16, allgathers 0.01, topo 0.09, graphs 0.01, connections 0.22, rest 0.00)
lccn19:2471272:2471512 [5] NCCL INFO Init timings - ncclCommInitRank: rank 13 nranks 16 total 2.01 (kernels 0.34, alloc 1.33, bootstrap 0.01, allgathers 0.01, topo 0.09, graphs 0.01, connections 0.22, rest 0.00)
lccn19:2471268:2471514 [1] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn19:2471268:2471514 [1] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn19:2471268:2471514 [1] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn19:2471268:2471514 [1] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn19:2471268:2471514 [1] NCCL INFO ncclCommInitRank comm 0x636c17517270 rank 9 nranks 16 cudaDev 1 nvmlDev 1 busId 2a000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn19:2471268:2471514 [1] NCCL INFO Init timings - ncclCommInitRank: rank 9 nranks 16 total 2.01 (kernels 0.34, alloc 1.33, bootstrap 0.01, allgathers 0.01, topo 0.09, graphs 0.01, connections 0.22, rest 0.00)
lccn19:2471278:2471517 [7] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn19:2471278:2471517 [7] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn19:2471278:2471517 [7] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn19:2471278:2471517 [7] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn19:2471278:2471517 [7] NCCL INFO ncclCommInitRank comm 0x5ace7c6af6a0 rank 15 nranks 16 cudaDev 7 nvmlDev 7 busId e4000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn19:2471278:2471517 [7] NCCL INFO Init timings - ncclCommInitRank: rank 15 nranks 16 total 2.01 (kernels 0.34, alloc 1.27, bootstrap 0.07, allgathers 0.00, topo 0.09, graphs 0.02, connections 0.22, rest 0.00)
lccn19:2471274:2471515 [6] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn19:2471274:2471515 [6] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn19:2471274:2471515 [6] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn19:2471274:2471515 [6] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn19:2471274:2471515 [6] NCCL INFO ncclCommInitRank comm 0x5fb68943cc30 rank 14 nranks 16 cudaDev 6 nvmlDev 6 busId 91000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn19:2471274:2471515 [6] NCCL INFO Init timings - ncclCommInitRank: rank 14 nranks 16 total 2.01 (kernels 0.34, alloc 1.33, bootstrap 0.00, allgathers 0.01, topo 0.09, graphs 0.01, connections 0.22, rest 0.00)
lccn19:2471269:2471511 [2] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn19:2471269:2471511 [2] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn19:2471269:2471511 [2] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn19:2471269:2471511 [2] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn19:2471269:2471511 [2] NCCL INFO ncclCommInitRank comm 0x570fd3fab090 rank 10 nranks 16 cudaDev 2 nvmlDev 2 busId 3a000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn19:2471269:2471511 [2] NCCL INFO Init timings - ncclCommInitRank: rank 10 nranks 16 total 2.01 (kernels 0.34, alloc 1.31, bootstrap 0.02, allgathers 0.00, topo 0.09, graphs 0.03, connections 0.22, rest 0.00)
lccn19:2471271:2471513 [4] NCCL INFO TUNER/Plugin: Could not find: libnccl-tuner.so. Using internal tuner plugin.
lccn19:2471271:2471513 [4] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v4 symbol.
lccn19:2471271:2471513 [4] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v3 symbol.
lccn19:2471271:2471513 [4] NCCL INFO TUNER/Plugin: Failed to find ncclTunerPlugin_v2 symbol, using internal tuner instead.
lccn19:2471271:2471513 [4] NCCL INFO ncclCommInitRank comm 0x6047aeda0e40 rank 12 nranks 16 cudaDev 4 nvmlDev 4 busId 84000 commId 0x550eec01d7c8e9ff - Init COMPLETE
lccn19:2471271:2471513 [4] NCCL INFO Init timings - ncclCommInitRank: rank 12 nranks 16 total 2.01 (kernels 0.34, alloc 1.31, bootstrap 0.02, allgathers 0.01, topo 0.09, graphs 0.02, connections 0.22, rest 0.00)
lccn19:2471267:2471612 [0] NCCL INFO Channel 02/0 : 8[0] -> 9[1] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 03/0 : 0[0] -> 1[1] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 04/0 : 8[0] -> 9[1] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 05/0 : 0[0] -> 1[1] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 06/0 : 8[0] -> 9[1] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 07/0 : 0[0] -> 1[1] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 10/0 : 8[0] -> 9[1] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 12/0 : 8[0] -> 9[1] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 11/0 : 0[0] -> 1[1] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 14/0 : 8[0] -> 9[1] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 01/0 : 1[1] -> 2[2] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 13/0 : 0[0] -> 1[1] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 15/0 : 0[0] -> 1[1] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 01/0 : 5[5] -> 6[6] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 03/0 : 1[1] -> 2[2] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 01/0 : 3[3] -> 4[4] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 05/0 : 1[1] -> 2[2] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 03/0 : 5[5] -> 6[6] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 00/0 : 14[6] -> 15[7] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 05/0 : 5[5] -> 6[6] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 07/0 : 1[1] -> 2[2] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 00/0 : 13[5] -> 14[6] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 00/0 : 9[1] -> 10[2] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 03/0 : 3[3] -> 4[4] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 02/0 : 14[6] -> 15[7] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 09/0 : 1[1] -> 2[2] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 07/0 : 5[5] -> 6[6] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 02/0 : 9[1] -> 10[2] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 02/0 : 13[5] -> 14[6] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 00/0 : 11[3] -> 12[4] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 01/0 : 2[2] -> 3[3] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 00/0 : 12[4] -> 13[5] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 05/0 : 3[3] -> 4[4] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 04/0 : 14[6] -> 15[7] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 11/0 : 1[1] -> 2[2] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 09/0 : 5[5] -> 6[6] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 04/0 : 9[1] -> 10[2] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 07/0 : 3[3] -> 4[4] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 08/0 : 14[6] -> 15[7] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 04/0 : 13[5] -> 14[6] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 02/0 : 11[3] -> 12[4] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 11/0 : 5[5] -> 6[6] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 13/0 : 1[1] -> 2[2] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 06/0 : 9[1] -> 10[2] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 05/0 : 2[2] -> 3[3] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 02/0 : 12[4] -> 13[5] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 01/0 : 4[4] -> 5[5] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 15/0 : 1[1] -> 2[2] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 13/0 : 5[5] -> 6[6] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 09/0 : 3[3] -> 4[4] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 10/0 : 14[6] -> 15[7] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 04/0 : 11[3] -> 12[4] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 01/0 : 6[6] -> 7[7] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 08/0 : 9[1] -> 10[2] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 03/0 : 4[4] -> 5[5] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 06/0 : 13[5] -> 14[6] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 06/0 : 12[4] -> 13[5] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 15/0 : 5[5] -> 6[6] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 12/0 : 14[6] -> 15[7] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 07/0 : 2[2] -> 3[3] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 00/0 : 0[0] -> 7[7] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 11/0 : 3[3] -> 4[4] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 07/0 : 4[4] -> 5[5] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 10/0 : 9[1] -> 10[2] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 03/0 : 6[6] -> 7[7] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 08/0 : 13[5] -> 14[6] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 06/0 : 11[3] -> 12[4] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 00/0 : 10[2] -> 11[3] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 08/0 : 12[4] -> 13[5] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 12/0 : 9[1] -> 10[2] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 10/0 : 13[5] -> 14[6] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 13/0 : 3[3] -> 4[4] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 09/0 : 2[2] -> 3[3] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 02/0 : 0[0] -> 7[7] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 09/0 : 4[4] -> 5[5] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 05/0 : 6[6] -> 7[7] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 12/0 : 13[5] -> 14[6] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 14/0 : 9[1] -> 10[2] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 15/0 : 3[3] -> 4[4] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 10/0 : 12[4] -> 13[5] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 04/0 : 10[2] -> 11[3] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 11/0 : 4[4] -> 5[5] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 08/0 : 11[3] -> 12[4] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 04/0 : 0[0] -> 7[7] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 14/0 : 13[5] -> 14[6] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 09/0 : 6[6] -> 7[7] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 13/0 : 2[2] -> 3[3] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 01/0 : 8[0] -> 15[7] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 14/0 : 12[4] -> 13[5] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 15/0 : 4[4] -> 5[5] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 06/0 : 0[0] -> 7[7] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 06/0 : 10[2] -> 11[3] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 11/0 : 6[6] -> 7[7] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 15/0 : 2[2] -> 3[3] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 08/0 : 0[0] -> 7[7] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 10/0 : 11[3] -> 12[4] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 03/0 : 8[0] -> 15[7] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 13/0 : 6[6] -> 7[7] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 08/0 : 10[2] -> 11[3] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 10/0 : 0[0] -> 7[7] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 12/0 : 11[3] -> 12[4] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 05/0 : 8[0] -> 15[7] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 12/0 : 0[0] -> 7[7] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 12/0 : 10[2] -> 11[3] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 14/0 : 11[3] -> 12[4] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 14/0 : 0[0] -> 7[7] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 07/0 : 8[0] -> 15[7] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 14/0 : 10[2] -> 11[3] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 09/0 : 8[0] -> 15[7] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 11/0 : 8[0] -> 15[7] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 13/0 : 8[0] -> 15[7] via P2P/CUMEM
lccn19:2471267:2471612 [0] NCCL INFO Channel 15/0 : 8[0] -> 15[7] via P2P/CUMEM
lccn09:2520137:2520340 [1] NCCL INFO [Proxy Progress] Device 1 CPU core 4
lccn09:2520137:2520336 [1] NCCL INFO Channel 01/0 : 9[1] -> 1[1] [receive] via NET/NCCL RDMA Plugin v8/1/GDRDMA
lccn09:2520137:2520336 [1] NCCL INFO Channel 09/0 : 9[1] -> 1[1] [receive] via NET/NCCL RDMA Plugin v8/1/GDRDMA
lccn09:2520137:2520336 [1] NCCL INFO Channel 00/0 : 1[1] -> 9[1] [send] via NET/NCCL RDMA Plugin v8/1/GDRDMA
lccn09:2520137:2520336 [1] NCCL INFO Channel 08/0 : 1[1] -> 9[1] [send] via NET/NCCL RDMA Plugin v8/1/GDRDMA
lccn19:2471274:2471616 [6] NCCL INFO [Proxy Progress] Device 6 CPU core 61
lccn19:2471274:2471614 [6] NCCL INFO Channel 07/0 : 6[6] -> 14[6] [receive] via NET/NCCL RDMA Plugin v8/6/GDRDMA
lccn19:2471274:2471614 [6] NCCL INFO Channel 15/0 : 6[6] -> 14[6] [receive] via NET/NCCL RDMA Plugin v8/6/GDRDMA
lccn19:2471274:2471614 [6] NCCL INFO Channel 06/0 : 14[6] -> 6[6] [send] via NET/NCCL RDMA Plugin v8/6/GDRDMA
lccn19:2471274:2471614 [6] NCCL INFO Channel 14/0 : 14[6] -> 6[6] [send] via NET/NCCL RDMA Plugin v8/6/GDRDMA
lccn19:2471268:2471617 [1] NCCL INFO [Proxy Progress] Device 1 CPU core 105
lccn19:2471268:2471611 [1] NCCL INFO Channel 00/0 : 1[1] -> 9[1] [receive] via NET/NCCL RDMA Plugin v8/1/GDRDMA
lccn19:2471268:2471611 [1] NCCL INFO Channel 08/0 : 1[1] -> 9[1] [receive] via NET/NCCL RDMA Plugin v8/1/GDRDMA
lccn19:2471268:2471611 [1] NCCL INFO Channel 01/0 : 9[1] -> 1[1] [send] via NET/NCCL RDMA Plugin v8/1/GDRDMA
lccn19:2471268:2471611 [1] NCCL INFO Channel 09/0 : 9[1] -> 1[1] [send] via NET/NCCL RDMA Plugin v8/1/GDRDMA
lccn09:2520137:2520336 [1] NCCL INFO Channel 02/0 : 1[1] -> 0[0] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 03/0 : 9[1] -> 8[0] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 04/0 : 1[1] -> 0[0] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 05/0 : 9[1] -> 8[0] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 06/0 : 1[1] -> 0[0] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 07/0 : 9[1] -> 8[0] via P2P/CUMEM
lccn09:2520137:2520336 [1] NCCL INFO Channel 10/0 : 1[1] -> 0[0] via P2P/CUMEM
lccn19:2471278:2471618 [7] NCCL INFO [Proxy Progress] Device 7 CPU core 59
lccn19:2471278:2471610 [7] NCCL INFO Channel 06/0 : 7[7] -> 15[7] [receive] via NET/NCCL RDMA Plugin v8/7/GDRDMA
lccn09:2520137:2520336 [1] NCCL INFO Channel 12/0 : 1[1] -> 0[0] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 11/0 : 9[1] -> 8[0] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 14/0 : 7[7] -> 15[7] [receive] via NET/NCCL RDMA Plugin v8/7/GDRDMA
lccn19:2471278:2471610 [7] NCCL INFO Channel 07/0 : 15[7] -> 7[7] [send] via NET/NCCL RDMA Plugin v8/7/GDRDMA
lccn09:2520137:2520336 [1] NCCL INFO Channel 14/0 : 1[1] -> 0[0] via P2P/CUMEM
lccn19:2471268:2471611 [1] NCCL INFO Channel 13/0 : 9[1] -> 8[0] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 15/0 : 15[7] -> 7[7] [send] via NET/NCCL RDMA Plugin v8/7/GDRDMA
lccn19:2471268:2471611 [1] NCCL INFO Channel 15/0 : 9[1] -> 8[0] via P2P/CUMEM
lccn09:2520139:2520341 [3] NCCL INFO [Proxy Progress] Device 3 CPU core 105
lccn09:2520139:2520335 [3] NCCL INFO Channel 03/0 : 11[3] -> 3[3] [receive] via NET/NCCL RDMA Plugin v8/3/GDRDMA
lccn09:2520139:2520335 [3] NCCL INFO Channel 11/0 : 11[3] -> 3[3] [receive] via NET/NCCL RDMA Plugin v8/3/GDRDMA
lccn09:2520139:2520335 [3] NCCL INFO Channel 02/0 : 3[3] -> 11[3] [send] via NET/NCCL RDMA Plugin v8/3/GDRDMA
lccn09:2520139:2520335 [3] NCCL INFO Channel 10/0 : 3[3] -> 11[3] [send] via NET/NCCL RDMA Plugin v8/3/GDRDMA
lccn19:2471272:2471619 [5] NCCL INFO [Proxy Progress] Device 5 CPU core 181
lccn19:2471272:2471609 [5] NCCL INFO Channel 04/0 : 5[5] -> 13[5] [receive] via NET/NCCL RDMA Plugin v8/5/GDRDMA
lccn19:2471272:2471609 [5] NCCL INFO Channel 12/0 : 5[5] -> 13[5] [receive] via NET/NCCL RDMA Plugin v8/5/GDRDMA
lccn19:2471272:2471609 [5] NCCL INFO Channel 05/0 : 13[5] -> 5[5] [send] via NET/NCCL RDMA Plugin v8/5/GDRDMA
lccn19:2471272:2471609 [5] NCCL INFO Channel 13/0 : 13[5] -> 5[5] [send] via NET/NCCL RDMA Plugin v8/5/GDRDMA
lccn09:2520145:2520342 [6] NCCL INFO [Proxy Progress] Device 6 CPU core 50
lccn09:2520143:2520343 [5] NCCL INFO [Proxy Progress] Device 5 CPU core 172
lccn09:2520145:2520339 [6] NCCL INFO Channel 06/0 : 14[6] -> 6[6] [receive] via NET/NCCL RDMA Plugin v8/6/GDRDMA
lccn09:2520143:2520338 [5] NCCL INFO Channel 05/0 : 13[5] -> 5[5] [receive] via NET/NCCL RDMA Plugin v8/5/GDRDMA
lccn09:2520145:2520339 [6] NCCL INFO Channel 14/0 : 14[6] -> 6[6] [receive] via NET/NCCL RDMA Plugin v8/6/GDRDMA
lccn09:2520143:2520338 [5] NCCL INFO Channel 13/0 : 13[5] -> 5[5] [receive] via NET/NCCL RDMA Plugin v8/5/GDRDMA
lccn09:2520145:2520339 [6] NCCL INFO Channel 07/0 : 6[6] -> 14[6] [send] via NET/NCCL RDMA Plugin v8/6/GDRDMA
lccn09:2520143:2520338 [5] NCCL INFO Channel 04/0 : 5[5] -> 13[5] [send] via NET/NCCL RDMA Plugin v8/5/GDRDMA
lccn09:2520145:2520339 [6] NCCL INFO Channel 15/0 : 6[6] -> 14[6] [send] via NET/NCCL RDMA Plugin v8/6/GDRDMA
lccn09:2520143:2520338 [5] NCCL INFO Channel 12/0 : 5[5] -> 13[5] [send] via NET/NCCL RDMA Plugin v8/5/GDRDMA
lccn09:2520140:2520344 [4] NCCL INFO [Proxy Progress] Device 4 CPU core 77
lccn09:2520140:2520337 [4] NCCL INFO Channel 04/0 : 12[4] -> 4[4] [receive] via NET/NCCL RDMA Plugin v8/4/GDRDMA
lccn09:2520138:2520345 [2] NCCL INFO [Proxy Progress] Device 2 CPU core 113
lccn09:2520140:2520337 [4] NCCL INFO Channel 12/0 : 12[4] -> 4[4] [receive] via NET/NCCL RDMA Plugin v8/4/GDRDMA
lccn09:2520138:2520334 [2] NCCL INFO Channel 02/0 : 10[2] -> 2[2] [receive] via NET/NCCL RDMA Plugin v8/2/GDRDMA
lccn09:2520140:2520337 [4] NCCL INFO Channel 05/0 : 4[4] -> 12[4] [send] via NET/NCCL RDMA Plugin v8/4/GDRDMA
lccn09:2520140:2520337 [4] NCCL INFO Channel 13/0 : 4[4] -> 12[4] [send] via NET/NCCL RDMA Plugin v8/4/GDRDMA
lccn09:2520138:2520334 [2] NCCL INFO Channel 10/0 : 10[2] -> 2[2] [receive] via NET/NCCL RDMA Plugin v8/2/GDRDMA
lccn09:2520138:2520334 [2] NCCL INFO Channel 03/0 : 2[2] -> 10[2] [send] via NET/NCCL RDMA Plugin v8/2/GDRDMA
lccn09:2520138:2520334 [2] NCCL INFO Channel 11/0 : 2[2] -> 10[2] [send] via NET/NCCL RDMA Plugin v8/2/GDRDMA
lccn09:2520145:2520339 [6] NCCL INFO Channel 00/0 : 6[6] -> 5[5] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 01/0 : 14[6] -> 13[5] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 03/0 : 14[6] -> 13[5] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 02/0 : 6[6] -> 5[5] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 05/0 : 14[6] -> 13[5] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 04/0 : 6[6] -> 5[5] via P2P/CUMEM
lccn19:2471271:2471620 [4] NCCL INFO [Proxy Progress] Device 4 CPU core 161
lccn09:2520143:2520338 [5] NCCL INFO Channel 00/0 : 5[5] -> 4[4] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 01/0 : 13[5] -> 12[4] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 05/0 : 4[4] -> 12[4] [receive] via NET/NCCL RDMA Plugin v8/4/GDRDMA
lccn19:2471274:2471614 [6] NCCL INFO Channel 07/0 : 14[6] -> 13[5] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 06/0 : 6[6] -> 5[5] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 13/0 : 4[4] -> 12[4] [receive] via NET/NCCL RDMA Plugin v8/4/GDRDMA
lccn09:2520143:2520338 [5] NCCL INFO Channel 02/0 : 5[5] -> 4[4] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 03/0 : 13[5] -> 12[4] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 09/0 : 14[6] -> 13[5] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 04/0 : 12[4] -> 4[4] [send] via NET/NCCL RDMA Plugin v8/4/GDRDMA
lccn09:2520145:2520339 [6] NCCL INFO Channel 08/0 : 6[6] -> 5[5] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 06/0 : 5[5] -> 4[4] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 12/0 : 12[4] -> 4[4] [send] via NET/NCCL RDMA Plugin v8/4/GDRDMA
lccn19:2471272:2471609 [5] NCCL INFO Channel 07/0 : 13[5] -> 12[4] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 11/0 : 14[6] -> 13[5] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 10/0 : 6[6] -> 5[5] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 08/0 : 5[5] -> 4[4] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 09/0 : 13[5] -> 12[4] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 13/0 : 14[6] -> 13[5] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 12/0 : 6[6] -> 5[5] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 10/0 : 5[5] -> 4[4] via P2P/CUMEM
lccn19:2471274:2471614 [6] NCCL INFO Channel 15/0 : 14[6] -> 13[5] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 11/0 : 13[5] -> 12[4] via P2P/CUMEM
lccn09:2520145:2520339 [6] NCCL INFO Channel 14/0 : 6[6] -> 5[5] via P2P/CUMEM
lccn09:2520143:2520338 [5] NCCL INFO Channel 14/0 : 5[5] -> 4[4] via P2P/CUMEM
lccn19:2471272:2471609 [5] NCCL INFO Channel 15/0 : 13[5] -> 12[4] via P2P/CUMEM
lccn09:2520148:2520346 [7] NCCL INFO [Proxy Progress] Device 7 CPU core 150
lccn09:2520148:2520333 [7] NCCL INFO Channel 07/0 : 15[7] -> 7[7] [receive] via NET/NCCL RDMA Plugin v8/7/GDRDMA
lccn09:2520148:2520333 [7] NCCL INFO Channel 15/0 : 15[7] -> 7[7] [receive] via NET/NCCL RDMA Plugin v8/7/GDRDMA
lccn09:2520148:2520333 [7] NCCL INFO Channel 06/0 : 7[7] -> 15[7] [send] via NET/NCCL RDMA Plugin v8/7/GDRDMA
lccn19:2471271:2471615 [4] NCCL INFO Channel 01/0 : 12[4] -> 11[3] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 14/0 : 7[7] -> 15[7] [send] via NET/NCCL RDMA Plugin v8/7/GDRDMA
lccn09:2520140:2520337 [4] NCCL INFO Channel 00/0 : 4[4] -> 3[3] via P2P/CUMEM
lccn09:2520136:2520347 [0] NCCL INFO [Proxy Progress] Device 0 CPU core 117
lccn19:2471271:2471615 [4] NCCL INFO Channel 03/0 : 12[4] -> 11[3] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 00/0 : 8[0] -> 0[0] [receive] via NET/NCCL RDMA Plugin v8/0/GDRDMA
lccn09:2520148:2520333 [7] NCCL INFO Channel 01/0 : 7[7] -> 0[0] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 02/0 : 4[4] -> 3[3] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 08/0 : 8[0] -> 0[0] [receive] via NET/NCCL RDMA Plugin v8/0/GDRDMA
lccn19:2471278:2471610 [7] NCCL INFO Channel 00/0 : 15[7] -> 8[0] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 05/0 : 12[4] -> 11[3] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 01/0 : 0[0] -> 8[0] [send] via NET/NCCL RDMA Plugin v8/0/GDRDMA
lccn09:2520148:2520333 [7] NCCL INFO Channel 03/0 : 7[7] -> 0[0] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 04/0 : 4[4] -> 3[3] via P2P/CUMEM
lccn09:2520136:2520332 [0] NCCL INFO Channel 09/0 : 0[0] -> 8[0] [send] via NET/NCCL RDMA Plugin v8/0/GDRDMA
lccn19:2471271:2471615 [4] NCCL INFO Channel 07/0 : 12[4] -> 11[3] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 02/0 : 15[7] -> 8[0] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 05/0 : 7[7] -> 0[0] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 06/0 : 4[4] -> 3[3] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 09/0 : 12[4] -> 11[3] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 04/0 : 15[7] -> 8[0] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 07/0 : 7[7] -> 0[0] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 08/0 : 4[4] -> 3[3] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 06/0 : 15[7] -> 8[0] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 11/0 : 12[4] -> 11[3] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 09/0 : 7[7] -> 0[0] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 08/0 : 15[7] -> 8[0] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 10/0 : 4[4] -> 3[3] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 13/0 : 12[4] -> 11[3] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 10/0 : 15[7] -> 8[0] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 11/0 : 7[7] -> 0[0] via P2P/CUMEM
lccn19:2471271:2471615 [4] NCCL INFO Channel 15/0 : 12[4] -> 11[3] via P2P/CUMEM
lccn09:2520140:2520337 [4] NCCL INFO Channel 12/0 : 4[4] -> 3[3] via P2P/CUMEM
lccn19:2471270:2471621 [3] NCCL INFO [Proxy Progress] Device 3 CPU core 10
lccn19:2471278:2471610 [7] NCCL INFO Channel 12/0 : 15[7] -> 8[0] via P2P/CUMEM
lccn19:2471269:2471622 [2] NCCL INFO [Proxy Progress] Device 2 CPU core 11
lccn09:2520148:2520333 [7] NCCL INFO Channel 13/0 : 7[7] -> 0[0] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 02/0 : 3[3] -> 11[3] [receive] via NET/NCCL RDMA Plugin v8/3/GDRDMA
lccn09:2520140:2520337 [4] NCCL INFO Channel 14/0 : 4[4] -> 3[3] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 14/0 : 15[7] -> 8[0] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 03/0 : 2[2] -> 10[2] [receive] via NET/NCCL RDMA Plugin v8/2/GDRDMA
lccn19:2471270:2471613 [3] NCCL INFO Channel 10/0 : 3[3] -> 11[3] [receive] via NET/NCCL RDMA Plugin v8/3/GDRDMA
lccn09:2520148:2520333 [7] NCCL INFO Channel 15/0 : 7[7] -> 0[0] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 03/0 : 11[3] -> 3[3] [send] via NET/NCCL RDMA Plugin v8/3/GDRDMA
lccn19:2471269:2471608 [2] NCCL INFO Channel 11/0 : 2[2] -> 10[2] [receive] via NET/NCCL RDMA Plugin v8/2/GDRDMA
lccn19:2471270:2471613 [3] NCCL INFO Channel 11/0 : 11[3] -> 3[3] [send] via NET/NCCL RDMA Plugin v8/3/GDRDMA
lccn19:2471267:2471623 [0] NCCL INFO [Proxy Progress] Device 0 CPU core 110
lccn19:2471269:2471608 [2] NCCL INFO Channel 02/0 : 10[2] -> 2[2] [send] via NET/NCCL RDMA Plugin v8/2/GDRDMA
lccn19:2471267:2471612 [0] NCCL INFO Channel 01/0 : 0[0] -> 8[0] [receive] via NET/NCCL RDMA Plugin v8/0/GDRDMA
lccn19:2471267:2471612 [0] NCCL INFO Channel 09/0 : 0[0] -> 8[0] [receive] via NET/NCCL RDMA Plugin v8/0/GDRDMA
lccn19:2471269:2471608 [2] NCCL INFO Channel 10/0 : 10[2] -> 2[2] [send] via NET/NCCL RDMA Plugin v8/2/GDRDMA
lccn19:2471267:2471612 [0] NCCL INFO Channel 00/0 : 8[0] -> 0[0] [send] via NET/NCCL RDMA Plugin v8/0/GDRDMA
lccn19:2471267:2471612 [0] NCCL INFO Channel 08/0 : 8[0] -> 0[0] [send] via NET/NCCL RDMA Plugin v8/0/GDRDMA
lccn19:2471269:2471608 [2] NCCL INFO Channel 01/0 : 10[2] -> 9[1] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 01/0 : 11[3] -> 10[2] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 00/0 : 2[2] -> 1[1] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 00/0 : 7[7] -> 6[6] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 05/0 : 11[3] -> 10[2] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 03/0 : 10[2] -> 9[1] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 02/0 : 7[7] -> 6[6] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 02/0 : 2[2] -> 1[1] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 05/0 : 10[2] -> 9[1] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 07/0 : 11[3] -> 10[2] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 01/0 : 15[7] -> 14[6] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 04/0 : 7[7] -> 6[6] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 04/0 : 2[2] -> 1[1] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 00/0 : 3[3] -> 2[2] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 03/0 : 15[7] -> 14[6] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 09/0 : 11[3] -> 10[2] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 07/0 : 10[2] -> 9[1] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 06/0 : 2[2] -> 1[1] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 08/0 : 7[7] -> 6[6] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 09/0 : 10[2] -> 9[1] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 04/0 : 3[3] -> 2[2] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 13/0 : 11[3] -> 10[2] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 05/0 : 15[7] -> 14[6] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 06/0 : 3[3] -> 2[2] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 08/0 : 2[2] -> 1[1] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 10/0 : 7[7] -> 6[6] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 09/0 : 15[7] -> 14[6] via P2P/CUMEM
lccn19:2471270:2471613 [3] NCCL INFO Channel 15/0 : 11[3] -> 10[2] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 11/0 : 10[2] -> 9[1] via P2P/CUMEM
lccn09:2520148:2520333 [7] NCCL INFO Channel 12/0 : 7[7] -> 6[6] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 10/0 : 2[2] -> 1[1] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 08/0 : 3[3] -> 2[2] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 13/0 : 10[2] -> 9[1] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 11/0 : 15[7] -> 14[6] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 12/0 : 3[3] -> 2[2] via P2P/CUMEM
lccn19:2471269:2471608 [2] NCCL INFO Channel 15/0 : 10[2] -> 9[1] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 12/0 : 2[2] -> 1[1] via P2P/CUMEM
lccn19:2471278:2471610 [7] NCCL INFO Channel 13/0 : 15[7] -> 14[6] via P2P/CUMEM
lccn09:2520138:2520334 [2] NCCL INFO Channel 14/0 : 2[2] -> 1[1] via P2P/CUMEM
lccn09:2520139:2520335 [3] NCCL INFO Channel 14/0 : 3[3] -> 2[2] via P2P/CUMEM
lccn09:2520143:2520316 [5] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471272:2471592 [5] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn09:2520137:2520327 [1] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn09:2520148:2520318 [7] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn09:2520139:2520330 [3] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn09:2520136:2520322 [0] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn09:2520138:2520324 [2] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn09:2520140:2520319 [4] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn09:2520145:2520317 [6] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471270:2471602 [3] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471268:2471595 [1] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471278:2471600 [7] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471269:2471603 [2] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471271:2471601 [4] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471274:2471593 [6] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471267:2471594 [0] NCCL INFO NCCL_IB_QPS_PER_CONNECTION set by environment to 64.
lccn19:2471271:2471615 [4] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn09:2520148:2520333 [7] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn09:2520145:2520339 [6] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn19:2471270:2471613 [3] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn09:2520143:2520338 [5] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn19:2471269:2471608 [2] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn09:2520140:2520337 [4] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn19:2471268:2471611 [1] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn09:2520138:2520334 [2] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn19:2471267:2471612 [0] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn09:2520137:2520336 [1] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn19:2471274:2471614 [6] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn09:2520139:2520335 [3] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn19:2471278:2471610 [7] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn09:2520136:2520332 [0] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
lccn19:2471272:2471609 [5] NCCL INFO Connected all rings, use ring PXN 0 GDR 1
           8             2     float     sum      -1    38.79    0.00    0.00      0    37.04    0.00    0.00      0
          16             4     float     sum      -1    36.92    0.00    0.00      0    37.15    0.00    0.00      0
          32             8     float     sum      -1    38.55    0.00    0.00      0    39.40    0.00    0.00      0
          64            16     float     sum      -1    42.34    0.00    0.00      0    41.99    0.00    0.00      0
         128            32     float     sum      -1    43.91    0.00    0.01      0    43.62    0.00    0.01      0
         256            64     float     sum      -1    45.47    0.01    0.01      0    45.23    0.01    0.01      0
         512           128     float     sum      -1    45.84    0.01    0.02      0    45.59    0.01    0.02      0
        1024           256     float     sum      -1    46.46    0.02    0.04      0    46.13    0.02    0.04      0
        2048           512     float     sum      -1    47.43    0.04    0.08      0    46.76    0.04    0.08      0
        4096          1024     float     sum      -1    47.45    0.09    0.16      0    47.20    0.09    0.16      0
        8192          2048     float     sum      -1    49.07    0.17    0.31      0    48.40    0.17    0.32      0
       16384          4096     float     sum      -1    49.36    0.33    0.62      0    48.94    0.33    0.63      0
       32768          8192     float     sum      -1    51.90    0.63    1.18      0    51.71    0.63    1.19      0
       65536         16384     float     sum      -1    57.35    1.14    2.14      0    57.16    1.15    2.15      0
      131072         32768     float     sum      -1    80.72    1.62    3.04      0    76.54    1.71    3.21      0
      262144         65536     float     sum      -1    87.19    3.01    5.64      0    86.62    3.03    5.67      0
      524288        131072     float     sum      -1    108.8    4.82    9.03      0    123.3    4.25    7.97      0
     1048576        262144     float     sum      -1    177.1    5.92   11.10      0    165.9    6.32   11.85      0
     2097152        524288     float     sum      -1    190.9   10.98   20.60      0    193.0   10.87   20.38      0
     4194304       1048576     float     sum      -1    201.9   20.78   38.96      0    200.0   20.97   39.31      0
     8388608       2097152     float     sum      -1    290.5   28.88   54.15      0    289.8   28.95   54.28      0
    16777216       4194304     float     sum      -1    524.3   32.00   60.00      0    533.8   31.43   58.93      0
    33554432       8388608     float     sum      -1   1543.4   21.74   40.76      0   1542.6   21.75   40.78      0
    67108864      16777216     float     sum      -1   3099.2   21.65   40.60      0   3097.9   21.66   40.62      0
   134217728      33554432     float     sum      -1   5876.9   22.84   42.82      0   5712.6   23.49   44.05      0
   268435456      67108864     float     sum      -1    11435   23.47   44.01      0    11418   23.51   44.08      0
   536870912     134217728     float     sum      -1    22669   23.68   44.41      0    23641   22.71   42.58      0
  1073741824     268435456     float     sum      -1    45390   23.66   44.36      0    45333   23.69   44.41      0
  2147483648     536870912     float     sum      -1    90808   23.65   44.34      0    90719   23.67   44.38      0
  4294967296    1073741824     float     sum      -1   181855   23.62   44.28      0   181450   23.67   44.38      0
  8589934592    2147483648     float     sum      -1   364906   23.54   44.14      0   363363   23.64   44.33      0
 17179869184    4294967296     float     sum      -1   727698   23.61   44.27      0   729105   23.56   44.18      0
lccn09:2520136:2520910 [0] NCCL INFO comm 0x5c2e9bbbb3f0 rank 0 nranks 16 cudaDev 0 busId 18000 - Destroy COMPLETE
# Out of bounds values : 0 OK
# Avg bus bandwidth    : 20.0176 
#
lccn09:2520138:2520907 [2] NCCL INFO comm 0x599183ef2180 rank 2 nranks 16 cudaDev 2 busId 3a000 - Destroy COMPLETE
lccn19:2471267:2472067 [0] NCCL INFO comm 0x5ed881236770 rank 8 nranks 16 cudaDev 0 busId 18000 - Destroy COMPLETE
lccn09:2520140:2520904 [4] NCCL INFO comm 0x5ebf81a002d0 rank 4 nranks 16 cudaDev 4 busId 84000 - Destroy COMPLETE
lccn09:2520145:2520908 [6] NCCL INFO comm 0x63013cd95690 rank 6 nranks 16 cudaDev 6 busId 91000 - Destroy COMPLETE
lccn09:2520143:2520906 [5] NCCL INFO comm 0x63f7a33c4720 rank 5 nranks 16 cudaDev 5 busId 8b000 - Destroy COMPLETE
lccn09:2520137:2520905 [1] NCCL INFO comm 0x56de325943a0 rank 1 nranks 16 cudaDev 1 busId 2a000 - Destroy COMPLETE
lccn19:2471271:2472066 [4] NCCL INFO comm 0x6047aeda0e40 rank 12 nranks 16 cudaDev 4 busId 84000 - Destroy COMPLETE
lccn19:2471269:2472065 [2] NCCL INFO comm 0x570fd3fab090 rank 10 nranks 16 cudaDev 2 busId 3a000 - Destroy COMPLETE
lccn09:2520139:2520909 [3] NCCL INFO comm 0x5dc5981799b0 rank 3 nranks 16 cudaDev 3 busId 5d000 - Destroy COMPLETE
lccn19:2471268:2472070 [1] NCCL INFO comm 0x636c17517270 rank 9 nranks 16 cudaDev 1 busId 2a000 - Destroy COMPLETE
lccn19:2471274:2472071 [6] NCCL INFO comm 0x5fb68943cc30 rank 14 nranks 16 cudaDev 6 busId 91000 - Destroy COMPLETE
lccn19:2471270:2472069 [3] NCCL INFO comm 0x59b8f7d12a50 rank 11 nranks 16 cudaDev 3 busId 5d000 - Destroy COMPLETE
lccn19:2471278:2472068 [7] NCCL INFO comm 0x5ace7c6af6a0 rank 15 nranks 16 cudaDev 7 busId e4000 - Destroy COMPLETE
lccn19:2471272:2472072 [5] NCCL INFO comm 0x5664a0a62880 rank 13 nranks 16 cudaDev 5 busId 8b000 - Destroy COMPLETE
lccn09:2520148:2520911 [7] NCCL INFO comm 0x559811bf9550 rank 7 nranks 16 cudaDev 7 busId e4000 - Destroy COMPLETE




export HPCX_SHARP_DIR=/opt/mellanox/sharp

export LD_LIBRARY_PATH=\
/scratch/optpar01/work/2025/10-sharp/build/nccl-rdma-sharp-plugins/src/.libs:\
$LD_LIBRARY_PATH

mpirun                        \
    -np 8                     \
    -mca btl ^openib          \
    -x NCCL_DEBUG=info        \
    -x NCCL_COLLNET_ENABLE=1  \
    -x SHARP_COLL_LOG_LEVEL=3 \
    ./build/nccl-tests/build/all_reduce_perf \
    -b 16 -e 4G -f 4 -g 1 


