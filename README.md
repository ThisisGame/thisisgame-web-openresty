### 1. 安装OpenResty

#### Windows

解压openresty-1.19.9.1-win64.zip到当前位置

到app目录点击bat启动openresty

#### Mac

先安装依赖

```bash
brew update
brew install pcre openssl
```

下载源码：https://openresty.org/cn/download.html

解压，进入文件夹，执行下面命令编译安装。

```bash
$ ./configure \
   --with-cc-opt="-I/usr/local/opt/openssl/include/ -I/usr/local/opt/pcre/include/" \
   --with-ld-opt="-L/usr/local/opt/openssl/lib/ -L/usr/local/opt/pcre/lib/" \
   -j8
```

上面命令假设 hombrew 把库都安装到 /usr/local/opt/ 目录下面。如果不是注意修改。

安装完毕后，在app目录执行sh启动。

#### Ubuntu18.04.6

先安装openresty

参考官网：https://openresty.org/cn/linux-packages.html

你可以在你的 Ubuntu 系统中添加我们的 APT 仓库，这样就可以便于未来安装或更新我们的软件包（通过 apt-get update 命令）。 运行下面的命令就可以添加仓库（每个系统只需要运行一次）：

步骤一：安装导入 GPG 公钥时所需的几个依赖包（整个安装过程完成后可以随时删除它们）：

```bash
sudo apt-get -y install --no-install-recommends wget gnupg ca-certificates
```

步骤二：导入我们的 GPG 密钥：

```bash
wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
```

步骤三：添加我们官方 APT 仓库。

对于 x86_64 或 amd64 系统，可以使用下面的命令：

```bash
echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" \
    | sudo tee /etc/apt/sources.list.d/openresty.list
```

而对于 arm64 或 aarch64 系统，则可以使用下面的命令:

```bash
echo "deb http://openresty.org/package/arm64/ubuntu $(lsb_release -sc) main" \
    | sudo tee /etc/apt/sources.list.d/openresty.list
```

步骤四：更新 APT 索引：

```bash
sudo apt-get update
```

然后就可以像下面这样安装软件包，比如 openresty：

```bash
sudo apt-get -y install openresty
```

这个包同时也推荐安装 openresty-opm 和 openresty-restydoc 包，所以后面两个包会缺省安装上。 如果你不想自动关联安装，可以用下面方法关闭自动关联安装：

```bash
sudo apt-get -y install --no-install-recommends openresty
```

参阅 OpenResty Deb 包 页面获取这个仓库里头更多可用包的信息。

安装完成后, openresty 已自动启动. 如需关闭,执行

```bash
sudo systemctl stop openresty.service
```

安装完成后, openresty 默认开机启动. 如需关闭,执行

```bash
sudo systemctl disable openresty.service
```

启动 openresty

```bash
sudo systemctl start openresty.service
```

这种方式 openresty 的默认安装位置

```bash
/usr/local/openresty/nginx/sbin/nginx
```

安装完毕后，先用上面的命令关闭openresty，并且关闭开机启动，因为我这里用的是手动启动。

搞定上面的之后，在app目录执行sh启动。

启动之后就能访问首页了，但是子模块的Markdown图书还没有下载好，现在访问不了教程内页。


### 2. 添加图书

进入`app\md`目录添加图书

```bash
#克隆仓库并且初始化、更新submodule
git clone https://github.com/ThisisGame/cpp-game-engine-book.git --recursive
```

这个命令等同于下面的：

```bash
git clone https://github.com/ThisisGame/cpp-game-engine-book.git
git submodule init && git submodule update
```

后续要更新submodule，使用下面命令：

```bash
git submodule update
```

更新好之后，就可以访问教程内页了。