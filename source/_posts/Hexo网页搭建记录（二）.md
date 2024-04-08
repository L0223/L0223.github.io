---
title: Hexo网页搭建记录（二）
date: 2024-04-08T11:55:57Z
tags: [hexo,网页搭建]
categories: 生产指南
index_img: https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408103905.png
banner_img: https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408103905.png
---

![](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408103905.png)

‍

书接上回👉：[Hexo网页搭建记录（一） (qq.com)](https://mp.weixin.qq.com/s/TBn7h0mGex3C1yNHuyDfyA)。

上回讲到，Hexo在**本地**的安装、配置以及部署。

🤔但怎样才能让别人在网上看得到我的博客？

这篇记录，或许能提供一个低成本的易上手的方案。

# 简介

* **Github pages**

  [关于 GitHub Pages - GitHub 文档](https://docs.github.com/zh/pages/getting-started-with-github-pages/about-github-pages)。GitHub Pages 是一项静态站点托管服务，它直接从 GitHub 上的仓库获取 HTML、CSS 和 JavaScript 文件，（可选）通过构建过程运行文件（Action)，然后发布网站。
* **部署原理**

  本地撰写完markdown格式文章后，通过hexo解析成具有主题样式的HTML静态网页，再推送至github pages 完成发布

  ![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408151534.png)​

这个方案的好处是安全、完全免费，迁移方便。不足是发文流程稍复杂，访问速度一般。

为了改善问题，前段时间我查找资料进行了一定的优化，有需要可以参考：

[【小白向】基于fluid模板的网页相册搭建 (qq.com)](https://mp.weixin.qq.com/s/7p6ez0PY6i4THydZELZ3DA)

[在GitHub Pages上自动部署Hexo (qq.com)](https://mp.weixin.qq.com/s/YbkyoJoba9vqaOPSaSGq5A)

# Github page创建

建立名为  `**<你的 GitHub 用户名>.github.io**`​ 的公开储存库，若之前已将 Hexo 上传至其他储存库，将该储存库重命名即可。之后点击pages选项则会自动生成静态网页。

![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408153513.png)

之后点击pages选项则会自动生成静态网页

![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408164937.png)

# Hexo部署至Github page

## 仓库连接

* 先查看git环境配置

  ```bash
  git config --list
  ```
* 如果本地还没有配置user.name和user.email，则需要用以下命令进行配置

  ```bash
  git config --global user.name "用户名"
  git config --global user.email  "<your github email>" #填写github注册的邮箱
  ```
* 生成ssh密钥

  ```bash
  ssh-keygen -t ed25519 -C "<your github email>"
  #或
  ssh-keygen -t rsa -C "<your github email>"
  ```

  运行完命令一路回车就行
* 添加密钥到github

  进入 [C:\Users\用户名\\\.ssh] 目录（要勾选显示“隐藏的项目”），用记事本打开公钥 id_rsa.pub （公钥）文件并复制里面的内容。

  登陆 GitHub ，进入账户Settings 页面，选择左边栏的 SSH and GPG keys，点击 New SSH key。

  ![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408160321.png)

  Titlte自定义，keytype默认，把刚刚复制的id_rsa.pub粘贴到key填写框

  ![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408160730.png)
* 验证

  ```bash
  ssh -T git@github.com
  # 如果输出以下内容，则表示配置成功，此时即可直接进行任何git操作。
  # Hi xxx! You've successfully authenticated, but GitHub does not provide shell access.
  ```

## 配置config.yml

补充hexo配置文件config.yml中的deploy配置，<respository url>可以填仓库的https或ssh

![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240408161926.png)

```bash
deploy:
  type: git
  repo: <repository url> # <repository url>为仓库的https或ssh
  branch: [branch] # [branch]为main或其他分支
```

## 部署流程

* 安装所需插件

  ```bash
  # （可选）本地部署渲染效果实时预览插件
  npm install hexo-browsersync --save

  # hexo部署插件
  npm install hexo-deployer-git --save
  ```

* 部署流程

  ```bash
  # 部署流程
  hexo clean # 清除缓存文件 (db.json) 和已生成的静态文件 (public)
  
  hexo g # 解析渲染生成静态文件
  
  hexo s # 启动服务器，可用于本地调试。默认情况下访问网址为：http://localhost:4000/
  
  hexo d # 部署网站至设置好的GitHub pages
  ```

  ‍

其他常用命令：

```bash
hexo new "name"       # 新建文章
hexo new page "name"  # 新建页面
hexo g                # 生成页面
hexo d                # 部署
hexo g -d             # 生成页面并部署
hexo s                # 本地预览
hexo clean            # 清除缓存和已生成的静态文件
hexo help             # 帮助
```

# 参考链接

[Hexo使用SSH连接GitHub_hexo的ssh连接github-CSDN博客](https://blog.csdn.net/weixin_42569846/article/details/105808683)

[创建 GitHub Pages 站点 - GitHub 文档](https://docs.github.com/zh/pages/getting-started-with-github-pages/creating-a-github-pages-site)

[Github配置SSH密钥连接（附相关问题解决） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/628727065#:~:text=Github%E9%85%8D%E7%BD%AESSH%E5%AF%86%E9%92%A5%E8%BF%9E%E6%8E%A5%EF%BC%88%E9%99%84%E7%9B%B8%E5%85%B3%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%EF%BC%89%201%201.%20%E7%94%9F%E6%88%90SSH%E5%AF%86%E9%92%A5%20%E9%A6%96%E5%85%88%E5%9C%A8%E6%9C%AC%E5%9C%B0%E6%9C%BA%E5%99%A8%E4%B8%8A%E6%89%93%E5%BC%80%E7%BB%88%E7%AB%AF%EF%BC%8C%20%E8%BE%93%E5%85%A5%E4%BB%A5%E4%B8%8B%E5%91%BD%E4%BB%A4%E7%94%9F%E6%88%90SSH%E5%AF%86%E9%92%A5%20%EF%BC%9A%20...,%E5%A4%8D%E5%88%B6%E5%85%AC%E9%92%A5%E5%86%85%E5%AE%B9%20%E5%88%B0%E8%87%AA%E5%B7%B1%E7%9A%84Github%E8%B4%A6%E6%88%B7%E4%B8%AD%E3%80%82%20...%204%204.%20%E9%AA%8C%E8%AF%81%20%E6%89%A7%E8%A1%8C%E5%AE%8C%E4%B8%8A%E8%BF%B0%E4%B8%A4%E6%AD%A5%E6%93%8D%E4%BD%9C%E5%90%8E%EF%BC%8C%E6%AD%A3%E5%B8%B8%E6%83%85%E5%86%B5%E4%B8%8B%E5%B7%B2%E7%BB%8F%E9%85%8D%E7%BD%AE%E6%88%90%E5%8A%9F%E4%BA%86%EF%BC%8C%E6%AD%A4%E6%97%B6%E5%8F%AF%E4%BB%A5%E9%AA%8C%E8%AF%81%E4%B8%80%E4%B8%8B%EF%BC%9A%20)

[部署 | Hexo](https://hexo.io/zh-cn/docs/one-command-deployment)
