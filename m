Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD357C2FD
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C047C433C9;
	Mon, 11 Sep 2023 14:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694442795;
	bh=9pIep38oZQZsSeBWdzXla9OdjotRw0G9/ta7/enYxA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q0IPmpkTUSiHulpSzpsU/nPbP4qb3EBJNytqqP38YD5TOKDdD7peHYiVGogc3/+Ro
	 2hbM3ukPumfzPeLZCxqFz5vc6lwfIwWBGAGOHbn2pIRoGyAkjaC5Hu/uEdxY9HBx7H
	 evgYV5afGsJjeju6qJ/WJTdJwKDeIVO2o+FVESVB7aADju6mnxtlui9FW4Z9y4yvfd
	 NxUvCBnxuWc0A4b4w9LNQaljg6hnNeKfuLIDIraMDwnZUPlFb44h6BQ6PLhOOJvPwX
	 TlL9MAlKbbrUQ2MTuSUsaharw8BTbQBvhmGYf6ViSgxSlicalcW348jV+yZlbGFlD2
	 P5EWajx0ATNDg==
Date: Mon, 11 Sep 2023 15:33:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexander Danilenko <al.b.danilenko@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 134/739] spi: tegra114: Remove unnecessary
 NULL-pointer checks
Message-ID: <ZP8lHSmZVOvbI3wN@finisterre.sirena.org.uk>
References: <20230911134650.921299741@linuxfoundation.org>
 <20230911134654.832694547@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="afYEVH52ZC8muFvY"
Content-Disposition: inline
In-Reply-To: <20230911134654.832694547@linuxfoundation.org>
X-Cookie: Save energy:  Drive a smaller shell.


--afYEVH52ZC8muFvY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2023 at 03:38:53PM +0200, Greg Kroah-Hartman wrote:
> 6.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Alexander Danilenko <al.b.danilenko@gmail.com>
>=20
> [ Upstream commit 373c36bf7914e3198ac2654dede499f340c52950 ]
>=20
> cs_setup, cs_hold and cs_inactive points to fields of spi_device struct,
> so there is no sense in checking them for NULL.
>=20
> Found by Linux Verification Center (linuxtesting.org) with SVACE.

This is a code cleanup, why is it a stable candidate?  It's not a
warning fix or anything.

--afYEVH52ZC8muFvY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmT/JRwACgkQJNaLcl1U
h9ClyQgAhmMdoPmUDlad8cDgodBr+fXJLkEq6jaJfpkyEauibGQeRCjdDknl9V9c
bV1K+LUYBdMajIDxro65oFoRrFJLbuN08t6Wmkp2wBQx2RAhVSAK1vxVEFK2Ipe6
gqK8jZlCGoP927koOd3r/yiYZYA96eAU9dPjJBZaWxKy+NKJGsr1Z6Htn/QVPylr
ykI1ujodM0GEW7Vm8hnyL4abCNvojzVH28D21UfVvGGd/gq4ej4RTQWv54CU5TAJ
qPiHRJrXwiMWLPyl5fW2eF+dWIORlneFxAcW+YoJqPcELj9s4c1F028JRvui0fy2
aglhK5NGIeyetTelWR1zS6FgxPXcgQ==
=gmau
-----END PGP SIGNATURE-----

--afYEVH52ZC8muFvY--
