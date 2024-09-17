Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DFF165F13
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 19:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726599993; cv=none; b=hHsfm147HhhdLynvohYj/9A9oCFn8NQVc3pRer6gHrXI/ohFyjMCi2ZQwLTWHltxv16Qju8pN12hPiORyBwzAJ2EEOIML6FKCaDoLvl3Jn1rhQQqsYcn9i3gTMm927zmiM3x3PwLRgo61R9vlGXdZl5AA5ir2bVGvxash3LsNDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726599993; c=relaxed/simple;
	bh=8wFtswZWFh91W7FGJxw4QcrzDtccGGJvKTDHEorF5es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rKHGDTBaDexy2iGx2ORh/jsFisHUP1FmeXUaF0D1xOV2+ZSFsvt9izSqDRmjlT1VeEdTRittRZUNaAh6/+prUyWcHejsuIPKlpK6IMcV09nAjrXK3V0u1YOScHsWGbgIIWVC+tsLOcZvL7O0tlEEtROYkB27DlLcnng4N3RqgEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 9195A1C0082; Tue, 17 Sep 2024 21:06:27 +0200 (CEST)
Date: Tue, 17 Sep 2024 21:06:26 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/63] 6.1.111-rc1 review
Message-ID: <ZunTMkoReHwXLx6l@duo.ucw.cz>
References: <20240916114221.021192667@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neNGhF22YAbEdb2K"
Content-Disposition: inline
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>


--neNGhF22YAbEdb2K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.111 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.

Could we get more time due to all the conferences/travel?

Best regards,
								Pavel
								=09
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--neNGhF22YAbEdb2K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZunTMgAKCRAw5/Bqldv6
8gh5AKCZ71OMuyJEDxznZP3+vsXVG1xuFwCfaNA8kDgtOW8gJ4N9CZil51UCi9U=
=wozB
-----END PGP SIGNATURE-----

--neNGhF22YAbEdb2K--
