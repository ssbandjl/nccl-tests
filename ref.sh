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