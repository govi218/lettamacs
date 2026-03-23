# Lettamacs

Letta Code in Emacs via vterm.

## Requirements

- Emacs 28.1+
- vterm
- Letta Code CLI (`npm install -g @letta-ai/letta-code`)

## Install

```elisp
(add-to-list 'load-path "~/dev/lettamacs")
(require 'lettamacs)
(global-set-key (kbd "C-c a") #'lettamacs-run)
```

## Usage

- `C-c a` - Start session
- `C-c m` (in buffer) - Command menu

## Commands

- `/agents` `/agent` `/model` - Manage agents
- `/init` `/remember` `/palace` `/search` - Memory
- `/new` `/clear` - Conversation
