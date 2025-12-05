Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0BC32F76C;
	Fri,  5 Dec 2025 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764940611; cv=none; b=pOoJZSEnxYF4Nr3T89T0Keq8MVY9QQXPLJeL5Ox4UAjq4MuERB6MttfgO8NDmmyIpRuJdR9Hqhje84IioOf3hmwS3QCIyT022HRaaiuD7+MWynDtSnlGiaJLvBAxo5/kCnXFJYxsNNNuAJsW4wiKEl7VQPUed+pF6w4xp+d5qLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764940611; c=relaxed/simple;
	bh=1MI15Aur0tUqLueQoySp0xm9nfDuxDBSeNkbmK5sfCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0tyseM3vS3TKvGOGWsFQQhCplkuw+jp3jHY7iYmswWMXG5FcF68SUM48I72VoC7wZETu9hPK3GliJbB5yMuUmXah2PB4CIMS7uMAnv175xis+xkEgxWz4W5hkofoIFD9XPbys9s0G9/FT/K/oKmL09pq9wZnp3CzVYX/r2YRxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nj6kL5GY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nj6kL5GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC06BC4CEF1;
	Fri,  5 Dec 2025 13:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764940608;
	bh=1MI15Aur0tUqLueQoySp0xm9nfDuxDBSeNkbmK5sfCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nj6kL5GYoe8IthsoTXnvKTtYfCc8GPT4SzACn5lKggxL97eO5jjCPwQ4vtuGjh9jY
	 Yt6AOy98dSEaY4u0m/g6wbJFE98RU87NSULBnmvRsBgEjzEeA5RCUkE2UtidAWIauD
	 +R5Kzf/IrLTX5r6dgI9BIHMpTwv86aJrZr54DT1w1nrvgAXwfiJNaWl4sFgqO1oovW
	 inf6Rz4ez7+J5l+Z5C9c9jVOBOoxxrbD8mEZUudQmvTi8fhpaDFl59/soALSmBk6Kh
	 30Ejd4WWUNODWQJT4h+NwxudQJN51FQqmMaJqInYNpt8aU3pn5EVYJQ8nqdZZfuusx
	 AF+zYzLcDExPA==
Date: Fri, 5 Dec 2025 13:16:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/295] 5.10.247-rc2 review
Message-ID: <2a08d448-81ca-4954-ac9c-b84137ccd8ea@sirena.org.uk>
References: <20251204163803.668231017@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qdw4NLvYSwmm6/60"
Content-Disposition: inline
In-Reply-To: <20251204163803.668231017@linuxfoundation.org>
X-Cookie: My EARS are GONE!!


--qdw4NLvYSwmm6/60
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2025 at 05:44:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.247 release.
> There are 295 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--qdw4NLvYSwmm6/60
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmky2zkACgkQJNaLcl1U
h9CiuQf+NHnGifn1NC6PVEbetCzsnoEm03ZPY8rE7UHOGxMCrNatcpqOye1Ih+Pr
o/q+3zk/dCBbussueVrom9n6JSb0/u9XqwthK/HkXPZEqKl7rMGRgaU09LRxyg/O
Aolqgp/aoFidd27mCy2zDRsws5aGbgxgGGqcYLKQvmq6wWPDZsRpm8B0w1StLQ0b
YlLlfwqOTt9jAqAMP03mQQygb+MYEKTVA1hnblDLU4ktEp35GMjXB6yrqPnpOEWR
uwiBvOToCdRv8XkOANsQaVSJ1hX6xRHLUoPZvjX29KofpLbr7ym1321Id1U3t3Cp
LhiMMcrVQLXc9gyd6eChwCh5yVvcCg==
=+ktT
-----END PGP SIGNATURE-----

--qdw4NLvYSwmm6/60--
