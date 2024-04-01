Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40CC54F86
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 20:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712005177; cv=none; b=GOzV6k6WIif4wHi3xODupX/4+Taj/8je1sr/weogUAhwOabpaxuxgFVhIAH8FhJEvwMiuo1BmRO02vafSmRFmajc+c3NFhaanRHtdlvXSPN5KoX7vCsvxxS8pY8DAlCqG+FoOJmnFsj0q4Q0Fiji4HwBQOOFy9PY+qDVPBRSstI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712005177; c=relaxed/simple;
	bh=eKWG1f6tm0zIMg5xKZI/ckCdSvymeFvwHNa29v4r2OI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwU/q3JXgQMUhvc6+tVsuFlO05ygeW+A0sSPD/N9io0zE0RIp0SQsqdpA9wrXmCXmbY4tqRjLWTpeYhPDCETgxGl6Hn3VGDG5XBi2BAlUmwHakjoMvoRMkcbHLoWvhkmprdF54IFr8BJfQbwi309OE6Al4ZviOMuoxbYjotBQmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id B7DD91C007F; Mon,  1 Apr 2024 22:49:38 +0200 (CEST)
Date: Mon, 1 Apr 2024 22:49:38 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/272] 6.1.84-rc1 review
Message-ID: <Zgsd4rrC5wztALCG@duo.ucw.cz>
References: <20240401152530.237785232@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Of4ZIbeCjk+Z5oeV"
Content-Disposition: inline
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>


--Of4ZIbeCjk+Z5oeV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.84 release.
> There are 272 patches in this series, all will be posted as a response
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

--Of4ZIbeCjk+Z5oeV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZgsd4gAKCRAw5/Bqldv6
8ip8AJ985uqouM5Ahp8XKWBviSlAhm0XEwCcCycULJA2isYd4SGrgz6YaVMSV6Y=
=gLxA
-----END PGP SIGNATURE-----

--Of4ZIbeCjk+Z5oeV--
