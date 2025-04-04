#!/bin/bash

# Define installation directory
DIR=$HOME/.wrf_dependencies
mkdir -p $DIR

# Set environment variables for the installation process
export NETCDF=$DIR/netcdf
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS="-m64 -fallow-argument-mismatch"
export F77=gfortran
export FFLAGS="-m64 -fallow-argument-mismatch"
export LDFLAGS="-L$NETCDF/lib -L$DIR/grib2/lib"
export CPPFLAGS="-I$NETCDF/include -I$DIR/grib2/include -fcommon"

# Number of cores for compilation
JOBS=4

# Function to download, extract, compile, and install libraries
install_lib() {
    local url=$1
    local dir_prefix=$2
    local config_options=$3

    local tar_file=${url##*/}
    local dir_name=${tar_file%.tar.gz}

    echo "Downloading $tar_file..."
    wget $url -O $tar_file

    echo "Extracting $tar_file..."
    tar xzvf $tar_file

    cd $dir_name || exit 1

    echo "Configuring $dir_name..."
    ./configure --prefix=$dir_prefix $config_options

    echo "Compiling $dir_name..."
    make -j $JOBS

    echo "Installing $dir_name..."
    make install

    cd ..
    rm -rf $tar_file $dir_name
}

# Install libraries
install_lib "https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.11.tar.gz" "$DIR/grib2"

install_lib "https://github.com/HDFGroup/hdf5/archive/hdf5-1_10_5.tar.gz" "$DIR/netcdf" "--with-zlib=$DIR/grib2 --enable-fortran --enable-shared"

install_lib "https://github.com/Unidata/netcdf-c/archive/v4.7.2.tar.gz" "$DIR/netcdf" "--disable-dap --enable-netcdf4 --enable-hdf5 --enable-shared"

export LIBS="-lnetcdf -lz"
install_lib "https://github.com/Unidata/netcdf-fortran/archive/v4.5.2.tar.gz" "$DIR/netcdf" "--disable-hdf5 --enable-shared"

install_lib "https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz" "$DIR/mpich"

install_lib "https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz" "$DIR/grib2"

install_lib "https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz" "$DIR/grib2"

# Set permanent environment variables in .bashrc
echo "Setting up permanent environment variables..."
cat <<EOF >> ~/.bashrc

# WRF Dependencies
export NETCDF=$DIR/netcdf
export LD_LIBRARY_PATH=\$NETCDF/lib:$DIR/grib2/lib
export PATH=\$NETCDF/bin:$DIR/mpich/bin:\$PATH
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include
EOF

echo "Installation complete! Restart your terminal or run 'source ~/.bashrc' to apply the settings."

