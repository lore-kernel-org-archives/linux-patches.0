Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F2B2E36F3
	for <patches@lists.linux.dev>; Sat, 26 Jul 2025 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753552925; cv=none; b=NIEM8LQ9ds8HlXnLQ0ep2Xk0qLyiYNdFmcewo/6vCqsaJP5zs1o23IDbHvGQ13iScWLI0Un53mBoxgx3f6oYl1Ka1pxTSnwgu8qKXxJB8cWmkDtSjLy3R+2DNBCXfhSGwrwFZbQ9KNHdvgqx7yP5N9I2YPcJEvGlt9FuFVHd4X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753552925; c=relaxed/simple;
	bh=9imcgVkJFAnkQ9CaISTdqtlgJnIAe8FDd3QAjmh4R7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EJBXKLRofgWI+++IlzMt0ekGxazbkV/WQHAauaTlKAYwWekJ7kFnbxhQugJ3/Lp/22rOM/AAZ2a6ZPvunHrVGl4kExFrCJ/p/Zs2wnK6RbDCy85VzzivEjfJo8hoNHJSWJO1I0DF6+adBC6IK++9tLpXnojGn1cUDXLc1se2bQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=gtqoGAv6; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="gtqoGAv6"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2301910391E80;
	Sat, 26 Jul 2025 20:01:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1753552921; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=jODPDo9JJ8Logbc+uAoNsqOkg/CTmX8MO5DbF0onVEY=;
	b=gtqoGAv6hO/+RURG7pKxFbF80Zh+G8Sm6CQXB3NjldAtKt81c5+/Kk7lcWNW4TI+fjSM0r
	LhHfU/P2BroMJpvSt63GYcRaRCJLlYeQIKy5/UmANo81CUlISw6YWQWULXmJFVf3IgXkq+
	C679Pto2tN9g5KGSyRPHYDvo98yjA0WkSsT766xy0EneYvEayZ/4duJRYEA0RkYeYTjsnA
	xGFOnIWkAiiOzO7HkHiVVgyMArEk+nxUSiQHs5vF1LLqUjLtKlaFP2y43Mn/A8xE+Ycvwn
	rCcO7NjN0SJcklj5PaSxySOpNGFDNkNmD1PPXvvi6DAX/MacpmAp/CZcplsYXw==
Date: Sat, 26 Jul 2025 20:01:55 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
Message-ID: <aIUYE9giKYqsPRdg@duo.ucw.cz>
References: <20250722134340.596340262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gw7fSz1fL+WRlY9B"
Content-Disposition: inline
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--gw7fSz1fL+WRlY9B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.40 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--gw7fSz1fL+WRlY9B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaIUYEwAKCRAw5/Bqldv6
8tkxAJ0VmNux0+LENZY65wV9tUwvmriSRACgm9KMBg9k89qv2ywx5irrKWmeTCo=
=/nzo
-----END PGP SIGNATURE-----

--gw7fSz1fL+WRlY9B--
