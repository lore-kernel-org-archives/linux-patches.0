Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA522032D;
	Fri, 27 Feb 2026 13:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772200098; cv=none; b=BKxkxEbfwxwrCQl8bW7llhpsb9Sd3Dizj+/u+pAQFHn3xJNyMavXF9jVEj/Cei/3sKIijm+duetiAogHSbq+JZl/mA1lX/9BIy2McCmbw5FhmPUXdPjJZq2cvvw8TSOu59w6DyM/+yL4ujElw9R+S39x+XGEK6ms9OsKAhKwJ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772200098; c=relaxed/simple;
	bh=X0tEx1WR5SYlW4f9YDV0oUNmnUYEUt9Y8zo+T27LgHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFlNga9cGV4b0xGBgth2WLac+2Z8Ee0Qc69k07pAZFn9q28byY89vRpkhT7r3luvTZs7BWePwLIki/6g1DT1osOYnt/XpoaHhRKqKmyL3JI0chr2zf+M5LuwgiukNZ05KIbKTAfYsMWaq3x71T/4cSmVqJJ5EOXZiWKluZGcle4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1+DwHqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1+DwHqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D51C19423;
	Fri, 27 Feb 2026 13:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772200098;
	bh=X0tEx1WR5SYlW4f9YDV0oUNmnUYEUt9Y8zo+T27LgHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u1+DwHqj024bZMEgJBKDno4Q8YSMNFdXwLH7PvpbYV7ECon5HbmUrWUg3hUi4dZmY
	 5+aGo2JXgt2FfrxMmpc+Kdt/JK21/8DAiyJsOUBuhPYuEWChNeE78oQhdoqRpAPUxp
	 yXnqSmiopIXX8kDfMS4tMz/D791A6IkuYclLDzkxpDea6kYjfn2au0vFIOiA7ZijHm
	 OJE5TQ3Bj0ZxcOFxEGzzJrSi34jDcnE8zfMDLCsLpkS1CD0y2Jd4BYpNFE7hnWD0mL
	 nEc47CFjjEllJ0ZwQek2VVQnWCDRz80tAPMKzMMiO+Bfg9G1fNTFnfpF6RSxUf5iEC
	 zoy2R+BnIp46A==
Date: Fri, 27 Feb 2026 13:48:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
Message-ID: <9449ad6d-acc6-469f-8c02-53752899f5a6@sirena.org.uk>
References: <20260225155341.094945851@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HgzRSqGZF3cPNDd2"
Content-Disposition: inline
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
X-Cookie: Only fools are quoted.


--HgzRSqGZF3cPNDd2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 25, 2026 at 07:54:11AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HgzRSqGZF3cPNDd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmhoJoACgkQJNaLcl1U
h9BJhQf+MXleuICEF8j7KWMA58n6vylT2GuixdoiXzeH1YcB6TKVzc2npuiZr0cK
HWXwJM3UPhCxcoSIl/nbD9aq6tiJ1boh9sI5w2dCWrztX0FdpWEnA2yYCevaQeUf
8TyziD60oqhFqV6iXTglW0Rs75gk1JG+uTaGx+dx383aLiKfd0F+YqovoOdyZf9A
8kaCkxEz9mLQq/gRofF0vv2YJSfipNeclcNe4E+KaO8iRZNpgxzEVOJ5YV1qa2hE
ci1XfT0q0JeY4meLyfDovuAfDRKaLsnVeuQzcCwxN/JKFioJv36iEiSwZlJGwUDb
ucRImoEdRK1EyTlSXunq4GM/NXx4BQ==
=7X+t
-----END PGP SIGNATURE-----

--HgzRSqGZF3cPNDd2--
