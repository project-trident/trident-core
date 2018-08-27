# $FreeBSD$

PORTNAME=	trident-core
PORTVERSION=	%%CHGVERSION%%
CATEGORIES=	trident

MAINTAINER=	jt@ixsystems.com
COMMENT=	Core distribution files and utilities for Project Trident

LICENSE=	BSD2CLAUSE

RUN_DEPENDS=	${LOCALBASE}/sbin/PCDMd:x11/pcdm \
		${LOCALBASE}/bin/qsudo:sysutils/qsudo \
		${LOCALBASE}/bin/pc-wificonfig:sysutils/pc-networkmanager \
		${LOCALBASE}/bin/pc-mixer:audio/pc-mixer \
		${LOCALBASE}/bin/sysadm-client:sysutils/sysadm-client \
		${LOCALBASE}/bin/personacrypt:sysutils/personacrypt \
		${LOCALBASE}/bin/xdg-open:devel/xdg-utils \
		cups-filters>=0:print/cups-filters \
		lumina>=0:x11/lumina \
		foomatic-db>=0:print/foomatic-db \
		fluxbox-tenr-styles-pack>=0:x11-themes/fluxbox-tenr-styles-pack \
		xorg-minimal>=0:x11/xorg-minimal \
		cuse4bsd-kmod>=0:multimedia/cuse4bsd-kmod \
		webcamd>=0:multimedia/webcamd \
		/boot/modules/drm.ko:graphics/drm-next-kmod \
		xdg-user-dirs>=0:devel/xdg-user-dirs \
		trident-icons>=0:trident/trident-icons \
		cursor-chameleon-pearl>=0:x11-themes/cursor-chameleon-pearl \
		xdpyinfo>=0:x11/xdpyinfo \
		sysadm>=0:sysutils/sysadm \
		alsa-sndio>=0:audio/alsa-sndio \
		pulseaudio-module-sndio>=0:audio/pulseaudio-module-sndio

USE_GITHUB=	yes
GH_ACCOUNT=	project-trident
GH_PROJECT=	trident-core
GH_TAGNAME=	%%GHTAG%%

NO_BUILD=	yes

do-install:
	cd ${WRKSRC} && ${WRKSRC}/install-local.sh ${STAGEDIR} core

.include <bsd.port.mk>
