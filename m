Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D43811E2
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708531337; cv=none; b=I4KhhNCATWrv7vt0Lycnha7PMtKTcQs1ltwvdSCxY2+pFmNoiwS4pMTZ4SL0ugsbHbJQ8CIIsvF901OI+gigvALLONnuJiby80VXrA8qHuIQMxoGDjPKlyMG7LzfALn9jFFbz5VaiecnY7r/lzZJKS9PCGLij7mDD4h5J7DuIgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708531337; c=relaxed/simple;
	bh=0KAynghYyA+dHgg47G8BTi+tCwA1k8+WpDwA6L6HeK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F1nLYP7cyOGIaX+Mn+yM1WVCZPSU99VtqHZBGd+NsDadsGlSvq0dwpJs5Ni/Rqy1fiyCQRlX49pK43fdH7mtUV0a19MKgZr3P43fLOHbHGYSccShFad2esX2IxAz78vu9awjdgQfcNVSmg7pjoHXRBbbZAT/kEPivgI7TTFYpiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 767351C007B; Wed, 21 Feb 2024 17:02:12 +0100 (CET)
Date: Wed, 21 Feb 2024 17:02:10 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/206] 6.1.79-rc2 review
Message-ID: <ZdYegmcWcNHqCdNx@duo.ucw.cz>
References: <20240221130223.073542172@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LWC0FHQXDkhUCjtS"
Content-Disposition: inline
In-Reply-To: <20240221130223.073542172@linuxfoundation.org>


--LWC0FHQXDkhUCjtS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.79 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

6.6.18-rc2 (6f4f386cf24e) appears ok, too; still testing 6.7.6-rc2
(028924d29f01), ok so far.

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--LWC0FHQXDkhUCjtS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZdYeggAKCRAw5/Bqldv6
8hoXAJ9wbVpOPWOainZCgAj8737bm/nBXQCeOiG0okyaJHyul4SB8JDIBcwdKlo=
=onLz
-----END PGP SIGNATURE-----

--LWC0FHQXDkhUCjtS--
