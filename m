Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4DC12CD96;
	Thu, 15 May 2025 08:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747296244; cv=none; b=YI4ZEPHdRxczdW1IMk20x3MgWn9FwX+XUaMiZTwSq4X3hkLHjkN6oEGKD257LRA91CL9qUrZvnGmlLmjkoJHqAG/s5+qZu2jMZAdkKcp2UYwdB2ha10MHHMmKReJ8dbihwsZXHoEpIQf54qCXORQH8T5aaH5quMGhK4gt3BMBqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747296244; c=relaxed/simple;
	bh=WmqB1+cthIKwEpGtMECz8g5q4Pu16sIckWCMguzEaTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlK0hyOZc15NeRI9hn8PUmxIO4lHEbUT/12gsY2eX/MxN5e/dIp4VNdeMescafXo5xZJyKevmBnUSyYk7wQOEHHnBGJ7K77lmbUiUnFOsvfSjrHvbvNh2QOKeNvKl447RYn8I/iePy6yuomee3Wa0A7v4pi8b1HemKEn9V4eYZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBm9Byqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBm9Byqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87913C4CEED;
	Thu, 15 May 2025 08:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747296243;
	bh=WmqB1+cthIKwEpGtMECz8g5q4Pu16sIckWCMguzEaTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gBm9Byqx8+B1s6DylV7uj6qPgIpAf6a5OggRfCkyBWZVqDQ2p5WyONmwmyUz6QE9v
	 namUu1Q7xzh97Rd425+S46wSQLov32S+AVY6SBbXh3lYG3oD68HeZxdYLD4Wl2yUMG
	 cTmeVXZRpDn20mf4zgcBrEDC858HGzF68RGNPaI9wj90+SXTT+FF/VFBxH+C6fogjY
	 71eJjDyIrIRlqqun4RUp1yUKiuOAn9fOt0abXhIlaOXnKjcFQbwL5Fvi8jibtmZ8OI
	 mTRfKLbl7BB3Z3m0dnv6Hpqu5T0TSGyNiN3zRKQlqtHxsEwhAApDmqmA7oowiGppbz
	 Ov8y/pbksE1MA==
Date: Thu, 15 May 2025 10:03:58 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
Message-ID: <aCWf7r4ZNqXw0Mzu@finisterre.sirena.org.uk>
References: <20250514125617.240903002@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aMyE9AdpZuxFQRjJ"
Content-Disposition: inline
In-Reply-To: <20250514125617.240903002@linuxfoundation.org>
X-Cookie: Well begun is half done.


--aMyE9AdpZuxFQRjJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2025 at 03:04:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--aMyE9AdpZuxFQRjJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgln+4ACgkQJNaLcl1U
h9CZ+Af9FPdXvM9w91FTbsCUW58ywAahUY/4rCcjlEOrWrSx4QzItz1mdX+7lNUh
B8182vS1F1hLw692Vzccr3vPEuWqd4Fg6uAQEDU3TNq483bWKv23JxXiGvvta+1b
50LwDaTpf50ci5yRyNwqtZ2fL8FfSIKxivPIYFsuHE9HG2tnw/wXA9ghR6/ob2FY
3JBJOXainddqNBedmModojIeN8YIF5oCQhoNIJwWRpjJnRTa7E4sCZj1B73RrH+1
YJsYxvzkbMkTbSCWBNdwpneMrrfCgyVy9IJVywh7ArdUzGRGXhDQT3i7feIxU8gh
2HzHq+63rTbcPXbtKDWFUAzQEErsQg==
=uwlm
-----END PGP SIGNATURE-----

--aMyE9AdpZuxFQRjJ--
