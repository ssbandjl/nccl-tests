# s114:

# export PATH=/usr/lib/x86_64-linux-gnu/open-coarrays/openmpi/bin:$PATH
# export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/open-coarrays/openmpi/lib:$LD_LIBRARY_PATH
# mpicc --showme:compile

# make -j32 MPI=1 CUDA_HOME=/usr/lib/cuda DEBUG=1 CXXFLAGS="-I/usr/lib/x86_64-linux-gnu/openmpi/include -g -Og"

# apt install libopenmpi-dev openmpi-bin
# export MPI_HOME="/usr/lib/x86_64-linux-gnu/openmpi"
# make -j32 CXXFLAGS="-I/usr/lib/x86_64-linux-gnu/openmpi/include -L/usr/lib/x86_64-linux-gnu/openmpi/lib -g -Og" MPI=1 CUDA_HOME=/usr/lib/cuda DEBUG=1


export CUDA_HOME=/usr/lib/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export MPI_HOME=/usr/lib/x86_64-linux-gnu/openmpi
# ln -s /usr/bin/nvcc /usr/lib/cuda/bin/nvcc

make MPI_HOME=$MPI_HOME CXXFLAGS="-I/usr/lib/x86_64-linux-gnu/openmpi/include -L/usr/lib/x86_64-linux-gnu/openmpi/lib -g -Og" MPI=1 CUDA_HOME=$CUDA_HOME NCCL_HOME=$NCCL_HOME
# make -j32 CXXFLAGS="-I/usr/lib/x86_64-linux-gnu/openmpi/include -L/usr/lib/x86_64-linux-gnu/openmpi/lib -g -Og" MPI=1 CUDA_HOME=/usr/lib/cuda DEBUG=1

# ref: 
# make MPI=1 MPI_HOME=$MPI_HOME CUDA_HOME=$CUDA_HOME NCCL_HOME=$NCCL_HOME