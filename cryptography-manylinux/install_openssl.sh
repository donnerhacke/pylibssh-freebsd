#!/bin/bash
set -xe

OPENSSL_URL="https://www.openssl.org/source/"
OPENSSL_NAME="openssl-1.1.1f"
OPENSSL_SHA256="186c6bfe6ecfba7a5b48c47f8a1673d0f3b0e5ba2e25602dd23b629975da3f35"

function check_sha256sum {
    local fname=$1
    local sha256=$2
    echo "${sha256}  ${fname}" > "${fname}.sha256"
    sha256sum -c "${fname}.sha256"
    rm "${fname}.sha256"
}

curl -#O "${OPENSSL_URL}/${OPENSSL_NAME}.tar.gz"
check_sha256sum ${OPENSSL_NAME}.tar.gz ${OPENSSL_SHA256}
tar zxf ${OPENSSL_NAME}.tar.gz
PATH=/opt/perl/bin:$PATH
pushd ${OPENSSL_NAME}
./config no-comp enable-ec_nistp_64_gcc_128 no-shared no-dynamic-engine --prefix=/opt/pyca/cryptography/openssl --openssldir=/opt/pyca/cryptography/openssl
make depend
make -j4
# avoid installing the docs
# https://github.com/openssl/openssl/issues/6685#issuecomment-403838728
make install_sw install_ssldirs
popd
rm -rf openssl*
