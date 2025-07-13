# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi
#
#

AF_BDF=08:00.0

ips='s114 s116'
run_cmd_no_master(){
	local command=$*
	if [[ $* == "" ]]; then
		echo "$1 pls give cmd"
	else
		for ip in $ips; do
			echo -e  "\n\033[32m`date +'%Y/%m/%d %H:%M:%S'` $ip $*\033[0m"
		        if [[ $ip == 's114' ]];then
			        echo -e  "skip master(s114)"
			else
				ssh $ip "${command}"
		        fi
		done
	fi
}

function run_cmd(){
	local command=$*
	if [[ $* == "" ]]; then
	  echo "$1 pls give cmd"
	else
		for ip in $ips; do
			echo -e  "\n\033[32m`date +'%Y/%m/%d %H:%M:%S'` $ip $*\033[0m"
      if [[ $ip == 's114' ]];then
        eval ${command}
			else
			  ssh $ip "${command}"
      fi
		done
	fi
}


export PATH=$PATH:/usr/local/cuda/bin:/root/project/net/ucx/install-debug/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
export CUDAHOME=$CUDA_HOME:/usr/local/cuda

perftest_root(){
	cd /root/project/rdma/perftest
}

ai_env(){
	run_cmd "lspci |grep -i 'mellanox'"
	run_cmd "ifconfig"
}

run_nccl_with_rdma(){
	run_cmd "/root/project/ai/nccl-tests/run_with_rdma.sh"
}

xilinx(){
	lspci |grep -i xilinx
}

dm(){
	dmesg -wT
}

nvidia_topo(){
	run_cmd "nvidia-smi"
}

nccl_build(){
    cd /root/project/ai/nccl-tests/nccl/
    ./build.sh
    cd -
}

nccl_test_build(){
    nccl_build
    cd /root/project/ai/nccl-tests/
    ./build.sh
    cd -
}
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/root/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/root/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/root/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/root/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<


fpga_version() {
/bin/expect <<EOF
set timeout -1
spawn /root/project/debug/pci_debug/dpu-debugutils/pcie_debug-master/bin/pci_debug -s $AF_BDF
expect {
    "PCI>" { send "d 200014 100\r" }
}
sleep 1
interact
EOF
}


fpga_enable_rto() {
/bin/expect <<EOF
set timeout -1
spawn /root/project/debug/pci_debug/dpu-debugutils/pcie_debug-master/bin/pci_debug -s $AF_BDF
expect {
    "PCI>" { send "d 0x2a00D8 4\r" }
}
expect {
    "PCI>" { send "c 0x2a00D8 1\r" }
}
sleep 1
interact
EOF
}


load_driver(){
        cd /root/project/rdma/dpu_kernel_rdma
        ./load_driver.sh
        cd -

        # cd /root/big/big/ofed/infiniband/core/
        # ls|while read file;do echo $file;insmod $file;done
        # cd -
}

remove_eth_and_rdma_module(){
	rmmod xt_rdma
	rmmod dpu_snd1
}


git_update(){
	git stash
	git pull
	git stash pop
}


shutdown_s114_and_s116(){
        ssh root@s116 "shutdown -h now"
        shutdown -h now
}

git_push_current_branch(){
	git push origin HEAD
}


show_register_rdma(){
	cd /root/project/debug/dpu-debugutils/
	./reg_display/bin/reg_display -s $AF_BDF -m rdmadebug
	cd -
}

# apt install libncurses5 nfs-common -y
update_fpga(){
	mkdir -p /opt/localnet/EDA1
	mount -t nfs 10.20.10.83:/opt/localnet/EDA1 /opt/localnet/EDA1
	source /opt/localnet/EDA1/xilinx/Vivado/2023.2/settings64.sh
	vivado
}

fpga_count(){
	echo -e "\n============ FPGA COUNTER ============"
	/root/project/debug/dpu-debugutils/reg_display/bin/reg_display -s $AF_BDF -m rdmadebug
}


pci_dbg_clean_count() {
# apt-get install expect -y
/bin/expect <<EOF
set timeout -1
spawn /root/project/debug/pci_debug/dpu-debugutils/pcie_debug-master/bin/pci_debug -s $AF_BDF
expect {
    "PCI>" { send "c 1000018 1\r" }
}
expect {
    "PCI>" { send "c 380084 1\r" }
}
expect {
    "PCI>" { send "d 380084 100\r" }
}
sleep 1
interact
EOF
fpga_count
}

fpga_default_config() {
/bin/expect <<EOF
set timeout -1
spawn /root/project/debug/pci_debug/dpu-debugutils/pcie_debug-master/bin/pci_debug -s $AF_BDF
# wait_ack_fetch:0x0c, retry_fetch:0x08
expect {
    "PCI>" { send "c 220118 0c08\r" }
}
# fetch_mode:0, dbpro_cc_en, add_num:2
expect {
    "PCI>" { send "c 220304 40000002\r" }
}
# fpath_en: 1
expect {
    "PCI>" { send "c 220738 1\r" }
}
# db shap
expect {
    "PCI>" { send "c 22071c 0\r" }
}
# sq pkt ost
expect {
    "PCI>" { send "c 220724 01f001b0\r" }
}
# eirq pkt
expect {
    "PCI>" { send "c 220728 03f003b0\r" }
}
# pkt ost
expect {
    "PCI>" { send "c 22072c 0\r" }
}
# db ost
expect {
    "PCI>" { send "c 220770 60\r" }
}
# db ost
expect {
    "PCI>" { send "c 220774 1\r" }
}
# bg
expect {
    "PCI>" { send "c 220734 1\r" }
}
# dsch fwqe
expect {
    "PCI>" { send "c b00130 5102\r" }
}
# quanta
expect {
    "PCI>" { send "c b00144 4000\r" }
}
# host0 db shap
expect {
    "PCI>" { send "c b00150 0\r" }
}
sleep 1
interact
EOF
}

pci_debug(){
	/root/project/debug/pci_debug/dpu-debugutils/pcie_debug-master/bin/pci_debug -s $AF_BDF
}


ib_dev() {
    export LD_LIBRARY_PATH=/root/project/rdma/dpu_user_rdma/build/lib
    export HUGE_PAGE_NUM=100
    export XT_CQ_INLINE_CQE=0
    ibv_devices
    ibv_devinfo
}

run_nccl_tests(){
    cd /root/project/ai/nccl-tests
    ./run_nccl_tests_on_13p_u24_k61x.sh
}

nvidia_gpu(){
	lspci|grep -i nvidia
}

copy_abi(){
	cd /root/project/rdma/dpu_user_rdma/
	cp kernel-headers/rdma/xtrdma-abi.h /lib/modules/`uname -r`/build/include/uapi/rdma/xtrdma-abi.h
	cp kernel-headers/rdma/ib_user_ioctl_verbs.h /lib/modules/`uname -r`/build/include/uapi/rdma/ib_user_ioctl_verbs.h
}

show_ecode(){
	show_register_rdma |grep -i ecode -C15
}
