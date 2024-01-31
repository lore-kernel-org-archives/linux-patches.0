Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B6C7AE47
	for <patches@lists.linux.dev>; Wed, 31 Jan 2024 10:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706698499; cv=none; b=caD58UWlsdD/VbCZ5AsMzcxzHo/YvAtxgqTjjqydjNh3wEoj1NizAaXubdWMqRkGyEkshaFuaWZMoyeUs/VoHcCvP6k+wHDonsAu2tdhEkSIMmEOxdfk2ZQWYjVRxTr6W+EfPq0Kux3CmzaZy7HGlTORg7OE0Nlp+qzR5CnfriI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706698499; c=relaxed/simple;
	bh=r8Wx/oQPjcA/lfeAL78zy/yacxpWCalvIEbrmbWXG5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zoaw2pVn/FP8GPBnE01TtpXfdFxdJ6SQ/PlggPgNTPRZUaWIpCJ62vTc3us4dqELM6kA3um5i58i8MMBgJh6CX733C95kl6N2HRqM2EcOP/NONePSQqnBz829kSs7Z2fQYeJiN6sDwZMi6F3yTSOvGsnQduh9a+UgqdevY5saY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 738871C0079; Wed, 31 Jan 2024 11:54:54 +0100 (CET)
Date: Wed, 31 Jan 2024 11:54:53 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/186] 6.1.76-rc2 review
Message-ID: <Zbom/Y4vjjZrKBn5@duo.ucw.cz>
References: <20240130183318.454044155@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1WdMPOtP07DzbyGD"
Content-Disposition: inline
In-Reply-To: <20240130183318.454044155@linuxfoundation.org>


--1WdMPOtP07DzbyGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.76 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 01 Feb 2024 18:32:32 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1WdMPOtP07DzbyGD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZbom/QAKCRAw5/Bqldv6
8vd0AJ9iDHOPh0yZfdI1TyWEicvCDkOU6QCfWUr3uIYsE5cxmDEY6NZta0hFCpk=
=RvJa
-----END PGP SIGNATURE-----

--1WdMPOtP07DzbyGD--
