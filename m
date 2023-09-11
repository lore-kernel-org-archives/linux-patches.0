Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B7911715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC53C433C9;
	Mon, 11 Sep 2023 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694443594;
	bh=2It49KItNZGBnAorNowsZeS4iwuYO9L2hV6pvsJvszA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NkAg1tzb/9uZaTFlE04bCiT6OaXYypB8331BVaJFAGVRQLOUcbpdYpsleSgWQtfJc
	 07b3cURxWtwR0QkR5jdJcVWELUSvohYNZz/d507EpYOsglWqsbXn+FhLQoqu5lsW/t
	 B3b3vc1SYXN/kvzjsffljACYu1z4nYeC5mnSxmNITaBGgSA5CPLTsfy8+AbOX8tTup
	 +Ns+tNMR61lPhlKG0UP/YHFHCrpYkFByLXZJH91YI/kDw/NJY8be8tBLX3R187RwRJ
	 564cXIGd9oy6Xbs0CpcNAY/Pn2uQ9W70eIjF/6+W8QOBpHOdjlD+7cya1vKkvwQack
	 aUnNdVGxE4+LQ==
Date: Mon, 11 Sep 2023 15:46:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 363/739] ASoC: pxa: merge DAI call back functions
 into ops
Message-ID: <ZP8oR4nDRDpsxLkM@finisterre.sirena.org.uk>
References: <20230911134650.921299741@linuxfoundation.org>
 <20230911134701.287984009@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5v/l/Hft6U+bbW2F"
Content-Disposition: inline
In-Reply-To: <20230911134701.287984009@linuxfoundation.org>
X-Cookie: Save energy:  Drive a smaller shell.


--5v/l/Hft6U+bbW2F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2023 at 03:42:42PM +0200, Greg Kroah-Hartman wrote:
> 6.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>=20
> [ Upstream commit 98e268a7205706f809658345399eead7c7d1b8bb ]
>=20
> ALSA SoC merges DAI call backs into .ops.
> This patch merge these into one.

This is obviously not stable material.

--5v/l/Hft6U+bbW2F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmT/KEYACgkQJNaLcl1U
h9COUQf+MF3nbU2r8UK2CM96oFjdqSlUoHmBa8VoOcSLGy8SpkLj27B9bUQkGluL
dq/R92rTs1QwJTXNzGZPAsl2Rz9qoYCNBFrgG98ZX8jfPJGl9PrZG8ca954wQhfx
68KIB5cgT+2OXuTzSFQNY3lEQWE3q5PESwmh3u3/nQKWQlHgsl3ICKtARhUBEOwe
bBeyFPTXrpGQywLQiueZnACxnXkpGyBciUhGDv0YVtYHteCVv3OAArKgS8VRNpwm
1/MstCluKhA5Lce59aN2tN+yxEAJG34I96HK9J2lmc9GCUDy7A84gbaSe9wJwAU6
4OV4WNzRgFnZilt+QxkrgzqEExFNXA==
=kBHO
-----END PGP SIGNATURE-----

--5v/l/Hft6U+bbW2F--
