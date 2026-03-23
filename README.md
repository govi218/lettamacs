# Lettamacs

Letta Code in Emacs via vterm.

## Requirements

- Emacs 28.1+
- vterm
- Letta Code CLI (`npm install -g @letta-ai/letta-code`)

## Install

With straight.el:

```elisp
(use-package lettamacs
  :straight (lettamacs :type git :host github :repo "govi218/lettamacs")
  :bind ("C-c a" . lettamacs-run))
```

Or clone and add to load-path manually.

## Usage

- `C-c a` - Start session
- `C-c m` (in buffer) - Command menu

## Commands

- `/agents` `/agent` `/model` - Manage agents
- `/init` `/remember` `/palace` `/search` - Memory
- `/new` `/clear` - Conversation
