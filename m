Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDE4274B2B;
	Fri, 24 Apr 2026 21:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067503; cv=none; b=CjNF4qlmki9sWP94QzEXfZij/G8kjMZalzahwdoUWQdgeGCEqp9R3iJvkFmml7YdR7E1ia1O1tvxpryycwTt9O/I8O+4b46fisnRiyRUN73yx1VR9uc2rWZrp4q7HgXbZimF0jPWQSYmtUaqjlejRM40eyBusihXCRumoYHoBVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067503; c=relaxed/simple;
	bh=TZF7+rdSxIYKKQoCmgaM1jARCCcQZdPZtWqdEagDiGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QJnteE2PiK56YE1ksT8hqssTkKIjbwU1/JvATMzQF2dEShmNaTtz337gOSC76b7BycxKZO172o1e2nvySJaBFQ5y2ID4PhYqLHEkHA03obdWbkcN+efKdY1eyDSvIMPEX550m1f5qrmHvZvEU9dkzUP1l3wkSV86fQtsjveb33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfQiwHO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfQiwHO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2697C19425;
	Fri, 24 Apr 2026 21:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067503;
	bh=TZF7+rdSxIYKKQoCmgaM1jARCCcQZdPZtWqdEagDiGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qfQiwHO12wYFO+NkZP6c3ra76JX8JgqpK25Lkef+J6AHf9sEsPYoAUFPJ8TVU0Mzv
	 7ecLwaXYJd8Jp6LJER+oQuzl1XhdZ0A4o3HVw2uyLTpmx2OhGhw2vPk53tqWBzFznH
	 cS2EyWNJDqElZ6vUA6DzKgMB2mUv0q4hxxDrEm9pY0J6tG8jv1N8TZu27zrRyj5cbG
	 MN2l09OontjCjqiY14d7W+/48G4j4zdN8q+fmG49n2ce87/varPtnU3B4/9ngB5JfM
	 vL/Ou3kkNIkAtHVuHEMBOa6U8tA0olCHsCahyDGZhN7JJd0YcNXurV4v6nxE43C24P
	 vj0eesYWhR+FQ==
Date: Fri, 24 Apr 2026 22:51:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
Message-ID: <2f14b31c-ab0d-417e-bf91-866264c293ed@sirena.org.uk>
References: <20260424132430.006424517@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="G2n2+xxaUyxMc8ID"
Content-Disposition: inline
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
X-Cookie: 1 bulls, 3 cows.


--G2n2+xxaUyxMc8ID
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 24, 2026 at 03:30:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--G2n2+xxaUyxMc8ID
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnr5egACgkQJNaLcl1U
h9BpQwf+NJRRD2d8nEeGDw/t4qxlyka+DKBHZVU0V4uOFFY9t9/hlUYEzmQiHf9U
I9wvTGQbJOawHRSH2WH4gMf5uU5XaEGKIeaSx01Wz/uzsu4Ly6MStl+pvS/r6xlN
4226KgixoHLiS9LNKXcfmvGWqhFNM15gzewVlQJb8FHRR4sh7QgYlMj/psVtxZBd
qqLdsXwGBkiOGB57mwykszMpXAAcgf7cVTMgS1g9gnjg/ErDsSWfoUNpVYuEMQyy
28ZZN3oxtbL/6wGuf4zU7MFabjhuSjwK0Szm/GaJ/HkOS70Zv7ry/P//RQhpUJZ6
gzzFJJRm8ylab1d6ApK6BvZBHk4TOg==
=B5NN
-----END PGP SIGNATURE-----

--G2n2+xxaUyxMc8ID--
