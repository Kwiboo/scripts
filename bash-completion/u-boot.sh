_scripts_u_boot()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	local SCRIPTS_PATH=$(dirname $(dirname $(readlink -f "${BASH_SOURCE[0]}")))
	local DEVICES_PATH=$SCRIPTS_PATH/devices
	COMPREPLY=( $(compgen -W "$(grep _defconfig -R $DEVICES_PATH/ -l | awk -F/ '{ print $NF }' | awk -F . '{ print $1 }')" -- $cur) )
}
complete -F _scripts_u_boot u-boot.sh
