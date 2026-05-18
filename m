Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A651FF7C7
	for <patches@lists.linux.dev>; Mon, 18 May 2026 01:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779066691; cv=none; b=jxfgCzwxTLrPUFU1wM9I3cag1FTBOui3FZVxc0hI+5p2TVL1wePaXEPb2XBbyQhMMwMAMkfAMpF5idfTpmkSrx2AEF2hWu8ShixcINqY6sIhPwEfMAs4l6h9FoP9meZUv2Lymmf6TslP8gOjVginv4vWCI3o1pYEpzwwHxknn94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779066691; c=relaxed/simple;
	bh=dMtxYkZHn8GKWvVhqVnIcG3LGAuKUwbzhLwypqsO4w4=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:MIME-Version:
	 Content-Type; b=tKEL4uYgwP7VoxcyxWreCzK843rMzfV0ckH2jCra0MksmpBFjR7ZJVHiaLCzZuF49RM9WL3MRRECl727YTTxWIZBn67yW+GnsJbgxBRnx6qL+p/UbJ0qx7WZQwa+OFV9Xcx5pUe7Rt9r3mIX6bfpVs31GnpwNGUh+Md+vyWLyAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from mop.sam.mop (1.5.5.2.4.d.e.f.f.f.5.f.9.d.6.0.a.5.c.d.c.d.9.1.0.b.8.0.1.0.0.2.ip6.arpa [IPv6:2001:8b0:19dc:dc5a:6d9:f5ff:fed4:2551])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sam)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 894E8342900;
	Mon, 18 May 2026 01:11:27 +0000 (UTC)
From: Sam James <sam@gentoo.org>
To: gregkh@linuxfoundation.org
Cc: ardb@kernel.org,herbert@gondor.apana.org.au,patches@lists.linux.dev,sashal@kernel.org,stable@vger.kernel.org,dist-kernel@gentoo.org,kernel@gentoo.org
Subject: Re: [PATCH 6.6 404/474] crypto: nx - Migrate to scomp API
In-Reply-To: <20260515154723.792269058@linuxfoundation.org>
Organization: Gentoo
User-Agent: mu4e 1.14.1; emacs 31.0.60
Date: Mon, 18 May 2026 02:11:23 +0100
Message-ID: <87y0hha5dw.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This fails to build. I think it's this patch. I did try figure out why
but I couldn't spot it when comparing branches (and all other branches
are fine).

# CC [M]  drivers/net/ethernet/mellanox/mlx5/core/en/rqt.o
  powerpc64le-unknown-linux-gnu-gcc -Wp,-MMD,drivers/net/ethernet/mellanox/=
mlx5/core/en/.rqt.o.d -nostdinc -I/var/tmp/portage/sys-kernel/gentoo-kernel=
-6.6.140/work/linux-6.6/arch/powerpc/include -I./arch/powerpc/include/gener=
ated -I/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/inc=
lude -I./include -I/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/l=
inux-6.6/arch/powerpc/include/uapi -I./arch/powerpc/include/generated/uapi =
-I/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/include/=
uapi -I./include/generated/uapi -include /var/tmp/portage/sys-kernel/gentoo=
-kernel-6.6.140/work/linux-6.6/include/linux/compiler-version.h -include /v=
ar/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/include/linu=
x/kconfig.h -include /var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work=
/linux-6.6/include/linux/compiler_types.h -D__KERNEL__ -DCC_USING_PATCHABLE=
_FUNCTION_ENTRY -I /var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/l=
inux-6.6/arch/powerpc -DHAVE_AS_ATHIGH=3D1 -fmacro-prefix-map=3D/var/tmp/po=
rtage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/=3D -std=3Dgnu11 -fsh=
ort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -mlittl=
e-endian -m64 -msoft-float -mtraceback=3Dno -mabi=3Delfv2 -mcmodel=3Dmedium=
 -mno-pointers-to-nested-functions -mlong-double-128 -mcpu=3Dpower8 -mno-pr=
