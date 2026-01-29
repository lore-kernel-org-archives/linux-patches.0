Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB563542C0;
	Thu, 29 Jan 2026 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769709013; cv=none; b=kDIBcuZafTPibq1ravJVC9ZgvCbMWHNTUs5uGt0b3YqoqGpNJgDJqSpWAgEUWjZbaiwUHEgfED0iTmnas4U03Cjr/n1UCUFwEayKxT4AV/6exBVsCseEWvqT8cgMHBqU5wLBjbNqMPqhtUujgTjRoDissb0X38CIknoiyNJK01A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769709013; c=relaxed/simple;
	bh=TcDfY0IaV5J+JVMxRWachBLlsRtCsIdWTSjRoR8piws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eo/bdcvebiR8hS2IJeNpudp5AE187BPywLTB81pkc1X4NXJvRwAA9jQAdPxnRked6In5UzQS+rI7uG+ZwV7at+6hglubxvV7Y6BbrKRuNG/zToX3nWex6wUGCJX7XIFTW5el9E97Pl0fFlum7/laoo0VogGgrhSYlwgBzrK+6Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7vmUR3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7vmUR3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78439C4CEF7;
	Thu, 29 Jan 2026 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769709013;
	bh=TcDfY0IaV5J+JVMxRWachBLlsRtCsIdWTSjRoR8piws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E7vmUR3nj4JRhmu71VEt5VPYUJjNc9yJcEvZmVuVgVJd8T9S0HOH8NSKfBQGszzQ+
	 RVURIXtaybxfeC3/2pgpvdrz+sjMYsUGJLm2RqJl70bU8E9qM2LaToUYnz6dLsxoGp
	 gI8DVf8YNw67EV4tBk4ch4t58fYMk7aOxpteSNKwR2897bz5FHknFW1o8hL8krCz1T
	 aBgntK2vp3wOhAcGbB1pB1/9vT5wzOWYY9Up5SuwQsDw5szQtAToQNthXpA5JhbkGm
	 RjEexawCNyA6R2SPJ55kTen7tvEWyiqYNBbSO2xLQh3ggwYwIEH6cEfkAAEjtdUTX2
	 I6nf2ti350hFg==
Date: Thu, 29 Jan 2026 17:50:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
Message-ID: <956ff656-51b5-4ff4-9dc5-3b20c71f2984@sirena.org.uk>
References: <20260128145344.698118637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EMV2XZYJMgHz38Eo"
Content-Disposition: inline
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
X-Cookie: You have taken yourself too seriously.


--EMV2XZYJMgHz38Eo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2026 at 04:19:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--EMV2XZYJMgHz38Eo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAml7nc0ACgkQJNaLcl1U
h9Clswf3SZTxLEcVLdy0FzrNuVXmDoL6wWRe9TJ9PuP3K6GuuG7xh2t5u9X2b31L
qx4+RS5tdfdYpyRMBvR9Py8ayKxIXC13IX4HIMCnOS6/xDcZ5j8SSEk6h47HGexz
2H5zULKcdqWdaun26RgwZZEgS5scOBZ9ht1LUGKgjVQmQSSLvXdHIcjt7X3VuEC0
vtwSe3LssrqFIyn/nmHouOALmruL2jjRxtCtZnI7z/zT/q6PjPS3D5/WTSZIBd4a
bslpkkYkR/yBeZkU84jd7fakJzPFgc9GhWAP2l5aDLPVnhKmkpriNHzBp0eCXPM0
UtvnFPb7eiqSm1Tv0nwh1OWZ7ruV
=eR3k
-----END PGP SIGNATURE-----

--EMV2XZYJMgHz38Eo--
