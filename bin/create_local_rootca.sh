#!/bin/bash
# @see https://gist.github.com/cecilemuller/9492b848eb8fe46d462abeb26656c4f8
# @see https://github.com/FiloSottile/mkcert
#
CWD=$(pwd)
COUNTRY='CA'
STATE='ON'
CITY='Toronto'
COUNTRY_NAME='Local-Root-CA'
HOSTS_FILE=hosts.txt
DOMAIN_EXT=domains.ext
TARGET_DIR="../docker-compose/nginx/"
CA_NAME=LocalRootCA

function createLocalRootCA {
  openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout LocalRootCA.key -out LocalRootCA.pem -subj "/C=${COUNTRY}/CN=${COUNTRY_NAME}" && {
    openssl x509 -outform pem -in ${CA_NAME}.pem -out ${CA_NAME}.crt
  }
}

function createDomainExt {
cat<<EOF> ${DOMAIN_EXT}
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
EOF

i=2
for l in `grep -vE '^#' ${HOSTS_FILE}`;do
  echo "Create DNS.$i = $l"
  echo "DNS.$i = $l" >> ${DOMAIN_EXT}
  i=$(($i + 1)) 
done 


}

function generateSSLCert {
  openssl req -new -nodes -newkey rsa:2048 -keyout localhost.key -out localhost.csr -subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=LocalCertificates/CN=localhost.local" && {
    openssl x509 -req -sha256 -days 1024 -in localhost.csr -CA LocalRootCA.pem -CAkey LocalRootCA.key -CAcreateserial -extfile domains.ext -out localhost.crt
  }
}

function copyLocalhostCrts {
  mv -v localhost.* ${TARGET_DIR}
  #mv -v ${CA_NAME}.* ${TARGET_DIR}
  #cat ${CA_NAME}.pem ${CA_NAME}.crt > ${CA_NAME}.cert
}

# MAIN
[ -f ${HOSTS_FILE} ] || {
cat<<EOL
${HOSTS_FILE} dose not exists.
Please create ${HOSTS_FILE}
e.g)
# add domains
host1.local
host2.local
EOL

    exit;
}

[ -f ${CA_NAME}.crt ] || {
  createLocalRootCA
}

createDomainExt && generateSSLCert && copyLocalhostCrts && {
cat << EOL

Completed!
Please set your Nginx config to;

ssl_certificate     /etc/nginx/conf.d/localhost.crt;
ssl_certificate_key /etc/nginx/conf.d/localhost.key;
ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
ssl_ciphers         HIGH:!aNULL:!MD5;

If you want install RootCa to your brower
sudo cp ${CA_NAME}.crt /usr/local/share/ca-certificates/
sudo chmod 644 /usr/local/share/ca-certificates/${CA_NAME}.crt
sudo dpkg-reconfigure ca-certificates
sudo update-ca-certificates
EOL

}



