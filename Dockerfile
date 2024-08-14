FROM ubuntu:24.04 AS toolchain-build

RUN apt-get update && apt-get install -y lsb-release wget software-properties-common gnupg curl && \
  wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 17 && rm llvm.sh

RUN apt-get -y install git

# Build MLIR from source
RUN git clone https://github.com/llvm/llvm-project.git && \
cd /llvm-project/ && \
git checkout 98e674c9f16d677d95c67bc130e267fae331e43c


RUN apt-get install -y ninja-build cmake clang clang-tools lld

RUN apt-get install libpthread-stubs0-dev
RUN mkdir /llvm-project/build && \
cd /llvm-project/build && \
cmake -G Ninja ../llvm \
   -DLLVM_ENABLE_PROJECTS=mlir \
   -DLLVM_TARGETS_TO_BUILD="X86" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON && \
# CCache can drastically speed up further rebuilds, try adding:
#  -DLLVM_CCACHE_BUILD=ON
# Optionally, using ASAN/UBSAN can find bugs early in development, enable with:
# -DLLVM_USE_SANITIZER="Address;Undefined"
# Optionally, enabling integration tests as well
# -DMLIR_INCLUDE_INTEGRATION_TESTS=ON
cmake --build . --target mlir-opt mlir-cpu-runner
