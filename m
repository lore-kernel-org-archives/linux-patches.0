Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C6C310784
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 08:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252195; cv=none; b=ewkltBT337zV7ig8Gb5V5aBNxI7PL7D9UjHcukR1RNRk/AuxwFo+RUjZXTI3e7jfEIYgB8qaNxzqXdAlHyUS2vuiA5XByn3KChBRFxWNBgi8OUvwft5+ZiYXq2KFz/CsYmijLXueZf1tjI2PsoVw492iFvMSBBOA3rS7nZVGrag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252195; c=relaxed/simple;
	bh=88bQ6KJwKBOVGiBPpW1nQDjj9DcONuBqbVieKxnUJSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AdP6Y0+V12dTba4PGHEvHC68BTTCUsb4b211Ce50kEEKEreYI2vVmzAFUuh3dojeTWf2bsMt47XMAZBc9FzAPP5RCUJ+Uzdnf7AkJtZp4Uwl+kEmQdUWUrPfPBs6I9ZkVZPWuooqmSoUGuwTWobvjr3bl1te7DXo/JaVOumYaAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=OHwiwlzu; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="OHwiwlzu"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F166B11C892;
	Tue, 01 Sep 2026 10:43:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1788252184;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=3SGcBkSHNkg20R2mZ2z8eQ6cFrWuwaV/3ddc+9T0qPg=;
	b=OHwiwlzugwBINQu/iEbF0HQkeZ6Ip13sxFh9i+Ga5JD9HT6x59/7jYky+s4UaJPP/EijdR
	6aYUdXX8aWjHSLb+cqE43XtcqUwGolCP+xInxd5HetOan1tEzmCs+GjCQW2Cl6n5UWW1Sz
	JS5+03zTWLSaIC106PmXdbkqciUpwRLmMW4o/JLcrpc0nA/QJ805qEQELK/PlMPZsgDmF3
	kbJH78R1SQiDWTqQyUcjc0GXlsk4pdQQSghERRLb669IARSXKM+37QhDPj+o7DdUVpd4mi
	ASSIipvtw8PcC90VjZxKDAdWBWG/kBx9dX10NqpO3lo2EIT9W8B25RHLdjhRuQ==
Date: Tue, 1 Sep 2026 10:43:02 +0200
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
Subject: Re: [PATCH 5.15 00/69] 5.15.220-rc1 review
Message-ID: <apaQFsSN0Sv31bEh@duo.ucw.cz>
References: <20260831133358.601894154@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SazJbK+UyqrwYyqX"
Content-Disposition: inline
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--SazJbK+UyqrwYyqX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.220 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--SazJbK+UyqrwYyqX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCapaQFgAKCRAw5/Bqldv6
8r+fAJ989w70+MXChIVuA9ftLsfEuPbhYQCdHZvWVSWppHzdPMIBxaaT/nv2dYI=
=Kl5h
-----END PGP SIGNATURE-----

--SazJbK+UyqrwYyqX--
