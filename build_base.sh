set -e
set +x

rm -rf bin extensions lib  temp_user_data  usr

CODE_VERSION="4.9.1"
curl -#fL -o code-server-${CODE_VERSION}-amd64.rpm -C - https://github.com/coder/code-server/releases/download/v${CODE_VERSION}/code-server-${CODE_VERSION}-amd64.rpm
rpm2cpio code-server-${CODE_VERSION}-amd64.rpm | cpio -idmv  --no-absolute-filenames

mv usr/* .
rm -r usr
echo '#!/usr/bin/env sh' > bin/code-server
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"' >> bin/code-server
echo 'exec $DIR/../lib/code-server/bin/code-server "$@"' >> bin/code-server
rm code-server-${CODE_VERSION}-amd64.rpm

EXT_DIR="$PWD/lib/code-server/lib/vscode/extensions"
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension ms-toolsai.jupyter
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension ms-python.python



wget https://nodejs.org/dist/v18.13.0/node-v18.13.0-linux-x64.tar.xz
tar -xvf node-v18.13.0-linux-x64.tar.xz
export PATH=$PWD/node-v18.13.0-linux-x64/bin:$PATH
git clone https://github.com/fortran-lang/vscode-fortran-support.git
cd vscode-fortran-support
git checkout v3.2.0
npm install
npm install vsce
node_modules/vsce/vsce package
mv linter-gfortran-3.2.0.vsix ..
cd ..
rm -rf node-v18.13.0-linux-x64.tar.xz  node-v18.13.0-linux-x64

CPPTOOLS_VERSION="1.13.9"
curl -#fL -o cpptools-linux.vsix -C - https://github.com/microsoft/vscode-cpptools/releases/download/${CPPTOOLS_VERSION}/cpptools-linux.vsix
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension cpptools-linux.vsix
./bin/code-server --extensions-dir="$EXT_DIR" --user-data-dir="$PWD/temp_user_data" --verbose --install-extension linter-gfortran-3.2.0.vsix


rm -r temp_user_data
rm -f linter-gfortran-3.2.0.vsix
rm -f cpptools-linux.vsix

chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/debugAdapters/bin/OpenDebugAD7"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools-srv"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/bin/cpptools-wordexp"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/LLVM/bin/clang-format"
chmod +x "$EXT_DIR/ms-vscode.cpptools-${CPPTOOLS_VERSION}/LLVM/bin/clang-tidy"

ml cray-python
python3 -m venv Py
source Py/bin/activate
pip3 install fortls
