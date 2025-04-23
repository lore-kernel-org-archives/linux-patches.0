Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F210227A12D
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 19:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745435978; cv=none; b=B7BM8DXhelzH0g2JWceEp3HTPeerLu2inB2NigkrB7zekDWjRS5sSCGoErtDqHQPI1EZm8ogfyXERYAG+rKV76SBZExRXUw5J51TOQ+/CzRECUKMiCM6sDN+7fhjG3Qt3Jn/fHLykgzvTHmLaJFDUabIVy8KAnAQfrJxqDjUyIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745435978; c=relaxed/simple;
	bh=0p1Q5uudiyRhewfOAldTtIJWPgQ0g3elpNOFeKo1xrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nB+58k/vH25bwiAfl/q7dpcLmIOBToa8oQMcsUjzLJ7mVHJgQepdz8adj9OehuPKUv1KLA43B5tMEP59mcLVRyS/JkhNrDJnZIfMCxmH3ZJ3sRJyAQtcaxvckZAHJSZa4r+L+CY2DLDxFUFnrdHVscv61AS7CSJQdo9L9MUzMJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=bTHe7VvY; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="bTHe7VvY"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E2119102A8CAA;
	Wed, 23 Apr 2025 21:19:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1745435974; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=RfHSVhww9UcPaGmFTglBp9Nkxc9V45W2rLeb/ggFMk8=;
	b=bTHe7VvYB5/L2YqiV2NCWscdNxiVe+EH4aW5lPNwqU4SrOhdk9raEP8FGa0ZIwBpRR1i50
	U/Ze/ELJXg0D45AQ7Bi9a5yWB+4TbdDTSmrLhDnrYGHtjidK3JAvxCnZSIW30iux4Fvptq
	xqE3Gtlob1OrL7nsom28ykHt2kr091kXOHX2XA83bl4EB2w8kXggUO/6UPQuv7Xe7siQpd
	B3UVCwpSfHmiRut7/SG0ZSwiTDLxeEqcKanbnBodFu+x8xDR88FlX01SrWFI/6idp6/F4I
	qjWN8V93s4k2pMKxC/TSghATmyj+OVwnfeUvolvGpwi64zlHonIF3Ib7HIT+CQ==
Date: Wed, 23 Apr 2025 21:19:28 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
Message-ID: <aAk9QKdVRo88+KF/@duo.ucw.cz>
References: <20250423142620.525425242@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EdJsNPKdIJbfQfPz"
Content-Disposition: inline
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--EdJsNPKdIJbfQfPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.14.4 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.14.y

no errors discovered in 6.12, either:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EdJsNPKdIJbfQfPz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaAk9QAAKCRAw5/Bqldv6
8nV/AJ9ioob9Jfq1rSZBHOPhnDeCK7wKeACcD/8eU4EnsghOy789+39tYBgH2Gk=
=MdDa
-----END PGP SIGNATURE-----

--EdJsNPKdIJbfQfPz--
