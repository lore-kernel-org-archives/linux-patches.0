Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EDA1BAECD
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 19:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726084757; cv=none; b=IqRp9Q9n+ZWxyu+3yTP4rym6xc6cLTyjqxyEasmoEPZTZB5vzLo2H1H1bw8gSKavG24nCRUC0mP4eGsC/B+d3r8erbxy56zVfISA375+gzh/HZw32OHeKmTePkQjjxANeR3H7bcEOAxujXeUHbdGdaR2jLTYZ9nwXSgKox4BfYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726084757; c=relaxed/simple;
	bh=TUWzvb3yw6nbEmODiVJTh4wv8+p9tUgIBBWID6mK1ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PfdiRsDxNVl2yRoaMbGLwNy9uMUT3ikTfapL3rrdQ3AZ9M1GK2eCX4c98nbpaIDVwqoLqFHkV8Bj6TEFxrRa6TvFomnru49iHJNaFf2w7dvy/GIxfzEHN1mKYQe2kf6dbBAGQ9QaPKDKdiNbK+yjcXlP7+yuqlcYm+0UvRDOzp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 622661C009C; Wed, 11 Sep 2024 21:59:13 +0200 (CEST)
Date: Wed, 11 Sep 2024 21:59:12 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/95] 4.19.322-rc2 review
Message-ID: <ZuH2kHBofUxZySDZ@duo.ucw.cz>
References: <20240910094253.246228054@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zy1+klCtqGobHtex"
Content-Disposition: inline
In-Reply-To: <20240910094253.246228054@linuxfoundation.org>


--zy1+klCtqGobHtex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.322 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--zy1+klCtqGobHtex
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZuH2kAAKCRAw5/Bqldv6
8ji7AKCVq7v7YDdVhTNpwL9sG0U1P1/pVgCWLohrT7ITMTdRUkkbfVoOsbEhVQ==
=VmUP
-----END PGP SIGNATURE-----

--zy1+klCtqGobHtex--
