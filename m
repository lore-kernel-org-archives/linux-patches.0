Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDB98F6E
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741719957; cv=none; b=g4t0UMPHVCx7eCiNQqRfRTx0Hqsm667BceY+LNsvkokzTGVfUo6WWR2BZYNaYdQexmivSgAfuYbG/t4TP+09OZnMKn/MmA/LndGFnWQHm1TQJOR/ffINDRmrXoeDUSVJ7cJ82FoTFsPJqskAGWYAqk4AwSJcaIT+bu2yYFKJaeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741719957; c=relaxed/simple;
	bh=oG9XKqp/+KDc+xKJftZyKUSaqzpejQOIqaBX1sv6dKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPylmyfze9Uz2ttEmD3hHiWc0GeiJ3IrBPbZlrHdzYnA7HwhfPvMluUBW54KNUEaeifuV+PwOEmMNT+ahbiGlUfzgc73iQoCR9U/+918VPanoISbvCLr22Rg60fDBO4jA7WB0MOynv5AKRxvMDZ2kQCjpX8e3LyY5DsyYNkiQ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=MJyrSf02; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="MJyrSf02"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1E7EA10210BC0;
	Tue, 11 Mar 2025 20:05:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1741719951; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=T3512c6eqP5cx2/CytnY6e04OxTMrJW2y9ZYzIYtG58=;
	b=MJyrSf02rmXL+bguKd4sJLgSHUKyumd4sCcnrMAnKyeqUSzie9Q/QRVB64a1MkOkpi5KqS
	3yvnJ4yfmkPAp5l2hv7vyqw1h0Wm9JWiJeTQmPFU9PwqEYxIg7vpKmHDS+8h/kr3umf8/q
	q/lcQOryG5hyv9S/6SQ0AVKxKeFU0CQxnsj3GQxGfxKii1+pRFDc6gSET6h7vTHgNaF+wA
	PQkoGtzemt2j6DS6AT1BrY3/Bq191IWCxDtD+sUcZ8v2Fot4tmD7ZX+RdJWWt4QSWKmaNF
	xuWk7z0TKLkZSp+8M0H4PsThGM09+am0bwXM1JF8mpidOfCRTcY8zfrC6jSXFg==
Date: Tue, 11 Mar 2025 20:05:42 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/462] 5.10.235-rc1 review
Message-ID: <Z9CJhppcLZQroefP@duo.ucw.cz>
References: <20250311145758.343076290@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/1sHxoHRQsmudflh"
Content-Disposition: inline
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--/1sHxoHRQsmudflh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.235 release.
> There are 462 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/1sHxoHRQsmudflh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ9CJhgAKCRAw5/Bqldv6
8p+eAKCIO5MpWLUO8uINzOcVFMLD91oQngCgkOOd3IsIDRlDbGB/wqq6McLI4cc=
=02b5
-----END PGP SIGNATURE-----

--/1sHxoHRQsmudflh--
