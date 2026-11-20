Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173723;
	b=ehDoLZLkLzSeyHYPnJUraGhXrkVOOejAolVKFy495n3EfpgjEWRkxb2ApjBzahNIeSUY
	 UnFcfoaST2aTHb1/KNSm7Bs2xVophgWsQ0+6mMkVdkPNd+bB+7fEMDLNOc75yQRemf8v+
	 rEdXiXoT2iPgTSLHvYFTSrBPXy18resz7+DxVVdJMcWwDnT2sfN3gzTzI4+oPY/12h5l2
	 sFU/voBTJwiFZMd03xY1PIT5aW/Kz1oUBcHa1XNrZ2y+O4RBJdKOeN/3Qm8o9JEm6gQfa
	 gkVsvFpAqjHr5VEWjsUMZTlGPgjTbZeN4VcDg7UeJv5a5F/09MMrMQcupqK7gsADv4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173723;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=3xcXQBXw2dwN+Fym14A8U+Dzj/UDkA1v49gVrTd4rNw=;
	b=0UPe5fdtm5adTJGiCJVsZlmpqJQR0KwqL8csz8uqiycNrlGADE8y2Cq+A4BIzx5JQJwZ
	 o+wL06xxwZMLEiFGK1plbnaCjBViYFcr94nZythIJ4YrpJ1cxHHLAeCNp4GcBooUheeCK
	 NKhLxN4gXQfYL5Fh2EUrT+o18n9TrarLkmghWPc5xNRfn3nICVBy20B72WPLOMQXcqqns
	 FdUXQ60cr46cmpXQe9kwIL/cF9bYb8BafgC+WzFPhEkUCtyH0L5USq6D9L8I84skRdL0g
	 yp0VXmOCeqgq/WgO+cTYdJugjfnDJ4VGDF4K2051AJ/K1irm2SbEMphnHKF2n985MXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=SPrbvTQX;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D633E606A325
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 11:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D633E606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=SPrbvTQX
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3879410CF42;
	Fri, 20 Nov 2026 12:21:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795173716;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=3xcXQBXw2dwN+Fym14A8U+Dzj/UDkA1v49gVrTd4rNw=;
	b=SPrbvTQXJZ1iKDnsn5mYhJnBGpeBJWJ3BLKfAJrQ4kqrHqtMmlhBkUJVw2Hpj1QnCz19+a
	sb2s4ts2hj5VyqxptyLAEf8FXie64EM/CtMbhfIIEp3Ad+YCaIA1M3AA3XY8xH6TAIPxH7
	VEtN88fLUU8isRiMTExKfCSDFmUmpzLV2v8oVjHLuu2MJf2rudRVFETNQQCrbIbsGKjdoU
	b9aX7Ko+2wm34XkbzU180KHpMvvJGnYujiKuiEUZn7UQP8yU3VJrJyqcQeiQprJu5QKsHs
	RCr2zA+W9H6uegPcH1VHILQ//XgykdYPptJH0APU+0xp7d/+jKGeYCW402z2aw==
Date: Fri, 20 Nov 2026 12:21:54 +0100
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
Subject: Re: [PATCH 5.15 0000/2178] 5.15.226-rc2 review
Message-ID: <awAtUjx74S7cUDow@duo.ucw.cz>
References: <20261120055015.328810133@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="/5CXrQqW+2L8BTE1"
Content-Disposition: inline
In-Reply-To: <20261120055015.328810133@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--/5CXrQqW+2L8BTE1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--/5CXrQqW+2L8BTE1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCawAtUgAKCRAw5/Bqldv6
8p4TAKCjY0+WUOam7VPEf3QwVNZY3X9kTgCfW5q9FZb8onGFs4vWEjkQdhS8pUw=
=IW4d
-----END PGP SIGNATURE-----

--/5CXrQqW+2L8BTE1--
