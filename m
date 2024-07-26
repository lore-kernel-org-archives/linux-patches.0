Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69050176FB8
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 08:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721981485; cv=none; b=Gp2gX+AC0eVjHVArzOSBicdE/RyHvisFWsLFKS68b1CbaVj4aTQIfXfh5252kERlNQbVpd0oXVa5D81S2Os8U3d/opXOrNlfqh+WO274vl2Vc4RNNmvmmkiD6QGgSUYW8opm3sSzXYP+yKkO+gNnE/OLg9e4cPDfoM14w8EycNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721981485; c=relaxed/simple;
	bh=f4lo8xC1ANrUkSpwwZlWHfmqtLUCIpF+Hse8obeqjd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFhcdT9BhyIbI7GKPeKr63inXVZWl0x1gf3OgcfrGOmhnoUzQJqkqrgksUi57V5Y/l5aaSuLzWLtbePAgBLYlcDlhNJXatiQtNUDYXxo01BKAgb9iT5V8TN2VWmQlK7kQg++jLEnNBmHDupRWR0VOehJRws8wEZv6RG8FtX1faM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D01371C009A; Fri, 26 Jul 2024 10:11:21 +0200 (CEST)
Date: Fri, 26 Jul 2024 10:11:21 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/13] 6.1.102-rc1 review
Message-ID: <ZqNaKclVy2YzTtBa@duo.ucw.cz>
References: <20240725142728.029052310@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YseUR5lVDl1UtYhI"
Content-Disposition: inline
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>


--YseUR5lVDl1UtYhI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.102 release.
> There are 13 patches in this series, all will be posted as a response
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

--YseUR5lVDl1UtYhI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqNaKQAKCRAw5/Bqldv6
8qMSAJ4ro1zfYFEGGWub3cjWtT5bAYFv4gCfaqd9r2gtQ8iYOPLC5fUaMORczZk=
=64nx
-----END PGP SIGNATURE-----

--YseUR5lVDl1UtYhI--
