Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915AF1F8EE3
	for <patches@lists.linux.dev>; Tue,  3 Dec 2024 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733249640; cv=none; b=IEhnqZOKG4cq66xRcSXBbDq5sKZMxaKD0D7LvRm336C0HQd8EI/I0yguD46ElEjEa3UKYy+eHvv0kY8MFIFtWka6MpyzZo3/Mgssh9hjiPN2XRQm/Hdjaj9RP7OTkLUnVxApcVHypf7smJx1ijjb51Afv83o1loYXRA7if98hCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733249640; c=relaxed/simple;
	bh=goNbn9LHti/OQqu0NtqUuzDIMzdSZPos2x6hTQxj6QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VduThITVyL7SFGvb8Uj35cRf8IhiCyEYHp1h73NdMBCOTrDB7QP3uSfsKB78AbFySI6079wPN1s+TJgIPjuRA5AOOw7ZzWFDhDOYQUlcaDcUO2sz7Y7kG5HWibtucY0C9cokrDivGn2H0bwEmv9d7liV/dhyILYNM79yU04VHDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 1935C1C00A0; Tue,  3 Dec 2024 19:13:51 +0100 (CET)
Date: Tue, 3 Dec 2024 19:13:50 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
Message-ID: <Z09KXnGlTJZBpA90@duo.ucw.cz>
References: <20241203141923.524658091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dKgCbh+6g0xCEEa"
Content-Disposition: inline
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>


--9dKgCbh+6g0xCEEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> ------------------
> Note, this is the LAST 4.19.y kernel to be released.  After this one, it
> is end-of-life.  It's been 6 years, everyone should have moved off of it
> by now.
> ------------------

Releasing 130 patches as end-of-life kernel is not good idea. There
may be regression hiding between them...

> This is the start of the stable review cycle for the 4.19.325 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build fails:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/853242=
3815

  CC      drivers/pinctrl/uniphier/pinctrl-uniphier-pro4.o
3895
  CC      drivers/pci/of.o
3896
drivers/rtc/rtc-st-lpc.c: In function 'st_rtc_probe':
3897
drivers/rtc/rtc-st-lpc.c:233:11: error: 'IRQF_NO_AUTOEN' undeclared (first =
use in this function); did you mean 'IRQ_NOAUTOEN'?
3898
           IRQF_NO_AUTOEN, pdev->name, rtc);
3899
           ^~~~~~~~~~~~~~
3900
           IRQ_NOAUTOEN
3901
drivers/rtc/rtc-st-lpc.c:233:11: note: each undeclared identifier is report=
ed only once for each function it appears in
3902
  CC      drivers/pci/quirks.o
3903
make[2]: *** [scripts/Makefile.build:303: drivers/rtc/rtc-st-lpc.o] Error 1
3904
make[1]: *** [scripts/Makefile.build:544: drivers/rtc] Error 2
3905
make[1]: *** Waiting for unfinished jobs....
3906
  CC      drivers/pinctrl/uniphier/pinctrl-uniphier-sld8.o
3907
  CC      drivers/soc/renesas/r8a7743-sysc.o

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9dKgCbh+6g0xCEEa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ09KXgAKCRAw5/Bqldv6
8igyAKC2pyBC6fWNiQh0OKW85uIIN0WbqACgwLulzTAF14u09GS4SkD6suO2gvs=
=6DTu
-----END PGP SIGNATURE-----

--9dKgCbh+6g0xCEEa--
