#!/bin/bash

readonly EXT='mp4'
readonly FPS='25'
readonly TMP_DIR='tmp'

function extract_images() {

  local target_dir=$1
  local output_dir=$2

  if [ -e "${TMP_DIR}" ]; then
    rm -rf "${TMP_DIR}"
  fi
  mkdir "${TMP_DIR}"
  cd "${TMP_DIR}"

  # Copies videos to the tmp directory
  cp "${target_dir}"/*."${EXT}" .

  # Extracts images
  for f in *."${EXT}"
  do
    ffmpeg /
      -i /
      $f /
      fps="${FPS}" /
      "${output_dir}/$(basename $f ".${EXT}")_%06d.png"
  done
}
