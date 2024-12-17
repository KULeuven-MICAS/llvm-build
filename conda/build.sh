curl -L $MLIR_URL -o /tmp/mlir.tar.gz
mkdir /tmp/mlir
tar -xzvf /tmp/mlir.tar.gz -C /tmp/mlir
mkdir ${PREFIX}/bin
cp /tmp/mlir/build/bin/mlir-opt ${PREFIX}/bin/mlir-opt
cp /tmp/mlir/build/bin/mlir-translate ${PREFIX}/bin/mlir-translate
rm -rf /tmp/mlir /tmp/mlir.tar.gz
