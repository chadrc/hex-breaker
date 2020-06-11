
mkdir -p "build/export"

godot --export "HTML5" "build/export/index.html"

cd "build/export"

zip ../bundle ./* 

cd ../../

butler push build/bundle.zip chadrc/hex-breaker:web-alpha
