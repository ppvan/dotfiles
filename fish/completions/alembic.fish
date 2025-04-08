set -l commands "branches check current downgrade edit ensure_version heads history init list_templates merge revision show stamp upgrade"


function __fish_alembic_needs_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

function __fish_alembic_using_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -gt 1
        if test $argv[1] = $cmd[2]
            return 0
        end
    end
    return 1
end

complete -c alembic -f

# current
complete -f -c alembic -n __fish_alembic_needs_command -a current -d 'Display the current revision for a database'

# upgrade
complete -f -c alembic -n __fish_alembic_needs_command -a upgrade -d 'Upgrade to a later version'

# downgrade
complete -f -c alembic -n __fish_alembic_needs_command -a downgrade -d 'Revert to a previous version'

# revision
complete -f -c alembic -n __fish_alembic_needs_command -a revision -d 'Create a new revision file.'
complete -f -c alembic -n '__fish_alembic_using_command revision' -s m -l message -d 'Specify a message to use for the revision.'


