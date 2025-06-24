Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D2F284682;
	Tue, 24 Jun 2025 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750765742; cv=none; b=i5+pw+T3Sw3w/3rrNbi38hRBOYsEzDyEipoBYphrVYOwMnrjYSe4LXooRoO+/UWICuziB/F9aZjIIgPP151KnjhYtl8Pbn8H9Q5QISkAvrpLJ2doiTFlmYUhAFoTyyeN79IMTZ6tJjI7Z2j7AW4h9+svezPih2AA/gqYtCaUKK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750765742; c=relaxed/simple;
	bh=cw/9YN5eCuNOj+h6sAk5pRs3ujA52Uc7g1g1tXp3X9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tEz5UYUcMA1Cg7FcPhCEUtCIAL1+Frgno1eKmI/FAo87RB/FqrDAVKJi6RW9p7Vu9kiyZyLkuGUK5Yed9nzlTYpg6x+2F5EIxlDcn3T1/RTXppwoMA5stNrAniuw2s+YLCa3dwDdlR5T1fvtx9rxY7XPKyacIy1xbHQL7cEKLtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N6/n9L9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6/n9L9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4A8C4CEE3;
	Tue, 24 Jun 2025 11:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750765741;
	bh=cw/9YN5eCuNOj+h6sAk5pRs3ujA52Uc7g1g1tXp3X9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N6/n9L9XqvtVWn5BA1lPyvfpXm8DOKcAeYJsSnAQZ86k0AjwKCJ1UHGyJls84aJ+q
	 4ufBoA6pL1/MREbg9e7GD5PWHJZ8e1ENPFvY5gY/ievuhmPX73LIE05eTgNlQLtUcA
	 RcC6S4raNHVrBXgtGjO+xO2GeiE5Tw/l0DhHoKzlXp4G+RiQ8tJzpPhv/nf9t0kPKt
	 hjbqjbMxAfboO4ZBRlytgfrgMoWhX9di8aWTUgsgsOtzWMDGRo5XcSRd+qX5Wx0bKF
	 Ffy9Dr3WNS0xUmEfm+gaQwfY0dHEqBMe8YX+3bp1a3zZbem3QfLXi7H47bHuvBs9Za
	 BBjX8B47GkUCw==
Date: Tue, 24 Jun 2025 12:48:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
Message-ID: <d568f701-c299-41a4-97af-47270cf640f7@sirena.org.uk>
References: <20250623130700.210182694@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="p7LEaVjrB2dgIlwA"
Content-Disposition: inline
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
X-Cookie: Do, or do not


--p7LEaVjrB2dgIlwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 23, 2025 at 02:59:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 592 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--p7LEaVjrB2dgIlwA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhakKcACgkQJNaLcl1U
h9C0OQf+JAHd8Ho4rS9wZZ7Bo4ppdU3g0ATEsiv/oO9UHhpYFbi9PUxd2Vv2ZWDX
7HZ8tdVlEXkKLcvWVzmVgeCEyTbB4/9nGXtoE2cVTsdNz193oe9+/XBiQkLTLhu4
rIlEjdsmCw34MfJWg634w8i/gcsC7k3v033aEEgjii1nZAhIUUG4ZBCRIx3poNbZ
x6k0DeeZqrr7/Vo0io6LP46TA2RljUuvgUSJ1UyJmaraM05f3LHfYGdxQ5jEq55h
zBlEPI2UfI3TPc2sJ8y1mSWB0PsKROjhvZD3Mv4ANSwr8XKO1yE9TMviv351pKSl
8ZcIKbl3ZFwDDgvQdXMcTl9Rnc683g==
=4+IV
-----END PGP SIGNATURE-----

--p7LEaVjrB2dgIlwA--
