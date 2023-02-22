git pull

# 还原 cpp-game-engine-book
cd app/md/cpp-game-engine-book
git checkout .
cd ../../../

# 还原 docker-book
cd app/md/docker-book
git checkout .
cd ../../../

# 还原 termux-book
cd app/md/termux-book
git checkout .
cd ../../../

# 设置资源目录可读
cd app/html/static/img
chmod 777 -R ./*

cd ../../../../

# 更新submodule，即md
git submodule update

# 设置md目录可读
cd app/md/
chmod 777 -R ./*

# reload
cd ../
./app.reload.nginx.sh