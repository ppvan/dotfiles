from pathlib import Path
from functools import wraps
import dnf
from typing import TextIO

def echo(func):
    @wraps(func)  # This preserves func's metadata
    def wrapper(*args, **kwargs):
        print(f"Begin {func.__name__}")
        result = func(*args, **kwargs)
        print(f"Done {func.__name__}")
        print()
        return result

    return wrapper


@echo
def setup_shell(dotfile_dir: str | Path):
    files = [".bashrc", ".bash_profile", ".bash_prompt", ".bash_alias"]

    for config_file in files:
        file_path = Path(dotfile_dir) / config_file
        dot_file = Path.home() / config_file

        print(f"Link {dot_file} -> {file_path}")
        dot_file.unlink(missing_ok=True)
        dot_file.symlink_to(file_path)

    print("Link fish shell config dir")
    link = Path.home().joinpath(".config", "fish")
    fish_config_dir = dotfile_dir.joinpath(".config", "fish").resolve()

    link.unlink()
    link.symlink_to(fish_config_dir)
    print(f"Link {link} -> {fish_config_dir}")

@echo
def setup_desktopfiles(dotfile_dir: str | Path):
    dotfile_desktop_files = dotfile_dir.joinpath(
        ".local", "share", "applications"
    ).glob("*.desktop")
    system_desktop_dir = Path.home().joinpath(".local", "share", "applications")

    for file in dotfile_desktop_files:
        link_path = system_desktop_dir.joinpath(file.name)
        link_path.unlink(missing_ok=True)
        link_path.symlink_to(file)

        print(f"Link {link_path} -> {file}")

def install_native_packages():
    pass

def backup_user_packages(desk: TextIO):
    with dnf.Base() as base:
        base.read_all_repos()
        base.fill_sack()
        q = base.sack.query()
        packages = q.installed()
        for p in packages:
            if base.history.user_installed(p):
                print(p.name, file=desk)

    pass


def backup_every_packages(desk: TextIO):
    with dnf.Base() as base:
        base.read_all_repos()
        base.fill_sack()
        q = base.sack.query()
        packages = q.installed()
        for p in packages:
            print(p.name, file=desk)

# print(os.getenv("HOME"))

if __name__ == '__main__':
    dotfile_dir = Path.cwd()
    # setup_shell(dotfile_dir)
    # setup_desktopfiles(dotfile_dir)

    with open(dotfile_dir / "packages.txt", "w") as des:
        backup_user_packages(des)

    with open(dotfile_dir / "packages-full.txt", "w") as des:
        backup_every_packages(des)

