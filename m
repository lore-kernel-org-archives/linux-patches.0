Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2550339719
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 08:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783067454; cv=none; b=s1FFoFNSXtSAZB2efYoZvZ3vDTJOEFX0eqkVuYXkNWJGXRwsipe2ZVbsmO3NDngUhnzuHVch/2KICLmRWFWD/lwZya6puEkoOnmVyXP3cIyLdfi4REOSdurgf2/zaYqsrhOaWNdyOx7sflw/H2rNDLwh6SQDg/Ci0WVo+/UipNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783067454; c=relaxed/simple;
	bh=hwsyZm1/G34HNtLQtbkaqg7zowOEukBeLR58BGiVuHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YbyBpJdtr8DF8mu9t9cBtcU8KwufIbBdy3mFAmwbYVMpt+Qspv2C4kRm8Xz/515Rb42m4YaJihbFYf3HTrP7qL0/XQ9kuE6svE9EJ8OF4IWsjgee2EcwcecPHWkfYWcZApSTWPv2vajr1rVT7/GXgElZqllokFoVV3vXeWKgp3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=TQ5Q8Q4x; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="TQ5Q8Q4x"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DF78E118BA9;
	Fri,  3 Jul 2026 10:30:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1783067450;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=f0itF6EjDNn0IXyI8Zrp57euAIEQlqO+V6SAHn2ccBU=;
	b=TQ5Q8Q4xjVPLGFZRXCg23KDvD2iFXRi01h2sNf7gP81/DF+keqn7W1S1VAbjHpMoISNh9/
	maxUmU6qA6fuy1TXqPaH46fr3rhNW4WIp+W1XYhBKkkvrHOM6LsEu6ZCHBD3C6rNlmpx7I
	+SvuBRKLVwy/TSjqDP1hTo70coCO+XfC1t7xU1W+fyHiZJ/zWCTADZlhpcO+Ke0MDfa6C2
	94kBDvS10PVL3neifJtyf5bnbMG208Hm6wMseLby4sx0e3/GVoOea1GoxwLuD9EE0sDVMI
	+tHnUScraACMxeB/z/RDd752I3CtPCqu6Vso6Puus0l/UdW633wtJ43gvWdLqQ==
Date: Fri, 3 Jul 2026 10:30:45 +0200
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
Subject: Re: [PATCH 5.10 00/96] 5.10.260-rc1 review
Message-ID: <akdzNauW-cGJumrh@duo.ucw.cz>
References: <20260702155108.949633242@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dmPIqyQ6TWCKY6T9"
Content-Disposition: inline
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--dmPIqyQ6TWCKY6T9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.260 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--dmPIqyQ6TWCKY6T9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCakdzNQAKCRAw5/Bqldv6
8rBeAKDD6y3hV/wnGHqwvlVpOhY/x+mN5gCfbo0cK1NYE0xaXZf6KG3oDEONF20=
=pqdD
-----END PGP SIGNATURE-----

--dmPIqyQ6TWCKY6T9--
