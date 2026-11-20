Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173686;
	b=XJFOPJEP8MrFcVnrrNwfZWzboILEUtTd3xPAUelAIQzul7fOWrIOSBKLi3pfy7xdUuUN
	 RhcwnHWljRAwIjt2fi6XcmXUDLw5h8p20twwwibf6G+pBj+1iGDlmKcD5zyMAt3QzF9Fe
	 ZHKeK8EwzYLNBSO189DeEJGZcGaU0IGUqoDfUtMrfDVTEeoyNj0dfimxfxSx7epog+3x3
	 A3zWHtD/Y9kIatrBIwmnqvuJOKt+37pBhjon6Q1jN6YmeEFm4HGEjN7y2mqrGP+iHcxII
	 +h6qUUQUVnybLdtM7eNzNEtaGovMJgRe3V0k88/bs1Quhw7QFSXUur6YuGeA1WeQGpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173686;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=uaVUnBDmxGslQfjIUf4HTYGbMGp9vWAbySz8fqeHtwU=;
	b=xggeOvxT1tN9Qbl5LlMIBxQhzPiEl5zuhPv8SgRobGcV8gQbX04KiYeHAQV2v1bGeUxu
	 YXx8ow/X3Dza6cGFepZNmsxkOro55YwKxgMR51RdiinKCqoM6FRWx1HDY9y6C3IH+TOLv
	 gMOUZefgOwKPKMZO0ZcC8lHO1g5UND/5BY4e5+ntrE5DnDmYWz+D+Eu2j0coExZJedT3f
	 1iblr4ekR7bySXKoXpyG2dEesAy6JLIuA8Q0lke/S7DQPwmYUSRkKH9PvFXK4YFdvcXvQ
	 pdMXGZu6NqXC38X+jziAAP7F2rU/iTAnlmDjwis5ouKwTU438ipOKZ6sfD00/doVvlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=U2Ur7mxu;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCFB606A320
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 11:21:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FCFB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=U2Ur7mxu
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9704410D007;
	Fri, 20 Nov 2026 12:21:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795173680;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=uaVUnBDmxGslQfjIUf4HTYGbMGp9vWAbySz8fqeHtwU=;
	b=U2Ur7mxuyYV2x/64e8Y1h2RIcKBxDnmmx4kmNoJQ/njxFt5y08wPqV4cGhY7nBO+W9lUin
	As7hQExzpWH6uo1fjf81FptrKjizPSCO7AsVQcvekbZa4XgchWYqlW9n7Yj6oboNGh7YL4
	KXAoj4Twl29Abii6RulUYV2E9HfijR++1JhDjcKYaMxHoexscpBWewYH7ctu88uDh2kpyX
	7ZBJsMQl5SeRCp+WhWRfVYJrb/s6KhIgzPB8BPFH7cROwmZfOw9tnB0XPxuA8Ti5eZpHvV
	p7Yk4AdYTUWjrOFS+jBGqKKaTDYiKHh6SKdFLfZ2SxlN3QTtdX939Rk7kzhcDw==
Date: Fri, 20 Nov 2026 12:21:18 +0100
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
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
Message-ID: <awAtLsB3yxwLMvUa@duo.ucw.cz>
References: <20261120055114.182757740@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="o1TDb4NYsGCEbU3P"
Content-Disposition: inline
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--o1TDb4NYsGCEbU3P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--o1TDb4NYsGCEbU3P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCawAtLgAKCRAw5/Bqldv6
8traAJwNpTOIMttVNVNSskazqFvQDURtOgCgvUiYLyrOHFOF2sxtaUCo0X2yoU4=
=M3vR
-----END PGP SIGNATURE-----

--o1TDb4NYsGCEbU3P--
