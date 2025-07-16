Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C017C1E1A3B
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752674231; cv=none; b=Mfldtuhwlf3sRAK/FFnEaqcikwW4HN35Cq6GcQluAxvPIwFk8Lnw0KQZS+xCZiIjqoKLDWZPdOnlBBzoxy49L1wInS8PNX6hZKU6fDYYJCaS+Mq65LUgtjlkaNXg8pgDibpgFM9U8Qs/+WjXbLGL9IGao0gXJSEaj//YHoyRBs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752674231; c=relaxed/simple;
	bh=IxgsdSDisGkC73OqrECjv5t+An4NHtS5BZMBtvoxKg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGB70RjC7JN9s28qRvqNg4oV0W/YlNhmGjFsf0TBvTuRuUFlnz25hlqXhHEDcOhB+szde9061NR5gNLLhjwnOeal8xyLVFUNwowpaoA8bT6Tv3BMJpDB+g2lpM3tzUklSoipjP2Tyt3fs7mx2B4GQMTTF8AG+G3L5bAUEXQiyW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=SFajuM6Z; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="SFajuM6Z"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D10D81027236F;
	Wed, 16 Jul 2025 15:57:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1752674226; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=2hjQ7BNc1y2qDz2+Yge14wa+g7Ys3P3s5T6m+/jBYO8=;
	b=SFajuM6Z/r2vfyOUhG/JVSV1Q8+SKKsMHdI9iGSGxDTcTLeIHOUDphkE0DwXK25vwwFBn+
	rCwqwVvTW4aCpYs2TzUWkX4zk6I8TKQFBbYd21j/kg9BTnGT3mVFibAq0Y+kqsaB4s31uP
	moTw4S5rUsbA81OZLkQAJzY4AwzczU11wsW3v8BN573tOc9XKtFRV3G+fVC7xmD84nt3Ny
	/4ckF5L2Dulf+7SL1qiy/zHS5l3C5qjHkFrV4ZScTWWtop8d/28499n9IbFCSk0pOyBBkU
	wNU+6EoDonI0/DwkeU41BK6bfU2NXLjpW1E65Wa5FU/fV282Ej1LF1CgUHicZA==
Date: Wed, 16 Jul 2025 15:57:00 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
Message-ID: <aHevrBHvSK8hgAim@duo.ucw.cz>
References: <20250715130814.854109770@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rbIai+MW8oM1v/GF"
Content-Disposition: inline
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--rbIai+MW8oM1v/GF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.15.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

We have some problems here, but I believe they are test problems:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rbIai+MW8oM1v/GF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaHevrAAKCRAw5/Bqldv6
8s7/AJ46Fv92Zd1Qfqh8ip+VGsCKdfPaJwCeJrIdDBQW7GUk6QBkmtveFEbBWr0=
=CEfC
-----END PGP SIGNATURE-----

--rbIai+MW8oM1v/GF--
