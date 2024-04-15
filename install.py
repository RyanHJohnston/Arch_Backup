import subprocess
import os

###
# this installation script still needs work!
### 

def run_command(command, check_install=False, package_name=None):
    """ Helper function to run a command and optionally check if a package was installed """
    try:
        subprocess.run(command, check=True, shell=True)
        if check_install:
            installed = subprocess.run(f"pacman -Qq | grep -Fxq {package_name}", shell=True)
            if installed.returncode != 0:
                print(f"ERROR: {package_name} failed to install.")
    except subprocess.CalledProcessError:
        if package_name:
            print(f"ERROR: {package_name} failed to install.")
        else:
            print("ERROR: Command failed.")
        raise

prereq_pkgs = ["neovim", "vim", "git", "htop", "net-tools", "openssh"]
for pkg in prereq_pkgs:
    run_command(f"sudo pacman -S {pkg} --noconfirm", check_install=True, package_name=pkg)

run_command("git clone https://aur.archlinux.org/yay.git")

if not any('yay' in entry for entry in os.listdir('.')):
    print("ERROR: Failed to clone yay repository.")
    exit(1)

yay_dir = os.path.abspath("yay")
os.chdir(yay_dir)
run_command("makepkg -sfi --noconfirm")
print("\n\nDone building yay\n\n")

# Check if yay is properly installed
run_command("pacman -Qq | grep -Fxq yay", check_install=True, package_name="yay")

def install_packages_from_file(file_path, installer="sudo pacman -S"):
    with open(file_path) as f:
        packages = f.read().strip().split()
    for pkg in packages:
        print(f"\n\nInstalling {pkg}...")
        run_command(f"{installer} {pkg} --noconfirm")

# Assuming PACMAN_PKGS and AUR_PKGS are defined environment variables or file paths
try:
    install_packages_from_file(os.getenv("PACMAN_PKGS"))
    install_packages_from_file(os.getenv("AUR_PKGS"), installer="yay -S")
except Exception as e:
    print(str(e))
