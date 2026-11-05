Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793892620;
	b=KEvLb43DtimOWZEd8GySTxhFSK/WB/1CMevHhUhoDs9V+X8CLEeroJFekcUTDHLT5MeZ
	 Noh4yIVJp/+tuOq+/lrww/vNkgNyUa0Dixvmou0XDXxmYKGNA6bY+W8jwR6FOUTCXDO86
	 zs8pdE3gxgSrWkG++EaHcmQE4RSoJ/6dl0AzEEZjA0zdtmmvRH5aOH4LSRAbCUSacNPkV
	 7/MOzsWTkq8jAUb7p7drDnwLie74XlhvUO8ePzyJXN29XWWDd4xWUFt9DrFn6qvyu1186
	 ZLNJANirPqlhvG3zXQ4O8mWj7ueqkZKssDrMt1irhpIbmlOmqT0kFUvvZEqxT9kVF/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892620;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=dR1D0mKpwqt5+k3otoLJdwlvTS9lJAMZTSK2BtdjMm4=;
	b=OexNGPcIpMWt1Zz/HBt1ya7T0PIt0IaG41M0RXgz7gqfe4uPivSqOe2Az2fioxgU/MXc
	 MCLdOlCBFwgrUYN7DS7aMNTZvm5T9UHD9qYGc6TQ60M9yDyeV93KYTdoSWHzkleezXodv
	 HWBiVK5rU5fOhkBCFtwOocaEATMyBxiPwsYE+H630ZQivyvLSScDpJXhpQvDwOfh8mY3p
	 ex6LG6PBtWkZ3QAlWlRchlmNJ/y74rb3lbZbfMmb6kf4RZmpxQYCaHp/bhQX5cg6yhGhC
	 lQ14j2F07+e5RmgbyWr3+5NI6l/jJ7d9OQJON9HWiaxpJLLDWbTpJKzJ0Swfovw5I0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=cfGwFD7I;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD22D606EE8A
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 15:30:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD22D606EE8A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=cfGwFD7I
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4E0E4109A73;
	Thu, 05 Nov 2026 16:30:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793892608;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=dR1D0mKpwqt5+k3otoLJdwlvTS9lJAMZTSK2BtdjMm4=;
	b=cfGwFD7Ix+cjvM4j1YUkLdfsPy3zWwCqTJqtU0B1ohX1nIbyWbH8f+tjXJxC7tvHp3BMp6
	S4uTRIFptpyYKiHtSyyrxagK5Fe/JshqjTSM9ZZpj1c2MkAe9eWDXXTHVgueKccvmaUfYf
	yO97P206p9/qnvIwHLwxdf28qCNHTsOZ0hF+i/WA/MCsxrhQfKVYJI8ksNViEQU+3Mg04r
	nmpPMwL+nwUwB5pDwmLawkb8sZE9LPkW5CochnYTVAcnnuStcravjqBNm5OZkWurW7YAt7
	Fk5v5vxyYv1txsmnOAqnr12m86wOM68w9SJrS8Rrm+w2R4X9ggzEXcRjzS/Wtg==
Date: Thu, 5 Nov 2026 16:30:03 +0100
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
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
Message-ID: <auyg-91iUyD0I80a@duo.ucw.cz>
References: <20261104211043.516122098@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="EmtiC/zCCuB7zuHe"
Content-Disposition: inline
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--EmtiC/zCCuB7zuHe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.61 release.
> There are 1005 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--EmtiC/zCCuB7zuHe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauyg+wAKCRAw5/Bqldv6
8oT5AKCm8+UYNWW5XvRfdDYFfVR9nXl8HwCcD/DYhxSOVxxLYYvwrC/9y1DwFK0=
=Hplc
-----END PGP SIGNATURE-----

--EmtiC/zCCuB7zuHe--
