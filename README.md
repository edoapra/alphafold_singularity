# alphafold_singularity
Singularity recipe for AlphaFold, with example Slurm job script.

This splits off my pull request https://github.com/deepmind/alphafold/pull/166

## Installation Instructions
Check out this repo into the top of the alphafold source tree to a directory called `singularity`:
```
$ cd alphafold-v2.x.x
$ git clone https://github.com/prehensilecode/alphafold_singularity singularity

```

To use, first install the Python requirements:
```
$ pip install -r singularity/requirements.txt
```

Then, build the Singularity image:
```
sudo singularity build alphafold.sif singularity/Singularity.def
```

If your `/tmp` directory is small, you may need to set the [`SINGULARITY_TMPDIR`
environment variable](https://sylabs.io/guides/3.3/user-guide/build_env.html#temporary-folders) to a directory on a filesystem with more free space.

To run, modify the `$ALPHAFOLD_SRC/singularity/run_singularity.py` and change the 
section marked `USER CONFIGURATION`. At the least, you will need to modify the values
of:
- `DOWNLOAD_DIR` - location where AlphaFold databases are downloaded
- `singularity_image` - absolute path to the `alphafold.sif` Singularity image
