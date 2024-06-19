Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ACB15A863
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 20:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718830422; cv=none; b=tWNeKUd1qptmDPLe/SeWy9+jq+LnzvYwzZ8HY+AZMMPwXn6BZMNpB4HIyWKR3LFEieG8PXmd/yp9/DV0szj/eGgigL8AZaJSAX5Y5Um/UjdRrD4TkUOebrnoKqspisG2SmEAqcWLYaJvWgyzbbfgrYCkjYKeJWiuRV+df/pxi8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718830422; c=relaxed/simple;
	bh=GNFCgL0eo3F/Upeqaudb5LNHEm1jLtMNrmv0qv2nLA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HfcR2JboP99wfxfXPKkG7uMTGqqhj+1uCm+lHSGwKU/ZJ4rR8x9n+t2Q92apCVR/Q3jfdjMw7+opqBUq0GB753mDWVMtSbZLoIzh4ALFvpFm3He6QpfotzLUPIpggkBxjTO84BN/U8vVnq+np8C4Nn8HBH9Q7feCYWLXHpoSQKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 8C91C1C009C; Wed, 19 Jun 2024 22:53:37 +0200 (CEST)
Date: Wed, 19 Jun 2024 22:53:37 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
Message-ID: <ZnNFUSCvPI/7KG1R@duo.ucw.cz>
References: <20240619125556.491243678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDOuMhcyTfEL1C/f"
Content-Disposition: inline
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>


--gDOuMhcyTfEL1C/f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
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

--gDOuMhcyTfEL1C/f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZnNFUQAKCRAw5/Bqldv6
8sBOAKCAFl46L0o6ySgncfy84IlpeLdEkwCgk6lw7qY/Lifqoq2waYQgt2OqisM=
=6ulv
-----END PGP SIGNATURE-----

--gDOuMhcyTfEL1C/f--
