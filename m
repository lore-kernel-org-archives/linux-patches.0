Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47737384CDC
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 08:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780304259; cv=none; b=FpegZXbUAtf/scmedQeXVfimMiSNORzYRiMdfYmets+0lcipdYkLPUHIwjA4nfr5jzJL0Du9yOde+J0XFBQ6J6Zl6h5F/Zo8Xjt6J81/f/buCxRWzpu+8G4TLBlYL8DP9mw6y1iNhXDpcLLGKsp7ntj07N9DLO4+h0WBjVpoVrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780304259; c=relaxed/simple;
	bh=KbWsRpe3SIhfIeylvLrLeQUakVue1xz16XtGgEZJByw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W32wqmrlM0gKmY2fJJISj0yvyB9KWdpUPBPKRoSxIhvnYx9NMYYFkPxOoo3OVVU/SGe0bvaqC0dy9RDWPPLZZxodyUAwTk4tJlY1QJ4gIXTkTRuR2UnA4LHNAul3/4u+qwf9TmPZQJ2+pZEgiKQqP8WcRk2rw+Hxu9YLZuPoEQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=WU8Javs8; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="WU8Javs8"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 63EBF116C3B;
	Mon,  1 Jun 2026 10:57:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780304254;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=O7+aX1WgTYimqo5AFft+uhwmFo51zynXJCJvagO0X5Q=;
	b=WU8Javs8CHX4vIzT3y8tdlM4VA/ZY0PqAkYXLLVz2y2Rqy+yO98ueLCIvRN++Ofwz718Px
	8/XC/4Qd7KJJX6IsIFUZPsgIAdHDF3TjB5PasrFSmVkIiOrmF4iN/6FO/IJSA82TyP5oCQ
	yQPQSpPA7hrNgYsZpsPK5iaaRoxQW+x/W6hvdBcCGvQy+zAim1lXlNwN2k1vRQ7GDCV97H
	VEhHuM3XCL08dM5P/XrSdRdvs+/kgxp0SFHrImPjEpfd7K/vyREl7sQwkmAYaauF41hAvK
	+a74rMpwMkiG+Z8Rzm+J8ENPPbfaeBlfejzfpJA3APd/9t1WpAA1VDPKox8Rdw==
Date: Mon, 1 Jun 2026 10:57:31 +0200
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
Subject: Re: [PATCH 5.15 000/776] 5.15.209-rc1 review
Message-ID: <ah1Je748wi2x15bF@duo.ucw.cz>
References: <20260530160240.228940103@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdRgzWVtrTO9nihX"
Content-Disposition: inline
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--KdRgzWVtrTO9nihX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.209 release.
> There are 776 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--KdRgzWVtrTO9nihX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCah1JewAKCRAw5/Bqldv6
8vxXAKCyZjbOdEkblUHBElCNWXC7DQq8jgCgpFn/SMoMv8mDs6eLDFxL4KHJQ/4=
=sdQq
-----END PGP SIGNATURE-----

--KdRgzWVtrTO9nihX--
