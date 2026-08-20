Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198BD30DD22
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250717; cv=none; b=ZHLjo1JBzbrx6NZ+fAHCZXGJLZk8YlkxSyWf3Wbt3n0wmA39Y3+k56p1Iz6OX2T3lZf+gC3D53Da8fcz3mzUzNww5lniW1vfiMjihHMyzpY95SfsoNYJyCyUJo59mT78A8hB1TPHxPZaL6MdDdeNCOX6s423aA6cwV6qkcn4DWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250717; c=relaxed/simple;
	bh=3q4eiFgLMI07qw/T+lyPaiWHSWXsFmfmAU/cA04Ah7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mID+C3X9Mo6zJtjgv/bcBZQbb7kpMlXm/1uFOM1waKeCVT/Yq5HT7NKnT9R6R5RBZigsjZjtypQX5xxOwO+yKBYH9VjVImFdrzr2Wn6/svSCh3WimTPuigA1RVIhCZZKY2YkrugK+rz0XYV0JpVMX7BliQKB80f7uOiDRkPaa5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=eDsYigLX; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="eDsYigLX"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DB77C11C61C;
	Thu, 20 Aug 2026 20:31:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787250709;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ANW+ojGqIUeyEZdub6PRDMjOsHxwa5MSEimwDwJ2ITc=;
	b=eDsYigLXUxKZ9LR5Tiv6dW5mK3UHBuuOLUfD4we65yVDvEkYMOTWj2G5bzhH0uAkTh9Or3
	abNAyPV5/cJ1zyjlh1P26kSF7f/otMbapO1S270gXRYGk20muf9jIO+3oFv1Y1QiqfNwWp
	Q2DcvMdEpdKPLny0KEgdWxdMfueUsnVVKSRR3aBD9dsrCsWetqz5xdKUsmVhtLhjDt+dof
	TNfLA53Fg1E2l7r4KCS3ALHN3wzkv4EtqhEHAaTEqaoXRDlrIkTuo3fEYCkHsYYakvS6sX
	LCKPP7pU7QpKJfehwGI2fahj+LwHH8HEsgsT/Q7n7GJFkVtdhxLD8S8zoHPYlg==
Date: Thu, 20 Aug 2026 20:31:47 +0200
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
Subject: Re: [PATCH 6.12 000/220] 6.12.105-rc1 review
Message-ID: <aodIE5lfeMHbyHje@duo.ucw.cz>
References: <20260820145223.480031205@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pS44aj2Ll/66yqjQ"
Content-Disposition: inline
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--pS44aj2Ll/66yqjQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.105 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--pS44aj2Ll/66yqjQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaodIEwAKCRAw5/Bqldv6
8p5CAKCyU7xvDp/tZwz8gBpT7eiIXshgpwCgwrMi0TEGT47JymscMO8Q654Cq24=
=OlAJ
-----END PGP SIGNATURE-----

--pS44aj2Ll/66yqjQ--
