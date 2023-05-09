Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0C81096E
	for <patches@lists.linux.dev>; Tue,  9 May 2023 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683635094; x=1715171094;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kh42O3+uJmh8/ovlC6i2f/t7fdo0dloLStJAHg4siTA=;
  b=WzZfstjqM6axiWWOTSYMd9VlUrQDPPjgswQq2wFk27hhM/OSQpGgfp7r
   5n6FZ0wOtX1b41aVPylNNybSnmLzDtDy/NCIlCOlWm5rMF2N8Nj/aNLsx
   nhrj+4Hle274xAku0LVOaegMYyUMdJKrgcO1hMLL+cTLbA5Ov8u1ic5ee
   s/WgXH9mWL5/OS/2wMME95diD6oHqQtHB4GJztvAKCRq3oHsQT2g2nqYW
   IecV8yPHR1xhQU2EfT/MfdFq4Y3VGnHQ6hHP7AjfQnaMmf0iOPoMmdb60
   rQ+R9CZ+YTptIxY0she0DzyiZEGR79Nq0hPjTTPVMwZoKoTiKEINn+n4t
   w==;
X-IronPort-AV: E=Sophos;i="5.99,262,1677567600"; 
   d="asc'?scan'208";a="151089056"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2023 05:24:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 9 May 2023 05:24:36 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 9 May 2023 05:24:34 -0700
Date: Tue, 9 May 2023 13:24:15 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Conor Dooley <conor@kernel.org>, Dhruva Gole <d-gole@ti.com>,
	<stable@vger.kernel.org>, <patches@lists.linux.dev>, Mark Brown
	<broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 455/611] spi: bcm63xx: remove PM_SLEEP based
 conditional compilation
Message-ID: <20230509-cheating-chapped-5fd1a32a05e5@wendy>
References: <20230508094421.513073170@linuxfoundation.org>
 <20230508094436.944529030@linuxfoundation.org>
 <0138fb50-507d-bccf-40bb-07340f3cbb33@ti.com>
 <2023050808-overbite-dancing-53c5@gregkh>
 <2023050845-pancreas-postage-5769@gregkh>
 <20230508-undefined-opium-c9824d160898@spud>
 <2023050940-outscore-kindle-f333@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9oLdbBtJMdB9cq9y"
Content-Disposition: inline
In-Reply-To: <2023050940-outscore-kindle-f333@gregkh>

--9oLdbBtJMdB9cq9y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 09, 2023 at 04:54:45AM +0200, Greg Kroah-Hartman wrote:
> On Mon, May 08, 2023 at 11:27:42PM +0100, Conor Dooley wrote:
> > On Mon, May 08, 2023 at 03:25:11PM +0200, Greg Kroah-Hartman wrote:
> > > On Mon, May 08, 2023 at 03:15:15PM +0200, Greg Kroah-Hartman wrote:
> > > > On Mon, May 08, 2023 at 05:55:50PM +0530, Dhruva Gole wrote:

> > > > > > -#endif
> > > > >=20
> > > > > This patch may cause build failures with some of the configs that=
 disable
> > > > > CONFIG_PM I understand,
> > > > > So to fix that I had sent another patch:
> > > > > https://lore.kernel.org/all/CAOiHx=3D=3DanPTqXNJNG7zap1XP2zKUp5Sb=
aVJdyUsUvvitKRUHZw@mail.gmail.com/
> > > > >=20
> > > > > However missed out adding the fixes tag.
> > > > >=20
> > > > > I humbly request you to add
> > > > > https://lore.kernel.org/all/20230424102546.1604484-1-d-gole@ti.co=
m/
> > > > >=20
> > > > > this patch to fix this patch throughout the stable fixes trees.
> > > > >=20
> > > > > It can also be found on Linus' master branch here:
> > > > >=20
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/drivers/spi/spi-bcm63xx.c?id=3Dcc5f6fa4f6590e3b9eb8d34302ea43af4a3=
cfed7
> > > > > >   static const struct dev_pm_ops bcm63xx_spi_pm_ops =3D {
> > > > > >   	SET_SYSTEM_SLEEP_PM_OPS(bcm63xx_spi_suspend, bcm63xx_spi_res=
ume)
> > > >=20
> > > > Sure, now queued up, thanks!
> > >=20
> > >=20
> > > Nope, sorry, that broke the build in many places, so I've dropped it =
now
> > > from kernels 5.15.y and older.
> >=20
> > I retriggered my CI after seeing these mails, but the build is still
> > broken on RISC-V.
>=20
> Now dropped, thanks.

All green now, thanks.

--9oLdbBtJMdB9cq9y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFo7bgAKCRB4tDGHoIJi
0qPPAP9YF43LLI/CKDk4Vwbnf+bwl6riszJiaWs8uI/rNIDIIwEAvuI6yUK//m76
EkxC/Hhhq85BQHTMHs7gP5Ak7yv6Rww=
=lIm7
-----END PGP SIGNATURE-----

--9oLdbBtJMdB9cq9y--
