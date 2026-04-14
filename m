Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3544037CD4D
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 08:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154261; cv=none; b=oC7iEQFQHXbfUES4F0uXgiOGbWU+r08HQNT6v+6+4WqzGN36xT4rpPSnI2R4C51EIkBKkDUnSBp++wxJEpfAt0e22+IGqKoS833A7zGapzvdy7PcaXC422JQK4zI9OnSgSR+33zXTlUQSWc5tNHddpE8ZFZsG9UZEoGEF1u7PhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154261; c=relaxed/simple;
	bh=HL0rM4HBwSDvitS2/cI4vC4zptg1f7tGrF5Cy65wfRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VA9IY3oyMiod2UsmmhjxlHgxkSW/bMTN9HmQ2vkJ0uY2Xb5xG7OhTQHkwP719fUfyBtoSiEw25ZkYJxSqnGS/BUscCikbAZGwKz+7EJRUO/nN5vSrKZKPCP2P3nS93lqcEETsI25GZOlMEJAx9s5ygamTfPPT3OBNb/OI2KaYy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=VfLwf6Yg; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="VfLwf6Yg"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2072810A419;
	Tue, 14 Apr 2026 10:10:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776154258;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=n0/9tOvaHLiDbnNc1UCtosMp2sNH2Wx8+ZMEEUgPKr8=;
	b=VfLwf6YgVkMWWnABZKzlOxv1m+qRBrhsed4jS/0MSvLBBlRNlhwDy3zzoDPypnPxdh9s0A
	nvcp+vjPyIAbc81gVxOXfO1en3dhxh04XGhhGe/G+kyyDpbSI12ATqFEHxwIQhmjmWT9gG
	ZT5yRe1RUKJsn0+Evd00AkhvkooXdKRPUHGju6o++YoYtDjkuTebG+fbCh2u2KsFx3FGCF
	nQVo+HteHEkajsHCp55+MQXvHOzJfN4OIvCHJs8BLWp7bb0qZbw2E2YYX7+7hJ2aNOmkEH
	Ghbs5KZIzg1f6QUsHTjweYdR1Lhe2V8sBogOAVVpdnp28nWm6QeR6qvkMobBLg==
Date: Tue, 14 Apr 2026 10:10:55 +0200
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
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
Message-ID: <ad32j1BQjM8ouMUi@duo.ucw.cz>
References: <20260413155724.497323914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="80V0ZgiJCmMOlAW1"
Content-Disposition: inline
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--80V0ZgiJCmMOlAW1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--80V0ZgiJCmMOlAW1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCad32jwAKCRAw5/Bqldv6
8uGlAJ9pC6ugQNWOsDcnIh5eWDKYJFbJ8wCfVARLwk2tckS+M1T8IsRJ3U6Nr3Y=
=7ja2
-----END PGP SIGNATURE-----

--80V0ZgiJCmMOlAW1--
