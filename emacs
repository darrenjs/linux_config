; Version: Wed Mar 17 08:03:00 2010

; Good emacs sites:
;
; http://www.emacswiki.org/emacs/EmacsNiftyTricks
;

; Things to have:

;   * go back to last edit point
;   * isearch, use  C-w (can press multiple times)
;   * mouse gestures
;   * change cursor during overwrite mode
;   * ediffmode


;; ===== package setup

(package-initialize)

;; ===== Quick customizations =====

;; Format of title bar. Use %f to show filename, and %b to show buffer
;; name.
(setq frame-title-format "%b")
(setq icon-title-format "%b")

(setq inhibit-startup-message   t)   ; Don't want any startup message
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         t) ; Enable auto saving

(setq search-highlight           t) ; Highlight search object
(setq query-replace-highlight    t) ; Highlight query object
(setq mouse-sel-retain-highlight t) ; Keep mouse high-lightening


 ;; Changes all yes/no questions that appear in the minbuffer to y/n
 ;; type questions
(fset 'yes-or-no-p 'y-or-n-p)


;; ===== Set load path to include my local elisp collection =====

(add-to-list 'load-path (expand-file-name "~/system/elisp"))
(add-to-list 'load-path (expand-file-name "~/system/elisp/cc-mode-5.32.9"))


(autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
(add-hook 'cmake-mode-hook 'cmake-font-lock-activate)


(defun my-cc-setup ()
   (c-set-offset 'innamespace [0]))
(add-hook 'c++-mode-hook 'my-cc-setup)

(require 'json-mode)
(require 'typescript-mode)
;; ===== Column marker =====


; Problem with this FCI mode is that is turns off line wrapping


;; (require 'fill-column-indicator)
;; (setq fci-rule-width 1)
;; (setq fci-rule-color "gray40")
;; (setq fci-rule-use-dashes 1)


;; (require 'column-marker)
;; (add-hook 'foo-mode-hook (lambda () (interactive) (column-marker-1 80)))
;; (global-set-key [?\C-c ?m] 'column-marker-1)



;; ===== Load TAGS ============================================================

; Note something with the 'visit-tags-table' function.  Emacs does not
; actually read in the tags table contents until you try to use them;
; all visit-tags-table does is store the file name in the variable
; tags-file-name, and setting the variable yourself is just as good

(if (file-exists-p "~/TAGS")
    (visit-tags-table "~/TAGS" nil))

; Note: here we use tags-table-list to specify a list of tags files, or
; directories, instead of using the tags-file-name variable. So, to get
; TAGS automatically loaded, just make sure to have the TAGS file infci the
; root directory.
(setq tags-table-list '("~/" "~/system"))



;; ===== CEDET =====

;; Semantic
;(load-file "/home/darrens/opt/cedet_snapshot-rev_8638/cedet-bzr/trunk/cedet-devel-load.el")


;; ===== winner mode ====================

;; Enable winner mode, for undo/redo of window layout. The ‘fbound’ test is for
;; those XEmacs installations that don’t have winner-mode available

;; (when (fboundp 'winner-mode)
;;       (winner-mode 1))

;; Default keys are:; ‘C-c left’ and ‘C-c right’.

;; (require 'layout-restore)

;; (global-set-key [?\C-c down] 'layout-save-current)
;; (global-set-key [?\C-c up] 'layout-restore)
;(global-set-key [?\C-c ?\C-l ?\C-c] 'layout-delete-current)

;; ===== Count words & chars in region =====

(defun count-region (beginning end)
  "Print number of words and chars in region."
  (interactive "r")
  (message "Counting ...")
  (save-excursion
    (let (wCnt charCnt)
      (setq wCnt 0)
      (setq charCnt (- end beginning))
      (goto-char beginning)
      (while (and (< (point) end)
                  (re-search-forward "\\w+\\W*" end t))
        (setq wCnt (1+ wCnt)))

      (message "Words: %d Chars: %d" wCnt charCnt)
      )))

;; ===== Define parentheses matching function =====

; This is a great little function.  Press '%' to jump from one
; parenthesis to its partner (and press again to jump back). Inspired by
; the vi editor.

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(global-set-key "%" 'match-paren)

;; ;; ===== Setting the Font =====

;; Guide to setting fonts it emacs.
;;
;; First, load up emacs in a normal mode. Move the mouse pointer over
;; the edit area. While holding down the SHIFT key, hold down the LEFT
;; mouse button. Depending on what kind of system emacs is running, a
;; menu or dialog will pop up, allowing you to select what font to
;; use. Use this interface to try out different fonts and size, until
;; you find one that you're comfortable with.
;;
;; To make this font selection permanent, we now need to get hold of the
;; name of the font. In a window (preferably the *scratch* buffer) enter
;; the following text on a line by itself:
;;
;;  (frame-parameter nil 'font)
;;
;; After doing this, position the cursor just after the rightmost
;; bracket. Now go to the command prompt (by pressing ESC-x or ALT-x)
;; and enter the command:  eval-print-last-sexp  <return>
;;
;; This should cause the font-name to appear just below the cursor, in
;; the edit window. It will be quoted. It might look something like:
;;
;;   "-outline-courier new-normal-r-normal-normal-12-90-96-96-c-*-iso8859-1"
;;
;; To make this font the your default choice edit your .emacs
;; configuration file and add the following command toward the bottom of
;; the file (so that it overrides other font selections):
;;
;; (set-default-font "FONT-NAME" )
;;
;; Finally restart emacs for changes to take effect
(set-default-font "-misc-fixed-medium-r-semicondensed--13-*-*-*-c-*-*-1")
;(set-default-font "-misc-fixed-medium-r-normal--14-*-*-*-c-*-*-1")

;; (defun font-big()
;;   "Change to big font"
;;   (interactive)
;;   (set-default-font "-misc-fixed-medium-r-normal--14-*-*-*-c-*-*-1")
;;   )

;; (defun font-small()
;;   "Change to small font"
;;   (interactive)
;;   (set-default-font "-misc-fixed-medium-r-semicondensed--13-*-*-*-c-*-*-1")
;;   )

;(defun font-gtk()
;  "Change to my preferred GTK font"
;  (interactive)
;  (set-default-font "dejavu sans mono-7")
;(set-default-font "monospace-8")
;(set-default-font "Courier 10 Pitch-8")
;(set-default-font "Kochi Mincho-8")
;(set-default-font "Terminal-9")
;(set-default-font "TlwgMono-8")
;(set-default-font "dejavu sans mono-7")
;(set-default-font "Terminus-9")
;  )

;; Fonts below will only work when emacs has been build with GTK support
;; (eg. emacs-snapshot-gtk)
;(if (string-match "GTK" (emacs-version))
;    (font-gtk)
;  )


;; Set a default font for new windows (eg speedbar window)

; (add-to-list 'default-frame-alist '(font . "-misc-fixed-medium-r-semicondensed--13-*-*-*-c-*-*-1"))



;; ===== Treat underscore as part of a symbol =================================

; By default, if you double click on a variable_name_with_underscore then the
; text which gets selected is only a part of the word, rather than the whole
; name, because the underscores are treated as separators. So here we modify
; the default symbol table to treat underscore as part of the word.

; Note, in any buffer you can do 'C-h s' to run (describe-syntax)

(modify-syntax-entry ?_ "w")


;; ===== Disable bell =========================================================

;; Disable all beeping.  Usually we don't need this function, since
;; running the command "xset b off" at a shell, or in the shell's
;; .probile should be sufficient).  But if all else fails, enable this
;; lisp:

(setq ring-bell-function (lambda () (message "*beep*")))

;; ===== Set initial mode =====

;; Emacs defaultly starts up in buffer called *scratch* in
;; initial-major-mode, which defaults to lisp-interaction-mode. Enabling
;; following code in the .emacs init file will cause the initial
;; *scratch* buffer to be put into auto-fill'ed text-mode.

(setq initial-major-mode
      (function (lambda ()
                  (text-mode)
                  (turn-on-auto-fill))))

;; ===== Delete selection when typing  =====

(delete-selection-mode 1)

;; ===== Recent files more =====

; I don't use the menu bar often, but nice to have a list of recently
; opened files.

(recentf-mode 1)

;; ===== Selection mode =====

;; There are two seletions modes: emacs default, which involves placing
;; a 'mark' and then moving the 'point' - and everything between is the
;; 'region' which is selected; and, the PC emulation mode which allows
;; selection via use of the SHIFT and cursor keys.

;; To enable the PC selection mode, enable the following line

;(pc-selection-mode)

;; If using the emacs selection mode, enable the transient-mark-mode
;; with the following line - this turns on highlighting for the
;; selection region. The highlighting can be canceled by pressing
;; CONTROL-g.

(transient-mark-mode t)

;; TIP: Use C-x C-x to swap the current cursor position with the mark

;; ===== Set the prefered size of the tab width =====

(setq default-tab-width 4)

;; ===== php mode =============================================================

;(require 'php-mode)

;; ===== Use the ibuffer mode

;; ; enable font lock mode before requiring ibuffer
;; (global-font-lock-mode 1)

;; (require 'ibuffer)

;; ; Recommended by someone on an emacs forum
;; (add-hook 'ibuffer-hook
;;           (lambda () (ibuffer-jump-to-buffer
;;                       (buffer-name (other-buffer (current-buffer) t)))))

;; ===== Add support for Python mode =====

;(add-to-list 'load-path (expand-file-name "~/system/elisp/python-mode"))
;(require 'python-mode)

(require 'highlight-indentation)
(set-face-background 'highlight-indentation-face "#333333")
(add-hook 'python-mode-hook 'highlight-indentation-mode)
(add-hook 'js2-mode-hook    'highlight-indentation-mode)

;; ===== Load bm.el easy bookmarks mode =====

(require 'bm)

(global-set-key [(meta return)] 'bm-toggle)
(global-set-key "\M-[" 'bm-previous)
(global-set-key "\M-]" 'bm-next)

;; ===== Add support for NXML mode =====

(add-to-list 'load-path (expand-file-name "~/system/elisp/nxml-mode"))

(require 'nxml-mode)

(add-to-list 'auto-mode-alist
             (cons (concat "\\." (regexp-opt '("xml"
                                               "xsd"
                                               "sch"
                                               "rng"
                                               "xslt"
                                               "svg"
                                               "rss") t) "\\'")
                   'nxml-mode))

;; ===== Enable the Matlab mode =====

(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)


;; ===== Enable the C# mode =====


;; (autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)

;; ; Associate C# files
;; (setq auto-mode-alist
;;       (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))


;; ;; C# hook - use for adding later customisations
;; (defun my-csharp-mode-hook ()
;;   (progn
;;    (turn-on-font-lock)
;;    (auto-fill-mode)
;;    (define-key csharp-mode-map "\t" 'c-tab-indent-or-complete)))
;; (add-hook 'csharp-mode-hook 'my-csharp-mode-hook)

;; ===== Load in my favourate Emacs customizations =====

;(require 'a4log-mode)  Used only in UBS configuration

;; (require 'balanced)
;; (add-hook 'scheme-mode-hook 'balanced-on)

;; Enables a recent-file list
(load "edit-history")

;; Enables quick access to last buffer
(require 'toggle-buffer)

;; Tabbar
;; (require 'tabbar)
;; (tabbar-mode)
;; (global-set-key [(control shift up)] 'tabbar-backward-group)
;; (global-set-key [(control shift down)] 'tabbar-forward-group)
;; (global-set-key [(control shift left)] 'tabbar-backward)
;; (global-set-key [(control shift right)] 'tabbar-forward)

;; ;; Persist emacs session
;; (require 'session)
;; (add-hook 'after-init-hook 'session-initialize)

;; Fast buffer navigation
(autoload `cyclebuffer-forward "cyclebuffer" "cycle forward" t)
(autoload `cyclebuffer-backward "cyclebuffer" "cycle backward" t)

;; ;; ===== Use color-moccor.el =====

(require 'compile)
(require 'color-moccur)

(global-set-key "\M-f" 'moccur)
(global-set-key "\M-s" 'occur-by-moccur)

 ;; ===== Set file associations =====

; Associate NRS n-files with the C mode
; (setq auto-mode-alist (append auto-mode-alist '(("\\.n$" . c-mode))))

;; ===== Automatically load abbreviations table =====
;; Note that emacs chooses, by default, the filename
;; "~/.abbrev_defs", so don't try to be too clever
;; by changing its name
(setq-default abbrev-mode t)
(read-abbrev-file "~/.abbrev_defs")
(setq save-abbrevs t)

;; ===== Set the highlight current line minor mode =====

;; In every buffer, the line which contains the cursor will be fully
;; highlighted

(global-hl-line-mode 1)

;; ===== Set standard indent to 2 rather that 4 ====
(setq standard-indent 2)

;; ===== Turn on the Iswitchb mode =====

; Iswitchb global minor mode provides convenient switching between
; buffers using substrings of their names. Its commands that are
; somewhat "smarter." As you type a buffer name, it attempts to complete
; the name, and pressing Enter selects the buffer name it suggests. Some
; other commands can be used at the iswitchb prompt:
;
; C-s Put the first element at the end of the list.
; C-r Put the last element at the start of the list.
; C-t Toggle regexp searching.
; C-k Kill buffer at head of buffer list.
; C-x C-f Exit iswitchb and drop into `find-file'.
;
; For more, do C-h f "iswitchb"

(iswitchb-mode 1)
(global-set-key [(control return)] 'iswitchb-buffer)

;; ===== Turn line numbering on =====

; The current line number is made visible in the status bar

(line-number-mode 1)

; Also, show line-numbers in each buffer

;(global-linum-mode 1)
;(setq linum-format " %d ")

; Faster line-number package
(require 'nlinum)
(global-nlinum-mode 1)

;; ===== Turn off tab character =====

; Emacs normally uses both tabs and spaces to indent lines.  If you
; prefer, all indentation can be made from spaces only.  To request
; this, set `indent-tabs-mode' to `nil'.  This is a per-buffer variable;
; altering the variable affects only the current buffer, but there is a

; Use (setq ...) to set value locally to a buffer.
; Use (setq-default ...) to set value globally.

(setq-default indent-tabs-mode nil)

;; ===== Restoring scrolling mistakes =====
;;
;; Restoring the scroll point involves defining several variables and
;; functions
(defvar unscroll-point nil
  "Text position for next call to `unscroll'.")
(defvar unscroll-window-start nil
  "Window start for next call to `unscroll'.")
(defvar unscroll-hscroll nil
  "Hscroll for next call to `unscroll'.")


(defun unscroll-maybe-remember ()
  (if (not (or (eq last-command 'scroll-up)
               (eq last-command 'scroll-down)
               (eq last-command 'scroll-left)
               (eq last-command 'scroll-right)))
      (setq unscroll-point (point)
            unscroll-window-start (window-start)
            unscroll-hscroll (window-hscroll))))

(defadvice scroll-up (before remember-for-unscroll
                             activate compile)
  "Remember where we started from, for `unscroll'."
  (unscroll-maybe-remember))

(defadvice scroll-down (before remember-for-unscroll
                               activate compile)
  "Remember where we started from, for `unscroll'."
  (unscroll-maybe-remember))

(defadvice scroll-left (before remember-for-unscroll
                               activate compile)
  "Remember where we started from, for `unscroll'."
  (unscroll-maybe-remember))

(defadvice scroll-right (before remember-for-unscroll
                                activate compile)
  "Remember where we started from, for `unscroll'."
  (unscroll-maybe-remember))

(defun unscroll()
  "Revert to `unscroll-point' and `unscroll-window-start'."
  (interactive)
  (if (not unscroll-point)
      (error "Cannot unscroll yet"))
  (goto-char unscroll-point)
  (set-window-start nil unscroll-window-start)
  (set-window-hscroll nil unscroll-hscroll))

;; ========== Prevent Emacs from making backup files ==========

;; Enable backup files. Uncomment to disable all backups
(setq make-backup-files nil)

;; Enable versioning with default values (keep five last versions, I think!)
;(setq version-control t)

;; Save all backup file in this directory.
;(setq backup-directory-alist (quote ((".*" . "~/personal/.emacs-backups/"))))

;; ========== Screen shiftbackward-delete-char-untabify  ==========

(defalias 'scroll-ahead 'scroll-up)
(defalias 'scroll-behind 'scroll-down)

(defun scroll-n-lines-ahead (&optional n)
  "Scroll ahead N lines (1 by default)."
  (interactive "P")
  (scroll-ahead (prefix-numeric-value n)))

(defun scroll-n-lines-behind (&optional n)
  "Scroll behind N lines (1 by default)."
  (interactive "P")
  (scroll-behind (prefix-numeric-value n)))

(defun scroll-fixed-lines-behind ()
  "Scroll behind a fixed amount of lines"
  (interactive)
  (scroll-behind (prefix-numeric-value 3)))

(defun scroll-fixed-lines-ahead ()
  "Scroll ahead a fixed amount of lines"
  (interactive)
  (scroll-ahead (prefix-numeric-value 3)))

;; ========== Mouse wheel scrolling ==========

; Rather than use the standard mouse scrolling, what we do instead is
; just map the mouse scroll events to some pre-defined scroll
; functions. These scroll functions behave less jerky than the standard
; mouse scrolling.  However, overall behaviour is dependant on which
; system emacs is being run.  In some cases, better behaviour might be
; achieved using the mouse-wheel-mode.

;; Turn on support for scrolling up and down using the wheel on a wheel mouse
;(mouse-wheel-mode t)

(global-set-key [mouse-5] 'scroll-fixed-lines-ahead)
(global-set-key [mouse-4] 'scroll-fixed-lines-behind)

;; Old style mouse scrolling
; (mouse-wheel-mode t)
; (setq mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))

;; ===== Set the fill column =====

(setq-default fill-column 80)

;; ========== Bind fill region ==========black

;; The key sequence for fill-paragraph is \M-q so a similar key sequence has
;; been chosen for fill-region.
(global-set-key [?\M-Q]       'fill-region)       ;; Meta-Shift-q

;; ===== Make Text mode the default mode for new buffers =====

(setq default-major-mode 'text-mode)

;; ===== Word count function =====

; Taken from the EmacsWiki
(defun count-words (start end)
  "Print number of words in the region."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (count-matches "\\sw+"))))

(defalias 'word-count 'count-words)

;; ===== Turn on Auto Fill mode automatically in all modes =====

;; Auto-fill-mode the the automatic wrapping of lines and insertion of
;; newlines when the cursor goes over the column limit.

;; This should actually turn on auto-fill-mode by default in all major
;; modes. The other way to do this is to turn on the fill for specific modes
;; via hooks.
(setq auto-fill-mode 1)

;; ===== Function to nuke (ie entirly delete) a line =====

;; First define a variable which will store the previous column position
(defvar previous-column nil
  "Save the column position")


;; Define the nuke-line function. The line is killed, then the newline
;; character is deleted. The column which the cursor was positioned at is then
;; restored. Because the kill-line function is used, the contents deleted can
;; be later restored by usibackward-delete-char-untabifyng the yank commands.
(defun nuke-line()
  "Kill an entire line, including the trailing newline character"
  (interactive)

  ;; Store the current column position, so it can later be restored for a more
  ;; natural feel to the deletion
  (setq previous-column (current-column))

  ;; Now move to the end of the current line
  (end-of-line)

  ;; Test the length of the line. If it is 0, there is no need for a
  ;; kill-line. All that happens in this case is that the new-line character
  ;; is deleted.
  (if (= (current-column) 0)
      (delete-char 1)

    ;; This is the 'else' clause. The current line being deleted is not zero
    ;; in length. First remove the line by moving to its start and then
    ;; killing, followed by deletion of the newline character, and then
    ;; finally restoration of the column position.
    (progn
      (beginning-of-line)
      (kill-line)
      (delete-char 1)
      (move-to-column previous-column))))

;; ========== Duplicate current line ==========

(defvar duplicate-start nil
  "Used for line duplication")

;; Make a copy of the current line and paste into buffer
(defun duplicate-line()
  "Make a copy of the current line"
  (interactive)

  ;; Store the current column position, so it can later be restored for a more
  ;; natural feel to the deletion
  (setq previous-column (current-column))
  (beginning-of-line)
  (setq duplicate-start (point))
  (end-of-line)
  (copy-region-as-kill duplicate-start (point))
  (newline)
  (yank)
  (move-to-column previous-column))

;; ========= Set colors ==========

; TIP: to list emacs colours, use the command: list-colors-display

(set-cursor-color "red")
(set-mouse-color "goldenrod")

;; Set region background colour
(set-face-background 'region "blue")

;; Set emacs basic colors
;(set-background-color "black")
(set-background-color "grey10")
(set-foreground-color "grey80")

;(set-background-color "azure2")
;(set-foreground-color "black")

;; ========== Tidy Save ==========

;; Function which first deletes all trailing whitespace, and then does a save
(defun tidy-save()
  "Delete trailing whitespace and save"
  (interactive)
  (delete-trailing-whitespace)
  (save-buffer)
  )

;; ========== Create a new buffer ==========

; Function to create a new buffer
(defun new-buffer()
  "Ceate a new buffer"
  (interactive)
  (let ((buf (generate-new-buffer-name "new")))
    (generate-new-buffer buf)
    (switch-to-buffer buf)
    )
  )

(global-set-key "\C-x\C-n" 'new-buffer)

;; ========== Line by line scrolling ==========

;; This makes the buffer scroll by only a single line when the up or
;; down cursor keys push the cursor (tool-bar-mode) outside the
;; buffer. The standard emacs behaviour is to reposition the cursor in
;; the center of the screen, but this can make the scrolling confusing

(setq scroll-step 1)

;; ========== Activating various modes ==========

;; Particular modes are selected here for personal preference

;; Turn off the tool-bar and menu-bar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Show column number in the mode line
(column-number-mode 1)

;; ========== Scroll to buffer limits instead of beep ==========

;; Emacs by default will produce an error beep when page-up or page-down force
;; a scroll to the beginning or end of the buffer. As well as beeping, the
;; cursor is not moved to the beginning or end of buffer, but is instead left
;; several lines away.
;;
;; This behaviour can be altered to make Emacs more like PC editors which move
;; the cursor to the beginning or end of the buffer and produce no error beep.
;;
;; This is achieved by 'advising' the scroll-down and scroll-up functions. The
;; code comes from Dave Pearson (harbour@matrixlist.com)
;;
;; In both cases the advice code wraps around the function calls so the advice
;; is responsible for making the code (the `ad-do-it' is the call to the
;; advises function). The condition case is simply an error trap.

(defadvice scroll-down (around full-scroll-down activate)
  "Ensure that `scroll-down' goes right to the start of the buffer."
  (condition-case nil
      ad-do-it
    (beginning-of-buffer (goto-char (point-min)))))

(defadvice scroll-up (around full-scroll-up activate)
  "Ensure that `scroll-up' goes right to the end of the buffer."
  (condition-case nil
      ad-do-it
    (end-of-buffer (goto-char (point-max)))))


;; ========== Customise the Java & C++ indentation ==========

;; Provide customisations to the default Java and C/C++ styles.
;;
;; Here the main change are really to alter the default settings of the
;; indentation.  E.g., be default, in the java-mode, the { brace
;; following an if/while/for block is indented.
;;
;; To make this change, and others like it,we need to set some
;; parameters in the c-offset-alist variable.  If you open emacs and run
;; the command "describe-variable" and then enter "c-offset-alist", you
;; can scroll down the text that appears to find a list of all the
;; syntax elements: you will find that "substatement" is the symbol that
;; controls first line indentin.
;;
;; So, to change this variable, we just add a hook and make a call to
;; (c-set-offset 'substatement-open 0)
;;
;; Note that the basic offset unit is determine by the c-basic-offset
;; value, which has been set earlier.
;;
;; During an Emacs session the current indentation style can be found by
;; doing C-h v for variable "c-indentation-style". At any time in Emacs,
;; the command "c-set-style" can be invoked to change current
;; indentation style.
;;

;; Define a function which will apply customisations to the Java
;; mode. Current this involves set the indentation style.

 (defun java-mode-customizations()
   (c-set-style "java")
   (setq c-basic-offset 2)
   (setq tab-width 2)

   (c-set-offset 'substatement 2)
   (c-set-offset 'substatement-open 0)
   (c-set-offset 'statement-case-intro 0)
   (c-set-offset 'statement-case-open 0)

   (modify-syntax-entry ?_ "w" )
   (modify-syntax-entry ?- "w")

   (font-lock-add-keywords nil
                           '(("\\<\\(true\\|false\\|null\\)" 1 font-lock-keyword-face t)))
   (font-lock-add-keywords nil
                           '(("\\<\\(FIXME\\|TODO\\|BUG\\)" 1 font-lock-warning-face t)))
  )
;; Register the above function to run when the "java-mode" is entered
(add-hook 'java-mode-hook 'java-mode-customizations)

;; Define C++ mode customizations - Modify the syntax table so that the
;; underscore and dash characters are considered word characters. This
;; is useful so that when I double click on a variable name, the whole
;; name is selected. By default this does not happen; the selection is
;; limited to an underscore or dash character, which is a problem
;; because I often have underscores and dashes in variable names.

(defun c++-mode-customizations()
  (c-set-style "ellemtel")
  (setq c-basic-offset 2)
  (turn-on-font-lock)

  (modify-syntax-entry ?_ "w" )
  (modify-syntax-entry ?- "w")

  (font-lock-add-keywords nil
                          '(("\\<\\(FIXME\\|TODO\\|BUG\\)" 1 font-lock-warning-face t)))
  )

;; Register the above function to run when C/C++ modes are entered
(add-hook 'c++-mode-hook 'c++-mode-customizations)
(add-hook 'c-mode-hook 'c++-mode-customizations)

(add-to-list 'auto-mode-alist
             (cons (concat "\\." (regexp-opt '("h"
                                               "inl") t) "\\'")
                   'c++-mode))


;; ========== Function to Quote a Region ==========

;; When writing documents which contain extended quotes, it can be
;; helpfull to fill the quote to a smaller width than the surrounding
;; text. The following function does this, aswell as preceding each
;; quote line with a comment character.

(defvar previous-fill-column nil "Save the previous values of fill-column")

(defun quote-region (beg end)
  "Indent the region to make it look like a quote"
  (interactive "r")
  (setq previous-fill-column fill-column)
  (setq fill-column 60)
  (comment-region beg end)
  (fill-region beg end `left' nil nil)
  (setq fill-column previous-fill-column)
  )

(defun kill-current-buffer()
  "Delete trailing whitespace and save"
  (interactive)
  (kill-buffer nil)
  )

(global-set-key [C-f6] 'quote-region)

;; ========== javascript mode customizations ==========


(defun javascript-mode-customizations()

  ;; Allow text lines to be commented out
  (setq comment-start "// ")

  ;; Turn on automatic fill
  (auto-fill-mode 1)

  ; Modify the syntax table so that the underscore and dash characters are
  ; considered word characters. This is useful so that when I double click on a
  ; variable name, the whole name is selected. By default this does not happen;
  ; the selection is limited to an underscore or dash character, which is a
  ; problem because I often have underscores and dashes in variable names. (YES,
  ; I want this to work in text files as well as in code files)
  (modify-syntax-entry ?_ "w" )
  (modify-syntax-entry ?- "w")

  (turn-on-font-lock)

  (font-lock-add-keywords nil
                          '(("\\<\\(true\\|false\\|null\\)" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil
                          '(("\\<\\(FIXME\\|TODO\\|BUG\\)" 1 font-lock-warning-face t)))
  (setq font-lock-defaults
        '(
          (
           ("\"[^\"]+\"" 0 font-lock-string-face)
           ("p[123456780]+" 0 font-lock-constant-face)
           ("P[123456780]+" 0 font-lock-constant-face)
           (":[123456780]+" 0 font-lock-constant-face)
           ("TRACE" 0 font-lock-warning-face)
           ("TODO" 0 font-lock-warning-face)
           ("DONE" 0 font-lock-string-face)
           ("---[-]+" 0 font-lock-comment-face)
           ("^\\* " 0 font-lock-comment-face)
           ("===[=]+" 0 font-lock-constant-face)
           )
          nil nil
          nil
          mark-paragraph
          )
        )
 )

; NOTE: the javascript mode hook is called 'js-mode-hook'
(add-hook 'js-mode-hook 'javascript-mode-customizations)

;; ========== Text mode customizations ==========

;; Make the following customizations when in the text mode. This is done by
;; attaching a hook to the function text-mode-customizations() - this function
;; is called when the text-mode is activated

(add-hook 'text-mode-hook 'text-mode-customizations)

(defun text-mode-customizations()

  ;; Allow text lines to be commented out
  (setq comment-start "| ")

  ;; Turn on automatic fill
  (auto-fill-mode 1)

 ; Modify the syntax table so that the underscore and dash characters
 ; are considered word characters. This is useful so that when I double
 ; click on a variable name, the whole name is selected. By default
 ; this does not happen; the selection is limited to an underscore or
 ; dash character, which is a problem because I often have underscores
 ; and dashes in variable names. (YES, I want this to work in text
 ; files as well as in code files)
  (modify-syntax-entry ?_ "w" )
  (modify-syntax-entry ?- "w")
  (turn-on-font-lock)

  (setq font-lock-defaults
        '(
          (
           ("\"[^\"]+\"" 0 font-lock-string-face)
           ("p[123456780]+" 0 font-lock-constant-face)
           ("P[123456780]+" 0 font-lock-constant-face)
           (":[123456780]+" 0 font-lock-constant-face)
           ("TRACE" 0 font-lock-warning-face)
           ("TODO" 0 font-lock-warning-face)
           ("DONE" 0 font-lock-string-face)
           ("---[-]+" 0 font-lock-comment-face)
           ("^\\* " 0 font-lock-comment-face)
           ("===[=]+" 0 font-lock-constant-face)
           )
          nil nil
          nil
          mark-paragraph
          )
        )
  )

        ;   ("===[=]+" 0 font-lock-constant-face)

;; (("\\(\"[<`]\\|``\\)[^'\">

;; font-lock-keywords - list of the below

;; should have one of these forms

;;  MATCHER
;;  (MATCHER . MATCH)
;;  (MATCHER . FACENAME)
;;  (MATCHER . HIGHLIGHT)
;;  (MATCHER HIGHLIGHT ...)
;;  (eval . FORM)

;; (1) First set the variable font-lock-defaults
;;     The value should look like this:
;;
;;     (keywords keywords-only case-fold
;;      syntax-alist syntax-begin other-vars...)

;; (setq font-lock-face-attributes
;;       ;; FACE FG BG bold italic underline
;;       '((font-lock-comment-face "Firebrick")
;;         (font-lock-string-face "blue1" nil nil nil t)
;;         (font-lock-emphasized-face nil nil t nil nil)
;;         (font-lock-keyword-face "Purple")
;;         (font-lock-function-name-face "Blue")
;;         (font-lock-variable-name-face "DarkGoldenrod")
;;         (font-lock-type-face "DarkOliveGreen")
;;         (font-lock-reference-face "CadetBlue")))

;; ========== Insert time stamp ==========

;; Functions to insert time, date, and a date-time-stamp

(defvar insert-time-format "%T"
  "*Format for \\[insert-time] (c.f. 'format-time-string' for how to format).")

(defvar insert-date-format "%d/%m/%y"
  "*Format for \\[insert-date] (c.f. 'format-time-string' for how to format).")

(defun time ()
  "Insert the current time according to the variable \"insert-time-format\"."
  (interactive "*")
  (insert (format-time-string insert-time-format
                              (current-time))))

(defun date ()
  "Insert the current date according to the variable \"insert-date-format\"."
  (interactive "*")
  (insert (format-time-string insert-date-format
                              (current-time))))

(defun now ()
  "Insert current date and time."
  (interactive "*")
  (insert (current-time-string)))


;; ========== Insert TODO ==========

(define-skeleton todo
  "Inserts a TODO keyword"
  > "TODO: ")

(global-set-key "\C-x\C-t" 'todo)


;; ========= Revert mode ==========

; Detect if a file has changed, and automatically refresh buffer

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-revert-interval 1))
(global-auto-revert-mode 1)


;; ========= Iteractive function for printing file-name of buffer =====

;; This can be bound to a key, such as Alt F2 so that we can easily
;; display the file name underlying the current buffer.

(defun display-buffer-filename ()
  "Display the file name of the current buffer."
  (interactive )
  (message buffer-file-name))

; Bind to C-?
(global-set-key [(control \?)] 'display-buffer-filename)

;; ===== point-stack =====

(require 'point-stack)

(global-set-key [(control -)] 'point-stack-pop)
(global-set-key [(control +)] 'point-stack-push)

;; ===== highlight-symbol =====

(require 'highlight-symbol)

(global-set-key [f5]           'highlight-symbol-at-point)
(global-set-key [(control f5)] 'highlight-symbol-next)
(global-set-key [(shift f5)]   'highlight-symbol-prev)
(global-set-key [(meta f5)]    'highlight-symbol-prev)

;; ========= Key bindings ==========

;; This is the place for most of my key bindings. However some might have
;; already been set earlier in this file
;;
;; Within emacs we can use the command describe-bindings to see which
;; keys are bound to which functions.

;;  hitting F1 will give you the man page for the library call at the
;;  current cursor position.
;;(global-set-key  [(f1)]  (lambda () (interactive) (manual-entry (current-word))))

(global-set-key [f1] 'iswitchb-buffer)
(global-set-key [C-f1] 'speedbar)

(global-set-key [f2] 'tidy-save)
(global-set-key [M-f3] 'revert-buffer)
(global-set-key [C-f2] 'save-buffer)
(global-set-key [f3] 'find-file)
(global-set-key [C-f3] 'find-file-read-only)


;; Only way I could get this working. C-` is for quoted-insert, since I
;; am using C-q for scrolling
(global-set-key [(control \`)] 'quoted-insert)

(global-set-key [f6] 'comment-region)
(global-set-key [M-f6] 'uncomment-reghion)

(global-set-key [f7] 'duplicate-line)
(global-set-key [f8] 'nuke-line)


;(global-set-key [f11] 'delete-window)
;(global-set-key [f12] 'split-window-vertically)

; Invoke last recorded macro with ctrl-x SPC
(global-set-key "\C-x " 'kmacro-end-and-call-macro)

;; Ctrl-PageUp
(global-set-key [C-prior] 'beginning-of-buffer)
;; Ctrl-PageDown
(global-set-key [C-next] 'end-of-buffer)

;; Hippie-expand
(global-set-key [C-tab] 'hippie-expand)

;; Emacs has replace-string and query replace functions, but they are on
;; awkard keys, so map these here
(global-set-key [\C-f4] 'query-replace)
(global-set-key [f4] 'replace-regexp)

;; Remove certain keys which annoy me
(global-unset-key [f9])

(global-set-key [f9] 'find-tag)
(global-set-key [\C-f9] 'pop-tag-mark)

;; Alt-G for goto-line
(global-set-key "\M-g" 'goto-line)

;; Quick buffer navigation
(global-set-key [(control shift up)] 'iswitchb-buffer)
(global-set-key [(control shift down)] 'joc-toggle-buffer)
(global-set-key [(control shift left)] 'cyclebuffer-forward)
(global-set-key [(control shift right)] 'cyclebuffer-backward)

;; Use ibuffer instead of buffer
(global-set-key "\C-x\C-b" 'ibuffer)


(global-set-key [(XF86Back)] 'scroll-down)
(global-set-key [(XF86Forward)] 'scroll-up)
(global-set-key [(control XF86Forward)] 'end-of-buffer )
(global-set-key [(control XF86Back)] 'beginning-of-buffer)
(global-set-key [(meta up)] 'scroll-n-lines-behind)
(global-set-key [(meta down)] 'scroll-n-lines-ahead)


;; Note, it is not necessary to map the copy, paste and cut functions,
;; because emacs has mappings for these by default:
;;
;; copy:  Meta-w
;; cut:   Control-w
;; paste: Control-y

;; Map Control-c Control-c to copy
(global-set-key "\C-c\C-c" 'copy-region-as-kill)

;; ;; Map Control-c Control-v to paste
(global-set-key "\C-c\C-v" 'yank)


;;;; Use MS-Windows style save key
;;(global-set-key "\C-s" 'tidy-save)

;;;; Now that C-s is used for saving, need a key for searching
(global-set-key "\C-s" 'isearch-forward)
(global-set-key "\C-f" 'isearch-forward)

;; For UBS only

(global-set-key [(control backspace)] 'backward-kill-word)
(global-set-key [(control delete)] 'kill-word)
;(global-set-key [(backspace)] 'backward-delete-char-untabify)
(global-set-key [(delete)] 'delete-char)



;; ===== Emacs server =========================================================

;; Run the emacs server in TCP mode, and set the server-host variable to be
;; the box where emacs is normally started.  This causes emacs to generate a
;; server-file at path:
;;
;;     ~/.emacs.d/server/server
;;
;; which in turn we give to emacsclient, so that it can find the emacs server
;; and authenticate.  I.e., we would start emacsclient (on any host) like:
;;
;;     emacsclient --server-file=~/.emacs.d/server/server <LINE> <FILE>
;;

(setq server-use-tcp t)
(setq server-host "t420")  ; set your host here
(server-start)

;; ========== Place Scroll-Bar on Right ==========

(setq scroll-bar-mode-explicit t)
(set-scroll-bar-mode `right)

;; ========== Font Lock Patterns ==========

(font-lock-add-keywords
  'c-mode
 ; put the string after include and import in the same color
  '(("^#[ \t]*\\(import\\|include\\)[ \t]*\\(<[^>\"\n]*>?\\)" 2 font-lock-builtin-face t)
 ; put the # before the keywords in the same color
  ("^#[ \t]*\\(import\\|include\\|ifdef\\|endif\\|ifndef\\|elif\\|endif\\|define\\)[ \t]*" 0 font-lock-builtin-face t)))



;; ===== Calendar & Diary =====

;; (setq view-diary-entries-initially t
;;       mark-diary-entries-in-calendar t
;;       number-of-diary-entries 7)


;; (setq calendar-week-start-day 1)

;; (add-hook 'today-visible-calendar-hook 'calendar-star-date)

;; (add-hook 'diary-display-hook 'fancy-diary-display)
;; (add-hook 'today-visible-calendar-hook 'calendar-mark-today)


;; (setq calendar-week-start-day 1
;;       calendar-day-name-array
;;       ["Domingo" "Lunes" "Martes"
;;        "Miercoles" "Jueves" "Viernes" "Sábado"]
;;       calendar-month-name-array
;;       ["Enero" "Febrero" "Marzo" "Abril"
;;        "Mayo" "Junio" "Julio" "Agosto" "Septiembre"
;;        "Octubre" "Noviembre" "Diciembre"])

;(calendar)



;; ========== Menu ==========

;; The function to load a single file
(defun fileload-chomsky ()
  "Load Chomsky file"
  (interactive "*")
  (find-file "~/work/politics/Chomsky_Guidelines.txt"))

;; The function to load a single file
(defun fileload-l_and_a ()
  "Load Letters"
  (interactive "*")
  (find-file "~/work/politics/LettersArticles.txt"))

;; Define the master menu for file-access
(defvar menu-bar-favourites-menu (make-sparse-keymap "favourites"))


;; Define a sub-menu
(defvar menu-bar-politics-menu (make-sparse-keymap "politics"))


;; Define an entry into this menu
(define-key menu-bar-politics-menu [loadfile_chomsky]
  '("Chomsky" .  fileload-chomsky))

;; Define an entry into this menu
(define-key menu-bar-politics-menu [loadfile_l_and_a]
  '("Letters" .  fileload-l_and_a))

 ;; Define an entry into this menu
(define-key menu-bar-favourites-menu [politics]
  (cons "Politics" menu-bar-politics-menu))



;; Attach the favourites menu to the Emacs menu bar
(define-key global-map [menu-bar favourites]
  (cons "Favourites"  menu-bar-favourites-menu))


;; ===== Andy Sawyer lisp

; I've updated the orignally lisp function by Andy Sawyer.  I've added two
; approaches to copying the text into the clipboard.  First we use
; 'x-select-text' to copy into the X11 SECONDARY clipboard, and also use
; 'x-set-selection' to copy in the X11 PRIMARY clipboard.

(defun gdb-pos()
  (interactive)
  (let ((buf (format "%s:%d"
                     (file-name-nondirectory (buffer-file-name))
                     (line-number-at-pos)
                     )))
    (message buf)
    (x-select-text buf)
    (x-set-selection nil buf)
    )
  )

;; ;; ===== Experimental Region =====

;; (require 'tramp)
;; (setq tramp-default-method "scp")

;; (autoload 'css-mode "css-mode")
;; (setq auto-mode-alist
;;       (cons '("\\.css\\'" . css-mode) auto-mode-alist))


;; ========== Custom Faces ==========

;;
;; This is where all kinds of faces are customized. Be careful here
;; because both the user and emacs may edit this section
;;

;;
;; Note - the init file should have only one of these sections
;;

;; Set my preferred small font. It's family name is 'fixed' and note
;; that it has no size specified. This is just one of the
;; characateristics of this font - it is a fixed, unscalable size.
;;

(put 'upcase-region 'disabled nil)

(put 'downcase-region 'disabled nil)

(put 'erase-buffer 'disabled nil)

(server-start)



(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "red" :foreground "black"))))
 '(font-lock-warning-face ((((class color) (min-colors 88) (background dark)) (:background "Red" :foreground "yellow" :weight bold))))
 '(highlight ((((class color) (background dark)) (:background "DarkSlateBlue"))))
; '(linum ((t (:inherit (shadow default) :foreground "grey30"))))
 '(show-ws-spaces ((t nil)))
 '(show-ws-tabs ((((class color)) nil)))
 '(show-ws-unbr-spaces ((((class color)) nil))))

;;======================================================================
;;
;; REFERENCE SECTION
;;
;;======================================================================


;----------------------------------------------------------------------
; Keys for using tags
; -------------------
;
;    * Tag lookup (current selection): M-.
;    * Search again                  : C-u M-.
;    * Pop search                    : M-*

;----------------------------------------------------------------------
; QUICK ELISP HOWTO
; -----------------
;
; When writing a function, make sure to include the (interactive) line,
; otherwise the user won't be able to call it. E.g.:
;
;      (defun tidy-save()
;       "Delete trailing whitespace and save"
;       (interactive)
;       (delete-trailing-whitespace)
;       (save-buffer)
;      )
;



;----- Sorting Lines Numerically -----

;; Emacs can sort the following region:
;
; 37 OrderID
; 11 ClOrdID
; 41 OrigClOrdID
; 109 ClientID
; 7 ExecID
; 20 ExecTransType
; 150 ExecType
; 39 OrdStatus
; 5 Symbol
; 4 Side
; 151 LeavesQty
; 14 CumQty
; 6 AvgPx
;
; Select the region, then run the command sort-numeric-fields. It produces
; the output:
;
; 4 Side
; 5 Symbol
; 6 AvgPx
; 7 ExecID
; 11 ClOrdID
; 14 CumQty
; 20 ExecTransType
; 37 OrderID
; 39 OrdStatus
; 41 OrigClOrdID
; 109 ClientID
; 150 ExecType
; 151 LeavesQty
;
