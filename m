Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB12214A96
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744994774; cv=none; b=Zl2Rp+6iO40no8HaXlquj0135rH8cjcKhrRBcDHwrMUAkM6+qtiuApnbREU2oDIYWLrW7hOfDRSHFsbgwj8180AlCtX5LXtsFW/4PoN14NhbWKjdMWJY0JXC1a7SniaWQNVdcfDtq6lQ/sZ2Qg8CZ6mgJ8KY60bELR5ESfxhIII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744994774; c=relaxed/simple;
	bh=fH24bE4dwfXOPFlUf+/olVRNCkzpuNpmBABGQPIvUdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZIXbWz/tb+M7G6rJfV3PWcgKN1HOwDFserdd+c+KQ7FbNtljXMMFxrQrlBaYMlyV60JZyWu0U6hndN4TYI74A5ENGBvKOTb7F3FcOiU/6+daQBJ8HY6rZYo+RK17davMJgUSF/fJwz+UHS1GkWDqiz1IFRzN51uY4OUI8sLl6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=SWy0NpBd; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="SWy0NpBd"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4252E102E6336;
	Fri, 18 Apr 2025 18:46:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1744994768; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=tUP8AY3kaYPIAoLu0xw+IYDW6ceng/eKtdbV9czoT1M=;
	b=SWy0NpBdIgK2+4pIaJiE1CtrBlvf/WGXxAKquwIU8zudlWNfZIywM3zeiU3hmGdL2AQKMS
	JcvdCu+t6IZpHtk5Fs/vR7NodnMGqj1AMF3T3OfeRgyNaQE8MdRQgAgAofeYv+Qy8IgSSA
	Ll+aR1H/nonmL8vwHcswqt3sUTbfb9huqsOx4H/juV2fuEAJGlSE+PyBeaWQa+ssZ5nWS5
	NItKxmuN2doSIYLNxzPXjobEGZRy+FpUamMTmxGS7YEj0ZSzAh1r1tN7TzTlwNkYPnLbJ3
	CQNzQlAROup4h/5JH0nRn70E9sc7Bz7nMyQtNkctB0oxXyVfqHjucGeUagXZ8A==
Date: Fri, 18 Apr 2025 18:46:00 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/447] 6.14.3-rc2 review
Message-ID: <aAKByDU2Ow28fuN8@duo.ucw.cz>
References: <20250418110423.925580973@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AdVqRUXHox3P+QDa"
Content-Disposition: inline
In-Reply-To: <20250418110423.925580973@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--AdVqRUXHox3P+QDa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.14.3 release.
> There are 447 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.14.y

6.12 and 6.13 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--AdVqRUXHox3P+QDa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaAKByAAKCRAw5/Bqldv6
8iBsAJ9Byb+KM0+bz+3i8J7CHhm8Tf3D6wCgmH2DT3yM0mw/2OhR8XWd9EzFrB8=
=JsDX
-----END PGP SIGNATURE-----

--AdVqRUXHox3P+QDa--
