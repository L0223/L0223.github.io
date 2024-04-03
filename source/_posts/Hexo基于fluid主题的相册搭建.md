---
title: Hexo基于fluid模板的相册搭建
date: 2024-03-25 22:31:56
author: lynx
tags: 网页搭建
categories: 生产指南
hide:
sticky: 
index_img: https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/gallery/Sdpaint/00252-642878706-1girl%2Cwhite%20hair%2Cblack%20long%20dress%2C%28flower%20background_1.1%29%2C%28studio%20ghibli_1.2%29%2C.png
banner_img: https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/gallery/Sdpaint/00252-642878706-1girl%2Cwhite%20hair%2Cblack%20long%20dress%2C%28flower%20background_1.1%29%2C%28studio%20ghibli_1.2%29%2C.png
---


Hexo主要是用于发表博客也就是文章的静态网页框架工具，所以官方很少给到相册搭建的教程。而作为前端小白的我，尝试搭建网页的目的就是为了制作一个网页相册，为此，我死磕了接近一个星期，才大概把这个博客网页集成相册功能的方法搞懂。

# Toc
<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=3 orderedList=false} -->

<!-- code_chunk_output -->

- [搭建思路](#搭建思路)
- [文件夹分配](#文件夹分配)
- [操作步骤](#操作步骤)
  - [1.新建相册页面](#1新建相册页面)
  - [2.处理图片信息](#2处理图片信息)
  - [3.加载js和css文件](#3加载js和css文件)
  - [4.网页端图片加速](#4网页端图片加速)
- [优化](#优化)
  - [简化create流程](#简化create流程)
  - [简化ossutil流程](#简化ossutil流程)
- [参考](#参考)

<!-- /code_chunk_output -->



## 搭建思路

![搭建思路](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/gallery/%E6%96%87%E7%AB%A0%E5%9B%BE/202403302122803.png)

## 文件夹分配

![文件夹结构](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/gallery/%E6%96%87%E7%AB%A0%E5%9B%BE/202403311642349.png)

- gallery：装载相册原图的文件夹。在该文件夹下，不同主题的相册以**单独**的文件夹存放，并且，相册里面只允许存放**图片格式**的文件
- photos：由hexo新建命令生成的页面文件夹，用于构成网页导航中的相册子页面。其中的**index**定义了页面的内容和元数据（通过YAML Front-matter），并会被Hexo转换成最终的静态HTML页面
- js：存放source文件下的JavaScript脚本
- hexo根目录下的scripts：存放注入代码等需要在根目录执行的JavaScript脚本

## 操作步骤

### 1.新建相册页面

```node
hexo n page photos
```

编辑index.md,输入以下信息形成页面布局

```markdown
---
title: Photos
date: 2024-03-25 16:57:45
subtitle: 岁月留痕
layout: photo
---

<style>
.ImageGrid {
  width: 100%;
  max-width: 1040px;
  margin: 0 auto;
  text-align: center;
}
.card {
  overflow: hidden;
  transition: .3s ease-in-out;
  border-radius: 8px;
  background-color: #efefef;
  padding: 1.4px;
}
.ImageInCard img {
  padding: 0;
  border-radius: 8px;
  width:100%;
  height:100%;
}
@media (prefers-color-scheme: dark) {
  .card {background-color: rgba(180,180,180,0.2)#333;}
}

</style>
<div id="imageTab"></div>
<div class="ImageGrid"></div>
```

### 2.处理图片信息

1. 创建存放照片原图文件夹images/gallery，子目录为根据主题分类的相册，如“广州”、“上海”...

2. 在gallery文件夹下新建js文件"create.js"，用于处理图片信息

   ```js
   # create.js
   const fs = require('fs-extra');
   const path = require('path');
   const imageSize = require('image-size');  # 这里没有安装 image-size，需要npm安装下:   npm i -S image-size
   
   const rootPath="gallery/"   //相册相对路径，也可填绝对路径，指向相册的目录，目的为了生成json
   
   class PhotoExtension {
       constructor() {
           this.size = 64;
           this.offset = [0, 0];
       }
   }
   
   class Photo {
       constructor() {
           this.dirName = '';
           this.fileName = '';
           this.iconID = '';
           this.extension = new PhotoExtension();
       }
   }
   
   class PhotoGroup {
       constructor() {
           this.name = '';
           this.children = [];
       }
   }
   
   function createPlotIconsData() {
       let allPlots = [];
       let allPlotGroups = [];
   
       const plotJsonFile = path.join(__dirname, './photosInfo.json');
       const plotGroupJsonFile = path.join(__dirname, './photos.json');
   
       if (fs.existsSync(plotJsonFile)) {
           allPlots = JSON.parse(fs.readFileSync(plotJsonFile));
       }
   
       if (fs.existsSync(plotGroupJsonFile)) {
           allPlotGroups = JSON.parse(fs.readFileSync(plotGroupJsonFile));
       }
   
       fs.readdirSync(__dirname).forEach(function(dirName) {
           const stats = fs.statSync(path.join(__dirname, dirName));
           const isDir = stats.isDirectory();
           if (isDir) {
               const subfiles = fs.readdirSync(path.join(__dirname, dirName));
               subfiles.forEach(function(subfileName) {
                   // 如果已经存在 则不再处理
                   // if (allPlots.find(o => o.fileName === subfileName && o.dirName === dirName)) {
                   //     return;
                   // }
   
                   // 新增标
                   const plot = new Photo();
                   plot.dirName = dirName;
                   plot.fileName = subfileName;
                   const imageInfo = imageSize(rootPath+dirName + "/" + subfileName);
                   plot.iconID = imageInfo.width + '.' + imageInfo.height + ' ' + subfileName;
                   allPlots.push(plot);
                   console.log(`RD: createPlotIconsData -> new plot`, plot);
   
                   // 为新增标添加分组 暂时以它所处的文件夹为分组
                   let group = allPlotGroups.find(o => o.name === dirName);
                   if (!group) {
                       group = new PhotoGroup();
                       group.name = dirName;
                       allPlotGroups.push(group);
                       console.log(`RD: createPlotIconsData -> new group`, group);
                   }
                   group.children.push(plot.iconID);
               });
           }
       });
   
       fs.writeJSONSync(plotJsonFile, allPlots);
       fs.writeJSONSync(plotGroupJsonFile, allPlotGroups);
   }
   
   createPlotIconsData();
   ```

3. **执行create.js文件**，在gallery文件夹下生成包含图片信息的JSON文件（photosInfo.json和photos.json`）

   ```cmd
   # 相册的生成需要先用create.js脚本对images\gallery\下的相册文件进行预处理
   # 示例 F:myblog\source\images>node gallery/create.js
   node gallery/create.js
   ```

4. 将photos.json**拷贝**到source目录下的photos页面文件夹中

### 3.加载js和css文件

1. 在 /source/js/ 目录下创建 photoWall.js，用于在网页上动态创建和管理图片相册的界面

   ```js
   var imgDataPath = "/photos/photos.json"; //图片名称高宽信息json文件路径
   var imgPath = "/sources/images/gallery/"; //图片访问路径, 这里示例是本地路径，后续会提供网页端图片加载加速方案
   var imgMaxNum = 50; //图片显示数量
   
   var windowWidth =
     window.innerWidth ||
     document.documentElement.clientWidth ||
     document.body.clientWidth;
   if (windowWidth < 768) {
     var imageWidth = 145; //图片显示宽度(手机端)
   } else {
     var imageWidth = 250; //图片显示宽度
   }
   
   const photo = {
     page: 1,
     offset: imgMaxNum,
     init: function () {
       var that = this;
       $.getJSON(imgDataPath, function (data) {
         that.render(that.page, data);
         //that.scroll(data);
         that.eventListen(data);
       });
     },
     constructHtml(options) {
       const {
         imageWidth,
         imageX,
         imageY,
         name,
         imgPath,
         imgName,
         imgNameWithPattern,
       } = options;
       const htmlEle = `<div class="card lozad" style="width:${imageWidth}px">
                     <div class="ImageInCard" style="height:${
                       (imageWidth * imageY) / imageX
                     }px">
                       <a data-fancybox="gallery" href="${imgPath}${name}/${imgNameWithPattern}"
                             data-caption="${imgName}" title="${imgName}">
                               <img  class="lazyload" data-src="${imgPath}${name}/${imgNameWithPattern}"
                               src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
                               onload="lzld(this)"
                               lazyload="auto">
                           </a>
                     </div>
                   </div>`;
       return htmlEle;
     },
     render: function (page, data = []) {
       this.data = data;
       if (!data.length) return;
       var html,
         imgNameWithPattern,
         imgName,
         imageSize,
         imageX,
         imageY,
         li = "";
   
       let liHtml = "";
       let contentHtml = "";
   
       data.forEach((item, index) => {
         const activeClass = index === 0 ? "active" : "";
         liHtml += `<li class="nav-item" role="presentation">
             <a class="nav-link ${activeClass} photo-tab" id="home-tab" photo-uuid="${item.name}" data-toggle="tab" href="#${item.name}"  role="tab" aria-controls="${item.name}" aria-selected="true">${item.name}</a>
           </li>`;
       });
       const [initData = {}] = data;
       const { children = [],name } = initData;
       children.forEach((item, index) => {
         imgNameWithPattern = item.split(" ")[1];
         imgName = imgNameWithPattern.split(".")[0];
         imageSize = item.split(" ")[0];
         imageX = imageSize.split(".")[0];
         imageY = imageSize.split(".")[1];
         let imgOptions = {
           imageWidth,
           imageX,
           imageY,
           name,
           imgName,
           imgPath,
           imgNameWithPattern,
         };
         li += this.constructHtml(imgOptions);
       });
       contentHtml += ` <div class="tab-pane fade show active"  role="tabpanel" aria-labelledby="home-tab">${li}</div>`;
   
       const ulHtml = `<ul class="nav nav-tabs" id="myTab" role="tablist">${liHtml}</ul>`;
       const tabContent = `<div class="tab-content" id="myTabContent">${contentHtml}</div>`;
   
       $("#imageTab").append(ulHtml);
       $(".ImageGrid").append(tabContent);
       this.minigrid();
     },
     eventListen: function (data) {
       let self = this;
       var html,
         imgNameWithPattern,
         imgName,
         imageSize,
         imageX,
         imageY,
         li = "";
       $('a[data-toggle="tab"]').on("shown.bs.tab", function (e) {
         $(".ImageGrid").empty();
         const selectId = $(e.target).attr("photo-uuid");
         const selectedData = data.find((data) => data.name === selectId) || {};
         const { children,name } = selectedData;
         let li = "";
         children.forEach((item, index) => {
           imgNameWithPattern = item.split(" ")[1];
           imgName = imgNameWithPattern.split(".")[0];
           imageSize = item.split(" ")[0];
           imageX = imageSize.split(".")[0];
           imageY = imageSize.split(".")[1];
           let imgOptions = {
             imageWidth,
             imageX,
             imageY,
             name,
             imgName,
             imgPath,
             imgNameWithPattern,
           };
           li += self.constructHtml(imgOptions);
         });
         $(".ImageGrid").append(li);
         self.minigrid();
       });
     },
     minigrid: function () {
       var grid = new Minigrid({
         container: ".ImageGrid",
         item: ".card",
         gutter: 12,
       });
       grid.mount();
       $(window).resize(function () {
         grid.mount();
       });
     },
   };
   photo.init();
   ```

2. 使用注册器将需要的js,css注入,在/scripts/injector.js(如没有,则创建)中输入以下内容:

   ```js
   const { root: siteRoot = "/" } = hexo.config;
   // layout为photo的时候导入这些js与css
   hexo.extend.injector.register(
     "body_end",
     `
     <link rel="stylesheet" href="https://cdn.staticfile.org/fancybox/3.5.7/jquery.fancybox.min.css">
     <script src="//cdn.jsdelivr.net/npm/minigrid@3.1.1/dist/minigrid.min.js"></script>
     <script src="https://cdn.staticfile.org/fancybox/3.5.7/jquery.fancybox.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/lazyloadjs/3.2.2/lazyload.js"></script>
       <script defer src="${siteRoot}js/photoWall.js"></script>`,
     "photo"
   );
   ```

### 4.网页端图片加速

​	因为我是基于githubpage部署的博客，国内访问的时候，图片文件加载起来巨慢从而导致导致网页基本打不开，刚开始我参考[如何使用jsDelivr+Github 实现免费CDN加速?](https://zhuanlan.zhihu.com/p/346643522)搭建了一个github仓库用于存放相册并用于cdn加速，但实际效果还是不行，因此，我想到了用阿里云oss图床，提高网页中图片加载速度，从而提高网页加载速度。

1. 文章中图片：采用typora+picgo+阿里云oss方案，参考链接：[【Typora】typora+picgo+阿里云oss搭建图床](https://www.cnblogs.com/myworld7/p/13132549.html)。

2. 相册图片：阿里云ossutil工具，具体方法参考官方说明：[ossutil概述](https://help.aliyun.com/zh/oss/developer-reference/overview-59?spm=5176.8465980.help.dexternal.9c691450trHl8S)。

   - 如果使用该方案photowall.js中的图片访问路径（imgPath）需更改为阿里云文件夹中的前缀。如“<https://picoflynx.oss-cn-XXX.aliyuncs.com/source/images/gallery/”>
   - 为了实现相对于photowall.js图片访问路径与本地相册路径的一致性，我把整个source文件都上传至oss了

   至此，一个基于hexo的fluid主题的相册就搭建完成啦~，效果如图：

   ![相册效果图](https://picoflynx.oss-cn-guangzhou.aliyuncs.com/source/images/gallery/%E6%96%87%E7%AB%A0%E5%9B%BE/202403302209080.png)

## 优化

### 简化create流程

​	每次上传图片的时候，都需要删除photos.json，再重新执行create.js生成新的photos.json，然后再复制到photos页面文件夹...太麻烦了

**解决方案**：写bat脚本执行这个过程（本人技术有限，只想到了这个...）

- 先写一个批处理文件（run-node-app.bat)置于image文件夹，用于删除旧photos.json,并执行create.js

  ```bat
  @echo off
  cd /d "F:myblog\source\images"
  
  :: 定义要删除的子文件夹中的文件路径
  SET "FILE_PATH_1=gallery\photos.json"
  SET "FILE_PATH_2=gallery\photosInfo.json"
  
  :: 删除第一个文件
  del "%FILE_PATH_1%" 2>nul
  if not exist "%FILE_PATH_1%" (
      echo The file %FILE_PATH_1% has been deleted successfully.
  ) else (
      echo The file %FILE_PATH_1% was not found or could not be deleted.
  )
  
  :: 删除第二个文件
  del "%FILE_PATH_2%" 2>nul
  if not exist "%FILE_PATH_2%" (
      echo The file %FILE_PATH_2% has been deleted successfully.
  ) else (
      echo The file %FILE_PATH_2% was not found or could not be deleted.
  )
  
  :: 执行create.js
  node "gallery\create.js"
  
  pause
  ```

- 在source文件夹下写一个批处理文件（img-refresh.bat)，用于调用run-node-app.bat,并覆盖photos/photos.js

  ```bat
  @echo off
  :: 处理相册gallery
  cd /d "F:myblog\source\images"
  call "run-node-app.bat"
  echo "run-node-app.bat has been executed."
  
  pause
  
  ::复制粘贴至photos
  
  cd /d "F:myblog\source"
  
  :: 定义要删除的photos中的文件路径
  SET "FILE_PATH_1=photos\photos.json"
  
  :: 定义要复制的文件路径和目标路径
  SET "SOURCE_FILE_PATH=images\gallery\photos.json"
  SET "TARGET_FILE_PATH=photos\photos.json"
  
  :: 删除子文件夹photos中的一个文件
  del "%FILE_PATH_1%" 2>nul
  if not exist "%FILE_PATH_1%" (
      echo The file %FILE_PATH_1% has been deleted successfully.
  ) else (
      echo The file %FILE_PATH_1% was not found or could not be deleted.
  )
  
  :: 将images/gallery/中的文件复制到photos中
  copy "%SOURCE_FILE_PATH%" "%TARGET_FILE_PATH%" /y
  if not exist "%TARGET_FILE_PATH%" (
      echo Failed to copy the file from subfolder1 to subfolder2.
      goto End
  ) else (
      echo The file has been copied successfully from subfolder1 to subfolder2.
  )
  
  pause
  ```

- 该法方法脚本编写过程可能有点低级，但最终实现的效果是，只需要在相册更新之后，双击一下img-refresh.bat就能实现相册更新了

### 简化ossutil流程

**痛点**：ossutil命令太难用了，搞了好久都没明白怎么实现命令简化

**解决方案**：那就又bat吧。编写一个bat(osssync.bat)置于image文件夹下，用于一键同步本地相册于oss

```bat
@echo off

ossutil64 sync F:myblog\source\images oss://bucket名/source/images/ --force
:: --force为可选项，当使用ossutil64 sync命令同步文件夹到阿里云OSS时，确实会提示你确认每个文件的上传操作。为了简化这个过程，避免每次上传时都需要手动输入确认（y/n），在命令行中添加--force选项。让ossutil在同步时自动覆盖目标OSS上的文件，而不需要进一步的确认。

pause
```

## 参考

1. [【Hexo】基于Fluid主题的Hexo增加相册功能实践 | Kezade](https://zyxelva.github.io/posts/45280.html#3-加载-js和css文件)

2. [如何使用jsDelivr+Github 实现免费CDN加速? - 知乎](https://zhuanlan.zhihu.com/p/346643522)

3. [【Hexo】基于Fluid主题的Hexo增加相册功能实践](https://zyxelva.github.io/posts/45280.html#3-%E5%8A%A0%E8%BD%BD-js%E5%92%8Ccss%E6%96%87%E4%BB%B6)