efixed -mno-pcrel -mno-altivec -mno-vsx -mno-mma -fno-asynchronous-unwind-t=
ables -mno-string -Wa,-maltivec -Wa,-mpower4 -Wa,-many -mno-strict-align -m=
little-endian -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-rac=
es -fstack-protector-strong -ftrivial-auto-var-init=3Dzero -fno-stack-clash=
-protection -fpatchable-function-entry=3D2 -fstrict-flex-arrays=3D3 -fno-st=
rict-overflow -fno-stack-check -fconserve-stack -fno-builtin-wcslen -Wall -=
Wundef -Werror=3Dimplicit-function-declaration -Werror=3Dimplicit-int -Werr=
or=3Dreturn-type -Werror=3Dstrict-prototypes -Wno-format-security -Wno-trig=
raphs -Wno-frame-address -Wno-address-of-packed-member -Wframe-larger-than=
=3D2048 -Wno-main -Wno-unused-but-set-variable -Wno-unused-const-variable -=
Wno-dangling-pointer -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-arra=
y-bounds -Wno-alloc-size-larger-than -Wimplicit-fallthrough=3D5 -Werror=3Dd=
ate-time -Werror=3Dincompatible-pointer-types -Werror=3Ddesignated-init -We=
num-conversion -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno=
-restrict -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncati=
on -Wno-stringop-overflow -Wno-stringop-truncation -Wno-missing-field-initi=
alizers -Wno-type-limits -Wno-shift-negative-value -Wno-maybe-uninitialized=
 -Wno-sign-compare -mstack-protector-guard=3Dtls -mstack-protector-guard-re=
g=3Dr13 -mstack-protector-guard-offset=3D3192 -Idrivers/net/ethernet/mellan=
ox/mlx5/core -I /var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linu=
x-6.6/drivers/net/ethernet/mellanox/mlx5/core -I ./drivers/net/ethernet/mel=
lanox/mlx5/core  -DMODULE -mno-save-toc-indirect -mcmodel=3Dlarge  -DKBUILD=
_BASENAME=3D'"rqt"' -DKBUILD_MODNAME=3D'"mlx5_core"' -D__KBUILD_MODNAME=3Dk=
mod_mlx5_core -c -o drivers/net/ethernet/mellanox/mlx5/core/en/rqt.o /var/t=
mp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/drivers/net/ethe=
rnet/mellanox/mlx5/core/en/rqt.c=20=20
/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/drivers/cr=
ypto/nx/nx-common-pseries.c:1023:35: error: initialization of =E2=80=98void=
 * (*)(struct crypto_scomp *)=E2=80=99 from incompatible pointer type =E2=
=80=98void * (*)(void)=E2=80=99 [-Wincompatible-pointer-types]
 1023 |         .alloc_ctx              =3D nx842_pseries_crypto_alloc_ctx,
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/drivers/cr=
ypto/nx/nx-common-pseries.c:1023:35: note: (near initialization for =E2=80=
=98nx842_pseries_alg.alloc_ctx=E2=80=99)
/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/drivers/cr=
ypto/nx/nx-common-pseries.c:1012:14: note: =E2=80=98nx842_pseries_crypto_al=
loc_ctx=E2=80=99 declared here
 1012 | static void *nx842_pseries_crypto_alloc_ctx(void)
      |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/drivers/cr=
ypto/nx/nx-common-pseries.c:1024:35: error: initialization of =E2=80=98void=
 (*)(struct crypto_scomp *, void *)=E2=80=99 from incompatible pointer type=
 =E2=80=98void (*)(void *)=E2=80=99 [-Wincompatible-pointer-types]
 1024 |         .free_ctx               =3D nx842_crypto_free_ctx,
      |                                   ^~~~~~~~~~~~~~~~~~~~~
/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/drivers/cr=
ypto/nx/nx-common-pseries.c:1024:35: note: (near initialization for =E2=80=
=98nx842_pseries_alg.free_ctx=E2=80=99)
In file included from /var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/wor=
k/linux-6.6/drivers/crypto/nx/nx-common-pseries.c:16:
/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-6.6/drivers/cr=
ypto/nx/nx-842.h:184:6: note: =E2=80=98nx842_crypto_free_ctx=E2=80=99 decla=
red here
  184 | void nx842_crypto_free_ctx(void *ctx);
      |      ^~~~~~~~~~~~~~~~~~~~~
make[6]: *** [/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-=
6.6/scripts/Makefile.build:243: drivers/crypto/nx/nx-common-pseries.o] Erro=
r 1
make[5]: *** [/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-=
6.6/scripts/Makefile.build:480: drivers/crypto/nx] Error 2
make[4]: *** [/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.140/work/linux-=
6.6/scripts/Makefile.build:480: drivers/crypto] Error 2
make[4]: *** Waiting for unfinished jobs....

sam

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEBBAEWCgCpFiEEJaa7iN2bdkxrVUHCc4QJ9SDfkZAFAmoKZzsbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25z
Lm9wZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQyNUE2QkI4OEREOUI3NjRDNkI1NTQx
QzI3Mzg0MDlGNTIwREY5MTkwDxxzYW1AZ2VudG9vLm9yZwAKCRBzhAn1IN+RkGUx
AP9wBsZTaPtDMyYyGuiOYTFUuwOGX8zj5OlrzUuVB2rVPQD/fy4TZYWfWMuEdgwK
KZ6p1Js7qmys+WCHpkaQt44oiAo=
=tDGM
-----END PGP SIGNATURE-----
--=-=-=--
