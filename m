Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256773806D5
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787686223; cv=none; b=tP8wu6zVFiRURDmfFkh+E4OcI9H9aDPvq1INxGsl915drABrLd9+BpYS3QIjnk1vTy5ewrNm/Ci75rlJPDFNabqn5aQDytDFHYcO9N4s+BUVy3dp1FxpTWSEkaSlh5Ap9FJvArSbXW+6mozQCNnjp66eNobiXZAq2UAL+w3CImA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787686223; c=relaxed/simple;
	bh=llhw0iGViWqmvqOFLyD78iP8KVWId36JOITpm4Xe8H0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tp4AJ5Dp/6mgd+uq3i9IpT7N1NfAhqkrO6pJxPayLOsCJz8uHM7Dc1pz8jHGEP51Oa5GmtJSvRTy72DkucHnbB1FrXxTYTVhQVIiyhwzyQqaW/b3cQ1DzbXPXdhCHaImztdIOq+ITQoGHli4nAsbEyHhrvwxqnqWcYE8HavVxKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=iJuYOGaM; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="iJuYOGaM"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1C22B11CD14;
	Tue, 25 Aug 2026 21:30:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787686215;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=j34S07le8QEjX50SXFlV+Ip2D5SWnPe6cZh3bqd1hnQ=;
	b=iJuYOGaMG3LNy0pMe1up0sAoV9uWtWXXovhfuCfKVHWgIo4gmmA7Rt1GYBnDeGekMYw+8T
	aTc14LT+d1Dc0wr+pFkDaI3/j+b24ZeZu8yBXUMJMKqoSAWkJ1s3kvA8nu4aU/oZGSIUEC
	uneYEOrE8LdKl651LJX7mxTPi7MR2IBv6U98E9G62ggv6IzxptvjYIkzLl3WZ/kRzIzlJn
	u5iUowFWhnAkIxwWJfSvWnUl5HhKkmlSSAffTY7K4Gk4LmvhMXdRkcLcmjNsV3tXqOGaez
	q7eyqZIP50IgayLlLBaZSHzX86X2GFmfBmnuVVpxS+KF2OWjP0uFn6not4t+AQ==
Date: Tue, 25 Aug 2026 21:30:12 +0200
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
Subject: Re: [PATCH 6.1 00/79] 6.1.185-rc1 review
Message-ID: <ao3tRGA693R1xuiz@duo.ucw.cz>
References: <20260825132541.677185791@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ejKUFun8CDvMEe7B"
Content-Disposition: inline
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ejKUFun8CDvMEe7B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.185 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This fails to build in one of configurations:

drivers/mmc/host/atmel-mci.c: In function 'atmci_remove':
4544
15:42:42
drivers/mmc/host/atmel-mci.c:2631:31: error: 'struct atmel_mci' has no member named 'bh_work'
4545
15:42:42
 2631 |         cancel_work_sync(&host->bh_work);
4546
15:42:42
      |                               ^~
4547
15:42:42
make[4]: *** [scripts/Makefile.build:250: drivers/mmc/host/atmel-mci.o] Error 1
4548
15:42:42
make[3]: *** [scripts/Makefile.build:503: drivers/mmc/host] Error 2
4549
15:42:42
make[3]: *** Waiting for unfinished jobs....

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16096613950
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2789507911

Best regards,

									Pavel

--ejKUFun8CDvMEe7B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCao3tRAAKCRAw5/Bqldv6
8v8AAJ97+GJqDxNxGSM1/Z5lPaDK0pqv3QCfYm7m0Y7+C3OOFBEduuabaZOqeu4=
=YtuP
-----END PGP SIGNATURE-----

--ejKUFun8CDvMEe7B--
