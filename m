Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D75C4E4C4C
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 09:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846311; cv=none; b=DCNRN1X/D02fQjjHATeXtEAJlvBU+gC/6ZrWjc10/ySX07P9/4glO5a1Cw8wp2ZmBKS5ixjExU7V8vuUGLnlPZj9/GwrZCbu1zpEJMTG3VwGgIf7q9rxPavBj9VrxX1is8wk824pGtlyORNdZDH3vlvQme7hpEFHlAgcc7Ko0tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846311; c=relaxed/simple;
	bh=Q6b3tF8PWoRHkaIdINK4EDtXjEMfy9Y1VVaW9Y8F8us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWX76Dm6/Gkl40AclF6RoFI/Dy6PlynWmfX619XPZufnuXoc3v6xnFEfxx3YAUKN/28JYDyUJowYEeYHgoWntXScvudMy2MTeS/WdoIcvMSX503WMXHOWt6tTOIyKvyjTOtvtiAnyisbQEexHNpEFQ0GywdgXo1NEgpiiWBI4KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Jw3RnTWr; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Jw3RnTWr"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7CCB2107296;
	Thu, 01 Oct 2026 11:18:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1790846304;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=01tQrXv/w7FiihJmveLQrHRL9n3LjIE2h3V2TDSl8dE=;
	b=Jw3RnTWrJ3cXQ+FUVpT3cn7xsIwWC0wDe16vrN5WDPFEZiCDqh57uoQ2GjvCu0jTNS1sVS
	uHzDivip1lzjayo3dZtnM4tQlE1F/CZhC8keYADyXD9Q/6jM+MU4hHWMBvUirZvcxQJA8Q
	3bnKGAYFffcwTGw/IL6rWBAAkaekNHXzP99ugdkqR++neDez9vMMgy8L7Do06Ur17IWI5a
	9uF7HAWPhJ+gcJXUQ+qG72meP6H8ecWU3isrp6F6tZ8ASa72Xk/JzMPqYZQcE4yKakDP1f
	3GF+5QnEydAEcPR25D78J/4l4g4OUy7Cmc6RWv54hrZDtrwI9T0x9EHHbvfX2g==
Date: Thu, 1 Oct 2026 11:18:21 +0200
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
Subject: Re: [PATCH 6.18 000/395] 6.18.55-rc1 review
Message-ID: <ar4lXW8YjNdOwmEO@duo.ucw.cz>
References: <20260930152340.591469096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dXK96DbHUup37KXx"
Content-Disposition: inline
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--dXK96DbHUup37KXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.55 release.
> There are 395 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel


--dXK96DbHUup37KXx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCar4lXQAKCRAw5/Bqldv6
8kgmAKC8WBYV1qCAANP5JDFz3pa5ydxPtwCgq/ZOI6+PbjeRhMWFA2QESXwefPM=
=P0y7
-----END PGP SIGNATURE-----

--dXK96DbHUup37KXx--
