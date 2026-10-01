Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C34BE440
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 09:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846189; cv=none; b=EcgSv/hiuyofUHfpDBZYQ0OSUsuwcmvBHX5f9GoAVWKAm+wTz2KCP/tJ7Qik9qGSmG1SoBbJmrYEI8oO2fpEjHvUNje0jQe57bmnhYTw3RCumVlCwCWkd5OSFcB6VO+9Hqa0mg1auIx4vtbfg6CtptgK7mzCVqVT08QFCxFfCbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846189; c=relaxed/simple;
	bh=c+KNAmKtvmRoeCPHevASW1CtXXHMEB1deDg/+2YfSUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLQ015xr/eVTJEq+1WcAkk8sF95beN0vLblSjpYXVkP6ljvWgScUvB6c3wGg9hDyR1TMKAzMG7zwb9S07Fb2V4WyzWj7l8Bd2dcMNCrRDZ9EqBXn1LTxSlFVSFGscIEKnQ1o+LfpjfZrP1AzqjGGNeEVq5pickXCm3GKtgsCnps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Gwc67f9l; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Gwc67f9l"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 85FEF106F65;
	Thu, 01 Oct 2026 11:16:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1790846174;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=k6W9vUH1FX5uWoLvulHhuws/gHo+18k5hm9pBLEyuyA=;
	b=Gwc67f9l+649hqcLPz+7kzi8uM+LxH3ot/jsPM6PvtZTo6eegtBWDXGzpjdoRpf3s0CeHe
	oAWIHt/2tmCBLcrW9L7BHydXepGhnkKmYrvLnJRZ0yoI9VN1oP3UodkCK/l2yn/kJn5mWC
	cGi4l1yv9DHAWcB8vgBDi0zpC1pUoq8ksS/8SVNnruWa0Y7s2gI5xSgy7Iy50aV+3mRukN
	yLNX++Ug1BMk8+NnnT/bP9jcXxSU6DcmC55GhfX5jjSTcfdZmd3KqpaqbGJTvPsSksn6nq
	FS1tEM+NOZxRWq2jKY9GuheNkiZdP5+aIf+TtCwPv3/K78nMpRGrZEhP00ZDbg==
Date: Thu, 1 Oct 2026 11:16:08 +0200
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
Subject: Re: [PATCH 5.10 000/595] 5.10.271-rc1 review
Message-ID: <ar4k2KLpl8Lw9hV0@duo.ucw.cz>
References: <20260930152347.700140858@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WmoHX+89beO8v+vy"
Content-Disposition: inline
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--WmoHX+89beO8v+vy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.271 release.
> There are 595 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--WmoHX+89beO8v+vy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCar4k2AAKCRAw5/Bqldv6
8k1dAJ9CkQVSNDQzolfDCcQsO7aj3zN6JQCeKmGYTTIZzYX52372TL5WCAKuxgY=
=TbYs
-----END PGP SIGNATURE-----

--WmoHX+89beO8v+vy--
