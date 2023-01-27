#!/bin/bash

port=0
password=$(echo $RANDOM | md5sum | head -c 20; echo)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PASSWORD_SHA256="$(echo -n "${password}" | openssl dgst -sha256 | awk '{print $NF}')"

export CONFIG_FILE="${SCRIPT_DIR}/config.yaml"
# Generate Jupyter configuration file with secure file permissions
(
umask 077
cat > "${CONFIG_FILE}" << EOL
hashed-password: $PASSWORD_SHA256
bind-addr: "0.0.0.0:$port"
cert: "false"

EOL
)
export PATH=$SCRIPT_DIR:$PATH
source $SCRIPT_DIR/Py/bin/activate
echo "Using password $password"
$SCRIPT_DIR/bin/code-server --disable-telemetry --user-data-dir="$SCRIPT_DIR/temp_user_data" --disable-update-check --config "${CONFIG_FILE}" --ignore-last-opened ~/my_file.f90
