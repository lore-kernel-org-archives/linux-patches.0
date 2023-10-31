Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FBD2031D
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qDLGMwJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4961FC433C8;
	Tue, 31 Oct 2023 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698772293;
	bh=WAbUlMghKoKGlwd5+6V7FdJ1+87/HQMMjKcjn5JCqEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qDLGMwJTHDvy4Dg9PIA2QHYvDAbZkQUQf5ut4qdOTRyUIctjRhkM/AwcPsKPQNVh1
	 VJFgEFrmEf1AZs1z6UfXmqSxTeZ232NXFojKj+N0ZkFsqQZaiCzRLJLAcSBWe6GvFq
	 /4nHKhzGHbbINJcsLk5y88LueFz5lu6NO0YxY+/5TPkEruc+/eRlDp05Vv1mwFb9CP
	 hmJYWOD0ZS8WZNDrnsRq5qZOv+WKhxOdDS7GIpLfD/+3lxBuY8qajD99hDoIWsuc2M
	 fOPypdRQ23BxZIo6ErdMvNqgWtF5AzGzmUVUOMnNfTdBbalIphIjcIJs24F4Vdfg36
	 PnWnQm4Co+mHQ==
Date: Tue, 31 Oct 2023 17:11:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Takashi Iwai <tiwai@suse.de>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 05/86] ASoC: codecs: wcd938x: Convert to platform
 remove callback returning void
Message-ID: <958957ff-bbaa-4fbc-a796-30e2fdf61453@sirena.org.uk>
References: <20231031165918.608547597@linuxfoundation.org>
 <20231031165918.777236098@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ol/i8CdclZvBsAfY"
Content-Disposition: inline
In-Reply-To: <20231031165918.777236098@linuxfoundation.org>
X-Cookie: Is it clean in other dimensions?


--ol/i8CdclZvBsAfY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 06:00:30PM +0100, Greg Kroah-Hartman wrote:

> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.

This doesn't seem like obvious stable material - it's not fixing any
leaks or anything, just preparing for an API transition?

--ol/i8CdclZvBsAfY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVBNT4ACgkQJNaLcl1U
h9C7Vwf+KLgzCd1r8pGTKJEpaOAwt9Pbf0FzBJNLYfMTHgnoa1pJITtiuIvaegQR
jh6DdMCzxL9zFhw2hpSmJquL5JjEvJsAVMdgmQ/M7uhh0HXQNdMb47G+UJQoDum+
eYm7oRqfku5cIMCesjVPLc8OWP9dnfbpgm7ZPuVpoOnLgvHMCwVJalX5WXv9AaED
P9/7i/7ffN06Nw50uNohmop5Ls6MrDSLpYyWgJ1FIOGTxH6J1QNsHvzcW69WPVER
zQJTFLstsIxfTjnP3u6gfNJcudBK3VsifonH4tF3EXvbO6FO8Htz0Pc8gyxtDmh8
v9j6BQkJP+IJrvYnjgl1loN2VjDp2A==
=3E9R
-----END PGP SIGNATURE-----

--ol/i8CdclZvBsAfY--
