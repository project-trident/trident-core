# $FreeBSD$

PORTNAME=	trident-core
PORTVERSION=	%%CHGVERSION%%
CATEGORIES=	trident

MAINTAINER=	ken@project-trident.org
COMMENT=	Core distribution files and utilities for Project Trident

LICENSE=	BSD2CLAUSE

RUN_DEPENDS=	${LOCALBASE}/sbin/PCDMd:x11/pcdm \
		${LOCALBASE}/bin/qsudo:sysutils/qsudo \
		${LOCALBASE}/bin/pc-wificonfig:sysutils/pc-networkmanager \
		${LOCALBASE}/bin/pc-mixer:audio/pc-mixer \
		${LOCALBASE}/bin/sysadm-client:sysutils/sysadm-client \
		${LOCALBASE}/bin/xdg-open:devel/xdg-utils \
		manifest>=0:os/manifest \
		ca_root_nss>=0:security/ca_root_nss \
		jq>=0:textproc/jq \
		sysup>=0:sysutils/sysup \
		cups-filters>=0:print/cups-filters \
		lumina>=0:x11/lumina \
		foomatic-db>=0:print/foomatic-db \
		fluxbox-tenr-styles-pack>=0:x11-themes/fluxbox-tenr-styles-pack \
		xorg-minimal>=0:x11/xorg-minimal \
		cuse4bsd-kmod>=0:multimedia/cuse4bsd-kmod \
		webcamd>=0:multimedia/webcamd \
		${NONEXISTENT}:graphics/drm-kmod \
		xf86-video-scfb>=0:x11-drivers/xf86-video-scfb \
		xdg-user-dirs>=0:devel/xdg-user-dirs \
		trident-icons>=0:trident/trident-icons \
		trident-updatemgr>=0:trident/trident-updatemgr \
		cursor-chameleon-pearl>=0:x11-themes/cursor-chameleon-pearl \
		xdpyinfo>=0:x11/xdpyinfo \
		xinput>=0:x11/xinput \
		sysadm>=0:sysutils/sysadm \
		alsa-sndio>=0:audio/alsa-sndio

USE_GITHUB=	yes
GH_ACCOUNT=	project-trident
GH_PROJECT=	trident-core
GH_TAGNAME=	%%GHTAG%%

NO_BUILD=	yes

do-install:
	cd ${WRKSRC} && ${WRKSRC}/install-local.sh ${STAGEDIR} core
	(cd ${STAGEDIR}/; ${FIND} . -type f \
		| ${SED} -e 's,^\./,/,g' \
		| ${AWK} '{print length, $$0}' | ${SORT} -rn \
		| cut -d " " -f 2- \
		| ${AWK} '{print $$0 }' >> ${TMPPLIST})
.include <bsd.port.mk>
