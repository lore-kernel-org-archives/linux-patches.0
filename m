Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D82D18412F
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720027682; cv=none; b=ZRpRIGAxH5RsTS5Z2W4rBGeQ2IR2+Ar+ns3a6hprG5lllMS6pRFdVVBdXfukfaGFk7lSzhvfRV3cnpXboh9s6MTOE41YpQgtfVzLSWckz8TOzO93tI+nDd26iBsgz5Gjz6z2eMy5OW6CkfiDwDqIBnjAJp50axynAT+EOvnWHZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720027682; c=relaxed/simple;
	bh=w0K+1FBi+TtptGJh/uSJqSNwyvtYCD4pZIz13f6Rw+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B33A0YbGZGlMmNi+FpshjWzDeqdrcVoMz3Weg1Hl+LgW7HotfsTFUyMCrr9UHxRx0yskZJdo5Df9dRBe3k0DH4KysCNJ3D7UBRHNL1SkfzaKSMIpu7sY56L2dkEnEEQa84Rf+YyS6JyBtdXdqeGSViYz7q2lsWnyeSI4PhCjmws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D35851C009A; Wed,  3 Jul 2024 19:27:58 +0200 (CEST)
Date: Wed, 3 Jul 2024 19:27:58 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/290] 5.10.221-rc1 review
Message-ID: <ZoWKHiNKjAc2VreH@duo.ucw.cz>
References: <20240703102904.170852981@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fQnoFvq0oC+PdLbL"
Content-Disposition: inline
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>


--fQnoFvq0oC+PdLbL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.221 release.
> There are 290 patches in this series, all will be posted as a response
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

--fQnoFvq0oC+PdLbL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZoWKHgAKCRAw5/Bqldv6
8vF4AJ4+dualZaec7FJ9QFznQIP1v49sLgCgtQATtkvptF96hdzb7MRoJJImJ+Q=
=Q9np
-----END PGP SIGNATURE-----

--fQnoFvq0oC+PdLbL--
