Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152E51E492;
	Wed, 30 Jul 2025 15:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753889347; cv=none; b=pV1tn2l/DiL4t629SyW+fMEyb6rHvzywlPLkgPYR0pLKhs/aJiQgCT4J97pnXfQ3Dz3O28PSkv0r/69HLJdMyqAJdwl5xiQX/xaqkDeTaGsDoSsvw8rOi0uU2CSwnXxeRcWVI5g+7yVzyzY9uN1W69w5NxQ3avT1E15nuJ7FVS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753889347; c=relaxed/simple;
	bh=OgXBpaAsic4nMS468vahtDEunU4AdzoBhyfpgoQC/38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgcA5l+cbTu66+PjBpX9WcEh+JHzdH8JpxbBcdBUUA5/vECaJSte+IH8n4/FQcw8w+JfDgoxEQuhsjjzaGVUiQ1oCpduLRo4br82qDKfAuozFzqxFEYIvWNGc1GjGuXwyYjuWHYw2DxNnzItVb8M1OkCgZVZqMLsGy70sBWqiZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RdNKp5YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RdNKp5YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398DBC4CEE3;
	Wed, 30 Jul 2025 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753889346;
	bh=OgXBpaAsic4nMS468vahtDEunU4AdzoBhyfpgoQC/38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RdNKp5YOgKvik3i+Wv6NLwH2UxocsRtxEG4otYmdcM2stFn7fmXzrn/NIiAQgiYCc
	 e9Um2O+Zl80TMhDBvdg2YCYGuBgdwm5kNFlhLPTHyQpT0kNpbLtEDq4Gcr5CurdqZ4
	 IjovzfDudtf6HD43CHbLnGElAZNTwy2e7uD2idoeEBLYjSu5aROUzPxt4fEEIZCKwz
	 /NW0UJFGIUTD/DNxrMnIiegTJM0yFYmcNBcyccOVRrLhxBtJzTqj4RNdm32T7JPdhi
	 vJsp+pTKtXakzpd3KgZotFFs2lSENi5ubxeAAI/tp8o9g24lmISL0Z6tIB7fmw31JM
	 /aLe9FVjXJ7+w==
Date: Wed, 30 Jul 2025 16:29:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
Message-ID: <ec14bd9a-ef9f-4458-b033-0f96cd5daae6@sirena.org.uk>
References: <20250730093230.629234025@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YS4c70tu4ZFNYZXq"
Content-Disposition: inline
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
X-Cookie: Linux is obsolete


--YS4c70tu4ZFNYZXq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 30, 2025 at 11:35:08AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--YS4c70tu4ZFNYZXq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiKOjsACgkQJNaLcl1U
h9B1rgf5AV8NwF3OZmRhsYjvixuU4pUEIARJWK/8mWdOlja3UIHIw/pQjxv51ztR
itkKmABSprvOsjPKrQVUkbgzE3GpOu9OXh2nZilECYf+MMDuI5ml3C/ysXM0UJS7
eNREgWjviKLN7c0c9KCxHHMte1oZErIYFQhhvuT95LD53A6CsWC+CzvXjJe4c1LV
5OC4N2EzLygVcd2qXaM8ondWQqxafV74yQU4sNMf1lxHLF0JlJaFKS0CYrzsyntW
y95D/ukeT748hkrR4zzGiN9Bjq0fReW1bkSJdSpIGJOrnAAjWvljZlKwYQ09oREi
Hr8zDHZJVOL7Qs3rCOrR8WlytF9KlA==
=sO58
-----END PGP SIGNATURE-----

--YS4c70tu4ZFNYZXq--
