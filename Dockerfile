FROM jupyter/notebook

MAINTAINER Laurent Gautier <lgautier@gmail.com>

# Info about the distribution
RUN \
  cat /etc/lsb-release

# Add CRAN repository
RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
  echo "deb http://cran.cnr.Berkeley.edu/bin/linux/ubuntu `cat /etc/lsb-release | grep DISTRIB_CODENAME | sed 's/.*=//'`/" >> /etc/apt/sources.list


# Update the repositories, install R and packages, and install Python packages
RUN \
  apt-get update -qq && \
  apt-get install -y r-base r-base-dev && \
  rm -rf /var/lib/apt/lists/* && \
  R -e 'install.packages(c("dplyr", "hexbin", "ggplot2", "ggmap", "lme4"), \
                         noCache = TRUE, \
                         repos="http://cran.cnr.Berkeley.edu")' && \
  pip2 --no-cache-dir install numpy pandas sphinx jinja2 singledispatch && \
  pip3 --no-cache-dir install numpy pandas sphinx jinja2 && \
  rm -rf /root/.cache

COPY Pothole_Repair_Requests.csv /notebooks/
COPY notebooks/potholes.ipynb /notebooks/

# Run dev version of rpy2
RUN \
  pip2 --no-cache-dir install \
        https://bitbucket.org/rpy2/rpy2/get/default.tar.gz && \
  pip3 --no-cache-dir install \
        https://bitbucket.org/rpy2/rpy2/get/default.tar.gz
