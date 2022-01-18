echo "Building up docker environment with cordova..."
docker-compose up -d
docker-compose exec cordova /bin/bash -c "if [ ! -d /workspace/node_modules ]; then npm install --no-audit 2> /dev/null 1> /dev/null > /dev/null fi && exit"
echo "Attaching into docker shell..."
echo "# Usage:"
echo "#"
echo "#  Local browser: cordova serve"
echo "#  Deploy release: ./release.sh"
echo "#"
echo "#  Close: exit"
echo "#"
docker-compose exec cordova /bin/bash
echo "Detaching from shell..."
echo "Shutting down docker environment..."
docker-compose down