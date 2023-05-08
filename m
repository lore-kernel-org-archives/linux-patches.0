Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94881096B
	for <patches@lists.linux.dev>; Mon,  8 May 2023 22:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBDDC433D2;
	Mon,  8 May 2023 22:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683584866;
	bh=GIS4XTRvypwgsB7uXZ/VDKgG7fnjdHtdyBYb7aG4hSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gWbiWSV4WvJ1vY/rfgheXAKIbReC9opEbLW408lef98FwiIJKABztYlmxvYBoI957
	 g/h2mam0WhUN3iKl5VwwHatgPKiAWMZpTbRBKxempwa38sljZ5cw24DaIElG8WmCVW
	 2+NdCZDeH4FDBdeTM2ebHyll/hYECF+5UsV6sMDA+fL8nD/7oEwTkChSLYHyB7n4Di
	 LkfQvKVpQETlCg2YmMMOxSg9UzIz/kcSPeAkIE3wxi3ItQiUE4hXZjdWXMzB8LI6hM
	 //ZENNBgg6jgQYX9RAWw75QYmIWN6FxS0G5DGTVqziPE0YdBnTyXtk4VeLF6FmCa+J
	 r1ClNZhBPsgYg==
Date: Mon, 8 May 2023 23:27:42 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dhruva Gole <d-gole@ti.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 455/611] spi: bcm63xx: remove PM_SLEEP based
 conditional compilation
Message-ID: <20230508-undefined-opium-c9824d160898@spud>
References: <20230508094421.513073170@linuxfoundation.org>
 <20230508094436.944529030@linuxfoundation.org>
 <0138fb50-507d-bccf-40bb-07340f3cbb33@ti.com>
 <2023050808-overbite-dancing-53c5@gregkh>
 <2023050845-pancreas-postage-5769@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="v27JpicFWoaqi9Mo"
Content-Disposition: inline
In-Reply-To: <2023050845-pancreas-postage-5769@gregkh>


--v27JpicFWoaqi9Mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 03:25:11PM +0200, Greg Kroah-Hartman wrote:
> On Mon, May 08, 2023 at 03:15:15PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, May 08, 2023 at 05:55:50PM +0530, Dhruva Gole wrote:
> > > Hi Greg,
> > >=20
> > > On 08/05/23 15:14, Greg Kroah-Hartman wrote:
> > > > From: Dhruva Gole <d-gole@ti.com>
> > > >=20
> > > > [ Upstream commit 25f0617109496e1aff49594fbae5644286447a0f ]
> > > >=20
> > > > Get rid of conditional compilation based on CONFIG_PM_SLEEP because
> > > > it may introduce build issues with certain configs where it maybe d=
isabled
> > > > This is because if above config is not enabled the suspend-resume
> > > > functions are never part of the code but the bcm63xx_spi_pm_ops str=
uct
> > > > still inits them to non-existent suspend-resume functions.
> > > >=20
> > > > Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driv=
er")
> > > >=20
> > > > Signed-off-by: Dhruva Gole <d-gole@ti.com>
> > > > Link: https://lore.kernel.org/r/20230420121615.967487-1-d-gole@ti.c=
om
> > > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >   drivers/spi/spi-bcm63xx.c | 2 --
> > > >   1 file changed, 2 deletions(-)
> > > >=20
> > > > diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
> > > > index 80fa0ef8909ca..0324ab3ce1c84 100644
> > > > --- a/drivers/spi/spi-bcm63xx.c
> > > > +++ b/drivers/spi/spi-bcm63xx.c
> > > > @@ -630,7 +630,6 @@ static int bcm63xx_spi_remove(struct platform_d=
evice *pdev)
> > > >   	return 0;
> > > >   }
> > > > -#ifdef CONFIG_PM_SLEEP
> > > >   static int bcm63xx_spi_suspend(struct device *dev)
> > > >   {
> > > >   	struct spi_master *master =3D dev_get_drvdata(dev);
> > > > @@ -657,7 +656,6 @@ static int bcm63xx_spi_resume(struct device *de=
v)
> > > >   	return 0;
> > > >   }
> > > > -#endif
> > >=20
> > > This patch may cause build failures with some of the configs that dis=
able
> > > CONFIG_PM I understand,
> > > So to fix that I had sent another patch:
> > > https://lore.kernel.org/all/CAOiHx=3D=3DanPTqXNJNG7zap1XP2zKUp5SbaVJd=
yUsUvvitKRUHZw@mail.gmail.com/
> > >=20
> > > However missed out adding the fixes tag.
> > >=20
> > > I humbly request you to add
> > > https://lore.kernel.org/all/20230424102546.1604484-1-d-gole@ti.com/
> > >=20
> > > this patch to fix this patch throughout the stable fixes trees.
> > >=20
> > > It can also be found on Linus' master branch here:
> > >=20
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/drivers/spi/spi-bcm63xx.c?id=3Dcc5f6fa4f6590e3b9eb8d34302ea43af4a3cfed7
> > > >   static const struct dev_pm_ops bcm63xx_spi_pm_ops =3D {
> > > >   	SET_SYSTEM_SLEEP_PM_OPS(bcm63xx_spi_suspend, bcm63xx_spi_resume)
> >=20
> > Sure, now queued up, thanks!
>=20
>=20
> Nope, sorry, that broke the build in many places, so I've dropped it now
> from kernels 5.15.y and older.

I retriggered my CI after seeing these mails, but the build is still
broken on RISC-V.

Cheers,
Conor.

--v27JpicFWoaqi9Mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFl3XgAKCRB4tDGHoIJi
0iQFAP0ZF29NmrQV9TTRoq3w3WDk6Aa9j4r1x1E3DJO4UmfQyAEAkUhEWeUj8HP+
phiWyYqGNoe0x9XfhTntMZuaaVfO6AY=
=3E4h
-----END PGP SIGNATURE-----

--v27JpicFWoaqi9Mo--
