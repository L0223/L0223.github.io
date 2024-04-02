---
title: {{ title }}
date: {{ date }}
tags:
excerpt:       #摘要
hide:          #是否隐藏
sticky:        #文章顺序
index_img:     #文章在首页封面图
banner_image:  #文章页顶部图

#组图文章，下面标签参数中，
##total：图片总数量，对应中间包含的图片 url 数量
#n1-n2-...：每行的图片数量，可以省略，默认单行最多 3 张图，求和必须相等于 total，否则按默认样式
#例：{% gi 5 3-2 %}
---

{% gi total n1-n2-... %}
  ![](url)
  ![](url)
  ![](url)
  ![](url)
  ![](url)
{% endgi %}