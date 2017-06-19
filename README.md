# kingshard dockerfile

### 安装kingshard镜像
```
docker build -t kingshard .
```

### 运行kingshard镜像
```
docker run -d -p 9696:9696 -p 9797:9797 kingshard
```

### 安装MySQL镜像
```
docker pull docker.io/mysql
```

### 运行MySQL镜像
```
docker run -p 3306:3306 --name mysql_3306 -e MYSQL_ROOT_PASSWORD=root -d docker.io/mysql
docker run -p 3307:3306 --name mysql_3307 -e MYSQL_ROOT_PASSWORD=root -d docker.io/mysql
```

### 建数据库
```
mysql -h 127.0.0.1 -P 3306 -u root -proot -e "create database kingshard;"
mysql -h 127.0.0.1 -P 3307 -u root -proot -e "create database kingshard;
```

### 创建分表
```
for i in `seq 0 3`;do /usr/bin/mysql -h 127.0.0.1 -P 3306 -u root -proot kingshard -e "CREATE TABLE IF NOT EXISTS test_shard_hash_000"${i}" ( id BIGINT(64) UNSIGNED  NOT NULL, str VARCHAR(256), f DOUBLE, e enum('test1', 'test2'), u tinyint unsigned, i tinyint, ni tinyint, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";done
for i in `seq 4 7`;do /usr/bin/mysql -h 127.0.0.1 -P 3307 -u root -proot kingshard -e "CREATE TABLE IF NOT EXISTS test_shard_hash_000"${i}" ( id BIGINT(64) UNSIGNED  NOT NULL, str VARCHAR(256), f DOUBLE, e enum('test1', 'test2'), u tinyint unsigned, i tinyint, ni tinyint, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";done
```

### 插入数据
```
for i in `seq 1 200`;do mysql -h 127.0.0.1 -P 9696 -u kingshard -pkingshard kingshard -e "insert into test_shard_hash (id, str, f, e, u, i) values(${i}, 'abc$i', 3.14, 'test1', 255, -127)";done
```