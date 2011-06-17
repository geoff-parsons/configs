#!/bin/sh

NAME=$1
: ${NAME:="rails"}
RVM=`rvm current`

tmux new-session -d -s $NAME

tmux rename-window -t $NAME:1  "emacs"
tmux send-keys -t $NAME:1 "emacs" C-m

tmux new-window -dt $NAME:2 -n "spec"
tmux send-keys -t $NAME:2 "rvm use $RVM" C-m

if [[ -x `which autotest` ]]; then
  tmux send-keys -t $NAME:2 "autotest" C-m
fi

tmux new-window -dt $NAME:3 -n "server"
tmux send-keys -t $NAME:3 "rvm use $RVM" C-m
tmux send-keys -t $NAME:3 "rails server" C-m

tmux new-window -dt $NAME:4 -n "console"
tmux send-keys -t $NAME:4 "rvm use $RVM" C-m
tmux send-keys -t $NAME:4 "rails console" C-m

tmux new-window -dt $NAME:5 -n "shell"
tmux send-keys -t $NAME:5 "rvm use $RVM" C-m

tmux -2 attach-session -t $NAME