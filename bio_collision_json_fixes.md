# JSON 作者简介错行修复清单

以下条目来自 `bio_collision_report.json`，源数据 `name` 与目录 `canonical` 不一致，且部分 JSON `description` 正文为另一人。自动补源不会按 JSON 名写入；需改 `chinese-poetry` 源或走 `author_bio_overrides.yaml`。

| slug | canonical | JSON name | 问题摘要 | 建议 |
|------|-----------|-----------|----------|------|
| han-jun | 韩浚 | 韩濬 | 正文为王濯 | 删除或改正 `全唐诗/authors.tang.json` 对应行；或 override |
| wang-jian | 王建 | 王坚 | 同音撞大诗人 | 保留王建 canonical；勿用「王坚」JSON 写入 |
| zhao-shi-chang | 赵世长 | 赵世昌 | 异名 | 以赵世长为准；JSON 名勿自动写入 |
| xue-shen-huo | 薛昚惑 | 薛眘惑 | 异体字 | 统一用 canonical 查古文岛 |

完整 79 条见 `bio_collision_report.txt`。修复后执行：

```bash
npm run report:bio-collisions
npm run audit:bios
```
