# 学术个人主页模板

典型的 GitHub Pages 学术主页：左侧个人信息，右侧简介、动态、论文、项目、教育和教学。纯 HTML + CSS，无需 Node.js、数据库、构建或第三方字体，双击 `index.html` 即可预览。支持手机、键盘导航和打印。

**页面内所有人物、经历与论文均为占位示例，不代表真实成果。发布前请替换或删除。**

## 文件

```text
index.html          About 首页（简介、动态、教育）
publications.html   Publications 论文页
projects.html       Projects 项目页
teaching.html       Teaching 教学与服务页
style.css           配色、排版和手机适配
assets/avatar.svg   默认头像（可换为自己的照片）
.nojekyll           告诉 GitHub Pages 直接发布静态文件
README.md           本说明
```

## 上传到 GitHub Pages

1. 新建公开仓库，命名为 `你的GitHub用户名.github.io`，例如用户名是 `alice`，仓库名就是 `alice.github.io`。
2. 将本文件夹**里面的文件及 assets 文件夹**上传到仓库根目录，而不是上传 ZIP 或在外面再套一层 `academic-homepage` 文件夹。确保仓库首页直接能看到 `index.html` 和 `style.css`。网页上传时可通过 Add file → Upload files 上传；隐藏文件 `.nojekyll` 可以用 Add file → Create new file 单独创建（内容可写一行 `# Static site`）。
3. 提交到 `main` 分支，打开仓库 Settings → Pages。
4. 在 Build and deployment 中，Source 选择 **Deploy from a branch**，Branch 选择 **main**，文件夹选择 **/(root)**，点击 Save。
5. 等待 Pages 部署成功，然后打开 `https://你的GitHub用户名.github.io/`。部署状态可在 Actions 或 Settings → Pages 查看。

也可使用普通仓库名（例如 `academic-homepage`），网址对应为 `https://你的GitHub用户名.github.io/academic-homepage/`。本模板使用相对资源路径，两种部署方式都可用。

官方说明：https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site

## 修改个人资料

使用任意文本编辑器打开对应的 HTML 页面。四个页面使用普通链接跳转，无需 JavaScript；当前页面的导航带有下划线。所有页面共用 `style.css`，个人资料和导航修改需同步到四个 HTML 文件。

编辑指南：

- 全局替换 `Your Name`、`你的姓名`、`Your University`、`Advisor Name`、邮箱和城市；同时修改 `<title>`、description 元信息和页脚。
- 将头像放入 `assets/`（例如 `photo.jpg`），把头像 `<img>` 的 `src` 改为 `assets/photo.jpg`，并将 `alt` 改为姓名。
- Google Scholar / GitHub / ORCID / CV 当前是文本占位，不会跳转到他人资料。把相应 `<span>` 换成实际链接，例如：

  ```html
  <a href="https://github.com/你的用户名">GitHub</a>
  <a href="assets/cv.pdf">CV</a>
  ```

  CV 需自行提供 PDF 并上传到 `assets/cv.pdf`；不要只增加链接而漏上传文件。
- 替换研究兴趣、简介、动态、教育和教学内容；不需要的 `<section>...</section>` 可以删除，并同步更新四个页面的顶部导航。
- 每篇论文是一个 `<article class="publication">...</article>`，可复制添加。修改论文标题、作者、会议、年份和 BibTeX，PDF/Code 占位标签也要改为真实 `<a href="...">PDF</a>` 链接。
- 发布前删除顶部 `template-note` 提示、个人链接配置提示，以及各处 `sample` 示例标签；确认所有示例经历已经替换为真实内容。
- 默认英文页面。要改中文，可直接替换可见文字，并将 `<html lang="en">` 改成 `<html lang="zh-CN">`。
- 在 `style.css` 顶部修改 `--blue` 改变主题链接颜色。

不需要添加 JavaScript。BibTeX 使用浏览器原生折叠控件，断网也可以展开查看。

## 本地预览与更新

双击 `index.html` 即可查看，或者在此文件夹运行 `python3 -m http.server 8000` 后访问 `http://localhost:8000`（Ctrl+C 停止）。修改文件并重新提交到 GitHub 后，Pages 会重新发布。若出现 404，检查发布分支、文件夹、文件名大小写，并确认 `index.html` 位于所选发布目录根部。

## 中英文版本

顶部“中文 / English”切换当前页面的语言。英文为 `index.html`、`projects.html`、`teaching.html`、`publications.html`；中文为对应的 `*.zh.html` 文件。栏目导航始终保留当前语言，语言链接会切换到同一栏目。所有页面都是独立静态 HTML，无需 JavaScript 或后端；收藏对应地址即可直接打开所需语言。更新内容时请同步编辑中英文版本，BibTeX 引用保持原文。
