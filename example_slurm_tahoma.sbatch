#!/bin/bash
#SBATCH -t 0:59:00
#SBATCH -N 1
#SBATCH -A msccons
#SBATCH -p analysis 
#SBATCH -o alpha1.output.%j
#SBATCH -e alpha1.output.%j
#SBATCH -J a1
source /etc/profile.d/modules.sh
module load python
org_dir=`pwd`
cd /big_scratch
if [ -d  "venv" ]; then
    echo "venv directory present"
else
    python -m venv venv
fi
source venv/bin/activate
export https_proxy=http://proxy.emsl.pnl.gov:3128
rm -rf alphafold
wget -q https://github.com/deepmind/alphafold/tarball/main -O - | tar -xz
ln -sf deepmind-alphafold-??????? alphafold
export DOWNLOAD_DIR=/tahoma/datasets/alphafold
#export DOWNLOAD_DIR=/tahoma/edo/alphafold_dir
export ALPHAFOLD_DIR=`pwd`/alphafold
singularity pull -F --name $ALPHAFOLD_DIR/alphafold.sif   oras://ghcr.io/edoapra/alphafold_singularity/alphafold:latest
ls -lrt $ALPHAFOLD_DIR/alphafold.sif
export MODFILES_DIR=$org_dir
mkdir -p /tmp/alphafold
export TMPDIR=/tmp/alphafold
python -m pip install --upgrade pip
python -m pip install absl-py spython
cp $MODFILES_DIR/* .
ls -lrt
/usr/bin/time -p python ./run_singularity.py \
  --fasta_paths=benchmark_24aas.fasta \
  --max_template_date=2022-05-14 \
--model_preset=monomer \
  --data_dir=$DOWNLOAD_DIR
cp -rp $TMPDIR $org_dir/tmp.$SLURM_JOBID
