Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D95E2EB02;
	Fri,  8 Nov 2024 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731080734; cv=none; b=Y7/UvtoLRTXC5sdalnsV6Ic/oYKn2tAd8ZmJq4FAkOCv/FZuZucFZaGPbmgb0NsnNxM3yukukWtZZ58ZQorPzRq9x5AATL+b2uWXmEKhDo3vvNuFF71dLDmhhoKu/EzLWcC9i8acRlu4K68xL/TanGhonP5oPYD0b2bP91Erdxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731080734; c=relaxed/simple;
	bh=cs436ItmcYEN1rvbB621TJdsYfZ3/4xVhLho6N8IGoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImXKt9991eWiPf9pdMqUt/FMpyekmkFfmQZTMOasKDZlBv1pY7aN12263jpwFC/Z/67F2ueyqsaqq7yHZ7aKWO4XKw4lqVeFbPGTUPLDFtzrQvmyYQHqvYaS41AuctItcuwfGWz53eNutvOu8CbF0bYpRPz26hmOWhqil6tp9bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=toc7v7OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="toc7v7OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40277C4CED9;
	Fri,  8 Nov 2024 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731080733;
	bh=cs436ItmcYEN1rvbB621TJdsYfZ3/4xVhLho6N8IGoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=toc7v7OTLdco81/w6pTQFNvhjlf92UfCG14Olx+FphXn3EVG3c2sJ7mSlf4cg3fRp
	 ccUsM6h6HrOXC8Ugq02KTRcFkTqB34tQEq1G80kJxhmKi1V++0u8MyOxsT/mG3VKs6
	 vKzxnp8pWQoOZMN1W4AvLJDkrEl7M1zEazmJ7V+tEO3WDClZKg1JY8GV5+dw5Eisvm
	 m8bSFeAd85qANI7TL8+LJhbLJ/VS1AqqzDvTpR40mp1nxyhffS3sQcJ+7S+hKVmdFE
	 SoD4nVX7CA7cyK9Y5VrLsvOdlyEhJriVIrsZojg5vryBBskmSR0ulqVQ3ON/M/l1Zx
	 wFO974l+a1GKg==
Date: Fri, 8 Nov 2024 15:45:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
Message-ID: <bea9f018-d9c8-42e6-aceb-cf8a8fb7e4b4@sirena.org.uk>
References: <20241106120306.038154857@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5bRavnsfeKeBJiFa"
Content-Disposition: inline
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
X-Cookie: Do not overtax your powers.


--5bRavnsfeKeBJiFa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 06, 2024 at 01:03:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--5bRavnsfeKeBJiFa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcuMhYACgkQJNaLcl1U
h9Dbkgf/ZPauhCvqnK9/AwrQeC+PFvlOl5YI812wcplXYW2mwmmQFUertmQaI1gH
ON9CDCNS9s0g+VieZKXGNxgC9m6fPXXbr3+0v4njxjj+fOeUxRptxNdeFDnuJmxC
vFR27SZCzBq/UVjElrfVZtCLxmcOdQNl9pi9ad1tp8xZSzklX/Yio2G74Y6oZikv
Tj+cewarHzvvcY3yXaOAk2rKpJ7xM0MJ5Jf4zOTPsD4TaXjtNvj8uLUEizoFRXug
Zd1nJyIEoSnV+m7iBVm9EalGZVUdj0rZq5y9c3vLnZQ1qr5C1s3lg6UotGNcMXPS
rCv/BZFfll2ExAj7esrB6DdTll0XyQ==
=/IRG
-----END PGP SIGNATURE-----

--5bRavnsfeKeBJiFa--
