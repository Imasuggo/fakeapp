#!/bin/bash

function extract {

  target_dir=$1
  ext=$2

  # TODO バリデーション

  dir=`basename ${target_dir}`
  tmp_dir="./${dir}"
  tmp_dir_png="./${dir}/png"
  tmp_dir_png_extracted="./${dir}/png/extracted"

  # 一時フォルダを作成
  if [ -e ${tmp_dir} ]; then
    rm -rf ${tmp_dir}
  fi
  mkdir ${tmp_dir}
  mkdir ${tmp_dir_png}

  # 動画をコピー
  cp "${target_dir}/*.${ext}" ${tmp_dir}/

  # 画像を抽出
  for f in "${tmp_dir}/*.${ext}"
  do
    ffmpeg -i $f -vf fps=5 "${tmp_dir_png}/$(basename $f ${ext})_%06d.png"
  done

  # 顔画像を抽出
  python faceswap/faceswap.py extract -i ${tmp_dir_png} -o ${tmp_dir_png_extracted}

  # 画像を圧縮
  zip -r ${dir}.zip ${tmp_dir_png_extracted}
}

function merge {
  target_dir=$1
  dir=`dirname ${target_dir}`
  ffmpeg -i "${target_dir}_%06d.png" -c:v libx264 -vf "fps=25,format=yuv420p" "${dir}_swap.mp4"
}