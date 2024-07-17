Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDFE15FA76
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 09:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721209545; cv=none; b=aM3ius/iieHqTQlX8H6YYvn7jydzianT6uLoLT/JF26GO/vdC5uEpMqLQwWpP4T8lpuUEe1Qwl0IA0APvz0PmY/Rd3xuhPqM3fycmiKhK1lbAMhpK/3IQEzf8I6kJL1TJvw66HRLQCj68AjB4uV3dtaqPmiqp1BWMEqY97ccLgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721209545; c=relaxed/simple;
	bh=bnb0ZqEVncoL3r2j1XafOVvLCTl2J8G21+OspuyiRgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFANl9GdOZg7KX/brdsET2jL/BlrK+OIoCL0Oh6cWka1n3qT5szH3GlnpSfL8FveWHnMB3q2VCfhj93kiZPCLSPAk/2w+ipEhXJdFifLoYanxfFp8bvKOL8oZAp/zBVkPzIM2qZe+XuHMr/WyOTQ65FwTifD+H4iyvUVlAMHqL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 2C95E1C009C; Wed, 17 Jul 2024 11:45:41 +0200 (CEST)
Date: Wed, 17 Jul 2024 11:45:40 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
Message-ID: <ZpeSxMB1lPzvYSm7@duo.ucw.cz>
References: <20240717063758.086668888@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Eb1K2ZlhIW9u/xNH"
Content-Disposition: inline
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>


--Eb1K2ZlhIW9u/xNH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
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

--Eb1K2ZlhIW9u/xNH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZpeSxAAKCRAw5/Bqldv6
8oMgAJ47qrxLCeR9uATnuxk8qmb5Y2FpRwCfbfRRX14ONk41F83VaIZ0wWXJNdQ=
=h7sI
-----END PGP SIGNATURE-----

--Eb1K2ZlhIW9u/xNH--
