;;; lettamacs.el --- Letta Code integration for Emacs -*- lexical-binding: t; -*-
;; Author: Govind Mohan
;; Version: 0.1.0
;; Keywords: ai tools letta coding
;; License: Apache-2.0

;;; Commentary:
;; Run Letta Code inside Emacs.  Uses vterm for terminal emulation.

;;; Code:

(require 'transient)

(declare-function evil-define-minor-mode-key "evil-core")

(defgroup lettamacs nil
  "Letta Code integration for Emacs."
  :group 'tools)

(defcustom lettamacs-program "letta"
  "The Letta Code executable to run."
  :type 'string)

(defvar lettamacs-vterm-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'vterm-send-return)
    (define-key map (kbd "<return>") #'vterm-send-return)
    (define-key map (kbd "C-c C-c") #'vterm-send-C-c)
    (define-key map (kbd "C-c m") #'lettamacs-transient)
    (when (featurep 'evil)
      (evil-define-minor-mode-key map 'insert
                                  (kbd "RET") #'vterm-send-return))
    map)
  "Keymap used when `lettamacs-vterm-mode' is enabled.")

(define-minor-mode lettamacs-vterm-mode
  "Minor mode for lettamacs vterm buffer."
  :init-value nil
  :keymap lettamacs-vterm-mode-map)

(defun lettamacs--send (cmd)
  "Send CMD to lettamacs buffer."
  (let ((buf (get-buffer "*lettamacs*")))
    (when buf
      (with-current-buffer buf
        (vterm-send-string cmd)
        (vterm-send-return)))))

(transient-define-prefix lettamacs-transient ()
  "Letta Code commands."
  ["Session"
   ("s" "Start" lettamacs-run)
   ("x" "Exit" (lambda () (interactive) (lettamacs--send "/exit")))]
  ["Agent"
   ("a" "List agents" (lambda () (interactive) (lettamacs--send "/agents")))
   ("A" "Switch agent" (lambda () (interactive) (lettamacs--send "/agent")))
   ("m" "Switch model" (lambda () (interactive) (lettamacs--send "/model")))]
  ["Memory"
   ("i" "Init memory" (lambda () (interactive) (lettamacs--send "/init")))
   ("r" "Remember" (lambda () (interactive)
                      (lettamacs--send (concat "/remember " (read-string "Remember: ")))))
   ("p" "Memory palace" (lambda () (interactive) (lettamacs--send "/palace")))
   ("S" "Search memory" (lambda () (interactive) (lettamacs--send "/search")))]
  ["Conversation"
   ("n" "New conversation" (lambda () (interactive) (lettamacs--send "/new")))
   ("c" "Clear" (lambda () (interactive) (lettamacs--send "/clear")))])

;;;###autoload
(defun lettamacs-run (&optional directory)
  "Start a Letta Code session in DIRECTORY (or current project root)."
  (interactive)
  (let ((default-directory (or directory
                               (or (project-root (project-current))
                                   default-directory))))
    (unless (executable-find lettamacs-program)
      (error "Letta Code not found. Install with: npm install -g @letta-ai/letta-code"))
    (let* ((buffer-name "*lettamacs*")
           (vterm-buffer-name buffer-name)
           (vterm-shell lettamacs-program)
           (vterm-kill-buffer-on-exit nil))
      (unless (get-buffer buffer-name)
        (with-current-buffer (vterm-other-window)
          (lettamacs-vterm-mode 1))))))

(provide 'lettamacs)
;;; lettamacs.el ends here
