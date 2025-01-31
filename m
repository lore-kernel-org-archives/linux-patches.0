Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BF41DFF0
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 12:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738328072; cv=none; b=NVDvpBK0m1EagXMJRehkdf0YrWmygqoGAMKq6oVEJoVq7+N2qqCpNzNc+9K4EfJ/F915cu64QHDZI4xXdX76ZHPEzEPaDL3NjAuulFVJeTKyDVBzF7PJNF0fkoYobNFvMSFQG0cAY0K0czrHcWVHphhwsF1qq+RLtESntbknWT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738328072; c=relaxed/simple;
	bh=qRE2ICPOuZEeY8yVZ7vexR8N9Ixk1jRpPdENg4r2e3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G98c1OVMgKc9tFs8yaWMBrujiD/Nlqc9gbTB/QPraUbXzROqkQor5fb3xD3gjF3iLna61bBkTgzNAaVXd289hXXj5XbRZZSaDHUmxufn9E5R6ZojlXjtVjOLHnDPdZPXF6pGf6Co1lau9juf3Bu1pmRO2gCpuWZ5npinsl1ECso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=KNfG/PNx; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="KNfG/PNx"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 50D9D10382D08;
	Fri, 31 Jan 2025 13:54:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1738328067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YiZso4P4ndJxEbddsdYHN3O4DXbAYma0UXhySd6OoUY=;
	b=KNfG/PNxWew7LE4VrK7BklCty0mspRirKqMTonAZtAsuxuzsStQAZUO9oToNTYPiNajfG8
	3yfYt8gFQjtjC0fgUTx+HqqzVuEjQURSeEdrEQEPPiEFR2k1RoHfFC8Cn0m4zaUpv5915Z
	Td8p12f5DHMbNgirnljR0rvlAhZz7NwR4ytKb4hKRwuEsP6siBWYb9UWTaPcjKrJgN/Iw1
	UM2LkxkPKzE1Hty2VE0wtKN5MalDot8iyCYk5QOLnDcuunQZotjyJi7pjvjJ83YY7v9BpC
	Geo3onftB51+xYsNQBcGkbAJ6FaHU8tdnruCH/dgCNXo4PdNtsu1RI7JaOlPNg==
Date: Fri, 31 Jan 2025 13:54:20 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/136] 5.10.234-rc2 review
Message-ID: <Z5zH/P5+j8uBklOS@duo.ucw.cz>
References: <20250131112129.273288063@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sJ2Py1zRnvgTz6uD"
Content-Disposition: inline
In-Reply-To: <20250131112129.273288063@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--sJ2Py1zRnvgTz6uD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.234 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here: (obsvx2 target is down)        =
           =20
                                                                           =
           =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y     =20
                                                                           =
           =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
           =20
                                                                           =
           =20
Best regards,                                                              =
           =20
                                                                Pavel      =
           =20
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--sJ2Py1zRnvgTz6uD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ5zH/AAKCRAw5/Bqldv6
8pyaAKC1lSVjSZXVrO8eGIFwc/7TPOth7wCgmetOpBclsed2wwbIvAaYiejoSS4=
=1gjB
-----END PGP SIGNATURE-----

--sJ2Py1zRnvgTz6uD--
