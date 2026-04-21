Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC87382F07
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 19:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776800020; cv=none; b=XCLMcnX7XLDoO0ztsuBiX923njT47q7q1Y+5aklWAgW2Rt9NWvNYXRJbSr8rt29xUgq0Gb9dFNRsEZBTBkET+vUbHGC63s6l+A27cY4RsJy7H9xvps8ZODCabCUlyeMmLIEJuaKvPRippOTsfs86UwWllyLhuB4swsOeaG1ugaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776800020; c=relaxed/simple;
	bh=xyz2ECQzPgHe0MYJW8k3QYOeyIfrH4vWPRcXX9gpi9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2n/r6MNScIuecjN6IkRbvrFkFQqOf0L/5c4xjJi2BFwkbG8Cn8XIWzEwfe9FQxONSzUe9vbizoqTHS+nBHkn+YA1ybYwR3T/9Oeol/sNVCMuzsDpe96+6sPEwFptFKfqu6ilXmRLhmmLaRq9CQKF0sEHqhc91hTjA3CxUpEq1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=SiBAgORy; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="SiBAgORy"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5123B11486A;
	Tue, 21 Apr 2026 21:33:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776800017;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=1ack7YTVwt4BcxZUFZyqsDvN5DxrmRKNcQGFoVBc56E=;
	b=SiBAgORy3rf4JrhOAyYLRN5ibqfJ/JkC3Z5jBL+55DXC5kWZe/6PwfJ7WWBlYVHYMf1j1T
	lvJOuE+d6/9Yi7Utqx0tI74qL96KTU7S90G8y9sLWMCIQu8lF1ECrpuafRROZ1TrfflLoE
	0dga2hjXDuA0ZoOJP8ivPUvcHH5K5sNuZ36dPPqCYrb3FTAWxNo6xRuY4FLSLjxtgkIIAK
	AYpKtQzfNGdRU1eMIR+FjDVeURcaTHXiWkpaKdNDGQdNoczOpUxywPaSg2aqpdfEeiW8FA
	qXQpl4jASRAzcEze2ugmpzQk8ZeWaqDIz08a3PGS+lOxFrwJ/gqbacMVqYK3/g==
Date: Tue, 21 Apr 2026 21:33:35 +0200
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
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
Message-ID: <aefRD-ACYRTRGrO2@duo.ucw.cz>
References: <20260420153935.605963767@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cm8CYQnTZ6JfAHw+"
Content-Disposition: inline
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--cm8CYQnTZ6JfAHw+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.24 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--cm8CYQnTZ6JfAHw+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaefRDwAKCRAw5/Bqldv6
8hirAJ95jYpEtRnBxcozzU0uANW5qr7kzACguq+jDsnBbzaEqA1ZJzmKCa4X79I=
=keQJ
-----END PGP SIGNATURE-----

--cm8CYQnTZ6JfAHw+--
