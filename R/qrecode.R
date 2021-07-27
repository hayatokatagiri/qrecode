#質問紙調査のリコードに便利な自作関数パッケージqrecode
#Coded by Hayato KATAGIRI

##2値の質問を0,1のダミー変数に変換#####
q_dum2 <- function(old,rev = F){
  #もとの2値変数の選択肢1、選択肢2を
  #rev == Tで選択肢1 → 1、選択肢2 → 0、
  #rev == Fで選択肢2 → 0、選択肢2 → 1
  #に変換する
  if (rev == TRUE){
    print('Crosstable of the old variable')
    print(table(old))
    new <- NA
    new[old == 1] <- 0
    new[old == 2] <- 1
    print('Crosstable of the new variable')
    print(table(new))
    return(new)
  }else {
    print('Crosstable of the old variable')
    print(table(old))
    new <- NA
    new[old == 1] <- 1
    new[old == 2] <- 0
    print('Crosstable of the new variable')
    print(table(new))
    return(new)
  }
}

#順序尺度の逆転項目を作成する関数####
#例 x <- q_rev(df$Q2,DK = c(5,88888))
q_rev <- function(old,DK = F){
  #もとの順序尺度の変数oldの選択肢1、選択肢2...nから
  #n、n-1...２、１と逆転項目の変数newを作成する関数
  #もとの変数oldのクロス表を表示[DKは「わからない」の位置。DKがなしのときはFalseを指定
  print('Crosstable of the old variable')
  print(table(old))
  #新しい変数newの作成
    old_alt <- unique(old) #もとの変数の選択肢をすべて取得
    j <- 1 #DKがベクトルで複数指定された場合のために繰り返し処理
    while (j <= length(DK)){
      old_alt <- old_alt[old_alt != DK[j]] #DKで指定した数字を削除
      j <- j + 1
    }
    old_alt <- old_alt[complete.cases(old_alt)] #naを削除
    old_alt <- sort(old_alt) #昇順に並べ替え
    print('Alternatives of the old variable without DK')
    print(old_alt)
    new_alt <- 1:length(old_alt) #新しい変数の選択肢new_alt
    new_alt <- rev(new_alt) #降順に並べ替え
    print('Alternatives of the new variable')
    print(new_alt)
    new <- NA
    max_value <- max(old,na.rm = T) #もとの選択肢の最大値を取得
    i <- 1
    while (i <= length(old_alt)){
      new[old == old_alt[i]] <- new_alt[i]
      i <- i + 1
    }
  #新しい変数newのクロス表を表示
  print('Crosstable of the new variable')
  print(table(new))
  return(new)
}
