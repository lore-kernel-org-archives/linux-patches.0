Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AB1392C25
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 20:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319580; cv=none; b=Und8NhE/EPnSSWebKdfzJYQYhfRsDZOx4cNUCtUOR6gcAGRCRDA0kYanpQ6TnfzxB5qBr+czSdv+wPyElzlY6FUslYIkLjQHwt1Wm4wzUIFqHFhQdVHXnMOv0RwI6YbtJ5HbMZpKVwQ9hDLLFUv560U2Ld+l/gOTWliU/ETdVPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319580; c=relaxed/simple;
	bh=4yHnPQA5e9ypTCfY5wEVZhiOhzfDoIoUxeYeBCI4rWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqpEyWQTX1CLDPdYka4sBiJphRVemHnZpskww7CnPpK/1tLglgJ2RlmKar4LI3H9B3ej7zq/zLeshGdAq3ZGWzsrogE8ABsVOx2qkCb6GQWeD0SeX1d+81ZeeNyU4c4u+n8Q6EFe1IDF3Qs+mBzesFpeLFg1NIdZHteiP1Uapn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=QukcSADv; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="QukcSADv"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 57AEB11A35A;
	Fri, 17 Jul 2026 22:19:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784319575;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=pp8pgN5NGIwiMGGucyPGxLybVtOr2vHhj08e5dyKhhc=;
	b=QukcSADvZXAmXfg9Al7cufn2eioYIpHpAeBidLNgYKXSPdgww+9i3MsO8vZlGEsPD519kb
	CVz/EWn+iF3IhgRwSuu+C/jMEvySTrPbdyniO3ufAmfbtXEEeNWX940e07L2pJvcUSG+Hi
	Fwa1vW1Vy+ZFkD73w6LHUkn0cmCrv78IguxyRo0cDLIGT718bhRZkZpVkSN7TKB6Pqwy9i
	mQBhq6pKVC0d4kFcGvKc8XeqL1GPyYejb4MhM2uF3uYXqTSxeqgM9F2dmhjsGTE1Zzxo5i
	ZnJFLqS4J33ds6+jQilUCe9yjmT+gCqFttcOBt9TrUSwcvdFnLmzzoobPuSF8w==
Date: Fri, 17 Jul 2026 22:19:32 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/480] 6.18.39-rc1 review
Message-ID: <alqOVJDrkuZRHgrL@duo.ucw.cz>
References: <20260716133044.672218725@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5r/IYvq3EqoY+Wu"
Content-Disposition: inline
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--r5r/IYvq3EqoY+Wu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.18.39 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--r5r/IYvq3EqoY+Wu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCalqOVAAKCRAw5/Bqldv6
8gpRAJ49qvjAo1t2TwN23GAZp4avcgm4gwCgpuX4P6VKin/ofwm9CYYpHYwwLO4=
=c0/P
-----END PGP SIGNATURE-----

--r5r/IYvq3EqoY+Wu--
