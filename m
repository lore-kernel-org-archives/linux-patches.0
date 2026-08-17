Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45A3448B86
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 15:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786982221; cv=none; b=IDyfr8oufx9m+9ldsnatU41r/NY330SycOaABVpo7yDhDNELDknDqtunTef9ldvLknsd15C5M37MKOalSPFrJWKcy+IRTvgQqx6d+aRXL3aZLMQbpbp3ThrtjRD3oHFOFqNlx5nu0ARGgSEgWW2hjRkqvKwPjj2VhquSt2sFwNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786982221; c=relaxed/simple;
	bh=mH3a7+MhpOP2t0hVgO6E+TTAZcJgRm2nPQLYbtoK8ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RmQe860hZrAjH5deB+V6TlmIdtybhUWW5mxo1KfW6EKX8I3uzfmigoSoPD3ySQQ2q5tBTop19A5MuyiGhdPOvVqhxBhonyhM9r3oKwJwU0gRqtqaKS4jg1ftxqC8Y+J0CJ8pX2FVJKZjhFqX+y7Rwod0NmYFrlC+WvAdVNtYqxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cO5yVa/y; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cO5yVa/y"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 915C711C1F9;
	Mon, 17 Aug 2026 17:56:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786982213;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Tw+9uiEU4bYYUBwAh5bAYr31QfTAd4G4yqkZVQsnCI8=;
	b=cO5yVa/yT1ompaufJFb+9p3i432olEBxA0KfzjbcBFpmAi/Af/FQLkXNzB+0hZXIEpBKBS
	EYOgFUBAyQX1k1f7Iw4LNBwkLU96WUxElfkoSvBn6/xv+IXmtxlYCViZ9vX82uBbUjkDmN
	iMQyiwaR7JpKkzTLY1AEU8c7loo4bxU165d1H2vbbXukgJ2974mCjfZx/qUGPnVX2KHwzZ
	EuMn8ejELUyM53YVNzXbR+0tfs+FnoeL8zi+dtylv+71HK6I09xjR2gaHl9rf6Ogac4oUQ
	9Iu9jC9MT+FpVpKEByn+VxDQ1vW3oGbsYVlU25FEQa5HOZy4TdKvMeJhHGJFvg==
Date: Mon, 17 Aug 2026 17:56:49 +0200
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
Subject: Re: [PATCH 5.15 000/456] 5.15.216-rc1 review
Message-ID: <aoMvQRKyDVgE9v6E@duo.ucw.cz>
References: <20260817132539.792407575@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oYLiovgRPL2/CuCH"
Content-Disposition: inline
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--oYLiovgRPL2/CuCH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.216 release.
> There are 456 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--oYLiovgRPL2/CuCH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaoMvQQAKCRAw5/Bqldv6
8svXAKCrkePHqlZ54GMcXdENkQRKqFS3RQCfU47A9jIBrvcU5263qeXRGGFmYm8=
=2IgJ
-----END PGP SIGNATURE-----

--oYLiovgRPL2/CuCH--
