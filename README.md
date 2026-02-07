# chinese-poetry-md

[![GitHub stars](https://img.shields.io/github/stars/daichangya/chinese-poetry-md)](https://github.com/daichangya/chinese-poetry-md/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/daichangya/chinese-poetry-md)](https://github.com/daichangya/chinese-poetry-md/network/members)

中文诗词 Markdown 仓库，供 [chinese-poetry-site](https://github.com/daichangya/chinese-poetry-site) 构建使用。每首诗对应一个 .md 文件，可在此仓参与纠错与完善。本仓是站点的**内容层**，便于版本管理与协作；可增补译文、赏析、注释或纠错别字，站点构建时从本仓解析 .md 入库后提供阅读与检索。

## 目录结构

- `poems/<作者slug>/<诗题slug>.md` — 单首诗词的 Markdown（正文、拼音、译文、注释、赏析等）
- `poems/<作者slug>/bio.md` — 该作者的简介（可选）

示例：`poems/li-bai/jing-ye-si.md`、`poems/su-shi/bio.md`。

## 单首 .md 格式

每个 .md 包含 **YAML frontmatter**（标题、作者、朝代、标签、词牌等）和 **正文区块**：`## 正文`、`## 拼音`、`## 译文`、`## 赏析`、`## 注释`。路径为 `poems/<作者slug>/<诗题slug>.md`，slug 为无声调拼音 + 连字符。详细约定见 [chinese-poetry-site 的 markdown-format](https://github.com/daichangya/chinese-poetry-site/blob/main/docs/markdown-format.md)。

## 访问站点

由本仓 .md 构建的诗词站：[https://shi-ci.cn](https://shi-ci.cn)（[chinese-poetry-site](https://github.com/daichangya/chinese-poetry-site) 部署）。

## 数据来源

本仓库内容由 [chinese-poetry](https://github.com/daichangya/chinese-poetry) 经 [chinese-poetry-site](https://github.com/daichangya/chinese-poetry-site) 的 `gen_markdown` 脚本生成，并可在本地或 GitHub 上人工增补、纠错。

## 相关仓库

| 仓库 | 说明 |
|------|------|
| [chinese-poetry](https://github.com/daichangya/chinese-poetry) | 诗词 JSON 数据源 |
| [chinese-poetry-site](https://github.com/daichangya/chinese-poetry-site) | 站点代码与 gen_markdown/seed_db |
| 本仓 chinese-poetry-md | 诗词 .md 合集，供站点构建使用 |

## 本地生成与推送

在 [chinese-poetry-site](https://github.com/daichangya/chinese-poetry-site) 中克隆本仓到目录（如 `chinese-poetry-md`），设置 `POEMS_DIR` 指向该目录。执行 `npm run gen_markdown` 生成 .md 到本仓；再用本仓根目录的 `git-add-n.sh` 分批 add/commit/push（见下方「大量文件时的推送」）。

## 如何参与

可增补译文、赏析、注释或纠错别字。

- 在 [chinese-poetry-site](https://github.com/daichangya/chinese-poetry-site) 诗词详情页点击「纠错与完善」可跳转到本仓对应文件的 GitHub 编辑页。
- 或直接在本仓提交 Pull Request；格式约定见站点的 [markdown-format](https://github.com/daichangya/chinese-poetry-site/blob/main/docs/markdown-format.md) 与 [CONTRIBUTING](https://github.com/daichangya/chinese-poetry-site/blob/main/CONTRIBUTING.md)。

## 大量文件时的推送

若未暂存文件很多（如首次全量生成或大批更新），可用仓库根目录下的 `git-add-n.sh` 分批提交：

```bash
./git-add-n.sh 500
```

表示本次最多 add 500 个文件并执行 commit + push。可多次运行直到 `git status` 无未暂存变更。不传参数时默认每次最多 100 个文件。
