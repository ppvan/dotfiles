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

complete -f -c alembic -n __fish_alembic_needs_command -a branches -d 'Show current branch points'
complete -f -c alembic -n __fish_alembic_needs_command -a check -d 'Check if revision command with autogenerate has pending upgrade ops'
complete -f -c alembic -n __fish_alembic_needs_command -a show -d 'Show the revision(s) denoted by the given symbol'
complete -f -c alembic -n __fish_alembic_needs_command -a heads -d 'Show current available heads'
complete -f -c alembic -n __fish_alembic_needs_command -a history -d 'List changeset scripts in chronological order'
complete -f -c alembic -n __fish_alembic_needs_command -a init -d 'Initialize a script directory'
complete -f -c alembic -n __fish_alembic_needs_command -a merge -d 'Merge two revisions together. Creates a new migration file'
complete -f -c alembic -n __fish_alembic_needs_command -a current -d 'Display the current revision for a database'
complete -f -c alembic -n __fish_alembic_needs_command -a upgrade -d 'Upgrade to a later version'
complete -f -c alembic -n __fish_alembic_needs_command -a downgrade -d 'Revert to a previous version'
complete -f -c alembic -n __fish_alembic_needs_command -a revision -d 'Create a new revision file.'
complete -f -c alembic -n '__fish_alembic_using_command revision' -s m -l message -l'autogenerate'


