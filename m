Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13F335979
	for <patches@lists.linux.dev>; Thu,  8 May 2025 07:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746688900; cv=none; b=Ypn2pCokMMcnl1/PD812qiLpUo7Ovyin2P3Lg46brsrd5tTJe5WTiyPQ/B+mcpATVQTXAHfUrLiy0jES/05woOwnHTCBe+hSh9hhpbLE7pehmGvMg2OX3pMtCjdYVX/CA89sYqWbFTFGYQvBfVBBDzjki8kHOgAPjGCZwKFnY0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746688900; c=relaxed/simple;
	bh=qOL4f2RLgXdT0YZtzSq18pt7Tjz6EdjQmZUJNqWd0C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxwlBcSzxSjzu3mIi8g72gfHNHVBxsHgfjJaA3s10o4OtVHdsMFz1McYFX4X+FqQR50/YP48EmcWdq6TYmTHD83PPJXoJjNgBfBg6LrFuTfCJYgeSIA3PyeZex3eFb6rKP/PWg9WlwOQhejZj9xRtoEKFZqVEFfVoP614ideFQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=VvybIIZk; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="VvybIIZk"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C50B21048C2EB;
	Thu,  8 May 2025 09:21:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1746688889; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=GOejZZWpJJW9i/GHDXx5JBAadvGplXiggpnweFOOR14=;
	b=VvybIIZk6Cvfa1+PlXVzZXxt+pkeFN1Nszn06RjFb1EpChFfH1v1Re8vj8ay5M24/9c+9M
	RluS+7W2nA/LXodb9McWoNYKyRajrwW54EDIOcpqEaBQX+7tkokA5B/jbdQy4k4zb9HS4A
	Qa2ZkKN/SmSE8u4HWyG2rp9tIVfxVfOxT0ylrFSYbQBybOliQ2O0QRC3yjd7ZBLsHtf1Ty
	TRPympJbbGp6k6/CWjGJBrkjY9q5gUV+mGl6lOO1kLRfN4Yt5rgZfspVLqoVm/+fwCrnPl
	/IHRKs9TVNl08w46X7ReY73P+y9f3k/WRKGcQ8mwyvVe+RDVsT9rzGVqSSq6Fg==
Date: Thu, 8 May 2025 09:21:21 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc1 review
Message-ID: <aBxbcdXqPdDlbDk3@duo.ucw.cz>
References: <20250507183806.987408728@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ncjxP+XKsSaL8wW"
Content-Disposition: inline
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--9ncjxP+XKsSaL8wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9ncjxP+XKsSaL8wW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaBxbcQAKCRAw5/Bqldv6
8jCDAJ9wrYyVga0V5sxo4rqJBriSe9CvKQCgt+XdOqQyNzBUBhVldUKDJz2utlQ=
=MpRQ
-----END PGP SIGNATURE-----

--9ncjxP+XKsSaL8wW--
