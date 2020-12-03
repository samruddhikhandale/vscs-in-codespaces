mkdir .\ssl -ErrorAction SilentlyContinue

echo "* Installing the root CA.."

.\bin\mkcert-windows -install

echo "* Creating certs.."

.\bin\mkcert-windows -cert-file .\ssl\cert.pem -key-file .\ssl\key.pem github.localhost '*.github.localhost'

docker --version

# docker is running

echo "* Starting nginx as codespaces-nginx.."

docker rm -f "codespaces-nginx"

docker run --name codespaces-nginx -p 443:443 -v ${PWD}:/etc/nginx:ro -d nginx

echo "* Done."
