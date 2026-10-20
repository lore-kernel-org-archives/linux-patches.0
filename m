Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792493094;
	b=2J7vlh/IAiFyEHMSI6MmLHAqFsqXG5Gka22MCwlsWVSirBccV7P0kC+C0FNheIzJQiat
	 6P68wimFVvmCRZczHUNT8K0lAF46akbd0hE29pHb6kol4UsTfJ8/YXD5VVqLXzmRojUsp
	 lhMoCjrbNcClpuMg5b5AJYWQfuj1S06tYidkC0PbLzkjeQl1KRRi5wsEPi9Kj9womaHwm
	 4K1zTwo8UPFpHR3zsCtjHMYcIKUQGwN5pvxWkvOrIgEslGwo1mM9FGMlJjInJN/ARKqdB
	 iMrYcfs4wfI9gv4HX08CUVAwvLD/VcTbuRsUQRzyv/NaoBOXBr3111S1zJvBdV466LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792493094;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=bdJJB61QYkq9ho1geehldCQFWiuq7JKEc41jyjNyIL4=;
	b=T4LPn+Bv9LUeOYYzJIyNqTXwk4HkzhVA2eaxRbDeq5FoaoMRtX6Ri8fhm9FUUNfdgVUb
	 ta1UlniAClPIwwWjBlMk50FkGMxkMU1nmcfNNuWszDEIhTy3vGw6kP0w6P9V2kVTnXt04
	 SIRl3DbpLfx8Sf5L/xJ1UcdIXR09yAfm7U9DQ4bNkfFj3hv+0g6s96N+kotCXGopIxeZA
	 OrJUEFWDbQCYCzMfRWGPcJOSTbByjtNp4Vr74TJkZ4w+KQU014L9445VWWir0EErZUA1M
	 NS8ie/lMwadIreM0A8cYnb5DzIfcRTnjYN1wUSCUxuLfWsniztjQ20lrQFpcO48ZmRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b="DCOO5/22";
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B586606A31C
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 10:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B586606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=DCOO5/22
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D0E3710A191;
	Tue, 20 Oct 2026 12:44:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1792493087;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=bdJJB61QYkq9ho1geehldCQFWiuq7JKEc41jyjNyIL4=;
	b=DCOO5/22Gl9KfNSqwY48J5lKB7WtjuIhPFeLxra+LcYvjDAYexZIxbnOlRSlyOKK6N1SET
	QYkJHOB9Ln6w/AW7reV37FO1ikbagwR72dy7EQXw47OAB2xifZt1o2BAfKG5W1V92SDDgY
	oi8vYPgkj5scj5SEGFszAAzMV0Mcyodeu/pdlF4vJFf9FdRK/WUP9OszcrOc9WH0smUIz7
	OpBBXTO1MHt/b+iIZOC1FW3RFngwaxN8BK8ugR4Zftpg6AC8dWV4dEz9lPlvvSe3M0XLfG
	Uh1qbKxGCY7DpIzhQDsJgQbc9Z8Us+wsKvF7BU/tYPaqvAH1fSzyd9iDcFbgmg==
Date: Tue, 20 Oct 2026 12:44:42 +0200
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
Subject: Re: [PATCH 6.12 000/858] 6.12.114-rc2 review
Message-ID: <atdGGiG2IGBo036a@duo.ucw.cz>
References: <20261020075246.861837975@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="1zhbme+XSnVkHJxz"
Content-Disposition: inline
In-Reply-To: <20261020075246.861837975@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1zhbme+XSnVkHJxz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.114 release.
> There are 858 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--1zhbme+XSnVkHJxz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCatdGGgAKCRAw5/Bqldv6
8ivNAKCrjCkUaH21SbegCMc2Yz9wqx3J3QCgi3A5EZqXQUJOhTTUJxQtjqEv0mM=
=S7FM
-----END PGP SIGNATURE-----

--1zhbme+XSnVkHJxz--
