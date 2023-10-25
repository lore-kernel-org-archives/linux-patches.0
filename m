Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BEF1401F
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 22:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 10F8F1C0077; Thu, 26 Oct 2023 00:00:27 +0200 (CEST)
Date: Thu, 26 Oct 2023 00:00:25 +0200
From: Pavel Machek <pavel@denx.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Pavel Machek <pavel@denx.de>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	niklas.soderlund+renesas@ragnatech.se,
	yoshihiro.shimoda.uh@renesas.com, biju.das.jz@bp.renesas.com,
	Chris.Paterson2@renesas.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	linux-reneas-soc@vger.kernel.org,
	Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10
 000/226] 5.10.198-rc1 review
Message-ID: <ZTmP+WuZGKQQiYzb@duo.ucw.cz>
References: <ZSRe78MAQwbBdyFP@duo.ucw.cz>
 <ZSUy+zA0+Chm6dFb@duo.ucw.cz>
 <ZSU+GHl1q7T/TBp5@duo.ucw.cz>
 <ZSWg1fv3gOyV5t+h@shikoro>
 <2023101057-runny-pellet-8952@gregkh>
 <ZTgZa1ic1iFbdaTM@duo.ucw.cz>
 <CAMuHMdXQApuOPfU1zNKcHKN5=fCuLBSDiLtF06U7e4Tx0+noyA@mail.gmail.com>
 <CAMuHMdVrdmBgopnPnJK_ij52wz2WVBdYRHur2KfosFnT945ULw@mail.gmail.com>
 <CAMuHMdWZvTGrFgx_o3g3usOwkDvD2rw5QH9_ibo=OKdw17sAzg@mail.gmail.com>
 <CAMuHMdXvpiGQ7jqAG69Zo=10wV-E0bioC9AYUHwwhRGmLXygWA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oR+xcAanc4zbdfY9"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXvpiGQ7jqAG69Zo=10wV-E0bioC9AYUHwwhRGmLXygWA@mail.gmail.com>


--oR+xcAanc4zbdfY9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > I don't have a HopeRun HiHope RZ/G2M, but both v5.10.198 and v5.10.=
199
> > > > seem to work fine on Salvator-XS with R-Car H3 ES2.0 and Salvator-X
> > > > with R-Car M3-W ES1.0, using a config based on latest renesas_defco=
nfig.
> > >
> > > Sorry, I looked at the wrong log on R-Car M3-W.
> > > I do see the issue with v5.10.198, but not with v5.10.199.
> >
> > It seems to be an intermittent issue. Investigating...
>=20
> After spending too much time on bisecting, the bad guy turns out to
> be commit 6d3745bbc3341d3b ("mmc: renesas_sdhi: register irqs before
> registering controller") in v5.10.198.

Thanks for bisection, let me take a look.

I reverted 6d3745bbc3341d3b on top of 5.10.199 and that solved my
issues:

https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/1049624365

(Strange thing is I seen a failure on qemu this fixed, too. I guess
that must be some kind of glitch).

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--oR+xcAanc4zbdfY9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZTmP+QAKCRAw5/Bqldv6
8k6SAJ4/HtaBXWwllktmFx2oj78m2U2KdwCfSayohMqJRiDbYUS5xiMrBw5qATs=
=5e5A
-----END PGP SIGNATURE-----

--oR+xcAanc4zbdfY9--
