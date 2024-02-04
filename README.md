# ssh
```bash
ssh username@paramshakti.iitkgp.ac.in
ssh -X username@paramshakti.iitkgp.ac.in # for gui
ssh -p 4422 username@paramshakti.iitkgp.ac.in # connecting from outside iitkgp
```

# Directory Structure
- `/home/username` 
    - 40GB storage and 50GB hard limit
    - has backup
    - use it to store important files, outputs, logs, etc.
    - don't store datasets here. don't submit jobs from here.
- `/scratch/username`
    - 2TB storage
    - no backup
    - use it to store datasets, code, etc.
    - submit jobs from here
    - export job outputs to `/home/username` if needed

# Installing conda

Easy just follow the instructions [here](https://docs.conda.io/projects/miniconda/en/latest/)
```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh

~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```

# Installing linux packages
Since we require sudo to use the default package manager, yum, we will install packages to our home directory and add the binaries to our path.

- Create a directory to store the packages and downloaded .rpm files
```bash
mkdir -p ~/centos # for installed packages
mkdir -p ~/rpm  # for downloading .rpm files
``` 
- Add the following to your .bashrc or .zshrc
```bash
export PATH="$HOME/centos/usr/sbin:$HOME/centos/usr/bin:$HOME/centos/bin:$PATH"
export MANPATH="$HOME/centos/usr/share/man:$MANPATH"
L='/lib:/lib64:/usr/lib:/usr/lib64'
export LD_LIBRARY_PATH="$L:$HOME/centos/usr/lib:$HOME/centos/usr/lib64"
```
- now download .rpm using `yumdownloader --destdir ~/rpm --resolve <package_name>` and install using `rpm2cpio <package_name>.rpm | cpio -D ~/centos -idmv`
- you can use the script [install_all.sh](./install_all.sh) to install all the packages in the rpm directory
- or you can run `python3 install_rpm.py <package_name>` to install a single package. find the python script [here](./install_rpm.py)


# Modules
- Use `module avail` to see all available modules
- Use `module load <module_name>` to load a module
- Latest cuda version installed is 11.7 so don't just `pip install torch`. You'll have to compile torch with correct cuda version. Use `module load compiler/cuda/11.7` in your job script before submitting the job on gpu nodes. see: https://pytorch.org/get-started/previous-versions/

eg for cuda 11.7 :
```bash
conda install pytorch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 pytorch-cuda=11.7 -c pytorch -c nvidia
# or use pip
pip install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2
```

- Find the available modules [here](./module_avail_jan_2024.txt) (as of Jan 2024)

# Installing MuJoCo
```bash
pip3 install -U 'mujoco-py<2.2,>=2.1' numpy scipy quaternion numpy-quaternion mujoco

mkdir ~/.mujoco && cd ~/.mujoco
wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz
tar -xf mujoco210-linux-x86_64.tar.gz
rm mujoco210-linux-x86_64.tar.gz
```

- add the following to your .bashrc or .zshrc
```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco210/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia
``````
- Install any missing dependencies using the script [install_rpm.py](./install_rpm.py)

# some basic slurm commands
- `sbatch <job_script>` to submit a job
- `squeue` to see jobs
- `scancel <job_id>` to cancel a job
- `sinfo` to see nodes
- `sinfo -s` to see nodes in a table

# jupyter
1. make sure your environment has `jupyter`
2. submit an interactive bash job by running `srun -p gpu --time=<H>:<MM>:<SS> --gres=gpu:<num_gpus> --pty bash`
3. activate your environment
4. (optional) use `screen` to (detachably) multiplex the shell
5. run `hostname -i` and note down your gpu node's IP, say as `ip` (if you don't know it already)
6. run `jupyter notebook --port XXXX --no-browser`
7. copy one of the full links (after Jupyter Server `<VER>` is running at:), e.g. `http://localhost:<PORT>/tree?token=<TOKEN>`
8. many ports are blocked so note down which port `(<PORT> above)` the jupyter kernel is actually listening on
9. on your local machine, in a new shell make a tunnel by running `ssh -t -t <USER>@paramshakti.iitkgp.ac.in -L localhost:<PORT>:localhost:<PORT> ssh <USER>@<ip> -L localhost:<PORT>:localhost:<PORT>`
10. open the link you copied in step 7 in a browser on your local machine

# wandb
- GPU nodes do not have access to the internet
- Set wandb to offline mode using
```bash
    export WANDB_MODE=offline # on shell
```
```python
    os.environ["WANDB_MODE"] = "offline" # in jupyter or inside a script
    wandb.init( ...,  mode="offline")
```
# GPU node IPs
1. **gpu021** (bad dns): `172.10.0.121`
---

kinda incomplete i'll update it as i learn more :p

---
- Reference: http://www.hpc.iitkgp.ac.in/HPCF/paramShakti
