Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DAA3AA1B9
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780784; cv=none; b=HeCtNC09z9CbahNU13dO/5d1CaI6xjDGr/pWHnRukc2C62FyYA3T6BwxBhmN5c9MEhomDf2KXMoI8iC39Tm9+VObWWuBKcRUNX/Ss4+8mbKFX2kSrU+S+QmrCuNT1yGztPOYo2Z04dz1rOjzm38KS5Ih0YKOgUxsug2so+O8XEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780784; c=relaxed/simple;
	bh=FIFbqvMB7ef1KEgrb9JAMcMLZXdvb9ba5w8PnnDmQSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nklaT81UG+WJB8NliTIaE2qRXQNPi9vU0Ey+MWfuAO4r6NnjI5WbQXe6E5x0jFPP4kwDL6ABvTiUbyiUPM5j3eiIo0mrWcp9tBz6hM5ZP8QunQr59mZPaBLnvtsewShPrDF0JkRF4ybjoE2E5/EDt1sTIGVjSHntR6Af54bm7Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=gBsPK19W; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="gBsPK19W"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 61389103ABB61;
	Wed,  3 Dec 2025 17:52:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1764780778; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=bup90Alh7SdqXckKvIL+2t0OH+vX20/yZvBw1FTUgbE=;
	b=gBsPK19WdKuDhjJ0rsjMmq8/jVyBSr7CZUxxqAZGOQqd11r05gmN74zd3uRi914BIAXjch
	FQyMScHEdUM1twCbQ2yaMekGHf0i7+gP+pOmBahvLQeOB4RTquIG0Y2LQg1KnY0A0hWbHK
	or8ui06so1BAKBiCbnky0v6H0DS35IWWRQdPJT+CKGhB30B5IzGPVqYUDGiZ/x+v1izK7Q
	6Pvg4kQ3pSp34OmcU9M2OnDF+c7hZmvASzmkDIhOu0jAUk85M3L66Ti6FtnFy/jPQK2NSM
	OS8jzIQ2tjJJ0/uEB+zK67NhOPXC37DKix7JskhG3m7ESDKf3/mXkQK6su+G5Q==
Date: Wed, 3 Dec 2025 17:52:51 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
Message-ID: <aTBq47Q45543E6j2@duo.ucw.cz>
References: <20251203152440.645416925@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I81sU3lDOpubUmQf"
Content-Disposition: inline
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--I81sU3lDOpubUmQf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.159 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We have similar situation to 5.10 here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/123097=
17631

drivers/soc/tegra/fuse/fuse-tegra30.c:250:10: error: 'const struct tegra_fu=
se_soc' has no member named 'cells'
2898
  250 |         .cells =3D tegra114_fuse_cells,
2899
      |          ^~~~~
2900
drivers/soc/tegra/fuse/fuse-tegra30.c:250:18: error: initialization of 'con=
st struct attribute_group *' from incompatible pointer type 'const struct n=
vmem_cell_info *' [-Werror=3Dincompatible-pointer-types]
2901
  250 |         .cells =3D tegra114_fuse_cells,
2902
      |                  ^~~~~~~~~~~~~~~~~~~
2903
drivers/soc/tegra/fuse/fuse-tegra30.c:250:18: note: (near initialization fo=
r 'tegra114_fuse_soc.soc_attr_group')
2904
drivers/soc/tegra/fuse/fuse-tegra30.c:251:10: error: 'const struct tegra_fu=
se_soc' has no member named 'num_cells'
2905
  251 |         .num_cells =3D ARRAY_SIZE(tegra114_fuse_cells),
2906
      |          ^~~~~~~~~
2907
cc1: some warnings being treated as errors
2908
make[5]: *** [scripts/Makefile.build:250: drivers/soc/tegra/fuse/fuse-tegra=
30.o] Error 1
2909
make[4]: *** [scripts/Makefile.build:503: drivers/soc/tegra/fuse] Error 2
2910
make[3]: *** [scripts/Makefile.build:503: drivers/soc/tegra] Error 2
2911
make[2]: *** [scripts/Makefile.build:503: drivers/soc] Error 2
2912
make[2]: *** Waiting for unfinished jobs....

Best regards,
									Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--I81sU3lDOpubUmQf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaTBq4wAKCRAw5/Bqldv6
8gPtAKCqxU0vnhDgWBM6eazxhwR89d9bPACgoqnEX9g7tIKJx6moiJlu5AbR5mc=
=A29j
-----END PGP SIGNATURE-----

--I81sU3lDOpubUmQf--
