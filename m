Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA36257431
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 09:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764752669; cv=none; b=bj5ETSSVoKtlAWwDm6fccw4qwAPpVNIjVJTtD5qgcrkCQNk7aFEKSxtqiKfJoioaFuVXwivePObX07DdkkiveQdqCLJEEP6ZDt5a02A0Wk7MfJh+3MLDb4HYUoZvIm+D7w99mTkZs5kDDXTOH3HD3/8wM+2X3EKpX9AT54y3DXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764752669; c=relaxed/simple;
	bh=5KsATw0ELRyIRlEHYF2JEmGFtDvXTWFtjPWtVjDk37I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9VBCYWiikz7yqH3zwSJSgjBrRlCe/2Da4teKBWeatZ39k2m36XIALkh+mtlRWGGeaXva/Pk7vSoGhSM4NsaDtopsjSyjYzN1zwO0DWq5vzXGVZuD49LHEyDgL2KVyLigaoBNvgkOSm3141G9e5yOX3I9dKJp+mYlkNnRoBuogg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=K/ff8a3F; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="K/ff8a3F"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6CFB4103ABB61;
	Wed,  3 Dec 2025 10:04:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1764752658; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=L5Ftsu1BaSn7zfEwWSbgedA4AWDv4S7Ea+U1fqRKEYQ=;
	b=K/ff8a3FSbBIJe03/1jVTjfulZIy1NerjEV98vsI+o6dm9GHJWaVOYrLFydSvcjs0R4tcR
	+3+ea+8OLa0GNMR6pU3esQpnspLf+XyeT8YH9rqRcEkm56AqSalDU8r/CwoA7ec6Mbj7Hr
	RgFRRCuWSJ4C5Gw7xkE7IW9lVJP4JaXGNQ2qSlFMC/3HT77Bc9snitwo5QO88QkpXl6EOC
	IvDkLlyrWjebPB8ZYnh4CAtbh/yQdEB6Ds1s5S8FDDOv0oDysn4FNBSErVJXkP9BCDxemL
	8o8DX7hKUg3X4uTwXG5p7uN0HBhvAyvdzFQOCRuXnXLEVbKGa1S6dihCGHMV/g==
Date: Wed, 3 Dec 2025 10:04:11 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.4 000/182] 5.4.302-rc3 review
Message-ID: <aS/9C63dliU1T3N6@duo.ucw.cz>
References: <20251202152903.637577865@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y+6qzsO/RpQXaq1W"
Content-Disposition: inline
In-Reply-To: <20251202152903.637577865@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Y+6qzsO/RpQXaq1W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.4.302 release.
> There are 182 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 04 Dec 2025 15:28:35 +0000.
> Anything received after that time might be too late.

This passes our testing (qemu failure is due to target not available):

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Y+6qzsO/RpQXaq1W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaS/9CwAKCRAw5/Bqldv6
8pmmAJ9Q/vDcBVQY5kM4s3mdc8Ecno68lACgu/jcSSplzj6NqH5OHBLVjMekACg=
=/6f0
-----END PGP SIGNATURE-----

--Y+6qzsO/RpQXaq1W--
