# qrecode

質問紙調査のデータリコーディングに便利なRパッケージ

## 概要

`qrecode`は質問紙調査のデータ処理を効率化するためのRパッケージです。アンケートデータの前処理でよく必要となる以下の操作を簡単に実行できる関数を提供します：

- 2値変数のダミー変数への変換
- 順序尺度の逆転項目の作成
- 複数回答（MA：Multiple Answer）変数の単純回答（SA：Single Answer）変数への分割
- その他質問紙調査特有のリコード機能（今後開発予定）

## インストール

```r
# 開発版をGitHubからインストール
# devtools::install_github("username/qrecode")  # 実際のGitHubリポジトリに置き換えてください

# ローカルでのインストール
# install.packages("path/to/qrecode", repos = NULL, type = "source")
```

## 関数一覧

### `q_rev()` - 順序尺度の逆転項目作成

順序尺度の変数から逆転項目を作成します。

#### 使用法
```r
q_rev(old, DK = FALSE)
```

#### 引数
- `old`: 元の順序尺度変数
- `DK`: 「わからない」など除外したい値のベクトル。除外する値がない場合は`FALSE`を指定（デフォルト）

#### 例
```r
# 5段階リッカート尺度のデータ
satisfaction <- c(1, 2, 3, 4, 5, 2, 1, 4)

# 逆転項目の作成（5→1, 4→2, 3→3, 2→4, 1→5）
satisfaction_rev <- q_rev(satisfaction)

# 「わからない」（例：88888）を除外した逆転項目
satisfaction_with_dk <- c(1, 2, 3, 4, 5, 88888, 2, 1)
satisfaction_rev2 <- q_rev(satisfaction_with_dk, DK = 88888)
```
### `q_dum2()` - 2値変数のダミー変数変換

2値の質問項目を0,1のダミー変数に変換します。

#### 使用法
```r
q_dum2(old, rev = FALSE)
```

#### 引数
- `old`: 元の2値変数（1, 2の値を持つベクトル）
- `rev`: 論理値。`TRUE`の場合は選択肢1→0、選択肢2→1に変換。`FALSE`の場合は選択肢1→1、選択肢2→0に変換（デフォルト）

#### 例
```r
# サンプルデータ
gender <- c(1, 2, 1, 2, 1)  # 1=男性, 2=女性

# 通常の変換（1→1, 2→0）
gender_dummy <- q_dum2(gender)

# 逆転変換（1→0, 2→1）
gender_dummy_rev <- q_dum2(gender, rev = TRUE)
```
### `ma2sa()` - 複数回答から単純回答への変換

複数回答形式の変数を複数のダミー変数に分割します。

#### 使用法
```r
ma2sa(df, column_name, prefix, delimiter = ",")
```

#### 引数
- `df`: 対象のデータフレーム
- `column_name`: 分割したい列名（文字列）
- `prefix`: 新しく作成される変数名の接頭辞
- `delimiter`: 区切り文字（デフォルトは","）

#### 例
```r
# サンプルデータフレーム
df <- data.frame(
  id = 1:3,
  hobbies = c("読書,音楽", "スポーツ,映画,読書", "音楽")
)

# 複数回答を単純回答に分割
df_expanded <- ma2sa(df, "hobbies", "hobby", ",")
# 結果: hobby_読書, hobby_音楽, hobby_スポーツ, hobby_映画の列が追加される
```

## 依存関係

- `tidyverse`: `ma2sa()`関数で使用
- `glue`: `ma2sa()`関数で使用

必要なパッケージは関数実行時に自動的にインストール・読み込みされます。

## 使用上の注意

- すべての関数は元の変数のクロス表と新しい変数のクロス表を表示し、変換結果を確認できます
- 欠損値（NA）は適切に処理されます
- `ma2sa()`関数では空白文字は自動的に除去されます

## 作成者

Hayato KATAGIRI

## ライセンス

このパッケージはMITライセンスの下で配布されています。

## 問題の報告・機能要望

バグの報告や新機能の要望はkatagiri.socio [at]  gmail.comまでお願いします。
