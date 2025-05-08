Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756F918DB02;
	Thu,  8 May 2025 14:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746714298; cv=none; b=ASdHM3hAHi9ptptmRtWnU6w5v7N4QDFqhVBZ7LLrsJN5le3SOFZJwM+ycTXzR1ErJi1ZTPJizDra4m7kPrVQhJEYdy8XqQ8kEegjlXkqDG9fNtCiNeZQUpQR233o2Zj38WhxZjXKx6P5/5g9f0+ZkO9KPjVxRGS1rTvjwuGjzQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746714298; c=relaxed/simple;
	bh=Vdi1Fvob149dmqTchXBuaWDmd/TVJPaIImKJVQ/mqSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ta2B+sii0b1op+yoPDUIXKHfNZfGeCZiWx5IMgBbXHsPuBbV35uoZX4H0EltQ8hVTETBFatFFcNKJNR2kwoZhcMaGweGVzAQjq2GZgvgIS7PI9tJ23ume0hlUBcG+SjIzCcTOhk5gkEt5P7QyVg2wPlvTc+iDSXZerjPCxeFyZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcSH3KgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcSH3KgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C36C4CEED;
	Thu,  8 May 2025 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746714296;
	bh=Vdi1Fvob149dmqTchXBuaWDmd/TVJPaIImKJVQ/mqSY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YcSH3KgK/5TvNlnL2uP4cMl2KGTLsf0aQzrQ6+z5GF8eAn5nIB3TORBg3hPIC450s
	 O/yyiGvY3DxMMW/H89d7FNJH//bMMfEk7SNUic4Hy3GGxEP/9h5zuh3Z730pOzLzAC
	 8oATpkupoYVkG6vFlkF7piAg7/TlGE4Dyq0DojLrlrP3L3Yue8pLDOudnPl0WK2u+g
	 5b/OA+DemvffZXmqG0IRAJkNBX2w2GVnOQwuW6Z0neEZXeQJWxr0B8DuDyU3AdMkIv
	 DG3oVm5AHkKtIKkI/gTybBZ1FKuY1xrYcHhrZEm1xDqKiz8vBvfQjqr5wWr6KHMjPi
	 ypzebBI1olzwg==
Date: Thu, 8 May 2025 23:24:53 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
Message-ID: <aBy-taLf9h-0_4iM@finisterre.sirena.org.uk>
References: <20250507183824.682671926@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iuHOqhtFAq6wT/Gc"
Content-Disposition: inline
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
X-Cookie: Well begun is half done.


--iuHOqhtFAq6wT/Gc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2025 at 08:37:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--iuHOqhtFAq6wT/Gc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgcvrUACgkQJNaLcl1U
h9CYfwf8CGWgwryJ29G7rgSi9Z5M+/t1KzkmRJII5CWkeR94K+FSE1X7ENrqANa5
E74+RpZJNyLFYogMQtWSXe4LIh2QI0jaMF9nR/Av+Pc2qyde1jc73D9/fqwANUGz
AiD5t9eddk+8mnYnHf9Z4E7sjg+GHytjTfFExXpEyzF89PtqdKoG3zVm2xf4UJER
c5sg/ZFZm1uIrQ4GpqEY6yHFrK7VSZeSyKChlupFLLdxfU9LxjnZ3vU8dreKt3Bp
n+lv9OfTIphV19hEI7GC1c6irw6P3qNHh+0jjfxJueesTZEwfNJfySXbPFNVnubP
cgLFVEYh8H8HYR8cL1d7hJUc8xjd7g==
=tKdx
-----END PGP SIGNATURE-----

--iuHOqhtFAq6wT/Gc--
