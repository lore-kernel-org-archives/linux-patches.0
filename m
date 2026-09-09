Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086CB559CB5
	for <patches@lists.linux.dev>; Wed,  9 Sep 2026 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788972733; cv=none; b=oXhh8rmUOU3lrf5a1FLLxAziNR5Q6RFwowCXuTnPGbNWPaLyeXVmdp71dZA4gti/k4Ebhg5/WoyjIBn2dwCX5iB5cJacElY17SBpF7P4kdLzwH8UqcvKGu14xmyeL0C/Bk4b2/i2BIbmV7qGevxEOgFWaIYUE5pTdatiXq9Af2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788972733; c=relaxed/simple;
	bh=lQn2lAir9FmbcFgnCmsBi+UMc2rRhAOD5HAtcyzblbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UO7PwgbGeQYvGCaR5uY5SdaBhDYC2T8Mjs82itu+wVdOWoLL7ceD3N5bDdkgeHNbXI7msE26NE9Tu1RLbmckkYrp77ucyly1N5GPq8sIjQHZ/4W3JhvndkEglQScBKHR1R9vuyuZhdhjK9XsmreQ/Ti8TioIWyDQrRGh7LdTBkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=DWmIPfOG; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="DWmIPfOG"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 011A6101EDF;
	Wed, 09 Sep 2026 18:52:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1788972725;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ikpn/6xWU1Pyb3tbfdQJr8tyx90voFpcP63y3bK2J7E=;
	b=DWmIPfOGsrMNulYtoStR2KaxJp5yfettnMD6+IftuSr+OwD1zdBHCg/DX+n/wEEsil51YW
	jSa5gZKscSsa8iyCsgOp0Y84MGU4MKVXM3rv/LscjOpyW/Bys33bDC7QCWQRRB+/43nhwg
	AM90FJwG519bHux/HiDaHSAuU3pR5acPyg2U/Zb3dPOc8qJFrNBkEfVyYEfq2ww1/OiHgw
	PG3enQPISbRn9HoI8tD04jp7WXdacRh0K9rBNSwzB8bfXSsnDRA5SEbzX5ReJEcCUQEhHD
	Vwj3mjCVOcd5N9ZM2MkLFJuZScybR/V9T42cMlOwC/RbkemgpUFYyG1wf6aJAQ==
Date: Wed, 9 Sep 2026 18:52:01 +0200
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
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
Message-ID: <aqGOsXLUZ164rVOF@duo.ucw.cz>
References: <20260909134237.773280130@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4XPSkX+TWMH9hFbg"
Content-Disposition: inline
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--4XPSkX+TWMH9hFbg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.51 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--4XPSkX+TWMH9hFbg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaqGOsQAKCRAw5/Bqldv6
8p0eAJ9vapROQZXU0Ore+HR4U7EWcYS+ZwCfZ5hftmCTwTYqRr/85lCnxWJYpkE=
=olhY
-----END PGP SIGNATURE-----

--4XPSkX+TWMH9hFbg--
