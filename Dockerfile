FROM jupyterhub/jupyterhub

MAINTAINER Christian Hotz-Behofsits <christian.hotz-behofsits@wu.ac.at>

# TODO: add openjdk-8-jdk-headless, cleanup

# install jupyter
RUN pip install jupyter

# install R
RUN echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list && \
    echo "deb http://ftp.de.debian.org/debian jessie-backports main" >> /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install --allow-unauthenticated r-base r-base-dev libssl-dev libopenblas-base libcurl4-openssl-dev && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
    apt-get clean

# install R plugins
COPY installRKernel.R /tmp/
RUN Rscript /tmp/installRKernel.R

# install julia
RUN apt-get -y install libblas3gf liblapack3gf libarpack2 libfftw3-dev libgmp3-dev libmpfr-dev libblas-dev liblapack-dev gcc-4.8 g++-4.8 gfortran libgfortran3 m4 libedit-dev

# download & extract cmake
WORKDIR /tmp
RUN wget https://cmake.org/files/v3.7/cmake-3.7.0.tar.gz && \
    tar -xzvf cmake-3.7.0.tar.gz  && \
    rm -f cmake-3.7.0.tar.gz

# compile & install cmake
WORKDIR /tmp/cmake-3.7.0
RUN ./bootstrap && \
    make -j 4 && \
    make install && \
    rm -rf /tmp/cmake-3.7.0

# download & extract julia
WORKDIR /tmp
RUN wget https://github.com/JuliaLang/julia/releases/download/v0.6.0/julia-0.6.0-full.tar.gz && \
    tar -xzvf julia-0.6.0-full.tar.gz

# compile and install julia
WORKDIR /tmp/julia-0.6.0
RUN make -j 4 && \
    make install

WORKDIR /srv/jupyterhub/
EXPOSE 8000

CMD ["jupyterhub"]
