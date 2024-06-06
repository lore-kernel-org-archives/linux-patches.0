Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D307461FC7
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717703655; cv=none; b=BVAFYcLnlUfuDs8wepfFun3aDh9bVqGkK7a02SYzceQqwgnmhQMv2hV1y/cdn9ZvxYYcLHt8WcqbLVTlkDM9kb4bt/R7SVCsmNICXsgYIQSDs3TtfXc41v1UX3F6hMNmNr5spFHFCqot7EGWmVFn52HkC/2W3WtlbUT1ogCgFFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717703655; c=relaxed/simple;
	bh=dbh5Ypd0ZmyH3xAejcwiN+t0FzYu/qtkowO/qqVSdG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pa23+BkJTzsjBtxQHUleLTOiOt7dK1zHiuVCa9TO2JuZLCvoDXgAGy4kP3sDsZWS9juWgZF3tuLHWX9CQIHe3yvKNVGydFHHy1UhJWLuuLANNVnP+5oj1Xzd3G+PaEbRvcmaVXwgDUVNGL7f31zWfWxlkfxFrh51zsYTL7zBtbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 090DC1C0082; Thu,  6 Jun 2024 21:54:12 +0200 (CEST)
Date: Thu, 6 Jun 2024 21:54:11 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
Message-ID: <ZmIT495hBOhvuAja@duo.ucw.cz>
References: <20240606131651.683718371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oxkWft30KxAt57A/"
Content-Disposition: inline
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>


--oxkWft30KxAt57A/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--oxkWft30KxAt57A/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZmIT4wAKCRAw5/Bqldv6
8tURAJ4q1GbGu7Yxo89RhSKzNnZddNz9OwCfSxZ+zqlyIuTC9hmn09LYF7vgZoI=
=a4/9
-----END PGP SIGNATURE-----

--oxkWft30KxAt57A/--
