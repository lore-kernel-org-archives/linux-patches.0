Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF9424A076
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 19:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739476521; cv=none; b=nh8pCA/VVHs94oCJxdqyUG8raboO6vRPyeCY6Q5D84yXj4xStUPObQKVAfflOoe7ym/SI+Ts4bqs8/eMunl163XWfHTciE686ZC+sBJsMo9MuMp8jUBVkTbp7dewSoYxqzJNYsqrFj1jXqb4+suIcqBKufVCx1SGIr02Au6xhcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739476521; c=relaxed/simple;
	bh=F7LqE1URqCuGoEQFHUM1HVqLqGoB41rk2iUP9g0/W7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+7yjjhcGTQOLqfXm+0oUv77nehNPetlZBKd71XigGL9X9DHN3bN8pkJspgUVsrTuvPL7LuupOwcziS68PrGaxLVV2MJwEOtV+StYluT/rHTePmPfVbhV89gR1Svmtyp6+e3cKNPCDj9FyBDgvxf98AMivuRSsgaKxJEhG4Vs6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=cRduRGnx; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="cRduRGnx"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 43490103718D2;
	Thu, 13 Feb 2025 20:55:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1739476509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uwSpogVphSkIKxtS8Irhggq5O+LrKrQVqm3lkNYpHoY=;
	b=cRduRGnxua0U/fU6sNzJZhrcqX4qCqtT4Vxlmx82BUmH410Qi3MLWAgrsCJWD3LAdoF9SI
	wWIZSfDpWf+NFLHQWhv6uwyaQxb0t41CCiP58mZa+/1BLVY3Nm51YtOsC8kVngl8VJVNdF
	yVt3z3IYLIwvmQRIHJpB/l688XJoZynfbhblQtArHy/xasTkpcPZIrLZwhJmVHlzriTQiZ
	Bn0cpxghPWZDLJnGXZDK0DA6BwOqOAsibqbo7ZZoEYaDaFlzr7yuLlB5uAvfpfz6Vdp3Xh
	TZCeK1zTqwlTv6tu4rtL8cIyjT4a0dWlWG+AQHGpkK43PlKw8uuhK7LThy+nGA==
Date: Thu, 13 Feb 2025 20:55:03 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
Message-ID: <Z65OF7U5grQm3TR2@duo.ucw.cz>
References: <20250213142440.609878115@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4CVjw4G1ZCejys6T"
Content-Disposition: inline
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--4CVjw4G1ZCejys6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y

6.12 passes our testing, too; 6.6 will likely be ok after retries.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4CVjw4G1ZCejys6T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ65OFwAKCRAw5/Bqldv6
8rZYAJ9cFT/nMMToOE6xSZPJ35dFgqS0WACggMqWYByv/qlUBQWjgPFDUMjelQo=
=B9tV
-----END PGP SIGNATURE-----

--4CVjw4G1ZCejys6T--
