# vim: ft=dockerfile
<?rb
APT_INSTALL = 'apt-get install -y --no-install-recommends'
APT_UPDATE = 'apt-get update -y'
GEM_INSTALL= 'gem install --no-user-install --verbose --norc --no-document'

Pathname.new(__dir__).join('helper.rb').tap do |file|
  self.instance_eval(file.read, file.to_s, 1)
end

autoload(:Shellwords, 'shellwords');
?>

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
    #{GEM_INSTALL} bundler ;\
    # remove caches ----------------------------------------------------
    apt-get -y clean autoclean ;\
    rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /var/tmp/* ;\
    # additional clean -------------------------------------------------
    rm -rf /var/log/apt/ /var/log/alternatives.log /var/log/dpkg.log /var/log/fontconfig.log ;\
    (path=/usr/share/X11/locale/; (ls "$path" || :)| grep -Ev '^C$' | while read dir; do rm -rf "$path""$dir"; done); \
    rm -rf /usr/share/doc/ \
        /usr/share/texlive/*.html \
        /usr/share/texlive/readme-*.dir/ \
        /usr/share/texlive/texmf-dist/doc/ \
        /usr/share/texlive/README \
        /usr/share/texlive/README.* \
        /usr/share/texlive/LICENSE.*

COPY files/ /

RUN set -eux ;\
    # set access -------------------------------------------------------
    chmod 644 /etc/bash/bashrc.sh ;\
    chmod 755 /etc/ImageMagick-*/ ;\
    chmod 644 /etc/ImageMagick-*/*.xml ;\
    # banner -----------------------------------------------------------
    tlmgr --version

# Local Variables:
# mode: Dockerfile
# End:
