;;; qrencode.el --- emacs interface to `qrencode'    -*- lexical-binding: t; -*-

;; Copyright (C) 2011-2013  Leo Liu

;; Author: Leo Liu <sdl.web@gmail.com>
;; Version: 1.0
;; Keywords: tools, convenience
;; Created: 2011-05-05

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A small library wrapping around the command-line tool `qrencode'
;; from libqrencode, which can be downloaded from
;; http://fukuchi.org/works/qrencode/index.html.en

;;; Documentation on QRcode: http://www.swetake.com/qr/qr1_en.html
;;; and this StackOverflow thread: http://tinyurl.com/3q5mcz4

;;; Code:

(eval-when-compile (require 'cl))

(defcustom qrencode-program "qrencode"
  "Name of the program `qrencode'."
  :type 'file
  :group 'image)

;;;###autoload
(defun* qrencode-string (string &key (type "png") (size 3) (level "L") (margin 4))
  "QRencode STRING and return a binary string of image data.
TYPE specifies the generated image format (default png): png,
eps, ansi, ansi256, ascii. SIZE (default 3) is a number
specifying the size of dot in pixel. The percentage of
codewords (8-bit long) that can be restored are defined by the
error-correction LEVEL as follows.

   L  => 7%
   M  => 15%
   Q  => 25%
   H  => 30%

MARGIN is a number specifying the width (in pixel, default 4) of
margin in the resulting image."
  (with-temp-buffer
    (set-buffer-multibyte nil)
    (or (zerop (call-process qrencode-program
                      nil t nil
                      "-o" "-"
                      "-t" type
                      "-l" level
                      "-s" (number-to-string size)
                      "-m" (number-to-string margin)
                      string))
        (error "Process `qrencode' returns non zero:\n%s" (buffer-string)))
    (buffer-string)))

;;;###autoload
(defun* qrencode-region (beg end &key (size 3) (level "L") (margin 4))
  "QRencode the region between BEG and END and return image data.
See `qrencode-string' for the meaning of argument SIZE, LEVEL and
MARGIN."
  (qrencode-string (buffer-substring-no-properties beg end)
                   :size size :level level :margin margin))

(provide 'qrencode)
;;; qrencode.el ends here
