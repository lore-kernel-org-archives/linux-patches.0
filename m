Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BFF49365E
	for <patches@lists.linux.dev>; Sat, 22 Aug 2026 08:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787387235; cv=none; b=Uv54vUZGBCazRSvcV68tTwud7ggvJIRWdf6hiCU4tCM4e6oRqatY33VUdG5EFzPKfocxH5J/1Dj9wLH+0ywU5x0w8mO4tyFj2RVP+kXb80y3MrnV4p8ND92CiOi6Mndn3zj4kh01Bl0Ib2e2fnRwusUYXbdcNrw1CGKd/D65W6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787387235; c=relaxed/simple;
	bh=2nXsVijmwknLOzaVCYdplHNptmNcZotfYbGaXmmCHA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjHjX89pass7/Mdyk+VCOalylRE8uoqt0rrn6qWYJTHna3hvI2wEi7fT6WUXFSPg9axqa2u0OPnF3ipHZAU0mEYZscgCQinwSqcmP2cSKgQ8Amzd2V0zKnB2wmB4nE0PbSH5CD/K9AAZxQJVeoD1n1XGevp2LJjqJUdECcgNvhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=BaC5s4UG; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="BaC5s4UG"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C205B11ACD8;
	Sat, 22 Aug 2026 10:27:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787387226;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=0rpt4Zntv7VOWkhgpKSH82pK3AHpo+VJqZrb3vjYVLc=;
	b=BaC5s4UGru3vOfwy3mW5OR6OyphubsHlIYiOtCkoonH4s864yHzhLMawMFnZjrEovp+EAo
	fyPvQsOJ7SKOTKIXyZ1mmk0lMk5QngSBXatd9vYALafO1jT79+N+4Sj9DS+tXh19/aVrNY
	4m/oH9B5fnSmn3aPkmsV7g3UuMPRv8KgDXf81hqVU2brZ2/GBe9mtwUFWovpW1pY5vqRxg
	q1SIuEqsCxO1TXhFizVsH73dsFMWI8llOyZApBNYEFqLIGHcpSKrvCPYPp/tLtnipsA4mK
	zli5vco7+6zkMuckV/0JQ1eLsk3LscLA6UDY2r1KKTwIxq7cVwrv+CaIah7PHA==
Date: Sat, 22 Aug 2026 10:27:01 +0200
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
Subject: Re: [PATCH 6.6 000/160] 6.6.153-rc2 review
Message-ID: <aoldVR--7kvaXvC-@duo.ucw.cz>
References: <20260821142844.249995408@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BJroToM9RP8mX68Q"
Content-Disposition: inline
In-Reply-To: <20260821142844.249995408@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--BJroToM9RP8mX68Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.153 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--BJroToM9RP8mX68Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaoldVQAKCRAw5/Bqldv6
8vcXAJ48X1IYNt/uT7UUG7j3M2aqZMhkZwCdHMhjkkhX/cD/lM8/Sbrpvw5aBFU=
=qULu
-----END PGP SIGNATURE-----

--BJroToM9RP8mX68Q--
