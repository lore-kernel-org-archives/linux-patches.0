Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF77EAD6;
	Fri, 14 Jun 2024 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718374568; cv=none; b=YQs6b0mZ9zYPOyjNSJeNSI3vKpH090hfnjs8TIDZdTWlqI86hohTmm4HSuSNRlVJN16gBEak/a5ASFQH+Dl50Hh6XopOcUqCLPoEQ3aiJ20tb6/ser8/6Dv3cCnMQ1igJ6JPk1VCIkm3UY+Oi0WAjRF87ZX4QT9Yzcr7C/3R1Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718374568; c=relaxed/simple;
	bh=u9DtTmYJXeuCvLChZQkpMf+7uXJ6Yu+NsPRruKduPHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s28U/wOymg9kXL243rDkD5aJ8O7nMJl4tRvam6mmCTfZQwCjrxEeaHrO1wR6H28X5idsPMyreAyyPEOnSj5qD7JrqIOR/0T/LII1Qho7yIU7YV4u5xGRfan1o4wMEvpuQ1n0ol83O7Pp4BvYkljovbME4n0e8SCaNp2w8MVCal4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dCn/GF/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dCn/GF/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C80AC2BD10;
	Fri, 14 Jun 2024 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718374568;
	bh=u9DtTmYJXeuCvLChZQkpMf+7uXJ6Yu+NsPRruKduPHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dCn/GF/3hNNMYVRfDaCQtgo12TJ38xpb73wHD83OYnU2eTOSp/xMbiyiembKrW1M6
	 sg4QWQRWTMiIhhwYKfJ/Pc2MSAVhZXaHIIwBTNYexMFhuY5+0wQf4pMByXJeipH+uh
	 8MGuNJKBPQ+tb7Rh/u6XixkKFD9urU7S4GsdrY1cXiLw9b9dClDNTz+KDBA5EY1SBc
	 nXwOs/J9weXBMhfoEmEhRhFiJ3d8buqoXI0IOzOXQzQO3v/URbYp02wMSOUGpxWgLQ
	 XLRpJ66k7iDnmr0KXJxsRR+JYzMijgMvznZD+VLDJdisa5LqepS5zmyt+rwbEbQZTc
	 gfzYD1eKNeLfw==
Date: Fri, 14 Jun 2024 15:16:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/317] 5.10.219-rc1 review
Message-ID: <ZmxQpRVg4Cm2qIDK@finisterre.sirena.org.uk>
References: <20240613113247.525431100@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VtzP+LD/juk/NzzW"
Content-Disposition: inline
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--VtzP+LD/juk/NzzW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2024 at 01:30:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.219 release.
> There are 317 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VtzP+LD/juk/NzzW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZsUKQACgkQJNaLcl1U
h9D1UAf/ZfdsZ2QlKqcsV03VPbgLmNLBPbWzCU+P10kMFdLXrCwPRG1pCn6D19RU
6QyvOZO5e2lRpTaHpd3Zu/DtA/onb5wG4tvycY2YO+a0BA/SKGs/8/52VFZkOclR
6KKZvlsgpZCbY/XYdMMD+H26qIpMx/meBAWE6tPFh4vWV1hFnbpqLjlj4j5Oy7n1
qrcW0OSFCF4wDK6tQxEJ8NXYpK83tetvDC8TKO12zhIGI3oqkbrx2WSvtaLxmW7+
D07blTCLJmDop+W+GCXgU1kcpZ5V3KQ0qDlKAZenh7YXTT6bfXD5gQ3kx9QlKTvT
uBOfotOrQiD+7wYZXuvLP3zKdqW9pQ==
=s+wa
-----END PGP SIGNATURE-----

--VtzP+LD/juk/NzzW--
