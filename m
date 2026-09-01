Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58919471CE0
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 08:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252227; cv=none; b=nGPNjBCu6cPLXf7Ie7I7mQt6nTe7H6/1oXXayqRsqXcCe3GbW1gseB9hMUIJ9pwsV9qtydLYUvM2ViajN/E5Q8uZIXvK1cf63473n11JY+Or1N5m2Y33bg/TpdkhAfsX4/dgzHY/Z7nker+jKfLxU6t1FaBiyOh4XiiblUfsRk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252227; c=relaxed/simple;
	bh=rkfs6oK/zN+MDI5PIRjNTRcAFAzLJP501cuDSKC8nKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RF/dTD+Zx52qH29N+KemhS0+/fZJZ0kKb4Ze4EgLDz3qkoX/1m0k1yuVqr8DPeZZRxKly3GqViXPxf0EsGA/cJJ4GnxASmD5E0ALEJ5Z3aP/aW3dLPaT8R9G5fDLupXv1hVTsvh8bZ/rqg4I0FoFub7Cu8JmZPVFOJR/gOjKgH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=PoKc6IYk; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="PoKc6IYk"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 01A5911B095;
	Tue, 01 Sep 2026 10:43:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1788252217;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=+e365EQFW1fgQlKGwSiPZ+wj0tmy3KQWnJRGCexvraU=;
	b=PoKc6IYkUnT1oo9P0duFURdMQp7Z0+eWE15gl2XsDNngdpKS2pZrz4fRZ6o59b0/jN021Q
	G9zRooG/uAS3oZFEPzcg6jh29JZGTSc9MQOWI7b3cVtimSdpBRh2ZtgHf/5kD2798bbm87
	yWv/WrBM9/eR1oH3PXcrplQrKbYB0yWxZ0c+6RDmfIL5eTFSS3317Z1kpltiOjkhVkywAr
	eI66eOaUlncwDT9iUJV0TbLXK+n/G8LAGrLchDeBqyckdvAAbVPArwc1aJYQ0BjiY2NomL
	ivI9RSUcIwwfup1ZkIwfBnvjenApzAJVnfq6YIjFCK9KOIYzN0uTHoca3Ett3Q==
Date: Tue, 1 Sep 2026 10:43:34 +0200
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
Subject: Re: [PATCH 6.18 00/83] 6.18.49-rc1 review
Message-ID: <apaQNhiXMbSIzBwF@duo.ucw.cz>
References: <20260831133359.207714926@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z7pv4oAiIsm1/LUf"
Content-Disposition: inline
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Z7pv4oAiIsm1/LUf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.49 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--Z7pv4oAiIsm1/LUf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCapaQNgAKCRAw5/Bqldv6
8vssAKDExOYCRQZXv2myUoQ+wU+p8sE/lQCgnsj8oxUynjD7a+ZdQO4CXuM8zTY=
=Nbvx
-----END PGP SIGNATURE-----

--Z7pv4oAiIsm1/LUf--
