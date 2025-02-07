Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F1C38385;
	Fri,  7 Feb 2025 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738956920; cv=none; b=tE7McQT3iWsZ5954T1rMjAIT4TWV0xSNBOv6uVkyr8pw7/23tNpBgKysvNaRMY2I6V+CJ6P3wGgZS9HTO2R8ov7yS9D+p/lP2gmCpaYqZiLy12aKGI+LG1OXdawvqZqRzQXE9VbN4cHv2eEHsjTqLakMMVJ3GqGx4AINaXjfeZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738956920; c=relaxed/simple;
	bh=f3ZKx9CKgA8lQv/4Qr1nkP6SIDJMF5UZ+LLeqfB0vR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7NCRoovMofd9M+DQGCoIFVGzW6Grndmus85MZrL+NOJWRItqQU1PILXXnsBnRbZPmsz9Xk68Uy3f0xFYG3Y39KX4BnD6SlaE5ZkzCCzWsZp9nm/MivJ83Yz5dSjZLMLOywz3hkAU3/N2tw9viQwCWCPec3zS/kprmsPHnmK5UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCX5L1qC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCX5L1qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A981C4CED1;
	Fri,  7 Feb 2025 19:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738956919;
	bh=f3ZKx9CKgA8lQv/4Qr1nkP6SIDJMF5UZ+LLeqfB0vR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OCX5L1qCaPYNjQ928vr+2Z24Gh+gu1eeaInmHFap8UANrbN+R+pYFqsyUUj/POqWX
	 dNbjcXIX87IpEX75Dr16H0c241GJwPQ19hpXVsM+LXb22rm31emkAIcz+ttbQFh0ra
	 KrVuKBMmg9lGEoHHv5WwZJBelQ73qizu8QtnCxA0eCbfDhPeAh+Ak/WtbCSVP0EpOU
	 y1vo1YKBSaFCWtsi3PldN7pK5i3suADDb2bQZYeY9ylro5hl9Zx3VnjUZZrnN53c9U
	 MzTRNWT0EL3oZ+lXO4pBaXXbfoSQzenWGi8Dg4maeB8PuNj2UIWV6h5GkznFSy4k3g
	 rjjA7e5dJoz4w==
Date: Fri, 7 Feb 2025 19:35:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
Message-ID: <12c2c464-e182-4e2f-9a7a-e7a675b37f4c@sirena.org.uk>
References: <20250206160718.019272260@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3u7ad+VhdG3v9x7u"
Content-Disposition: inline
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>
X-Cookie: MMM-MM!!  So THIS is BIO-NEBULATION!


--3u7ad+VhdG3v9x7u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2025 at 05:11:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 619 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--3u7ad+VhdG3v9x7u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmemYHEACgkQJNaLcl1U
h9DhEAf+NxD9DCqCGbYUVhC4jSmzW/3MwSxgz7FZ2eahW0i4FWN0BD6fmK+kynOp
hf/w5yY7tFxbL0T922eUhMR2cXGwh5dCrE6P/ex9xjCnCccogGVWbbh+mTxCoSE3
nf1VnnmS6eBekKUyBmrcxMSu2NGk6tpl8vU7lpVbJQl0CZ9X6d6inKbgEBR3xSZA
8z1skAuWGstx8F1mmiqR6wnNfFyWUV8URA9mlEIKRsZDnwmbjqm1R0mzTviN4hb7
NDlvWMbECwBqjBMvNhtxgT0+B4QWKpHehGLbEflPIGdY6aqJCDclGwwrpgYknWOj
deF+OHAyrxThVNlO6L/IR62hGfAYmA==
=1t5d
-----END PGP SIGNATURE-----

--3u7ad+VhdG3v9x7u--
