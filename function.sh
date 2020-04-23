#!/bin/bash

readonly EXT='mp4'
readonly FPS='25'
readonly TMP_DIR='tmp'
readonly TMP_IMAGES_DIR='tmp_images'

function extract_images_from_videos() {

  local target_dir=$1
  local output_dir=$2

  if [ -e "${TMP_DIR}" ]; then
    rm -rf "${TMP_DIR}"
  fi
  mkdir "${TMP_DIR}"

  if [ -e "${output_dir}" ]; then
    rm -rf "${output_dir}"
  fi
  mkdir "${output_dir}"

  # Copies videos to the tmp directory
  cp "${target_dir}"/*."${EXT}" "${TMP_DIR}"

  # Extracts images
  for f in "${TMP_DIR}"/*."${EXT}"
  do
    ffmpeg \
      -i \
      $f \
      -vf fps="${FPS}" \
      "${output_dir}/$(basename $f ".${EXT}")_%06d.png"
  done

  rm -rf "{TMP_DIR}"
}

function extract_faces_from_videos() {

  local target_dir=$1
  local output_dir=$2

  if [ -e "${output_dir}" ]; then
    rm -rf "${output_dir}"
  fi
  mkdir "${output_dir}"

  extract_images_from_videos "${target_dir}" "${TMP_IMAGES_DIR}"

  python faceswap/faceswap.py extract \
    -i "${TMP_IMAGES_DIR}" \
    -o "${output_dir}"

  rm -rf "${TMP_IMAGES_DIR}"
}
