Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8941BAEFC
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 20:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085976; cv=none; b=Wk4UD+PMCfJfBiEQOKN+VuEeq/bPKf1rND48s8o4neJML718yHAhG5cI0JDdxrKOAC6DvhL31pH1Ew9g8uuVDvzGzA2NrNOJ54fHUVgr5rm4uPg+x4N/SvUYVpIJPWMnu9AcG+S0NgdNeA46tynffjgmFrUfuqagwxiudZwmUOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085976; c=relaxed/simple;
	bh=T/zlB7Jrvnav28tz/65G1BBZpc0uMvCc2JQVYVGaHns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ro0dwLoJPEgX1Op1c57a/rXEid8kZVQBecmeDFT1Lc8nkI4lPCmyxh6hz1VGpc6sVjYsuFz51tcqaD7I9tG5Y6KWMi3OF1XeB1EolassoUu6Cv5LnpuMFZIO64GsPJbkeebfiY9Q2ZFKJ558dv4NQLfl3k5eB5/piLOQB2l+8mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0E4011C009C; Wed, 11 Sep 2024 22:19:33 +0200 (CEST)
Date: Wed, 11 Sep 2024 22:19:32 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/186] 6.1.110-rc2 review
Message-ID: <ZuH7VLU/tGyBFvj1@duo.ucw.cz>
References: <20240911130536.697107864@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o1C0MLSEXStKmb6A"
Content-Disposition: inline
In-Reply-To: <20240911130536.697107864@linuxfoundation.org>


--o1C0MLSEXStKmb6A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.110 release.
> There are 186 patches in this series, all will be posted as a response
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

--o1C0MLSEXStKmb6A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZuH7VAAKCRAw5/Bqldv6
8v0LAJ4r0HRIxfpxSh47m+RB5WVsBUfNsgCePjaP3G1Zd2nGWrM9Mep24ReGHMs=
=m6F4
-----END PGP SIGNATURE-----

--o1C0MLSEXStKmb6A--
