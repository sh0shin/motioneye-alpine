# MotionEye Alpine

Running on the edge, minimal Alpine motionEye Python3 container.

**Testing & Development only!**

## Movie format

### Supported

- MPEG4 (.avi)
- MSMPEG4v2 (.avi)
- Flash Video (.flv)
- Matroska Video (.mkv)

- H.264/V4L2M2M (.mp4) linux/arm/v7, linux/arm64
- Matroska Video/V4L2M2M (.mkv) linux/arm/v7, linux/arm64

- H.264/QSV (.mp4) on supported Intel CPUs
  See: <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>

### Unsupported

- QuickTime (.mov)
- Small Web Format (.swf)

[//]: # ( vim: set ft=markdown cc=80 : )
