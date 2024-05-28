Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8A1328A0;
	Tue, 28 May 2024 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716920424; cv=none; b=dH0pqCg/4xJW1BydLKgFoTW1+PBzVU/18gfCS37p6/+UFss422GeAAKJnx6uL+MfyTBQ/yE0f+qjWm0u9mXHOWH62H6EFWS0Mj99eLOG/w4jwUbBkSZyrpxWV253+a+Pfrq5IeaOlKlslI11hGJu7SG4loM72TAGU/YMM7YZs9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716920424; c=relaxed/simple;
	bh=42E4r1VKm0B2TmehB7K0UCqmgkW9B1ISSl44r7e27/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfIzs1Tyf+MDDI++z/fWF2euRD/mLjW7sBRLmLb6L77Bhnrj/wa7yTr0r4Laq0c2SyPaCJCjCqUXvZn47EqpwpGxxz9bISj0+iqhvxL1r2CxXB4PfeGnjssLXuyswMymaGYRaG8NJhH5MVn/30CTjn3E0z2ngUUXNTOw6flr1Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTp1GK2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTp1GK2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93C5C32786;
	Tue, 28 May 2024 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716920424;
	bh=42E4r1VKm0B2TmehB7K0UCqmgkW9B1ISSl44r7e27/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTp1GK2hlDZ7iq+riwTqYVVdX15uKuvV8PjUteHqu7zjRUy72FTFz2Fyxi+B2+FdA
	 hALfw0Ku34pkTCp3NyfjPAESt3irqYIxezfBoaE8ttai0rLUkgGWqI+wZylS1hjkEm
	 kk0ylDMhZE//yhAQEKhv/v0yx8H65LTFkWg8XN45CxaV3/F8oDavD4AWq1KTM7Frn9
	 +9DpIubaKmCnNvuqzalwnSJfmvef8I3wZQDjwv9fqGsjnGESvK6vpcGjyGzXTH+C6y
	 WT9TFvyEeynAhK4OKF29OkmwgPNFB95fDAWj/LDh5jWhKYPrRWGVPHt+FfZYdx3MUV
	 zSA9tRrWWdn0Q==
Date: Tue, 28 May 2024 19:20:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/427] 6.9.3-rc1 review
Message-ID: <4d2d1b28-bb64-4d56-b24c-c42a87618ca2@sirena.org.uk>
References: <20240527185601.713589927@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/YKMmMF7xefc4Dsw"
Content-Disposition: inline
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
X-Cookie: How do I get HOME?


--/YKMmMF7xefc4Dsw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 27, 2024 at 08:50:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.3 release.
> There are 427 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--/YKMmMF7xefc4Dsw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZWIGAACgkQJNaLcl1U
h9Dt8gf/djWNXSdKlfvoalK12t5vQdHk1nLX5PlWlrsU0n3Gg1BrTtngq9YX5377
XQuSnixXOQILWAOyA7aVqL+stQhv+So4+4xd2Vu6CTYqxk4Y1QNSf7sjcEvvrYF3
bOGuZsxuHvL/225WLRD+EMeXMyjIz5Qd1m9uclWTIDvP9rT03Et2ZpzSfgAxp62n
9wJ+y/hG+RM+Y6yRV4M6llRcppqWL9ZfZjni/aqkqw6Hui/tmlGO5lt1Ygz9NSYk
IFHrM7fUW5X/e/OHr+QSPQUOBX3PnsL6XFzm9HPjgPQdZWxwMMgyyDUNZIsJbS0m
uCu/n4P/OJ37cnvK057aEoRL8pHS4w==
=TUA6
-----END PGP SIGNATURE-----

--/YKMmMF7xefc4Dsw--
