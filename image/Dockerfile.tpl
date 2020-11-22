# vim: ft=dockerfile
<?rb
APT_INSTALL = 'apt-get install -y --no-install-recommends'
APT_UPDATE = 'apt-get update -y'

Pathname.new(__dir__).join('helper.rb').tap do |file|
  self.instance_eval(file.read, file.to_s, 1)
end

autoload(:Shellwords, 'shellwords');
?>

# build ImageMagick ----------------------------------------------------
FROM #{@from} AS magick
<?rb
config = {
  workdir: '/tmp',
  version: '7.0.10-38',
  archive: 'ImageMagick.tar.xz',
  destdir: '/build',
  baseurl: 'https://www.imagemagick.org/download/releases',
}
?>
WORKDIR #{config.fetch(:workdir)}
ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux ;\
    # minimal packages -------------------------------------------------
    #{APT_UPDATE} ;\
    #{APT_INSTALL} wget tar xz-utils ;\
    # download archive -------------------------------------------------
    wget '#{config.fetch(:baseurl)}/ImageMagick-#{config.fetch(:version)}.tar.xz' \
         --no-check-certificate \
         -nv --show-progress --progress=bar:force:noscroll \
         -O '#{config.fetch(:archive)}' ;\
    tar xJfv '#{config.fetch(:archive)}' ;\
    rm -f '#{config.fetch(:archive)}' ;\
    # build packages ---------------------------------------------------
    #{APT_INSTALL} build-essential \
                   libltdl-dev \
                   libperl-dev \
                   libxml2-dev \
                   librsvg2-dev \
                   libgs-dev ;\
    # build ------------------------------------------------------------
    ( \
      set -eux ;\
      cd ImageMagick-7* ;\
      ./configure --prefix=/usr     \
                  --sysconfdir=/etc \
                  --enable-hdri     \
                  --with-modules    \
                  --with-perl       \
                  --with-rsvg       \
                  --with-gslib      \
                  --disable-static ;\
      make DESTDIR=#{config.fetch(:destdir)} -j $(nproc) install ;\
    );
<?rb config = nil ?>

# concrete image -------------------------------------------------------
FROM #{@from}

LABEL maintainer=#{quote('%s <%s>' % [@maintainer, @email])} \
      org.label-schema.name=#{quote(@image.name)} \
      org.label-schema.version=#{quote(@image.version)} \
      org.label-schema.url=#{quote(@homepage)}

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    DOCKER_BUILD=1

RUN set -eux ;\
    # packages ---------------------------------------------------------
    #{APT_UPDATE} ;\
    #{APT_INSTALL} #{Shellwords.join(packages)} ;\
    # remove useless ImageMagick config --------------------------------
    rm -rf /etc/ImageMagick-* ;\
    # remove caches ----------------------------------------------------
    apt-get -y clean autoclean ;\
    rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /var/tmp/*

COPY --from=magick /build /
COPY files/ /

RUN set -eux ;\
    # set access -------------------------------------------------------
    chmod 644 /etc/bash/bashrc.sh ;\
    chmod 755 /etc/ImageMagick-*/ ;\
    chmod 644 /etc/ImageMagick-*/*.xml

# Local Variables:
# mode: Dockerfile
# End:
