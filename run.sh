# s114
Run on single node with 8 GPUs (`-g 2`), scanning from 8 Bytes to 128MBytes :
./build/all_reduce_perf -b 8 -e 128M -f 2 -g 2

# across 2 node:
mpirun -np 2 -H s114:1,s116:1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO \
    -x NCCL_IB_DISABLE=0 \
    -x LD_LIBRARY_PATH \
    --allow-run-as-root \
    ./build/all_reduce_perf -b 8 -e 1G -f 2 -g 1