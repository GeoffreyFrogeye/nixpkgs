{stdenv, fetchurl, gtk2, pkgconfig, perl, perlXMLParser, libxml2, gettext
, python, libxml2Python, docbook5, docbook_xsl, libxslt, intltool, libart_lgpl
, withGNOME ? false, libgnomeui }:

stdenv.mkDerivation rec {
  name = "dia-${minVer}.3";
  minVer = "0.97";

  src = fetchurl {
    url = "mirror://gnome/sources/dia/${minVer}/${name}.tar.xz";
    sha256 = "0d3x6w0l6fwd0l8xx06y1h56xf8ss31yzia3a6xr9y28xx44x492";
  };

  buildInputs =
    [ gtk2 perlXMLParser libxml2 gettext python libxml2Python docbook5
      libxslt docbook_xsl libart_lgpl
    ] ++ stdenv.lib.optional withGNOME libgnomeui;

  nativeBuildInputs = [ pkgconfig intltool perl ];

  configureFlags = stdenv.lib.optionalString withGNOME "--enable-gnome";

  patches = [ ];

  # This file should normally require a gtk-update-icon-cache -q /usr/share/icons/hicolor command
  # It have no reasons to exist in a redistribuable package
  postInstall = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = {
    description = "Gnome Diagram drawing software";
    homepage = http://live.gnome.org/Dia;
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
