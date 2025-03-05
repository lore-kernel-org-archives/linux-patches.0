Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0125487E
	for <patches@lists.linux.dev>; Wed,  5 Mar 2025 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741203481; cv=none; b=EInZm/jUo8Js73ZFSknf5YN5muiUUNIfbR5ezJ9T9mA1avLwmLdvEdksWSe2rmQau7rXYtIIiACoEHgHVykURanjn6kSbNaNb7EGXOpRW6GO5owpHyDGafTZ3Yo6ht8g9oYc4Gc76f3lnl8tErds8eItBcugerX5/wcC/5+vahU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741203481; c=relaxed/simple;
	bh=YaeXAIalc5DmxyKI0ax248xGq1aSY2e1Rppfasxvec0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJ2brlAkMb9o8T/Zk9+TzoTIlJq8ThgpQGa4LBmcDYtgWKX4k7uqb+V+wW5y2hZ+54WzGWNIiWIUGoE7fiDr1doVileKO/L+i+R1GP0obrCiWglrRWFBcQUe52OZTC8n960o7NKJN/qATv1o9ziddL1Pmid3N779hJxhhxLaQ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Ygv6KX9z; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Ygv6KX9z"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4865010382C18;
	Wed,  5 Mar 2025 20:37:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1741203477; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=pfqBtTAyM0wNbUUeMeWy6C19KVMVCE7Zn0dvNPi44FY=;
	b=Ygv6KX9ztc+yAMGd5LBvD38tYzNnuWy+d/ptEMM1kW9VsnSmJf1KzhP9+JOeyxRdhci4pW
	c0w7sRYt0hI3D5JmZvLVYVgGI10cww8nP5/EGEvhse9ysN2opE2LBiC9cNulcyEEeCurft
	5KaHzgHTLqrrQDJq1tlcYEOrGTBXaKgeIAX9wg2s4/AfT/Gree+hU5LqrTDMzO/SSf/2s7
	5F6Or20X3fuQxbXzOFBPPDBzKf0peiSMERRX6VCt500OdA/WAf2TjuK7uHL26Qr4mg5Gbp
	pZLWTkfa6hwFlW7LZAXbbu7HtrdueyY9cxoCMkFBwlrd2nJARuqzTJBTGXNhNA==
Date: Wed, 5 Mar 2025 20:37:50 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/176] 6.1.130-rc1 review
Message-ID: <Z8ioDomrJ9pcv4MW@duo.ucw.cz>
References: <20250305174505.437358097@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A/bYaBZRBTYrYPQ0"
Content-Disposition: inline
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--A/bYaBZRBTYrYPQ0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.130 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--A/bYaBZRBTYrYPQ0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ8ioDgAKCRAw5/Bqldv6
8qerAJ9lpnQHt2XVKls1G/LcFTVRwpRUHQCfbp7qkY7Rq5GohWl0nJZQc0tgrqQ=
=Ew1O
-----END PGP SIGNATURE-----

--A/bYaBZRBTYrYPQ0--
