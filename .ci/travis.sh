# Make errors fatal
set -e

# Get Travis CPU speed
echo "Travis CPU clock speed:"
lscpu | grep "MHz"

# Miniconda
export PATH="$HOME/miniconda-cache/bin:$PATH"

# Check if the conda command exists, and if not,
# download and install miniconda
if ! command -v conda > /dev/null; then

    # Conda
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
    bash miniconda.sh -b -p $HOME/miniconda-cache -u;
    conda config --add channels conda-forge;
    conda config --set always_yes yes;
    conda update --all;
    conda create --yes -n test python=$PYTHON_VERSION
    source activate test
    conda install tectonic;
    conda install -c conda-forge numpy=$NUMPY_VERSION scipy matplotlib setuptools pytest pytest-cov pip;
    conda install -c conda-forge fast-histogram

fi

# Display some info
conda info -a

# Attempt to resolve issues with SSL certificate expiring for purl.org:
# https://tectonic.newton.cx/t/how-to-use-tectonic-if-you-can-t-access-purl-org/44
mkdir -p $HOME/.config/Tectonic
cat > $HOME/.config/Tectonic/config.toml << EOL
[[default_bundles]]
url = "http://purl.org/net/pkgwpub/tectonic-default"
EOL
