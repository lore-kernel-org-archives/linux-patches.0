Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67194D2ED0
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 09:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846216; cv=none; b=HTRmUaSn/Tc47ltEbMRN12TVXDqcaJ6fJtndmm9VO9PhV/YNUVopG6vxvkHWAMGj9ApO8tno8KdvKnOrxTVv87VnNOhjCJNbvUt91AvoLaOnLpxCfj82MA+de3cKCT30hKUUemeG216b8nX2SOly45P3hmspNvCWeZGZ3K2qwSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846216; c=relaxed/simple;
	bh=Wls2OxT9hEDY8qF5hyR07n3HdvQoLUjEYwQ5Wl8TUA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOjVSpGmlj46CWG2rYQmNvUQ0yFesOnXQWcn7yOOYB3xrYJKcky4uUGxJQGpYw05BGHF2KRCFLqMPHDgrGMF1n8ezyft7gJ649iKSuao2nvAwWV95i6FmnFtJ3H4ETb1cCtM4n/rqbnzNtvSAMaqlYNbQVgikoX9TvckEGT4ZNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=PhteDpdj; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="PhteDpdj"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EE83210721E;
	Thu, 01 Oct 2026 11:16:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1790846208;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=h/KVnL1Wpn8UtkjCz2coa6M+T1lGHLMNB6SwvM7pZsw=;
	b=PhteDpdjdFJga9tWmm8/NEYJVs2iSWEEt/wR4Yud1CsDWRgBG+G522HUIU36pqD70H1U9C
	oH96qOeekJjNOx/rxhul8nGwfILAYBS9v1lJVMfcxs02is5CEswpwNJKJwDvaW9JlY0umL
	AdhX5zjf0mIyyNOTPosv3LKT9uCgSHuYWVtxtQNl24nwpbJSs2tFadqvMb2WDqoJznkGUa
	kZlwqF2tzs60CmttbxuVkenTzhjinKBUiUicMYCHY7QODChRFu36k8JBNMkLRVTONPIvFA
	VNPgv8osvPXtk2J/vowKqTyWGjnJXLOVyewJ7Q0V8gRQtcEw3iRsuKJXdn1FBA==
Date: Thu, 1 Oct 2026 11:16:46 +0200
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
Subject: Re: [PATCH 6.1 000/982] 6.1.189-rc1 review
Message-ID: <ar4k_gHgwnL-rAEA@duo.ucw.cz>
References: <20260930152416.775402466@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mcy86lavjKCZ7JGD"
Content-Disposition: inline
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--mcy86lavjKCZ7JGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.189 release.
> There are 982 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--mcy86lavjKCZ7JGD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCar4k/gAKCRAw5/Bqldv6
8pLOAKCNRNtprQvmCc73YXRfblLBcjl2oACeOG/dr8Yfe8zvDuuidFt7OAwKloY=
=aHet
-----END PGP SIGNATURE-----

--mcy86lavjKCZ7JGD--
