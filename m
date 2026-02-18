Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3967335076
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 09:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771405938; cv=none; b=gAYwJcAz5ZoyHeMmHEPo8X2aerDvAaU4B8TEwNelcDAj/k2skEVcx1rdnApSPfpT+LGJ7SUtT9ytScbdNBdIPNU7asodx7RJPsMDPYnpj46VYCYSlynHJ7tqFKJYRUzjDHYmBx22iLXUPQr29l3peCt657V1TcUO6crmB2UWYTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771405938; c=relaxed/simple;
	bh=7LTwcdDkKoItAY1ybcWsBLvvKlo4101auTdJMWLa+6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXkZWY9HH5yrN2QQNKshbQmZQoQJmcdWGNr8rZDB6F1K5gEs33lFlk5mc/dC0MAHY+MTYsx6NfyNm1NH0EfUMnPTEXIo2ByD8UDtf6pcI8iPwUlBkSyHkzpgcsuQB7EBjLjptG/+fojnJD6FnzCyWORM8P5pPqsuh/KAJQ9K3LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Dr1B63EZ; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Dr1B63EZ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9470A10F3EF;
	Wed, 18 Feb 2026 10:12:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1771405933;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=G9EmTwZ+X99gDzhQiXJz37hRgQ8zCJ/elTWPFu05Zq8=;
	b=Dr1B63EZYKmjrAYowep9ruuEi6tsZ6G3rvgziqRXxe3UCkanTkqXjGV2kNdzIiQmCcIujo
	iIi5gfWZeIuiOTvc2SuX1HMbZXNf6dhv0bo8bYTFhNg0d5gr9cS40kJ/MukBZz3If4QttA
	KrpuBDUDxt2w1NEeWeU1JWr2NL8UH0/bdKqTlOgn/4ZzkcvaOQkmEVVzHELLEYqu4uc632
	Tag8ktpmYEBlj913kWSH2Jkm1kBRlsMCU+YqdrXwcZzJsU/e6U5DBt6bhM+BcWX9hBDTjO
	F9Z0Z+2+LSZpbfswfaYKak2FZwj3VxvbpPv4pnNA6AZpntdgVE09AC8SLX1ttA==
Date: Wed, 18 Feb 2026 10:12:11 +0100
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
Subject: Re: [PATCH 6.1 00/64] 6.1.164-rc1 review
Message-ID: <aZWCa+HOG/wUv9S4@duo.ucw.cz>
References: <20260217200007.505931165@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mqy9qYJvtkEkNlm"
Content-Disposition: inline
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--7mqy9qYJvtkEkNlm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel
--=20
In cooperation with Nabla.

--7mqy9qYJvtkEkNlm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaZWCawAKCRAw5/Bqldv6
8kJ4AKCZUJH8qbeyAtC2jPUZA/S99nfeCACfQWBz6xI9KYUg7sRtcxG1gEVM9kY=
=Kxby
-----END PGP SIGNATURE-----

--7mqy9qYJvtkEkNlm--
