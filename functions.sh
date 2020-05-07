#!/bin/bash

function extract {

  pwd

  target_dir=$1
  ext=$2
  fps=$3

  # TODO バリデーション

  dir=`basename "${target_dir}"`
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
  cp ${target_dir}/*.${ext} ${tmp_dir}/

  # 画像を抽出
  for f in ${tmp_dir}/*.${ext}
  do
    ffmpeg -i $f -vf fps=${fps} "${tmp_dir_png}/$(basename $f ".${ext}")_%06d.png"
  done

  # 顔画像を抽出
  python faceswap/faceswap.py extract -i ${tmp_dir_png} -o ${tmp_dir_png_extracted}

  # 画像を圧縮
  zip -r ${dir}.zip ${tmp_dir_png_extracted}
}

function merge {
  target_dir=$1
  ffmpeg -i "${target_dir}_%06d.png" -c:v libx264 -vf "fps=25,format=yuv420p" "output_swap.mp4"
}

function train {

  data_a=$1
  data_b=$2
  data_a_file=`basename ${data_a}`
  data_b_file=`basename ${data_b}`
  model=$3

  if [ -e train ]; then
    rm -rf train
  fi
  mkdir train

  cp ${data_a} train/
  cp ${data_b} train/
  unzip train/${data_a_file} -d train/data_a/ > /dev/null
  unzip train/${data_b_file} -d train/data_b/ > /dev/null
  
  python faceswap/faceswap.py train -A train/data_a/extracted -B train/data_b/extracted -m "${model}" -bs 16 -s 1000
}
