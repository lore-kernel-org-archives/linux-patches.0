Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022099;
	b=HkAodWrpBTk+h+ACtv+eEjaCJCpPrblmexOx5K93eOlJEz+ZRjKxiRun5Mahkr3qHBA1
	 zeC/g0R9q/a/3XbsAnnECvRaZJozAV63yoOTlNxxR9rnUyspJg4XREMUSrpOSeY1UAzhZ
	 5YH9wGcnuYMtAdhVQIdSykj8MihUhkhrSPysOAoEBoBGRrDNZ7fElfBu0CyQlRu0zeXPb
	 8/8p1HSAsb4Gr2vyQYvzi9c6FWgzWO/VlAy1a+yLJUzsZhBz6802tdSSyKAvmsRhZLtWm
	 EYJjgvsNiT1JBF0WyR3jxr7LtGBIpTCOFudiIU7ep0mRg/HEUEqMT1DW8e3Q1EGlTUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022099;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=bbgtcDoVMF/QPbHUExOaFjNAJPWnnDdKtqU2UAqaUzg=;
	b=rtCPPFWKQ27QawLZNJ3yDL2jpVoeQehbYF0ZMFUseaQlfaAdOd3DX3PRNJ4sVUNboACP
	 8TrjGxd/vL82ESRe4cJ+wQiI+NLIp4jZgO1gmphiLrcN/Fmces37IWKvS2SZMvq/KrPXO
	 YJjvOi1bTbd2SkhNlUUs9VoTZwE9rt5sjWnoKoBG8BQeSIKRYMyMgIsRFLDHLP6YPHG34
	 CWRf3eG6mf6dInALVTB3TeqFea7nn7NbZrqfaEOriLqLExNWaBpimN0H/8Gp+ijrMl8tU
	 T1eG0rlQ9G+1WEbUyiRv2tWeZvOLGb0WsdxOz5aXpd5RGiY+aqr81ZGhiSRevnHwCQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=jRZe7mGY;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F9D606A32C
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 17:14:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76F9D606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=jRZe7mGY
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 16F6A10DF33;
	Wed, 18 Nov 2026 18:14:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795022092;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=bbgtcDoVMF/QPbHUExOaFjNAJPWnnDdKtqU2UAqaUzg=;
	b=jRZe7mGY5T09x3UEc6+VkrkQoNarfY/lMyIxTYzWTHpRB90AUtpBaMyWORHiG2xycoukmC
	XGPUrdIBBuPRt9ib6n2sNoCIrkuTYBim3IVR3F43Z0GMXYWQAH8qOWAAA9fhohL1mWggy+
	QjdChAZFHJGhRODh4QxGynnU3rMCrNvDjihVziCc44IM1SG+hQU6dgFTSNi5Vgvp2sJhF6
	Y/IMgSZ2zcCBF5el1hzsVYIAVdQEWfd80ul7cbEdXIQKupIcWfT9AX/W9olmX/YpFesEnM
	uLitjjje2p0o60dZyHzipYrg8Ja68PNFaEnMqFka7jHNSY5eH0alIG9SboXZRQ==
Date: Wed, 18 Nov 2026 18:14:49 +0100
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
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
Message-ID: <av3dCX_jikgUH0oz@duo.ucw.cz>
References: <20261118150009.797899913@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="R9UF4ktUmYBpCif0"
Content-Disposition: inline
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--R9UF4ktUmYBpCif0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see build failures here, similar to ones already reported.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3084761653
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Best regards,
								Pavel

--R9UF4ktUmYBpCif0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCav3dCQAKCRAw5/Bqldv6
8uXnAJ9v+lNPNAwhYU+fLAshiMgRsdEpqwCdFBek2LBMMzK2+YkkSuanNn8Cw4E=
=rNBx
-----END PGP SIGNATURE-----

--R9UF4ktUmYBpCif0--
