Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217887;
	b=iPnRPw9H9/x0a26DED3PhXiZ4goZNqAbxNDM2w2EjA/CEKwxoX8ocNkKHWEqc2Xb7I1f
	 0n5M2f4x6pFCnFjXoWPur1/d1OSpbUCuo9LliooKtE0gnWoNCkFuqZ3Id7b3mZCWHVo8k
	 MmDU+y/aLEowKIHXkIX6FM72LPWwsvX0yXe/lU3pagaLkGk4+e942rY+9L9XGz4WmjijT
	 YlwMg+hthjqySlQHNZaCVJQbSNnatscuscPQw+rQ+euPqphrDqp8A0Shvn7tYzsDzQWtc
	 m/CQgrX1eVe/ZJTYPCrFoxPxxxJ9IhflAmBYwOM6tP8lopr67q8QJa0xs7F8nCZpNJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217887;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=ezNOCMrbd9p4oAuHMi4rq419vdcjfc42j5tDoLcIzx0=;
	b=W/blJLnnu0ePxM2EVaHAJu/UeongsG6fuPILoqr+dotHFSdJXZRNjl+aUMCTKNsa8wou
	 yyGBGKQ0BYMsm9caV7V6XRQ3xtqyuq7ZAY5OUo3TonLf0vWT0q5+LMYPghLi3gcavwe0/
	 WdoSG4HAMxqgqazXVBBnnOgx2dUMAcgPowT7FrwN5hXMSnx7Efr0q/SM15eX4B9iohiZq
	 8tb4uNpUgCQC/gCU00Ga/8nbpC32XcKAUM1XgaGOY9SBAYG1WDPgEMWKC/qyBXNEU88G6
	 kuldn0IbAABC75xDsp1tgfGoqHUZ2Eccnu893uNLOZFUs/L/jOw+OH+n7qkGqITd2+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=gN76syU0;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0AA606A322
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 09:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C0AA606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=gN76syU0
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 69BED10C082;
	Mon, 09 Nov 2026 10:51:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1794217881;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ezNOCMrbd9p4oAuHMi4rq419vdcjfc42j5tDoLcIzx0=;
	b=gN76syU0YfAf3f/w5NXJuxEyDjFVJqGz7hNh57wHqHYRaQhJToc8oGBXlQs51gkFi0BkXk
	Cw6E3HtIbFJqZt2UY0oyV6HQB8oWhP6caXyYn7l/0ucZyxPX8r32dw0Py7C4xsbmdpMzjd
	+t91IbyG9R2FOw45pIYP0UuICiFdNjpc8wZojDDMoYH+k+pnpQyusbDs0KSmikdsXL8aqA
	nQvzuwXYN+jhgjb6qo8152h+9KPDlfGUs2abxwScAL5gp81fNglevrK+mtY8+OVGoLC9wS
	AXiqWK4wgQw02yeBQTjZERlnBV+jJwALAtR74HYpn9D/HZN2hIjKKJx0qWUPCw==
Date: Mon, 9 Nov 2026 10:51:19 +0100
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
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Message-ID: <avGXl7Uy2PkEjPhH@duo.ucw.cz>
References: <20261107134939.434104957@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fMg5DBF/WS7L0yPR"
Content-Disposition: inline
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--fMg5DBF/WS7L0yPR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.3.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--fMg5DBF/WS7L0yPR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCavGXlwAKCRAw5/Bqldv6
8va6AKCebkyoVCc+WnL20xljuFGKvNL+0wCfdEXXnne74yZJryfDUneVvvzL+o8=
=s0/j
-----END PGP SIGNATURE-----

--fMg5DBF/WS7L0yPR--
