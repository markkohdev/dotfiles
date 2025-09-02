# Mark's Dotfiles 🛠️
Welcome! This is my highly opinionated collection of dotfiles and setup scripts for making a fresh Mac or Linux system feel like home. I keep this repo public because friends and coworkers sometimes ask about my setup, and you're welcome to borrow ideas or use anything you find helpful. 😊

This setup was originally forked from [holman's dotfiles](https://github.com/holman/dotfiles) but at this point has very few remaining bits from that repo so I've started fresh.  That said, I appreciate all that Holman has inspired me in terms of striving for a seamless dev environment setup and install <3

The main things this sets up are:
- [Brew](https://brew.sh/) packages (for Mac)
- [Apt](https://apt-get.org/) packages (for Linux)
- [Oh-my-zsh](https://ohmyz.sh/) (for a better shell experience)
- Python and [uv](https://github.com/astral-sh/uv) (with a global virtual environment)
- Symlinks which set up zsh and bash in the way that I like them :)

## 🚀 Quickstart
1. **Clone this repo:**
  ```sh
  git clone https://github.com/markkohdev/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  ```
2. **Run the bootstrap script:**
  ```sh
  ./bootstrap
  ```
  This will:
  - Install Homebrew (on Mac) or apt packages (on Linux) 🍺
  - Set up oh-my-zsh (for a better shell experience) 🐚
  - Run all the module installers (fonts, python, symlinks, etc) ⚡️

3. **Restart your terminal** to pick up all the changes. 🔄

## What Does `bootstrap` Do?
The `bootstrap` script:
- Detects if you’re on a Mac or Linux (Windows is not supported)
- Installs Homebrew and everything in `brew/Brewfile` (Mac), or apt packages from `apt/apt-packages.txt` (Linux)
- Installs [oh-my-zsh](https://ohmyz.sh/) if needed, and offers to set zsh as your default shell
- Runs every `install.sh` it finds in the modules (fonts, python, symlinks, etc)
- Prints progress and info as it goes (with a few friendly emojis)

## Modules & What They Do
This repo is organized into folders, each with a specific purpose:
- **`bin/`**: Useful scripts and command-line tools. All scripts here are added to your `$PATH`.
- **`brew/`**: Homebrew packages for Mac. Edit `Brewfile` to customize. 🍺
- **`apt/`**: Apt packages for Linux. Edit `apt-packages.txt` as needed. 📦
- **`fonts/`**: Installs fonts for your terminal (e.g., Powerline support). 🖋️
- **`python/`**: Sets up a global Python virtual environment using [uv](https://github.com/astral-sh/uv), and installs tools from `requirements.txt`. 🐍
- **`symlinks/`**: Symlinks dotfiles (like `.vimrc`, `.zshrc`, etc) into your home directory. If a file exists, you can choose to overwrite, backup, or skip.
- **`sublime/`**: Settings for Sublime Text.
- **`iterm/`**: iTerm2 profiles and settings for Mac.

## Customization
Add your own scripts or configs by dropping them in the appropriate folder. To add a new module, create a new folder with an `install.sh`—it will be picked up automatically.

## Notable Scripts in `bin/`
- `banana`, `pizza`: Fun little scripts. Not essential, but entertaining. 🍌🍕
- `git-wtf`: Shows you what's going on in your git repo.
- `nap`: Take a break. Your computer will wait. 😴
- `emojify`: Adds emoji to your output. 😃
- `search`, `remove-quotes`, `docker-cleanup`, `download-song`, `what`, `subl`, `sublime`, `newvenv`: Other utilities—explore as needed.

## FAQ
**Q: Is this safe to run?**
A: It’s as safe as running a bunch of scripts you found on the internet can be. Read the code if you’re worried!

**Q: Can I use this on Windows?**
A: Not unless you like pain.

**Q: Why so many emojis?**
A: Why not?

**Q: Why is this public?**
A: Mostly for my own use, but I keep it public in case friends, coworkers, or anyone else is curious or wants to borrow ideas.

## License
MIT. Fork, modify, and enjoy.