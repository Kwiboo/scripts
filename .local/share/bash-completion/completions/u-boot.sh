_scripts_u_boot()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(grep _defconfig -R ~/devices/ -l | awk -F/ '{ print $NF }' | awk -F . '{ print $1 }')" -- $cur) )
}
complete -F _scripts_u_boot ./u-boot.sh
