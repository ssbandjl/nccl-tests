# s114:

# export PATH=/usr/lib/x86_64-linux-gnu/open-coarrays/openmpi/bin:$PATH
# export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/open-coarrays/openmpi/lib:$LD_LIBRARY_PATH
# mpicc --showme:compile

# make -j32 MPI=1 CUDA_HOME=/usr/lib/cuda DEBUG=1 CXXFLAGS="-I/usr/lib/x86_64-linux-gnu/openmpi/include -g -Og"

# apt install libopenmpi-dev openmpi-bin
export MPI_HOME="/usr/lib/x86_64-linux-gnu/openmpi"
make -j32 CXXFLAGS="-I/usr/lib/x86_64-linux-gnu/openmpi/include -L/usr/lib/x86_64-linux-gnu/openmpi/lib -g -Og" MPI=1 CUDA_HOME=/usr/lib/cuda DEBUG=1


