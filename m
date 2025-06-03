Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AEC54763;
	Tue,  3 Jun 2025 09:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748943941; cv=none; b=AtSTMVxce9oJkDmGTLAW6ksI3SV4fOsaLZTU/IReWrCt9SkHbQHm6LmqUTFa1cuEh26hh+eMs6NPsRZHicwkPoQGHUm41sV75NNIiCycJJFiw5Bz0EkDUa7P7gtRtAj8vsuDWbLWwA0yBvGXCHk0W4tjWv3SPrNzJehHHsRm8G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748943941; c=relaxed/simple;
	bh=iCvMXHxiA2qgEAPvWQqhM0E7rkAR/e+OuO1o5IdduxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmgTWJSMfnBQzyLMKEoy69XpPPN+DJKcgz+xTyivyd1q68xx8Mgr1CbLzRKKLCA+evkukmzxRIRkri6HKYRDjaayyp6EXHc2sBS5EobwVea4lT3AoclLMYsx9tAZ/ekdlrXHuKTk0LqOiQmQk7ynMJ2/kezfrN30/AIne4ziN/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNaqoOl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNaqoOl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165ECC4CEF3;
	Tue,  3 Jun 2025 09:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748943940;
	bh=iCvMXHxiA2qgEAPvWQqhM0E7rkAR/e+OuO1o5IdduxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aNaqoOl3KebbXvqU/Ts9faLHynUQB4wim3w/XcmHi1D39kf8VhNkMwQhHZyR53kHz
	 kV4ITOCa6i9qPdwKvMZRa+akjj9yo8Er18FIGhlai09URBXKXnPKSertHZuPmQL/ME
	 o8rbnWopgDwqmgcPTK6BoICK4FQt15j5r8kQfwBk5Qf2FPLjnjvRyx+tsp5IdIg1JJ
	 AV0o+FJn44CEOCb7nH7u230R/C+G7pJaJ0AfDAVArotlahCK6aG4MkTTrjPkHD5uvh
	 bjpC08lMAGh1p/0BHjfyr4CoUt2CahUZBZCeK/Qu2AyYJBoWSZypZpVOqcDk7UO0Hr
	 VQuRtoHEDWD0A==
Date: Tue, 3 Jun 2025 10:45:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
Message-ID: <6dd7aac1-4ca1-46c5-8a07-22a4851a9b34@sirena.org.uk>
References: <20250602134307.195171844@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0iTAqS3VjQIYAC1n"
Content-Disposition: inline
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
X-Cookie: Avec!


--0iTAqS3VjQIYAC1n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2025 at 03:44:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.238 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This fails to boot with a NFS root on Raspberry Pi 3b+, due to
558a48d4fabd70213117ec20f476adff48f72365 ("net: phy: microchip: force
IRQ polling mode for lan88xx") as was also a problem for other stables.

--0iTAqS3VjQIYAC1n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg+xD0ACgkQJNaLcl1U
h9Dlhgf/Y9EqkliRPIbWMWkUcwKCHQ63zfTF/8vSegPGW2jI/aIjNnlqxxSa+QqC
Desp7L/14lU9BNAVzlaNjE2dzVXluP3U9UxuDzVANHKRww9TRgjzpglUV2lnT0AM
UihkqBapjhbXK5wAmYO3ZDAApu37eGFQVuSqJ0kohddSlfqCai5Ce6wDaIPH2bJL
Q6kUEoOA+Zyxo9ZJInGPp227dbwHh4Zxj4rjFpKr6whL6HXrCcZXtBxw5YgzGmOS
xmSKSkpIo2DYFL3b5orj5fOE20+UBHxt4BZfiptkdxlIhgcMiDbY+ao+EEhDPRin
FshKmajlQebGuQfmUrJ7bFqAAm1KEg==
=+pht
-----END PGP SIGNATURE-----

--0iTAqS3VjQIYAC1n--
