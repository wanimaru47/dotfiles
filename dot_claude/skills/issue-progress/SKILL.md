---
name: issue-progress
description: Show progress and decisions of a GitHub issue and verify PR alignment. Use when the user wants to check issue status, progress, or decisions. Accepts an optional issue number argument (e.g., `/issue-progress 123`).
allowed-tools: Bash, Read
---

現在のブランチに関連するGitHub Issueの進捗と意思決定を要約し、PRの実装内容がIssueの意思決定に沿っているかを検証する。

## 引数

- `$ARGUMENTS` にIssue番号（例: `123`, `#123`）が渡された場合、そのIssueを直接対象とする（Step 1, 2をスキップ）
- 引数がない場合は、現在のブランチのPRから関連Issueを自動検出する

## 手順

### 引数ありの場合
1. 引数からIssue番号を取得する（`#` プレフィックスは除去）
2. そのIssueに紐づくPRを特定する → Step 3へ進む

### 引数なしの場合
1. 現在のブランチに紐づくPRを取得する
2. PRの本文やコメントからリンクされたIssueを特定する
3. Issueの詳細（本文・コメント・タイムライン）を読み取る
4. PRの実装内容（diff・コメント・レビュー）を取得する
5. Issueの意思決定とPRの実装内容を突き合わせて検証する
6. 日本語で要約を出力する

## 実行

### Step 1: 起点の決定

**引数にIssue番号がある場合:**

`$ARGUMENTS` からIssue番号を取り出し、そのIssueに紐づくPRを探す:
```
gh issue view <number> --json title,body,state,comments,labels,assignees,milestone
```

Issueのタイムラインからリンクされたpull requestを特定する:
```
gh api repos/{owner}/{repo}/issues/<number>/timeline --paginate
```

タイムラインに `cross-referenced` イベントでPRが見つかればそれを対象PRとする。複数のPRがある場合は、openなものを優先し、なければ最新のものを使う。PRが見つからない場合は整合性チェック（Step 4, 5）をスキップし、Issue要約のみ出力する。

→ Step 3へ進む（Issueは取得済み）

**引数がない場合:**

`gh pr view` で現在のブランチのPRを取得する。PRが見つからない場合はその旨を伝えて終了する。

```
gh pr view --json number,title,body,url
```

→ Step 2へ進む

### Step 2: 関連Issueの特定（引数なしの場合のみ）

PRの本文から `#123`, `fixes #123`, `closes #123`, `resolves #123` などのパターン、または `https://github.com/.../issues/123` 形式のURLを探してIssue番号を抽出する。

PRのコメントも確認する:
```
gh pr view --json comments
```

見つからない場合は、PRのタイトルやブランチ名からIssue番号を推測する（例: `feature/123-add-login` → Issue #123）。

### Step 3: Issueの詳細取得

各Issueについて以下を取得する:
```
gh issue view <number> --json title,body,state,comments,labels,assignees,milestone
```

Issueのタイムラインイベント（参照されたコミット、PRリンク等）も確認する:
```
gh api repos/{owner}/{repo}/issues/<number>/timeline --paginate
```

### Step 4: PRの実装内容の取得

PRのdiff、コメント、レビューを取得する:

```
gh pr diff
```

```
gh pr view --json comments,reviews,files
```

PRのレビューコメント（コード上のインラインコメント）も取得する:
```
gh api repos/{owner}/{repo}/pulls/<pr_number>/comments --paginate
```

### Step 5: Issueの意思決定 vs PRの実装内容の検証

Step 3で抽出したIssueの意思決定事項を1つずつ確認し、Step 4で取得したPRの実装内容と突き合わせる。

検証観点:
- Issueで決定された仕様・方針がPRの実装に反映されているか
- Issueで却下・変更された方針がPRに残っていないか
- Issueで未決定の事項についてPRが独断で実装を進めていないか
- Issue側で議論されていないが、PRで新たに導入された設計判断があるか

### Step 6: 要約の出力

以下のフォーマットで日本語の要約を出力する:

```
## Issue の進捗状況

### 概要
- Issue: #<number> <title>
- 状態: <open/closed>
- PR: #<pr_number> <pr_title>
- ラベル: <labels>
- 担当: <assignees>

### 進捗
<時系列で主要な進捗をまとめる>

### 意思決定
<Issue内で行われた重要な決定事項をまとめる>

### 整合性チェック
| Issueの決定事項 | PRの実装状況 | 判定 |
|---|---|---|
| <決定事項1> | <対応する実装の有無と内容> | ✅ 反映済 / ⚠️ 未反映 / ❌ 乖離あり |
| ... | ... | ... |

#### ⚠️ 注意が必要な点
<乖離や未反映がある場合、具体的に何が問題かを記載>

#### 💡 PR独自の判断
<Issueで議論されていないがPRで新たに導入された設計判断があれば記載>

### 残課題
<未解決の課題や次のアクションがあれば記載>
```

## 注意事項

- コメントが多い場合でも全て読み、重要なものを抽出すること
- 技術的な議論の要点を簡潔にまとめること
- 意思決定の理由（なぜその判断に至ったか）も含めること
- 整合性チェックでは、diffの内容を根拠にして判定すること（推測で判定しない）
- 乖離がある場合は、修正提案ではなく事実の報告に徹すること
