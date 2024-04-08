---
title: Hexo网页搭建记录（一）
date: 2024-04-07T09:18:23Z
lastmod: 2024-04-08T17:28:52Z
tags: [网页搭建,hexo]
categories: 生产指南
index_img: https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408103905.png
banner_img: https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408103905.png
---

![image](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408103905.png)

‍

# 🙄Hexo 是啥？

Hexo 是一个快速、简洁且高效的博客框架。Hexo 使用 Markdown（或其他标记语言）解析文章，在几秒内，即可利用靓丽的主题生成静态网页。[官方文档 | Hexo](https://hexo.io/zh-cn/docs/)

# 🤔 怎么装？

## 🧑‍🌾 环境安装：

主要是 git 和 node.js 的安装，具体可参考我上一篇推文

[Hexo 网页搭建环境安装 (qq.com)](https://mp.weixin.qq.com/s/RFNJn3v--Zza7-CplweiKg)

[Hexo 网页搭建环境安装-CSDN 博客](https://blog.csdn.net/lpl0223/article/details/137473610)

## 🧑‍🔧Hexo 安装

* 当环境安装完成后，即可在 cmd 窗口或者使用 npm 安装 Hexo

  ```bash
  # 选择以下一种安装类型

  npm install hexo #局部安装

  npm install -g hexo cli #全局安装
  ```

* 检查 hexo 版本

  ```bash
  hexo --version
  ```

# 🤓 本地页面

* 创建博客文件夹，名字自定义
* 进入文件夹，在地址栏**输入 cmd 回车**，或选择文件夹空白处右键选择 **git bash here** 打开当前文件夹的命令行窗口。

  ![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408090943.png)​
* 初始化 hexo：

  ```bash
  hexo init #初始化文件夹

  npm install # 安装所需文件
  ```

  新建完成后，文件夹的目录如下

  ```
  .
  ├── _config.yml # 博客配置文件
  ├── package.json # #应用程序的信息
  ├── scaffolds # 模板文件夹
  ├── source # 存放用户资源
  |   ├── _drafts
  |   └── _posts # 文章存放文件夹
  └── themes # 主题文件夹
  ```

* 检查能否启动

  ```bash
  hexo s # 本地部署网页命令
  ```

  运行命令后，窗口会提示已在 `http://localhost:4000/` ​部署，点击链接打开，即可看到 hexo 的初始主题网页界面

# 🧐 网站配置

## hexo 配置

网页的大部分配置都可以在根目录的_config.yml 文件中进行配置和修改，具体参考 [Hexo 配置文档说明](https://hexo.io/zh-cn/docs/configuration)

# 😤 我要换主题！

## 主题下载

进入 hexo 官方主题库：

![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408102500.png)​

* 方式一：

  挑选喜欢的界面，点击进入，下载 release 到 theme 文件夹，解压
* 方式二：

  在得到主题 github 仓库地址后，在 theme 文件夹下，打开命令行窗口

  ```bash
  # 把下面网址替换成你需要的主题github仓库地址
  git clone --depth=1 https://github.com/jerryc127/hexo-theme-butterfly
  ```

* 方式三：

  Hexo 5.0.0 版本以上，推荐通过 npm 直接安装，进入博客目录执行命令：

  ```bash
  npm install --save hexo-theme-fluid
  ```

以上方式都需要把主题文件夹的名称改成主题名，方便后续设置

## 主题配置

修改 hexo 安装文件夹下的_config.yml 文件，theme 后面的名字改为你安装主题的名字，如 fluid。

![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408100125.png)​

后续的界面 diy，参考主题对应的参考文档就好啦 👍

‍

下面是几个比较热门，相关教程也比较多的主题：

* [Hexo Theme Fluid (fluid-dev.com)](https://hexo.fluid-dev.com/)
* [Butterfly - A Simple and Card UI Design theme for Hexo](https://butterfly.js.org/)
* [theme-next.js.org](https://theme-next.js.org/)
* [DaraW | Code is Poetry](https://blog.daraw.cn/)

# 指令

在 hexo 文件夹根目录下 👇

* 新建文章：

  ```bash
  hexo new [layout] <title>
  # 例hexo new "如何新建一篇文章"
  ```
* 新建页面

  ```bash
  hexo new page "page name"
  ```

  **注意**：新增 tags、categories 等页面后，需要到主题文件夹下的_config.yml 中的 menu 设置项开启页面（取消注释即可）

  ![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408105759.png)​
* 生成静态文件

  ```bash
  hexo g
  ```
* 启动服务器

  ```bash
  hexo s
  ```
* 部署网站(需要服务器）

  ```bash
  hexo d
  ```

# 参考链接

* [建站 | Hexo](https://hexo.io/zh-cn/docs/setup)
* [开始使用 | Hexo Fluid 用户手册 (fluid-dev.com)](https://hexo.fluid-dev.com/docs/start/)
* https://sspai.com/post/62441
