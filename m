Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E06E1E1C3A;
	Wed,  9 Apr 2025 20:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229694; cv=none; b=P0fVOxPcTa5Fob0UVMjlYvyR41NUIfo9g2/nnv7V25sWmQKmXnCwVGv80aPs5zrPnFAcXi25A9j8kEbskyTnV4gQOTYtlLl0ls9rD18glxkSLngkeENQ7p7vFTa/sFsDSiWrOfZoHjEMsCvo2POwIebZZW4BFnfXza6gPDk8538=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229694; c=relaxed/simple;
	bh=gDKF6IDwCGb+nDIy7uvV4VpW5luda8n8djf7eCc0dCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UlwlabmlQafRyRD/++XHxrg+KHIm2VJkqWy+pm3sqFN1eTHo+MioX4wAgC41Rgc3k+ck5rYQNb5+hKTjo593vLH3KLkeV68HCPzFHEMk7FbWwG04Alesgs+xA1NNDi7toAWh7CINjI7hMCxYP8+RY/2mXp5UPgSW4FpmT7mY7K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ShMjsafl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ShMjsafl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51548C4CEEA;
	Wed,  9 Apr 2025 20:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744229693;
	bh=gDKF6IDwCGb+nDIy7uvV4VpW5luda8n8djf7eCc0dCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ShMjsafl5dtb+C1NDpZ1iE9pAMuKv3moGjhlo1mByhCZaHjU+7/FPtyh0EOOEO6n5
	 RPLxtOtfoeZP8MTYuUEqdV9Vu4MMLvUILaFnqt6TH4y843yKckpu5h4XuNrQpHLHLT
	 uAyGgLRj1PrgFQOg/lo825FQ0SHpHTn6ygTztGG61STdtDCNjRY55z7OsaFiKqYAOL
	 OwkXZQfRay3UUF4ci6d/MJTpGHBx+ktm2k0cTijLRF77FUGZ59K3wvBFPqMRhE3iIK
	 Nfy/HlKqpWf9Mj2BzZsv7CEsbtwlhXy32hJoK87ISPGsAmr0PjdRQ+bMddPZhrrw/M
	 iT4Q6JffL4Wzg==
Date: Wed, 9 Apr 2025 21:14:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/269] 6.6.87-rc2 review
Message-ID: <843b6d90-eeb7-4a6d-ac63-4baf36e367b4@sirena.org.uk>
References: <20250409115840.028123334@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zl/5xxoYAZyHqXnx"
Content-Disposition: inline
In-Reply-To: <20250409115840.028123334@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--zl/5xxoYAZyHqXnx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 02:02:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--zl/5xxoYAZyHqXnx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf21TYACgkQJNaLcl1U
h9DSqAf7B+ufbtDmYmsU9g+m4nmIu8cSlICDEOLeM4m3icqOwja2cEZcYnttveAI
EKTsHLGh4ThS+/HwAhpWNX1WawvV5i6RGHY1I58sZ49VThvgRUBai2Uanjk3XaKk
ff7mIil3RNkbP4r5wbbKMGR+9P3fnu9/urv7lTzOXhDCP7wXBBxBPbioRpOj8L8K
yp+DSpNQzJxFTyhjPkwqklhHXFHSXkiO2Cbi8FRZHnucAF17TYkMT3x8XZTYu8hm
yvIFPLFal0DC0+6tPawOyhx2dOM9tYMQgcwMguquy8zwrC5V2ZO0bJToQz0pMWPc
m1vahULdH7aRHOLbuG+cZtW5fKdSCg==
=EcyT
-----END PGP SIGNATURE-----

--zl/5xxoYAZyHqXnx--
