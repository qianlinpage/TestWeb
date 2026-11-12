# 林乾的学术主页

林乾（Qian Lin）的双语 GitHub Pages 学术主页，包含首页、研究项目、教学与服务、学术论文四个栏目，共 8 个页面。纯 HTML + CSS，无需 Node.js、数据库或第三方字体；网页浏览不依赖 Ruby 或 JavaScript。

- 网站：[英文首页](https://qianlinpage.github.io/TestWeb/index.html) · [中文首页](https://qianlinpage.github.io/TestWeb/index.zh.html)
- 仓库：[qianlinpage/TestWeb](https://github.com/qianlinpage/TestWeb)，发布分支为 `main`，Pages 发布目录为仓库根目录。
- 协作要求：[AGENTS.md](AGENTS.md)。每次更新都应检查全站，并在同一任务中同步受影响页面的中英文版本。

## 文件

| 栏目 | 英文页面 | 中文页面 |
| --- | --- | --- |
| 首页、动态与经历 | `index.html` | `index.zh.html` |
| 研究项目与合作 | `projects.html` | `projects.zh.html` |
| 教学与服务 | `teaching.html` | `teaching.zh.html` |
| 学术论文 | `publications.html` | `publications.zh.html` |

其他文件：

- `style.css`：全站配色、排版、移动端和打印样式。
- `assets/qian-lin.jpg`：清华大学教师主页公开照片。
- `assets/favicon.svg`：QL 网站图标；`assets/avatar.svg` 为保留的旧模板资源，页面已不再引用。
- `publications-data.json`：统一论文数据、核查来源与重复记录映射。
- `scripts/render-publications.rb`：同时生成两种语言的论文正文。
- `scripts/sync-site-layout.rb`：同步全部页面的页头、侧栏、图标和页脚。
- `.nojekyll`：让 GitHub Pages 直接发布静态文件。

## 全站更新流程

1. 核对资料来源，并检查信息在全部 8 个页面中的关联位置；例如论文状态变化时，也要更新首页动态和项目页的相关引用。
2. 同时修改对应的中英文正文、标题和描述。共享的个人资料、照片、页头导航、语言选择器、图标与页脚，分别在 `index.html` 和 `index.zh.html` 修改。
3. 论文数据有变化时，先运行 `ruby scripts/render-publications.rb`；随后运行 `ruby scripts/sync-site-layout.rb`。共享布局脚本以两种语言的首页为来源，保留各页正文，自动设置当前导航和同栏目语言链接。新增页面还需更新脚本的 `PAGES` 列表及两种语言首页导航。
4. 检查全部页面的姓名、照片、资料链接、元信息、导航、语言切换、站内锚点及资源；确认双语事实、条目和日期一致，没有模板占位内容。论文核查日期独立于页脚维护日期，未重新核查论文时不改动前者。
5. 提交相关文件到现有仓库 `main` 分支，等待 GitHub Pages 部署成功，再核对线上页面。

直接打开 `index.html` 或 `index.zh.html` 即可本地预览。页面和资源使用相对路径，语言切换始终对应同一栏目。涉及布局或交互时，应同时查看两种语言的桌面及移动端效果。

## 资料来源与取舍

全站个人资料、项目及教学页面于 **2026-11-13** 核对和更新；论文数据的核查日期仍为 **2026-11-12**。

- 个人资料与照片：[清华教师主页](https://www.stat.tsinghua.edu.cn/info/1023/2413.htm)及其[英文版](https://www.stat.tsinghua.edu.cn/en/info/1023/1049.htm)，用于职称、单位、任职日期、邮箱、办公室和照片。照片保留官网原图，仅以 CSS 调整展示位置。
- 教育经历：[北京国际数学研究中心报告简介](https://bicmr.pku.edu.cn/content/show/18-2959.html)，用于 2010 年 MIT 数学博士和 2017 年加入清华的经历。
- 研究方向和动态：[学术论文页](https://qianlinpage.github.io/TestWeb/publications.html)及 `publications-data.json`。首页动态和项目页相关论文均使用稳定的 `paper-*` 锚点，保留预印本、接收和正式发表状态的区别。
- 项目：[教师主页](https://www.stat.tsinghua.edu.cn/info/1023/2413.htm)列出的 2 项基金项目及 3 项合作研究。原始中文项目名保留，英文为对应翻译；不将相关论文擅自标记为某一项目的资助成果。合作项目未公开的期限和具体角色不补写。
- 项目期限差异：充分性降维面上项目在教师主页列为 2020/01–2023/12，而[2022–2023 年报](https://www.stat.tsinghua.edu.cn/PDF/2022-2023NB.pdf)的基金汇总表列为 2020–2024。由于公开资料存在差异且缺少可直接对应的项目编号，页面暂只展示已确认的题名、资助类别和主持角色，不将其中一个结束年份作为定论。北京市自然科学基金项目采用教师主页明确给出的 2019/10–2023/10。
- 教学：[教师主页](https://www.stat.tsinghua.edu.cn/info/1023/2413.htm)的 6 门历史课程，加上[2025 年秋季课程表](https://www.stat.tsinghua.edu.cn/__local/5/04/32/2F29E052CB9F6A1DA2579C40C24_3AF97D1F_1CBCF.pdf)中的“深度学习的数学基础”，并依据[2026 年春季课程表](https://www.stat.tsinghua.edu.cn/__local/D/20/6C/0BB2B057B9326092C966D2BE6A9_B1AE85DA_1EAA9.pdf)补充“高等数理统计 II”的授课学期。两份课程表已查看整页及红色研究生课程标注；最终为 6 门研究生课程、1 门本科课程，共 8 条已确认的授课学期记录。未将历史课程表的教室、时段当作当前安排。
- 服务：两项学会任职依据[教师主页](https://www.stat.tsinghua.edu.cn/info/1023/2413.htm)；统计系学生组组长（Head, Student Affairs Group）依据用户于 2026-11-13 的明确更正，不再沿用此前院系新闻中的职务表述。学会英文名依[中国现场统计研究会官网](https://caas.kejie.org.cn/c98)使用 Chinese Association for Applied Statistics。未推断服务任期。
- 本次全站同步统一了全部 8 个页面的照片、姓名、职称、单位、联系方式、研究方向、资料链接、导航、图标与页脚，并替换了 Projects 和 Teaching 的全部模板内容。

## 论文整理与核查

论文页分为“已发表”和“预印本”两类，页首可直接跳转至对应分区。各类按正式期刊卷期、会议或预印本首次公开年份倒序排列，编号在每类内从 01 开始。尚未分配卷期的在线文章使用上线年份，已在线发表但分配到未来卷期的文章另有说明。当前 40 条记录中，25 条正式发表与 2 条在线发表合并列入“已发表”，共 27 条；“预印本”区列出 11 条预印本、1 条已接收待出版论文，以及 1 条作者与发表状态待核实的投稿稿件。已接收稿件暂按首次预印本年份排序，不计入已发表数量。更新时应优先使用出版社、会议官网和作者提交的 arXiv 记录，不能把投稿年份或汇总网站中的会议标签视为正式录用依据。

2026-11-12 对照用户提供的 [Google Scholar](https://scholar.google.com/citations?user=kHPrqdgAAAAJ&hl=en) 全部 47 条记录重新核查：7 组重复合并，1 条补充材料与 1 条软件记录附在相关论文下，对应 38 项研究成果。网站另外保留原有待核实的 Kernel PCA 投稿稿件，并补充从 arXiv 和合作者主页找到的 2026 年 9 月预印本，共展示 40 条记录。直接访问 Scholar 返回 403，因此本次 Scholar 清单来自用户粘贴内容；正式出版信息仍逐项使用原始来源核查。未合计重复条目的引用次数。

各论文的 `merge_note_zh` / `merge_note_en` 保存公开展示的合并说明，`related_materials` 保存附属资源，`scholar_rows` 对应原清单行号；`scholar_review` 保存全部 47 条记录与主记录的映射。特别是 `Exact Rates and Saturation Effect …` 与 `Large Dimensional Kernel Ridge Regression: Extending to Product Kernels` 的版本关系由用户明确确认后合并。

`On the Optimality of Functional Sliced Inverse Regression` 的期刊页面已公开接收稿，并将其排入 2027 年 1 月的未来卷期；Crossref 也将出版年份列为 2027。因此截至本次核查日，状态为“已接收，待正式出版”，没有将 DOI 注册日期当作正式发表日期。
