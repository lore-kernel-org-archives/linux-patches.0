Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67632745E4
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 08:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721981453; cv=none; b=cDKNY2k0s2WjMrfvX2UEgelI3gC/p1YomhZKQVXSKfNpT9VtxkNq5tKhDGTEruzb1uvr3a2aV8i+pFHiFCIXJ26Unb18HUIQBQTaV/gchZJBvWpaiu6C2tmeF8QLaMxBs328m+gm0BlS5L3R6UvQA//sfRjbvKeiqEJCamvJ3I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721981453; c=relaxed/simple;
	bh=TH63FRKyjEHQwbVDOC2WVlq5NhPS8ablh/6EKbT1leY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kE4pV9C95Mnlf+OOzlWFTWltQWoG2Paw/nUJClN7UnRvy1cDd1sEPs3cLCecTaqjS4JWy6TiBhIckskseuA4Q2AawdX51QyX68cq0RhFgfwvbymNj+SI3fc8j7iGUYVJGw5VokC9YAcXUg+tBc9hVVunFqxWvFf19Iu+iiHUzLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 04FAC1C009B; Fri, 26 Jul 2024 10:10:44 +0200 (CEST)
Date: Fri, 26 Jul 2024 10:10:43 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 00/59] 5.10.223-rc1 review
Message-ID: <ZqNaA29cUYbmHZC6@duo.ucw.cz>
References: <20240725142733.262322603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D+nzZP0aZdbtVv8l"
Content-Disposition: inline
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>


--D+nzZP0aZdbtVv8l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.223 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--D+nzZP0aZdbtVv8l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqNaAwAKCRAw5/Bqldv6
8j3/AKCS7WnKxlfRjOeX8FsxwWN0KaFvIACfQU1Y1xuH+yy20AN55ebM8itkyNQ=
=Uvyk
-----END PGP SIGNATURE-----

--D+nzZP0aZdbtVv8l--
