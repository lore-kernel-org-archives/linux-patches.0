Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428C934572F
	for <patches@lists.linux.dev>; Thu, 21 May 2026 09:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354357; cv=none; b=SKamg/kPiAifP6asLT6XO379CulDtJNMks1YKtLYsmSzbVP6O79U+2TH4sZ7FDb6qagpAYeDlUQK6Ek4BoWXbf1dg/rj8BE9v8PK8duCZ8QJD7fSctXvabkw8dssmRdFk+ezTmgA6f1QG12tBuQYUQNrvrDVpQ9hLHAR2++KGYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354357; c=relaxed/simple;
	bh=dFjEvPArH922on0XCInl3185VRSeoz43R2KMUW4RUR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHfvrgnLn8qtJSK69GP4gucyDgESiVGQL3whSK9XZhx3l660QLvZvawfQf/fp0ViJXJTpCfzxziQlEASyYXx3SzfZEcLjMX5XXQHMFpIvJNXvYLCTEniXQ86H1oPkGzWIX57k8rdkq6zLqEXUCnwVZOXDlpAhyww56WV+0Je5qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=RDPCxLGN; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="RDPCxLGN"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4BC8F10CED4;
	Thu, 21 May 2026 11:05:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1779354352;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=UC46RUZD9PMWSccAce2U5mQaC/VaceitGNkisxDspmg=;
	b=RDPCxLGNqrFPwZy2yHl6Lf7+T8dWxsbuxK0UbHKFaJMhSD7aPI2p615RtoTRGU8uRpvOv7
	BUuGJesCgkr561HHJjnTDSAFfMYU5xIRA0VTGFQOTgTPopQSPN1geWmvLS6w5yxqPw+oxg
	zeSDrm+mSp9+hcyiVAFIQe6xnkQNL5vYAp36j2FZOi4ynQ1EYRXCFXciZZEGuKnfdRXhYC
	wndUOyu/j81SipXqHnBrQKQRpvQGW6UUwenrppODsyzbJX11Oa7is3dwkApWucxu2bRZRY
	bC8KKPYQL9Y29sXp/BLDFn9UuRYU/fThQVBQwKAAkLR2kWHeLbii+EyYESveWw==
Date: Thu, 21 May 2026 11:05:45 +0200
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
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
Message-ID: <ag7K6Yb0olLaU4Gg@duo.ucw.cz>
References: <20260520162148.390695140@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WSsezcR/4Jgr1l4h"
Content-Disposition: inline
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--WSsezcR/4Jgr1l4h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.0.10 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.0.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--WSsezcR/4Jgr1l4h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCag7K6QAKCRAw5/Bqldv6
8qfFAJ9Ut+Hu4NkZtMfEAvjmM2ZCM5glwgCgulkaFdp/Oktk7U4se5+NSyKbKFY=
=7f4w
-----END PGP SIGNATURE-----

--WSsezcR/4Jgr1l4h--
