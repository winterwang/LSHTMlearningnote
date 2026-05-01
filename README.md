# 醫學統計學 — LSHTMlearningnote

📖 **線上閱讀**: [wangcc.me/LSHTMlearningnote](https://wangcc.me/LSHTMlearningnote/)

這是我在**倫敦衛生與熱帶醫學院 (LSHTM)** 攻讀醫學統計學碩士課程時的學習筆記，以中文撰寫，部分術語保留英文原文。全書使用 [bookdown](https://bookdown.org/) 編譯，包含大量 R 程式碼、LaTeX 數學推導和實際數據分析範例。

不定時更新。如果看到有錯，歡迎在 GitHub 上提 Issue 指出糾正。

## 內容概覽

全書共 **16 章**，涵蓋 191 個 Rmd 源文件，渲染為 149 頁 HTML：

| 章節 | 主題 | 關鍵詞 |
|------|------|--------|
| 01 | 概率論 Probability | 條件概率、貝葉斯定理、分布 |
| 02 | 統計推斷 Inference | 假設檢驗、信賴區間、似然函數 |
| 03 | 統計分析方法 Analytical Techniques | t 檢驗、ANOVA、卡方檢驗 |
| 04 | 線性迴歸 Linear Regression | OLS、殘差診斷、交互作用 |
| 05 | 臨床實驗 Clinical Trials | 隨機化、盲法、樣本量計算、ANCOVA |
| 06 | 穩健統計方法 Robust Statistics | Bootstrap、置換檢驗 |
| 08 | 貝葉斯統計入門 Intro to Bayesian | 先驗/後驗、brms、MCMC |
| 09 | 廣義線性迴歸 GLM | Logistic、Poisson、偏差 |
| 10 | 等級線性迴歸 Hierarchical Models | 隨機效應、混合模型、lme4 |
| 11 | 生存分析 Survival Analysis | Kaplan-Meier、Cox 迴歸 |
| 12 | 貝葉斯統計學 Bayesian Statistics | JAGS、Gibbs、Metropolis |
| 13 | 非參數貝葉斯 Bayesian Nonparametric | Dirichlet Process |
| 16 | 因果推斷 Causal Inference | DAG、IV、傾向分數、DiD |
| 29-SME | 流行病學統計方法 | 混雜、效應修飾 |
| 29-RWE | 真實世界數據 Real World Data | RWD、觀察性研究 |
| 29-HTA | 成本效益分析 HTA Modelling | Markov 模型、QALY |

## 2026 年重大改造

2026 年 4 月對本書進行了系統性的現代化改造：

### R 4.5 相容性遷移
- **rethinking → brms**：將 Richard McElreath《Statistical Rethinking》相關章節（Ch08, Ch12, Ch13）從 `rethinking` 套件全面遷移至 `brms`，解決了 R 4.5 下 `rethinking` 無法安裝的問題
- **兼容性 shim**：在 `R/global_setup.R` 中集中管理 `dens()`、`precis()`、`coeftab()` 等函數的 brms 兼容實現，確保舊程式碼無需逐一修改
- **R 程式碼修復**：修復了數十個因 R 版本升級導致的棄用警告和錯誤（`size=` → `linewidth=`、`aes_string()` → `aes()` 等）
- **全書重新渲染**：完成 4 輪完整渲染（P1–P4），解決了 Bayesian/Survival/GLM 章節的各類編譯問題

### 新增內容
- **[試驗結果的報告](https://wangcc.me/LSHTMlearningnote/reporting-trials.html#CT-reporting-intro) (Ch05 Session03)**：CONSORT 聲明與流程圖、P 值與信賴區間的陷阱、相對 vs 絕對效益、NNT/NNH、KM 曲線呈現方式、統計結果的語言表述（Pocock & Ware 六情境框架）、發表偏倚與 Symplicity 系列教訓 (2026-05-01)
- **[試驗報告實作](https://wangcc.me/LSHTMlearningnote/reporting-trials.html#CT-prac03) (Ch05 Practical03)**：RITA-2 試驗三種 KM 圖比較與心絞痛結果解讀、生長激素重症試驗的 RR/ARD 計算與卡方檢定、KM 替代展示方式 (2026-05-01)
- **[排列置換法筆記](https://wangcc.me/LSHTMlearningnote/permutation.html) (Ch06 Session03)**：充實血壓臨床試驗排列置換範例、可置換性定義、單側/雙側 p 值計算、Monte Carlo 誤差、連續變量排列、Spearman 精確排列檢驗、保守檢驗定義 (2026-04-30)
- **[排列置換法實作](https://wangcc.me/LSHTMlearningnote/permutation.html#RS-prac03) (Ch06 Practical03)**：甲狀腺素數據的 t 統計量/均值差/秩次排列置換檢驗、精確 WMW 檢驗、頭痛數據 Pearson/Spearman 相關排列檢驗、五種方法 p 值比較總結 (2026-04-30)
- **[基於秩次的非參數檢驗](https://wangcc.me/LSHTMlearningnote/rank-tests.html) (Ch06 Session02)**：充實符號檢驗中位數信賴區間、Wilcoxon 正態近似均值與方差推導、配對數據應用、Kendall τ 相關係數、95.5% ARE 詳細說明；修復 ggplot2 `linewidth` 棄用警告 (2026-04-30)
- **[秩次檢驗實作](https://wangcc.me/LSHTMlearningnote/rank-tests.html#RS-prac02) (Ch06 Practical02)**：符號檢驗 (GHQ 數據)、Wilcoxon 符號秩和檢驗與 CI 反轉、Spearman vs Pearson 相關係數的離群值比較、WMW 檢驗 (甲狀腺數據) (2026-04-30)
- **章節結構重組 (Ch06)**：將排列置換法從 Session02 獨立為 Session03、自助重抽法移至 Session04、新增 Session05 佔位 (Sandwich Estimator) (2026-04-30)
- **[穩健統計方法導論](https://wangcc.me/LSHTMlearningnote/robust-intro.html) (Ch06 Session01)**：涵蓋穩健方法的定義與目標，以血糖、甲狀腺素、淋巴球數據為例探討偏態與離群值問題，複習抽樣分布/假設檢驗/信賴區間，討論 t 檢驗假設與殘差分析 (2026-04-29)
- **[穩健統計方法實作](https://wangcc.me/LSHTMlearningnote/robust-intro.html#RS-prac01) (Ch06 Practical01)**：偏態數據的 CI 計算與圖形診斷、離群值對相關分析的影響、檢定-信賴區間等價性的數值驗證、Monte Carlo 模擬比較三種情境下的覆蓋率 (2026-04-29)
- **[基線調整與 ANCOVA](https://wangcc.me/LSHTMlearningnote/baseline-adjustment-using-ancova.html#CT-ANCOVA-intro) (Ch05 Session11)**：比較 POST/CHANGE/ANCOVA 三種分析方法的統計性質，涵蓋條件偏倚、回歸到均值、精確度公式推導、Lord's Paradox，並附詳細計算步驟 (2026-04-19)
- **[血壓臨床試驗 ANCOVA 實作](https://wangcc.me/LSHTMlearningnote/baseline-adjustment-using-ancova.html#CT-ANCOVA-practical) (Ch05 Practical11)**：將 Stata 實作完整轉換為 R，包含描述統計、散佈圖、相關矩陣、三種方法比較、假設檢驗與 CHANGE+基線=ANCOVA 的數學證明 (2026-04-19)
- **[臨床實驗基本原則](https://wangcc.me/LSHTMlearningnote/clinical-trials.html#CT-principles) (Ch05 Session01)**：涵蓋隨機化、盲法、假手術對照 (SYMPLICITY)、試驗分期、解釋型 vs 務實型實驗等核心概念 (2026-04-18)
- **[HRT 與冠心病實作](https://wangcc.me/LSHTMlearningnote/clinical-trials.html#CT-prac01) (Ch05 Practical01)**：比較 Grodstein 觀察性研究與 WHI 隨機對照試驗的結論差異，探討混雜、選擇偏差與盲法問題 (2026-04-18)

### 基礎設施
- **GitHub Pages 部署**：`docs/` 目錄直接託管，推送即部署
- **Obsidian 知識庫同步**：`lshtm-sync` 腳本自動將 Rmd → Markdown，同步至 Obsidian vault 並生成章節索引
- **Claude Skill 整合**：全書內容作為 `lshtm-medical-statistics` skill 可被 AI 助手直接檢索和引用

## 本地編譯

```r
# 安裝依賴
source("install_deps.R")

# 編譯全書
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

需要 R ≥ 4.5、Stata 18（部分章節）、JAGS 4.x（貝葉斯章節）。

## 致謝

- **LSHTM** 各科講師提供的講義與教材
- **Richard McElreath** 的 [Statistical Rethinking](https://xcelab.net/rm/statistical-rethinking/) 教科書與開源課程材料（第八章 Sessions 06–16 的學習筆記基於此書，程式碼已從 `rethinking` 遷移至 `brms`）
- **GitHub Copilot (Claude)** 協助完成 2026 年現代化改造，包括 rethinking → brms 遷移、全書渲染調試、部分章節撰寫、lshtm-sync 工具開發等

## 授權

本書以 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 授權釋出。課程原始教材的版權歸 LSHTM 及各講師所有，本授權僅適用於作者的原創評論、翻譯、程式碼和補充內容。
