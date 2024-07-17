Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F4A3FB1B
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223784; cv=none; b=u2tckDSFTxwTtibHXDq8iUl9Y+1PO0Pk+2l4TamJBAbuQFLyAEnUHhmk3/EDMNkGwjyQlckVV4c0144MlGlA3JRTcs6Udb/asSaBkQWinTDgprE3y8DBo8jLnYZih+H3HHiiDOFdDhE2Gl9ROzOzljmVEm1+KWsKb0y6Bb7qREY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223784; c=relaxed/simple;
	bh=ixCL8xzaE2ZxtRi1fPUh2QkbJpm7j8F/r5sUTI8caL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FhP2R1W2/+kNqvWosWv3A5Y591ksd56CLJhphyGEkfuzD7YZlxLrcQhrvmcqVvYU1619/Q2yGICi1p5DYgsMaGPRVA5a8z+qORmXHq8/M49Rnp1CPGpHihSWTc4EuRKlWYY0r2JLR9thUCDAqWQabp2FVjRjbAv8HEQSCCIkqYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 165B61C0099; Wed, 17 Jul 2024 15:43:01 +0200 (CEST)
Date: Wed, 17 Jul 2024 15:43:00 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc3 review
Message-ID: <ZpfKZLGpunPDxLz9@duo.ucw.cz>
References: <20240717101028.579732070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eXfPdIR6E+OdLT5h"
Content-Disposition: inline
In-Reply-To: <20240717101028.579732070@linuxfoundation.org>


--eXfPdIR6E+OdLT5h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.318 release.
> There are 66 patches in this series, all will be posted as a response
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

--eXfPdIR6E+OdLT5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZpfKZAAKCRAw5/Bqldv6
8tbDAJ9gptSQeDQUaBuDtsqzkKncayCqMACgjKSzDsM4KSsNDjxGotPR2bWRvfc=
=p+R5
-----END PGP SIGNATURE-----

--eXfPdIR6E+OdLT5h--
