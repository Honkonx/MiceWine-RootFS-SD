#!/bin/bash

# --- Configuración del Paquete ---
# Versión y nombre para la compilación, optimizado para Micewine/Winlator.
PKG_VER="11-micewine-custom"
PKG_CATEGORY="Wine"
PKG_PRETTY_NAME="Wine Proton ($PKG_VER)"

# Arquitecturas a excluir.
BLACKLIST_ARCH=aarch64

# --- Fuente y Versión ---
# URL del repositorio Git. Se recomienda usar un fork actualizado como el de GloriousEggroll.
GIT_URL=https://github.com/GloriousEggroll/wine-ge-custom
# Para usar la última versión, puedes usar 'master' o un tag específico.
GIT_COMMIT=master

# --- Compilación de Herramientas (Host) ---
# Se compila una versión de Wine para el host que provee las herramientas necesarias
# para la compilación cruzada (cross-compilation) hacia Windows.
HOST_BUILD_CONFIGURE_ARGS="--enable-win64 --without-x"
HOST_BUILD_FOLDER="$INIT_DIR/workdir/$package/wine-tools"
HOST_BUILD_MAKE="make -j $(nproc) __tooldeps__ nls/all"

# --- Configuración de la Compilación Final ---
# Directorio de instalación.
OVERRIDE_PREFIX="$(realpath $PREFIX/../wine)"

# Argumentos de configuración para la compilación final de Wine.
CONFIGURE_ARGS="--enable-archs=i386,x86_64 \
                --host=$TOOLCHAIN_TRIPLE \
                --with-wine-tools=$HOST_BUILD_FOLDER \
                --prefix=$OVERRIDE_PREFIX \
                --disable-win16 \
                --disable-tests \
                --disable-winemenubuilder \
                \
                # --- Habilitar características gráficas y de audio ---
                --with-x \
                --x-libraries=$PREFIX/lib \
                --x-includes=$PREFIX/include \
                --with-pulse \
                --with-gstreamer \
                --with-opengl \
                --with-gnutls \
                \
                # --- Habilitar características para juegos (muy importante) ---
                --with-xinput \
                --with-xinput2 \
                --with-sdl # Esencial para el soporte de controles en Android
                \
                # --- Deshabilitar características no esenciales para Android/móviles ---
                --without-oss \
                --without-xshm \
                --without-xinerama # No se usan múltiples monitores
                --without-xrandr # No se necesita gestión de resolución de escritorio
                --without-xxf86vm # Extensión de video no necesaria
                --without-osmesa \
                --without-usb \
                --without-cups \
                --without-netapi \
                --without-pcap \
                --without-gphoto \
                --without-v4l2 \
                --without-pcsclite \
                --without-opencl \
                --without-dbus \
                --without-sane \
                --without-udev \
                --without-capi \
                --without-wayland # Wayland no se usa en estos entornos"

# --- Dependencias de Compilación ---
# Lista de bibliotecas necesarias y optimizadas para Micewine
DEPENDENCIES="libX11 libXext libXcomposite libXrender libXcursor libXrandr libXxf86vm libXinerama libXfixes libXi Vulkan-Headers Vulkan-Loader libglvnd pulseaudio freetype libgnutls gstreamer gst-plugins-base gst-plugins-ugly gst-plugins-good gst-plugins-bad"
