FROM archlinux:latest

# install required packages
RUN pacman -Syu --noconfirm --needed \
    base-devel git python openssh pacman-contrib \
    && pacman -Scc --noconfirm

# add action files
COPY entrypoint.sh /entrypoint.sh
COPY build.sh /build.sh
COPY generate-pkgbuild.py /generate-pkgbuild.py
COPY ssh_config /ssh_config

RUN chmod +x /entrypoint.sh /build.sh /generate-pkgbuild.py

ENTRYPOINT ["/entrypoint.sh"]
