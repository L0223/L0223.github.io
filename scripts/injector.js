// hexo.extend.injector.register('head_end', 
// `
// <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fancyapps/fancybox@3.5.7/dist/jquery.fancybox.min.css">
// <link rel="stylesheet" href="/assets/justifiedGallery.min.css" />
// `,
// 'gallery')
// hexo.extend.injector.register('body_end', 
// `
//   <script src="https://cdn.jsdelivr.net/npm/@fancyapps/fancybox@3.5.7/dist/jquery.fancybox.min.js"></script>
//   <script src="/assets/jquery.justifiedGallery.min.js"></script>
//   <script src="/assets/gallery.js"></script>
// `,
// 'gallery')

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

