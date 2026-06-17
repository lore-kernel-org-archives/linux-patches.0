Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAE31E32D6;
	Wed, 17 Jun 2026 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781705256; cv=none; b=RV429CsEZB+WewiC7VON5qi3mlHJvUJA1w178ueje+0K9lXcrcyEQ5dEaVRZ19u6PW1BtJVRYZQGpHSr9Il/rFiJ3HMci6QeWV+2Z0nFzI06YsdndUQaHcGWk7aY7B34T1WcNa5Zs4GX0N/h3PUM2AzfZfcaxFi+oR2qupNoq+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781705256; c=relaxed/simple;
	bh=yvf+aVJD+/Ptq2rqsTYX2x9P09IW5EDooHhtopwJkk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFoCVpCbUjjJQ50ai9sEYceJx95XkmNc5RDsd0KW0/A2QnIqdVwMYODtBrFJ+YHqw6WQPQhDFsLaJB0ZL4qUxTE7EitAyV0FVS5X8QC52H0mblUM7GNsSy+qgjiCnwU7xG9PcJxTI/cibH8bGCmXS5v1PSFgrydEfsZMsr6FBo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ch3HY+OY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ch3HY+OY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99151F000E9;
	Wed, 17 Jun 2026 14:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781705255;
	bh=Iz3+qRjVW2r1uJNGxLHFf5ovKeC4xDqW7ujO9LN4qAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ch3HY+OYJVrBOWvADnfOcduZvXa+Uv3J26MIzsu4JAtdpDL8+BjdjBtmos22JPX0F
	 bzJuCVaMDjSL+Nadb5x0I3m2pZByDTusnTW7EzIaYlUEHOl8HJZ+h+qmput5l8TjcU
	 nLO9pqHqhfj1/sPmGjwGEefcB1L+RgSoAUSbS/MkwFzjwrRDE3zbBTgagDtxBnJ5Zz
	 cb4pkorJI/hZf5l3ZaRzo7pLupo2WGsk12YBAVuhjFPpwm4oSZqBhcgBqPdaxi8sDd
	 0PkSMBnv8vlK1JC1u7o4bHQXhGuIHsZ+yoiLtNV5lk0fUKJtxnioIGTbUzWRlTC4SF
	 qhYxclA/zZ6aw==
Date: Wed, 17 Jun 2026 15:07:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
Message-ID: <85832846-cd99-4a13-ad95-2272ef08b941@sirena.org.uk>
References: <20260616145057.827196531@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wLXcK03wNx25UkZe"
Content-Disposition: inline
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
X-Cookie: Absence makes the heart go wander.


--wLXcK03wNx25UkZe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2026 at 08:26:36PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--wLXcK03wNx25UkZe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoyqiAACgkQJNaLcl1U
h9Akywf/cwyYCsRUzczN+FtLllobfMbjRVr98UM0GdZXYlJ5nv3opA5z93bMNBNz
xGY5vBwOyyjrWxkRjxEAdvVLKxZG55Cj3IUKUPh6CtyRgIE+KMpVhmeMhKBWK0Rq
Yo4at6VuG5OG7y6c5sADoUWoch9RE8rSqJ4FerW1N3s2giDpJbya+UE1fdwo5VTq
7SWNJIjooAn1859gvhH4a/ovxUju1Vo0rAlA8E3ZNblr9Vuia5JYTZsTNIKKizzW
YvI2PbW57LQPY/a7hc1IlSSLPH+7GCEp6rfJ8SbFIfqcnBaK2ZbgF8HhSc1bbDRE
yAT6VGnTXY9cgWgUVVT9MfNRNlpnvg==
=18aZ
-----END PGP SIGNATURE-----

--wLXcK03wNx25UkZe--
