Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256361AE863
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 11:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733312047; cv=none; b=fNNmMT4QDnXPkMdB06igH7PiD4KlVWJxzoxdJpttUHEL6KHRiHAMpm9qV3bNDHy4qfOSRCRLnLPYhpLbBm5jrPyB3W9FX/47WspThmsJiOctV/vpk1uXv5LRk6IU+6q6azEEEIybtfBj1nq11gNNKJBWrTtdywkiqkU+bhjY6b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733312047; c=relaxed/simple;
	bh=WOmmx/TYJt9siuctuf82NMwVd5HB06rxCXNrNMiCQ6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5gtR/yEjaZLkJgUXjDaCLSt4UDPmz+4K1HS4Y0I2uTFaBw2p9Gp6cknKyf1zgVy6dEUE5IBonsajeMP1QpJbK6+zBjYJPnh//awGLe6HS/wcX1aDRHMFIZCE0nv4NkZleW70OJmaIbxMe9BMlU1OrqB6oooDb6RQ9JfKKm+jBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id CC1431C00A0; Wed,  4 Dec 2024 12:34:02 +0100 (CET)
Date: Wed, 4 Dec 2024 12:34:02 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
Message-ID: <Z1A+Ku5D0OFOSUm4@duo.ucw.cz>
References: <20241203141923.524658091@linuxfoundation.org>
 <Z09KXnGlTJZBpA90@duo.ucw.cz>
 <2024120424-diminish-staple-50d5@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rRJwBGNM29yCb0EE"
Content-Disposition: inline
In-Reply-To: <2024120424-diminish-staple-50d5@gregkh>


--rRJwBGNM29yCb0EE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 4.19.325 release.
> > > There are 138 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > Build fails:
> >=20
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/85=
32423815
> >=20
> >   CC      drivers/pinctrl/uniphier/pinctrl-uniphier-pro4.o
> > 3895
> >   CC      drivers/pci/of.o
> > 3896
> > drivers/rtc/rtc-st-lpc.c: In function 'st_rtc_probe':
> > 3897
> > drivers/rtc/rtc-st-lpc.c:233:11: error: 'IRQF_NO_AUTOEN' undeclared (fi=
rst use in this function); did you mean 'IRQ_NOAUTOEN'?
> > 3898
> >            IRQF_NO_AUTOEN, pdev->name, rtc);
> > 3899
> >            ^~~~~~~~~~~~~~
> > 3900
> >            IRQ_NOAUTOEN
> > 3901
> > drivers/rtc/rtc-st-lpc.c:233:11: note: each undeclared identifier is re=
ported only once for each function it appears in
> > 3902
> >   CC      drivers/pci/quirks.o
> > 3903
> > make[2]: *** [scripts/Makefile.build:303: drivers/rtc/rtc-st-lpc.o] Err=
or 1
> > 3904
> > make[1]: *** [scripts/Makefile.build:544: drivers/rtc] Error 2
> > 3905
> > make[1]: *** Waiting for unfinished jobs....
> > 3906
> >   CC      drivers/pinctrl/uniphier/pinctrl-uniphier-sld8.o
> > 3907
> >   CC      drivers/soc/renesas/r8a7743-sysc.o
>=20
> What arch is this?  And can you not wrap error logs like this please?

Not easily. But you can easily get nicely formatted logs +
architecture details by clicking the hyperlink above.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rRJwBGNM29yCb0EE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ1A+KgAKCRAw5/Bqldv6
8st2AKC74IP/4VCvOaJ9Mhd5CPms1awCbQCgh3KYxqrHsKB+NVWPrTEJlYJBAN0=
=HNVQ
-----END PGP SIGNATURE-----

--rRJwBGNM29yCb0EE--
