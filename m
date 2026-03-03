Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F307139656D;
	Tue,  3 Mar 2026 19:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565576; cv=none; b=j9AsOk5NqNjWBc6C3pP5hVGOGuu89CKP8nAASiZQYhExuOo0a7eUhW/+0PPnC1HSukYjN6NXl2KO9IXO+u+q6lEfK5OIFkWeF5TcOsf5W6jx8QNPpAofkEylfzFlKhelLoariKFlRnfTbX1SI8rduoO7bn8kAjVcXZ/xWlnm2sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565576; c=relaxed/simple;
	bh=LlrxnhNot7y8rfvMteBtsZDoI3TwJ8lQL0JUOn/NJJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9TF+bupzOdO95qtSql1R0+ZCnsQ0oLCfN9AIhJas65Wqhh0XsxMiZLLlyDCBwt5+Ie8MbPClU8/yx0v77gKXHZd6RuKeYqXO6RiK3RgGRqtx5bVt1LIo8/iRZbzybBdym7pCG+AsHyOWzuCMR4gRWFI+AiVEulqRhLf4nWJNgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bO+LIJRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bO+LIJRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927C5C116C6;
	Tue,  3 Mar 2026 19:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565575;
	bh=LlrxnhNot7y8rfvMteBtsZDoI3TwJ8lQL0JUOn/NJJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bO+LIJROP6tTCTu2HOUlI4tVLHjsIMZwTbNk9gpsC1Sai88t9xVr0C0gIy6NIwTjY
	 HJ3HbHCjGBz9e7P9n/HnhLWWr5KYF6fXZUg5B37CyLSVFpFdrn1SRm/ARfN27iLnDb
	 kHxvSvhyje+Ltfx/0qu3bYaoqTxqEYbh/Bz3gJkx22fuYBNUHn7Ma0ESgzw9CQnEE+
	 6nmF6ZefTW4ziQ6ntwviWQFFDADAxcCy1gUbBKo6/aaz1x68SB7+XOccpHuwwqs5R7
	 8BNadAGhCLz9HLcQF7k7maBC1J+n80MeY2ZpwpedPv8IBn2xLeRa5aX0lm4j11vYfs
	 ti0edAQTfrVjQ==
Date: Tue, 3 Mar 2026 19:19:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
Message-ID: <75853fe3-da0c-445f-b128-69e0ab5898d2@sirena.org.uk>
References: <20260302160934.2521545-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ug0+ln7T8L5Op2/v"
Content-Disposition: inline
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>
X-Cookie: Use the Force, Luke.


--ug0+ln7T8L5Op2/v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 02, 2026 at 11:09:34AM -0500, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 684 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Reviewed-by: Mark Brown <broonie@kernel.org>

--ug0+ln7T8L5Op2/v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmnND8ACgkQJNaLcl1U
h9AgKAf/fynvjqcYJFV+ZnYPYWrXHfQZrqDlTKlkpSyXPFAK+vTq9f6DUyA4qBQx
dQXtpzoPkEagricr/SJcbdoZLB8PDfDtPqS1ykGnEKRn/+5BfG47Hjp506niOlwh
TIkSIixxmOZq3OBlVGiPWm8i/NnyxGT5buvBFVoPUfOllEOqZoZawm6xUV3YQ44I
hstHK0zK+APNMhW+gpszo8CsGriofa7aRcJdAWNpD+NWGOwEINgtWYKh6UB/nsu2
4D65VJQgpAY8O3ESQ/F7mNxMfF3EjOBZbjf3E1kSNydTKXzVw0MVdfY27sMU1KND
ol0KQwOIUtuiZKpkp4R+dNFrkLAzMw==
=ZeBK
-----END PGP SIGNATURE-----

--ug0+ln7T8L5Op2/v--
