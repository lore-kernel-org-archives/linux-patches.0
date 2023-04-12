Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC282F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 09:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681292293; x=1712828293;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iW014jw93jNltxJmodVKxtkwW3MpOg3Vy7vWHpczrgk=;
  b=AoNEuiXTR/g4Kd426timnKcY5U/fnr/5TIHkSgVQSOgV+mJws1ZoBfJp
   6E3RBmim3f/5m2HLJ59k6zOzjc2T3fITF8RA4qDup+dF3YvG0eC/mubl+
   BWTz/Kqlllt7QIZ1h84kdn/rkLp+dXIFfGqhBqNNjAj2OzFRTgp6b1ErT
   9nGXiLVTrYR0T05ij7ZC17aajkNvW1G9bLJxfsvkYVV7ekSsFPh0oxMdt
   oapjDunG67NvpC56etRYOZRYYbENbX5tNv1UzjIvpc0FPFjmozpPpDxPN
   vP8cDDMYA8Eiw18XXUnDedH9fMS66LAFS1AIAaIJkmHvQUiAnDz/p/c/H
   w==;
X-IronPort-AV: E=Sophos;i="5.98,338,1673938800"; 
   d="asc'?scan'208";a="210027622"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2023 02:37:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 12 Apr 2023 02:37:02 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 12 Apr 2023 02:37:01 -0700
Date: Wed, 12 Apr 2023 10:36:45 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Greentime Hu
	<greentime.hu@sifive.com>, Zong Li <zong.li@sifive.com>, Palmer Dabbelt
	<palmer@rivosinc.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 01/93] soc: sifive: ccache: Rename SiFive L2 cache
 to Composable cache.
Message-ID: <20230412-mustang-machine-e9fccdb6b81c@wendy>
References: <20230412082823.045155996@linuxfoundation.org>
 <20230412082823.103777810@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9Li8sIjHv3RuwQst"
Content-Disposition: inline
In-Reply-To: <20230412082823.103777810@linuxfoundation.org>

--9Li8sIjHv3RuwQst
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:33:02AM +0200, Greg Kroah-Hartman wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> [ Upstream commit ca120a79cf5a3323172c82e77efd70ae10d120ef ]
>=20
> Since composable cache may be L3 cache if there is a L2 cache, we should
> use its original name composable cache to prevent confusion.
>=20
> There are some new lines were generated due to adding the compatible
> "sifive,ccache0" into ID table and indent requirement.
>=20
> The sifive L2 has been renamed to sifive CCACHE, EDAC driver needs to
> apply the change as well.
>=20
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Zong Li <zong.li@sifive.com>
> Co-developed-by: Zong Li <zong.li@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://lore.kernel.org/r/20220913061817.22564-3-zong.li@sifive.com
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> Stable-dep-of: 73e770f08502 ("soc: sifive: ccache: fix missing iounmap() =
in error path in sifive_ccache_init()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Did I just miss AUTOSEL emails for this stuff?

NAK. This seems waay too invasive to me, and changing the Kconfig symbol
for the driver in stable kernels sounds like a bit of a nasty surprise?

The two actual fixes that this is a dep of should be backported
individually, please drop patches 1-7 (inclusive) & I'll give you less
invasive backports for 6 & 7.

Cheers,
Conor.


--9Li8sIjHv3RuwQst
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDZ7rQAKCRB4tDGHoIJi
0n0yAQDJWAJh1t0v3srK/Av27ty95824Xdc+7Q1a509lswdQsgEAu+8YoG573yI2
wE02xMBWjLrAsYCZh7kDrk63xubycAU=
=cQwy
-----END PGP SIGNATURE-----

--9Li8sIjHv3RuwQst--
