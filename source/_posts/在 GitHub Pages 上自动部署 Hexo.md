---
title: 在 GitHub Pages 上自动部署 Hexo
date: 2024-04-03T23:04:52Z
lastmod: 2024-04-05T23:17:19Z
author: lynx
tags: 网页搭建
categories: 生产指南
index_img: https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240405230721.png
banner_img: https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240405230721.png
---

# Github Action 介绍

GitHub Actions 是 GitHub 于 2018 年 10 月推出的持续集成服务。

GitHub Actions 的工作原理如下：

1. 当我们设置好需要自动化执行的任务脚本（存放在 `.github/workflows`​ 目录下的 `.yml`​ 文件）后，GitHub Actions 监控当前仓库的某一个操作（如 push）。
2. 一旦有此操作发生，GitHub Actions 将分配一个虚拟主机来自动化执行这些任务。

我们设置的任务即为 Action，它存放在项目根目录的 `.github/workflows`​ 文件下，后缀为 `.yml`​。一个 Action 相当于是一个工作流，一个工作流可以包含多个任务，每个任务又可以分成几个步骤。任务、步骤会依次执行。

**接下来就是操作步骤了**

# 1、Hexo 本地源文件连接 github page 仓库

1. **GitHub 上建立名为**  `**<你的 GitHub 用户名>.github.io**` **的储存库**，若之前已将 Hexo 上传至其他储存库，将该储存库重命名即可。教程参考 👉[siyuan://blocks/20240403225625-rs9ss7g](siyuan://blocks/20240403225625-rs9ss7g)
2. **git 创建新分支（若本地还未连接过 github 仓库，可参考：**​[Github——git 本地仓库建立与远程连接（最详细清晰版本！附简化步骤与常见错误）_将本地仓库与远程仓库关联-CSDN 博客](https://blog.csdn.net/qq_29493173/article/details/113094143)）

   ```git
   git branch new-branch #本地创建一个新的分支，new-branch为新分支名
   
   git checkout new-branch #切换到新分支
   
   #如果你已经在本地进行了一些修改（例如，添加了新文件或者修改了现有文件），你需要将这些更改暂存并提交到新分支上
   git add . #将更改暂存
   
   git commit -m "Your commit message" #使用git commit命令将暂存的更改提交到新分支上
   
   git push origin new-branch #将新分支的更改推送到远程仓库
   ```
3. 将 Hexo 文件夹中的文件 push 到储存库新建的非默认分支（如 hexooo）

* 将本地 hexooo 分支 push 到 GitHub

  ```
  git push -u origin hexooo
  ```
* 默认情况下 `public/`​ 不会被上传(也不该被上传)，确保 `.gitignore`​ 文件中包含一行 `public/`​。整体文件夹结构应该与 [示例储存库](https://github.com/hexojs/hexo-starter) 大致相似。

# 2、配置密钥

如果你的 Hexo 可以正常地部署到 GitHub，那么实际上你原来的秘钥是可以正常使用的。但是私钥可能还用于不同的服务器的 SSH 访问和其他身份验证，因此，我们生成一个新的秘钥对来专门部署 Hexo。

以操作系统是 Windows 为例：

1. **打开命令提示符**：在开始菜单中搜索并打开 "命令提示符"或"cmd"。
2. **检查是否已存在 SSH 密钥**：输入以下命令并按 Enter 键：

   ```bash
   dir %userprofile%\.ssh
   ```

   如果已经存在 SSH 密钥，你将看到类似 `id_rsa`​ 和 `id_rsa.pub`​ 这样的文件。这些文件就是你的 SSH 私钥和公钥。
3. **如果没有 SSH 密钥，生成新的密钥**：输入以下命令并按 Enter 键：

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

   替换 `your_email@example.com`​ 为你的 GitHub 注册邮箱。这条命令将会生成一对新的 SSH 密钥。
4. **按提示操作**：运行上述命令后，你会看到一些提示，如密钥文件的保存位置等。你可以选择默认选项，或者按照提示输入自定义的文件名和密码。
5. **添加 SSH 密钥到 GitHub**：完成密钥生成后，你需要将**公钥**（一般是以 XXXpub 结尾的）和私钥都添加到 GitHub 上。你可以使用命令来显示，也可以去刚刚生成密钥文件查看。
6. **在 GitHub 上添加公钥**：在 GitHub 部署仓库，进入 Settings -> Deploy keys -> Add deploy key 页面。在 "Title" 中输入一个描述性的标题如，然后粘贴刚才复制的公钥到 "Key" 文本框中，最后点击 "Add SSH key" 按钮。

   ![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240405222023.png "Deploy keys页面")
7. **在 GitHub 上添加部署 Action 私钥：** 仓库访问 Settings -> Deploy keys -> New respository secret，名字部分填写：`HEXO_DEPLOY_KEY`​，注意大小写，这个后面的 GitHub Actions Workflow 要用到，一定不能写错。

   ![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240405222337.png "Action secret页面")

# 3、创建 Github Action 工作流 workflow

* 使用 `node --version`​ 指令检查你电脑上的 Node.js 版本，并**记下该版本** (例如：`v20.y.z`​)
* 在 github 储存库中前往 `Settings > Pages > Source`​，并将 `Source`​ 改为 `GitHub Actions`​。
* 在本地 Hexo 根目录中创建 `.github/workflows/pages.yml`​，并填入以下内容 (将 node 版本中的 20 替换为第一个步骤中记下的版本)：

```yml
# 定义一个名为 Pages 的动作
name: Pages

# 当有一个新的推送（push）到名为 hexooo 的分支时，执行部署任务
on:
  push:
    branches:
      - hexooo

# 定义一个名为 build-and-deploy 的 job
jobs:
  build-and-deploy:
    # 在 Ubuntu 最新版本上运行此 job
    runs-on: ubuntu-latest
    steps:
      # 检出 hexooo 分支的代码
      - name: Checkout code from hexooo branch
        uses: actions/checkout@v4
        with:
          ref: hexooo
          persist-credentials: false

      # 设置 Git 用户信息
      - name: Set up Git user information
        run: |
          git config --global user.name "L0223"
          git config --global user.email "18312158453@163.com"

      # 设置 Node.js 20.x 版本
      - name: Set up Node.js 20.x
        uses: actions/setup-node@v2
        with:
          node-version: '20'
  
      # 全局安装 Hexo
      - name: Install Hexo globally
        run: |
          npm install -g hexo-cli
          npm install

      # 缓存 NPM 依赖
      - name: Cache NPM dependencies
        uses: actions/cache@v2
        with:
          path: node_modules
          key: ${{ runner.OS }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.OS }}-node-

      # 构建hexo博客（可选）
      # - name: Build
      #   run: npm run build

      # 使用环境变量 ACTION_DEPLOY_KEY 部署到主分支
      - name: Deploy to main branch
        env:
          ACTION_DEPLOY_KEY: ${{ secrets.HEXO_DEPLOY_KEY }}
        run: |
          mkdir -p ~/.ssh/
          echo "$ACTION_DEPLOY_KEY" > ~/.ssh/id_rsa
          chmod 700 ~/.ssh
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts

      # 部署
      - name: Deploy
        run: |
          hexo clean
          hexo generate
          hexo deploy
```

6. 文件创建完后，push 至 github，在仓库页面的 Action 选项卡可查看工作部署流程

   ![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240405230309.png "Action部署页面")

最后，前往 `https://<你的 GitHub 用户名>.github.io`​ 查看网站

![image.png](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/siyuanpic/20240405230721.png "部署成功")

## 参考链接

* [GitHub Pages 使用文档](https://docs.github.com/zh/pages)
* [使用自定义 GitHub Actions 工作流进行发布](https://docs.github.com/zh/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#%E4%BD%BF%E7%94%A8%E8%87%AA%E5%AE%9A%E4%B9%89-github-actions-%E5%B7%A5%E4%BD%9C%E6%B5%81%E8%BF%9B%E8%A1%8C%E5%8F%91%E5%B8%83)
* [actions/deploy-github-pages-site](https://github.com/marketplace/actions/deploy-github-pages-site)
* [在 GitHub Pages 上部署 Hexo | Hexo](https://hexo.io/zh-cn/docs/github-pages)
* [Github——git 本地仓库建立与远程连接（最详细清晰版本！附简化步骤与常见错误）_将本地仓库与远程仓库关联-CSDN 博客](https://blog.csdn.net/qq_29493173/article/details/113094143)
* [GitHub Actions 来自动部署 Hexo - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/170563000)
* [使用 GitHub Actions 自动部署 Hexo 博客到 GitHub Pages - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/161969042#:~:text=%E4%BD%BF%E7%94%A8%20GitHub%20Actions%20%E8%87%AA%E5%8A%A8%E9%83%A8%E7%BD%B2%20Hexo%20%E5%8D%9A%E5%AE%A2%E5%88%B0%20GitHub%20Pages,%E5%BC%80%E5%8F%91%E6%BA%90%E7%A0%81%E3%80%82%20...%203%20%E9%83%A8%E7%BD%B2%20%E6%9C%80%E5%90%8E%EF%BC%8C%E6%88%91%E4%BB%AC%E5%8F%AA%E9%9C%80%E8%A6%81%E5%B0%86%E6%BA%90%E7%A0%81%E6%8E%A8%E9%80%81%E5%88%B0%E6%8C%87%E5%AE%9A%E5%88%86%E6%94%AF%EF%BC%8CGitHub%20Actions%20%E5%B0%B1%E4%BC%9A%E8%87%AA%E5%8A%A8%E5%B8%AE%E6%88%91%E4%BB%AC%E9%83%A8%E7%BD%B2%E9%A1%B9%E7%9B%AE%E5%95%A6%E3%80%82%20)

‍
