#lang racket/base

(require racket/require
         (multi-in racket (bool contract/base contract/region file list match path splicing)))

(provide macos-user-font-folders
         system-font-folders
         populate-known-fonts
         known-fonts)

;;----------------------------------------------------------------------

; Return the list of existing /Users/{name}/Library/Fonts directories
(define/contract (macos-user-font-folders)
  (-> (listof path?))

  (define Users-dir  (build-path "/" "Users"))
  (define suffix (build-path "Library" "Fonts"))
  (filter directory-exists?
          (for/list ([username (in-list (directory-list Users-dir))])
            (build-path Users-dir username suffix))))

;;----------------------------------------------------------------------

; Return the list of standard font folders for this operating system
(splicing-let ([sys-font-folders
                (match (system-type)
                  ['macosx  (list* (build-path "/" "System" "Library" "Fonts")
                                   (build-path "/" "Library" "Fonts")
                                   (macos-user-font-folders))]
                  ['unix    (error "Unix and Linux do not have a standard location for fonts")] ; @@TODO Handle this more gracefully
                  ['windows (list (build-path "C:\\" "Windows" "Fonts")
                                  (build-path "C:\\" "psfonts" "pfm"))])])

  (define/contract (system-font-folders)
    (-> (listof path?))
    sys-font-folders))

;;----------------------------------------------------------------------

; Scan the disk to locate font files
(define kf #f)
(define (populate-known-fonts)
  (set! kf (apply append
                  (filter-not empty?
                              (for/list ([folder (system-font-folders)])
                                (find-files (λ (p)
                                              ((or/c #".ttf" #".ttc" #".otf" #".pfm" #".pfb")
                                               (path-get-extension p)))
                                            folder))))))

;;----------------------------------------------------------------------

; Return the list of known font files.  Will call populate-known-fonts
; if it hasn't been called
(define/contract (known-fonts)
  (-> (listof path?))
  (when (false? kf)
    (populate-known-fonts))
  kf)


