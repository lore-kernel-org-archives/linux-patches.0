Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0F118AED
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 910C61C006D; Tue, 10 Oct 2023 13:18:19 +0200 (CEST)
Date: Tue, 10 Oct 2023 13:18:19 +0200
From: Pavel Machek <pavel@denx.de>
To: Pavel Machek <pavel@denx.de>
Cc: wsa+renesas@sang-engineering.com, niklas.soderlund+renesas@ragnatech.se,
	yoshihiro.shimoda.uh@renesas.com, geert+renesas@glider.be,
	biju.das.jz@bp.renesas.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris.Paterson2@renesas.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10
 000/226] 5.10.198-rc1 review
Message-ID: <ZSUy+zA0+Chm6dFb@duo.ucw.cz>
References: <20231009130126.697995596@linuxfoundation.org>
 <ZSRVgj5AqJbDXqZU@duo.ucw.cz>
 <ZSRe78MAQwbBdyFP@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A9Lr04onjTJhAtpN"
Content-Disposition: inline
In-Reply-To: <ZSRe78MAQwbBdyFP@duo.ucw.cz>


--A9Lr04onjTJhAtpN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 5.10.198 release.
> > > There are 226 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> > > Anything received after that time might be too late.
> >=20
> > 4.14, 4.19 and 6.1 tests ok, 5.10 seems to have problems:
>=20
> Guessing from stack traces, these may be relevant:

So bisection reveals these are relevant:

  |e10d3d256 b161d8 o: 5.10| mmc: renesas_sdhi: probe into TMIO after   SCC=
 parameters have been setup

Ok

 |493b70c48 d14ac6 o: 5.10| mmc: renesas_sdhi: populate SCC pointer at  the=
 proper place

Testing now: https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipeline=
s/1031822035

 |c508545f4 0d856c o: 5.10| mmc: tmio: support custom irq masks
 |8df1f0639 74f45d o: 5.10| mmc: renesas_sdhi: register irqs before registe=
ring controller

Fail: https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/10317=
86077

I should be able to point specific commit with two more tests.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--A9Lr04onjTJhAtpN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZSUy+wAKCRAw5/Bqldv6
8l+cAKC5myuJkrwEyf9tCv+eqSAzp44+BACgpL5hAh7OSoSbpIj6nYPrbvMxOZA=
=ZKvd
-----END PGP SIGNATURE-----

--A9Lr04onjTJhAtpN--
