# Task Plan: Session04-10 + Practicals — Clinical Trials completion

## Objective
Generate `05-Clinical-Trials/Session04.Rmd` and `05-Clinical-Trials/Practical04.Rmd` covering sample size calculation for clinical trials.

## Context
- Topic: sample size, power, Type I/II error, comparing proportions, comparing means, trial-size adjustments.
- Practical examples: pain relief in labour and REPAIR kidney transplantation trial.
- Data: no external patient-level dataset required; `Sampsize.xls` is a calculator workbook and has been converted for reference.
- Source files:
  - `/Users/chaopro/pCloud Drive/LSHTM/study/Term1/Clinical Trials/Week4/Size 2017.pdf`
  - `/Users/chaopro/pCloud Drive/LSHTM/study/Term1/Clinical Trials/Week4/Size handout CT 2017.pdf`
  - `/Users/chaopro/pCloud Drive/LSHTM/study/Term1/Clinical Trials/Week4/Size pract 2017.pdf`
  - `/Users/chaopro/pCloud Drive/LSHTM/study/Term1/Clinical Trials/Week4/Size soln 17.pdf`
  - `/Users/chaopro/pCloud Drive/LSHTM/study/Term1/Clinical Trials/Week4/Sampsize.xls`

## Section Plan — Session

| Section | Header | Anchor | Status |
|---------|--------|--------|--------|
| 1 | 為什麼樣本量本身會改變證據的重量 | `#CT-s04-why-size-matters` | ✅ |
| 2 | 決定樣本量的五個問題 | `#CT-s04-five-questions` | ✅ |
| 3 | 第一類錯誤、第二類錯誤與 power | `#CT-s04-errors-power` | ✅ |
| 4 | 比較兩個比例：公式與敏感度 | `#CT-s04-proportions` | ✅ |
| 5 | 比較兩個均值：標準差與差異大小 | `#CT-s04-means` | ✅ |
| 6 | 樣本量調整：失訪、換治療、不等比例 | `#CT-s04-adjustments` | ✅ |
| 7 | 太小的試驗與可行性判斷 | `#CT-s04-too-small` | ✅ |

## Section Plan — Practical

| Section | Header | Chunk names | Status |
|---------|--------|-------------|--------|
| 1 | 背景與 helper functions | `CT-p04-helpers` | ✅ |
| 2 | Question 1: pethidine vs diamorphine | `CT-p04-q1-*` | ✅ |
| 3 | Question 2: REPAIR trial | `CT-p04-q2-*` | ✅ |

## Key Answers
- Q1a: 353 per group, 706 total.
- Q1b: 1468 per group, 2936 total.
- Q1c: 473 per group, 945 total (rounded from formula as solution key).
- Q1d: 527 per group, 1054 total.
- Q1e: 3467 per group, 6934 total.
- Q2a: 136 per group, 272 total; 90% power gives 182 per group, 364 total.
- Q2b: SD 13 gives 119 per group / 238 total; SD 15 gives 158 per group / 316 total.
- Q2c: 15% missing GFR gives 272 / 0.85 = 320 total.
- Q2d: 2:1 allocation gives 272 * 9 / 8 = 306 total, about 204 RIPC and 102 sham.
- Q2e: 5% switching in each arm gives 272 / (1 - 0.05 - 0.05)^2 = 336 total.

## Files
- Output already created: `05-Clinical-Trials/Session04.Rmd`, `05-Clinical-Trials/Practical04.Rmd`
- Additional output: `Session05.Rmd`-`Session10.Rmd`, `Practical05.Rmd`-`Practical08.Rmd`, `Practical10.Rmd`
- Week9 has protocol-development practical material only; implemented as `Session09.Rmd`.
- Must update: `05-clinical-trials.Rmd` with child includes for Session05-10 and Practical05-08/10.
- References added to `book.bib`: `Little1998`, `Boutron2008`, `VonHertzen2009`, `Rubins1999`, `Fox2010`, `Clasen2007`, `Cohn2003`, `Crash2004`, `Pfeffer2003`, `MacAllister2015`, `ISIS21988`, `Toff2005`, `AlLamee2018`.
- References still pending: the primary citation for the handout's `1st Australian` streptokinase example could not be reliably verified from the local course material or quick bibliographic search, so it has intentionally not been added.

## Section Plan — Remaining Sessions

| Week | Header | Files | Status |
|------|--------|-------|--------|
| 5 | Data Monitoring Committees | `Session05.Rmd`, `Practical05.Rmd` | ✅ |
| 6 | Alternative Designs I | `Session06.Rmd`, `Practical06.Rmd` | ✅ |
| 7 | Alternative Designs II | `Session07.Rmd`, `Practical07.Rmd` | ✅ |
| 8 | Multiplicity | `Session08.Rmd`, `Practical08.Rmd` | ✅ |
| 9 | Protocol Development | `Session09.Rmd` | ✅ |
| 10 | Systematic Reviews and Meta-analysis | `Session10.Rmd`, `Practical10.Rmd` | ✅ |
