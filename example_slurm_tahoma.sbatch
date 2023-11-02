#!/bin/bash
#SBATCH -t 0:59:00
#SBATCH -N 1
#SBATCH -A XXXXXX
#SBATCH -p analysis 
#SBATCH -o alpha1.output.%j
#SBATCH -e alpha1.output.%j
#SBATCH -J a1
source /etc/profile.d/modules.sh
module purge
module load python
module load gcc
export APPTAINER_CACHEDIR=/tahoma/emsla60288/edo/scratch
org_dir=`pwd`
cd /big_scratch
if [ -d  "venv" ]; then
    echo "venv directory present"
else
    python3 -m venv venv
fi
source venv/bin/activate
export https_proxy=http://proxy.emsl.pnl.gov:3128
rm -rf alphafold
#wget -q https://github.com/deepmind/alphafold/tarball/v2.2.4 -O - | tar -xz
wget -q https://github.com/deepmind/alphafold/tarball/v2.3.0 -O - | tar -xz
ln -sf google-deepmind-alphafold-??????? alphafold
#export DOWNLOAD_DIR=/tahoma/datasets/alphafold
#needed for uniref30
export DOWNLOAD_DIR=/tahoma/datasets/alphafold-20230322/
export ALPHAFOLD_DIR=`pwd`/alphafold
mkdir -p $ALPHAFOLD_DIR
singularity pull -F --name $ALPHAFOLD_DIR/alphafold.sif   oras://ghcr.io/edoapra/alphafold_singularity/alphafold:latest
export MODFILES_DIR=$org_dir
mkdir -p /tmp/alphafold
export TMPDIR=/tmp/alphafold
python3 -m pip install --upgrade pip
python3 -m pip install absl-py spython
cp $MODFILES_DIR/* .
ls -lrt
/usr/bin/time -p python ./run_singularity.py \
  --fasta_paths=benchmark_24aas.fasta \
  --max_template_date=2022-05-14 \
--model_preset=monomer \
  --data_dir=$DOWNLOAD_DIR
cp -rp $TMPDIR $org_dir/tmp.$SLURM_JOBID
