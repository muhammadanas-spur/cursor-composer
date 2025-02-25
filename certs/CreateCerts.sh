#!/bin/bash

# openssl genrsa -out test-ca.private-key.pem 4096
# openssl rsa -in test-ca.private-key.pem -pubout -out test-ca.public-key.pem
# openssl req -new -x509 -key test-ca.private-key.pem -out test-ca.cert.pem -days 365 -config test-ca.cnf
# openssl pkcs12 -export -inkey test-ca.private-key.pem -in test-ca.cert.pem -out test-ca.pfx -passout file:Password.txt
# openssl x509 -in test-ca.cert.pem -out test-ca.crt

# openssl genrsa -out integrations.api.private-key.pem 4096
# openssl rsa -in integrations.api.private-key.pem -pubout -out integrations.api.public-key.pem
# openssl req -new -sha256 -key integrations.api.private-key.pem -out integrations.api.csr -config integrations.api.cnf
# openssl x509 -req -in integrations.api.csr -CA test-ca.cert.pem -CAkey test-ca.private-key.pem -CAcreateserial -out integrations.api.cer -days 365 -sha256 -extfile integrations.api.cnf -extensions req_v3
# openssl pkcs12 -export -inkey integrations.api.private-key.pem -in integrations.api.cer -out integrations.api.pfx -passout file:Password.txt

# openssl genrsa -out queuing.api.private-key.pem 4096
# openssl rsa -in queuing.api.private-key.pem -pubout -out queuing.api.public-key.pem
# openssl req -new -sha256 -key queuing.api.private-key.pem -out queuing.api.csr -config queuing.api.cnf
# openssl x509 -req -in queuing.api.csr -CA test-ca.cert.pem -CAkey test-ca.private-key.pem -CAcreateserial -out queuing.api.cer -days 365 -sha256 -extfile queuing.api.cnf -extensions req_v3
# openssl pkcs12 -export -inkey queuing.api.private-key.pem -in queuing.api.cer -out queuing.api.pfx -passout file:Password.txt

# openssl genrsa -out businessmodules.api.private-key.pem 4096
# openssl rsa -in businessmodules.api.private-key.pem -pubout -out businessmodules.api.public-key.pem
# openssl req -new -sha256 -key businessmodules.api.private-key.pem -out businessmodules.api.csr -config businessmodules.api.cnf
# openssl x509 -req -in businessmodules.api.csr -CA test-ca.cert.pem -CAkey test-ca.private-key.pem -CAcreateserial -out businessmodules.api.cer -days 365 -sha256 -extfile businessmodules.api.cnf -extensions req_v3
# openssl pkcs12 -export -inkey businessmodules.api.private-key.pem -in businessmodules.api.cer -out businessmodules.api.pfx -passout file:Password.txt

# openssl genrsa -out webaggregator.private-key.pem 4096
# openssl rsa -in webaggregator.private-key.pem -pubout -out webaggregator.public-key.pem
# openssl req -new -sha256 -key webaggregator.private-key.pem -out webaggregator.csr -config webaggregator.cnf
# openssl x509 -req -in webaggregator.csr -CA test-ca.cert.pem -CAkey test-ca.private-key.pem -CAcreateserial -out webaggregator.cer -days 365 -sha256 -extfile webaggregator.cnf -extensions req_v3
# openssl pkcs12 -export -inkey webaggregator.private-key.pem -in webaggregator.cer -out webaggregator.pfx -passout file:Password.txt

# openssl genrsa -out alerts.api.private-key.pem 4096
# openssl rsa -in alerts.api.private-key.pem -pubout -out alerts.api.public-key.pem
# openssl req -new -sha256 -key alerts.api.private-key.pem -out alerts.api.csr -config alerts.api.cnf
# openssl x509 -req -in alerts.api.csr -CA test-ca.cert.pem -CAkey test-ca.private-key.pem -CAcreateserial -out alerts.api.cer -days 365 -sha256 -extfile alerts.api.cnf -extensions req_v3
# openssl pkcs12 -export -inkey alerts.api.private-key.pem -in alerts.api.cer -out alerts.api.pfx -passout file:Password.txt

# openssl genrsa -out interactions.api.private-key.pem 4096
# openssl rsa -in interactions.api.private-key.pem -pubout -out interactions.api.public-key.pem
# openssl req -new -sha256 -key interactions.api.private-key.pem -out interactions.api.csr -config interactions.api.cnf
# openssl x509 -req -in interactions.api.csr -CA test-ca.cert.pem -CAkey test-ca.private-key.pem -CAcreateserial -out interactions.api.cer -days 365 -sha256 -extfile interactions.api.cnf -extensions req_v3
# openssl pkcs12 -export -inkey interactions.api.private-key.pem -in interactions.api.cer -out interactions.api.pfx -passout file:Password.txt


# Function to generate keys and certificates
generate_cert() {
  local name=$1
  local config=$2

  openssl genrsa -out ${name}.private-key.pem 4096
  openssl rsa -in ${name}.private-key.pem -pubout -out ${name}.public-key.pem
  openssl req -new -sha256 -key ${name}.private-key.pem -out ${name}.csr -config ${config}
  openssl x509 -req -in ${name}.csr -CA custom-sample-ca.cert.pem -CAkey custom-sample-ca.private-key.pem -CAcreateserial -out ${name}.cer -days 365 -sha256 -extfile ${config} -extensions req_v3
  openssl pkcs12 -export -inkey ${name}.private-key.pem -in ${name}.cer -out ${name}.pfx -passout file:Password.txt
}

# Generate CA keys and certificate
openssl genrsa -out custom-sample-ca.private-key.pem 4096
openssl rsa -in custom-sample-ca.private-key.pem -pubout -out custom-sample-ca.public-key.pem
openssl req -new -x509 -key custom-sample-ca.private-key.pem -out custom-sample-ca.cert.pem -days 365 -config custom-sample-ca.cnf
openssl pkcs12 -export -inkey custom-sample-ca.private-key.pem -in custom-sample-ca.cert.pem -out custom-sample-ca.pfx -passout file:Password.txt
openssl x509 -in custom-sample-ca.cert.pem -out custom-sample-ca.crt

# Generate certificates for each API
generate_cert "backendservices" "backendservices.cnf"
generate_cert "anotherbackendservice" "anotherbackendservice.cnf"