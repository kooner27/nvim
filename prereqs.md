# Installation Steps for Dependencies

## 1. Install `ripgrep`

`ripgrep` is a fast search tool.

```bash
sudo apt update
sudo apt install ripgrep
```

---

## 2. Install a Clipboard Tool (e.g., `xclip`)

`xclip` is a command-line clipboard utility.

```bash
sudo apt install xclip
```

Alternatively, you can install `xsel`:

```bash
sudo apt install xsel
```

---

## 3. Install Python 3 and `pip`

Python 3 and its package manager `pip` are necessary for most Python projects.

```bash
sudo apt update
sudo apt install python3 python3-pip
```

Verify installation:

```bash
python3 --version
pip3 --version
```

---

## 4. Install `python3-venv`

`python3-venv` is used to create Python virtual environments.

```bash
sudo apt install python3-venv
```

---

## 5. Install `nvm` (Node Version Manager) with LTS Node.js

### Step 1: Download and Install `nvm`

Use the following command to install `nvm`:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
```

> **Note:** Replace `v0.39.4` with the latest version from the [official repository](https://github.com/nvm-sh/nvm).

### Step 2: Activate `nvm`

Add the following lines to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

Reload your shell:

```bash
source ~/.bashrc  # Or source ~/.zshrc, depending on your shell.
```

### Step 3: Install the Latest LTS Version of Node.js

Once `nvm` is set up, install the latest Long Term Support (LTS) version of Node.js:

```bash
nvm install --lts
```

### Step 4: Verify Installation

Check the installed versions of Node.js and `npm`:

```bash
node --version
npm --version
```

---

