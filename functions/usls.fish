function usls --description 'list systemd user-slice cgroups'
    cgls '/user.slice/user-'(id -u)".slice/$argv"
end
