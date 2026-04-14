Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B72B390CA3
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 08:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154206; cv=none; b=BU88bPLhh0fRCppeh6dDgM4/h91kfWxyRgAD1Jccn//XjcZnRkEY06CiU+Ff9CaiSOKlskQw8kZMl9UJ8nvA2xPLY4Gb/LeUkPD5AJZIzX48kmHcMfTv6/tR8NOiup9PRgdqnC7rWFlXGBt1lsSM/jwwNCBRcpyoq0gnNTNPXL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154206; c=relaxed/simple;
	bh=2EnXGX2z9TMO+hpY4tQUlTggq9jlMtm+1+CGokVKDVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDavsjseTTLtxcvKhK7W5odC7vKhk6VVAc/v5J4oiZltiZqr5F7vG673yYjrRX8Ox/8xeVPq+NppbGBmH1dDgyhPnI5bWcbh2kr/IlAH3Hcn7mW6LpD+y+omFfzxi1bqEglr6IpwuNdwHkieSOSGZxTZQpsH+QLUXhlKMsESf7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Zubs1nG0; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Zubs1nG0"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5601410A419;
	Tue, 14 Apr 2026 10:10:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776154201;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=k8aytfPrSK6DaMTCqcRfYD+pTuCBknlnE5eq8n2Rhsw=;
	b=Zubs1nG0JkxgPqu6jzHXeu9r/zLxAKMfSx1Rrbdr+3CTj6C1ZgIw1M5DkmwdMzMrHVvCLp
	rlVAUeufqoNCHWCBuioaja3IQqhULXHHGLTg7kcQpNSOzpwnvdzbyQkI8MUOAfUeLWD4PK
	6GmAYJDZcR/QOyHhNE2X0/UQjdW8oAVqcgcZ9pN1Ny3JMXP3VZhGcBxEgYMJkHvxbrUhbI
	fm8NY0WQA2sILUtp8Aogy36AwT7Z8HbKPvah3EvD2rKuTL8icPJU5GJhtiGKir2P0D21r7
	cWVLBQtQAd4OKD2OjPbhnpZft9G6sPx0s4gwPG+NHHOodBocaJYQcTWdnkEA8A==
Date: Tue, 14 Apr 2026 10:09:59 +0200
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
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
Message-ID: <ad32V5vsqqY6pGAO@duo.ucw.cz>
References: <20260413155731.019638460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gkbzmwdc7BOgPODj"
Content-Disposition: inline
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Gkbzmwdc7BOgPODj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--Gkbzmwdc7BOgPODj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCad32VwAKCRAw5/Bqldv6
8hyfAJ0SA6YN2bH+7VOZbZVS7P9jEwc1iwCfV4g3H8t+wU89tH08PMFqjYPTIzk=
=zhVT
-----END PGP SIGNATURE-----

--Gkbzmwdc7BOgPODj--
