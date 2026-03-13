Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75852E040D;
	Fri, 13 Mar 2026 13:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773407113; cv=none; b=qzPQnEf21IlQvVXLgUTA2p4sDsbvMqNzVIC5NNqVnyAybB4H7bRZfCwDuFI0szcZWNN+VeB4xZlorh314M0rX5lo9aN3WAQtug4vG72XwLEuC2NqzhFmSzciM51Y6afotDju90N6AQgy9tC6kUTLsfq4N7c8oHNrRGnJIxsjnfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773407113; c=relaxed/simple;
	bh=02Qz2Blpm4owVvlfAn97zUbASh+PlbTXPCnUAuOB8rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VafV3PhtiwAsXtVeHOWLyYHJkcFJV/DmKmtSP0tsP874m7AmKf3St6ICtZXbNp7xJdNnQTk2S/5IRxzLJS2yFFfdaIONeAtafmBMEjhYNKStoD318xRT2fC1wH2cXTJ8EOB6kpzEx/FRPEuGsCE6xcmtSCF61e5pEgWG4CkmQYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LpTdYjwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpTdYjwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FF3C19421;
	Fri, 13 Mar 2026 13:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773407113;
	bh=02Qz2Blpm4owVvlfAn97zUbASh+PlbTXPCnUAuOB8rQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LpTdYjwKwZQbpRMR6j6uH1kCCtMTCsK4xGATzGqYH0AoKcw4aGE3ruoXogJ0T56BX
	 ita98FtYmM+bYtKW90wZa1QTwXFdbeMXZtgJB6i666gUK1dt63EuH4P2LAhsznUlxl
	 xNG/CJFyHUIPqW98lJtEu+R5oUnw5qmHsVmbytrvrCTGJ+2B8wzSlG+0FQpp9POw2c
	 a1qePALdi121Wkv0EHm1DTjQ/OFYGZwNNSDkfPVdctEZhknzmXWIQgy6cDSTcjD+OY
	 yV2vodeGd9StQSurz8/ipBUEpXb9JOR4mG6UirTapFSZvmO/3yh7bW7TlP0CJ9wv6I
	 CA2UFne/DCMnw==
Date: Fri, 13 Mar 2026 13:05:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/265] 6.12.77-rc1 review
Message-ID: <d54d43c4-96fb-409a-a87f-fc093086ee60@sirena.org.uk>
References: <20260312201018.128816016@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Sj3wDGsBYrr482S+"
Content-Disposition: inline
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
X-Cookie: Monitor not included.


--Sj3wDGsBYrr482S+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 12, 2026 at 09:06:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.77 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Sj3wDGsBYrr482S+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm0C4IACgkQJNaLcl1U
h9D4UQf9EWMWwiYeu/WNMcDHbhSqrFtOI/UTJR2h7NzCUGkmVUT7eZ6W4FRPyc7u
T7BpBeAqKMlsNbo/R4oKxBHgWaBmp7D5wwUEsJWt26gDK+5dOKBlBCmqz4UA0b9W
olUOs41AzhsQFX8v4zygDF+5R7/+JUaxjboBIsCH2KjCw70dTsBeToSfu8Uc9IIu
t9jUcMbTAYAJOsWDDqaWl8da62PVH45F97FzFVX6Srwv3UVN1DkIXdhBHXwxXXS3
RJeSE2xYVpAqj6d6InYJOWbPHsQBTQDjFA6vESq5c/L9XmgjRMv8czBpYe4alI+9
AoTW69lKvmJEOrFpz6GBfFozJtIQ+A==
=tkhd
-----END PGP SIGNATURE-----

--Sj3wDGsBYrr482S+--
