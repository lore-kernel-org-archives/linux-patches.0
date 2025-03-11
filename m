Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2162E5680;
	Tue, 11 Mar 2025 13:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741699601; cv=none; b=Y/vIYeZbtrpI8ogDtBVPHHu19AmbLUMOlkdlOVCozDJ9eiC0SbqIkWP5hfBXht142yFvUu4BKBmSC1cR9YAxzI3oZ00CkkqdjDX9R5eMxIu0YX+W23k/SI5heyJUE/XqZvHLOUXg3wToszHxrqous/uRJ9NHXH4QyK9r685+K3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741699601; c=relaxed/simple;
	bh=6vwoLYDEO0sclPWLvRykycYPWlixS3LqBxJsGlHWJM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAOiW40ByC0tY67yc402YdDhhfXEQtpg64KBNNHIqovT+Jb58g2lwX1xOE8Qg0F5WKuRe5zCnwQLZE0f05B0tippqkp5I6UbLXR5FsojzBEo5AsLnzIwcAvxdeXFLqqCsFVthes02Mbehz9E2ot7HUB3KsvIhu0iFl2ZEHUAOQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lo5NgzJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lo5NgzJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9859DC4CEF0;
	Tue, 11 Mar 2025 13:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741699600;
	bh=6vwoLYDEO0sclPWLvRykycYPWlixS3LqBxJsGlHWJM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lo5NgzJjYmOF9Cwwrf0cKvMjjq3nZpstoT400EUtgsRsM6sukQ9S7wWw9O3cVsI70
	 MbjWzLEYRf+CBWlzVYrXAoKUMQ7quZh5tCunbkw3q+CbLoFXFQ3PY2FGmgMzi3xdW/
	 nWewRV7nrtrM21QvxiW3ieytUH/Y+GYuQxzZdfBSxvK56TWCGRvrW1UezbGIP5rFtM
	 HOrxBXzs4/4PbOW9K1POFWp5iX4kcZl/hMCPyVvNjfNiyVgAE0tR/+iWdl/4aYz2tW
	 oxKlNBCjrcyKQWWt/5Jkdm1lu5WRfa2YBNdWm96+WOOb6VztuoCMyWzjbZ2N9mgNpt
	 5ZsCq3T3yyu3w==
Date: Tue, 11 Mar 2025 13:26:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
Message-ID: <86bbe03e-7ded-4bb3-a58b-bf5e3b5d9368@sirena.org.uk>
References: <20250310170427.529761261@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n0XCh5xlJfjQbuu6"
Content-Disposition: inline
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
X-Cookie: Androphobia:


--n0XCh5xlJfjQbuu6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2025 at 06:05:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.131 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--n0XCh5xlJfjQbuu6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfQOgkACgkQJNaLcl1U
h9DZ3gf9Gks+kHYmX0qfwt7VoCfZ+21YggJqANgsIPTOwMKOK5IwVqpImXRLwByy
EG72+U91YXKKfVLoqEx8yoLfgv0Dufh7NJV5IPmxk5SJkOXSZNKJsyywsDnbL4Wi
Bm1JXTf+WmdY0CUouUdB8WyJHg/qD5Mckp6GDyCZbZdQjAEC6bzvLzh03s4FPdDq
IB95MN/8wQUyoRqzIjsi1irB2zF42WyQIkL5mWMbLnsjuz0xiCC8v39R2L4j+f4T
PD3xkhx4E/ECp+rZFVx0qIgvmVEjJxTZ+6AscWw8pRu4b2QIZZF0nCObF53hfIqv
Ek90wH3sosf7EvFmDZl2NRocs3AeyQ==
=w4Xy
-----END PGP SIGNATURE-----

--n0XCh5xlJfjQbuu6--
