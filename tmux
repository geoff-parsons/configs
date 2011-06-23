
set -g default-terminal "xterm-256color"

# Start Window List at 1
set -g base-index 1

# Visual Bell
set-option -g visual-bell on

# Enable Window Activity Notifications
setw -g monitor-activity on
set -g visual-activity on


##
## Key Bindings
##

bind-key -n ^[ previous-window
bind-key -n ^] next-window


##
## Status Bar
##

# Default colors
set -g status-bg white
set -g status-fg black
 
# Left side of status bar
set -g status-left ' #(hostname | cut -f1 -d".") #[fg=blue](#S) '
 
# Inactive windows in status bar
set-window-option -g window-status-format '[#I: #W#F]'
 
# Current or active window in status bar
set-window-option -g window-status-current-format "#[bg=colour14,fg=black][#I: #W#F]"
 
# Alerted window in status bar. Windows which have an alert (bell, activity or content).
set-window-option -g window-status-alert-fg red
set-window-option -g window-status-alert-bg white
 
# Right side of status bar
set -g status-right ' #(date +"%l:%M:%S %p %e-%h-%Y") '
