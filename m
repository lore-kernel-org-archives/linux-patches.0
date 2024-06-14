Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E331146D60
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 09:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718357796; cv=none; b=QUHPl96acnB/sNoIm1APpvP6ld6rJeF8ZBUandAKTZ42/4t1iNhEyFHp3sgFee2rpxs6M4TBo9DzSXPRkRAgw4P8R8G21t67mSsTlw6wGobLMIUCQZaE8hByMh3XJXHzEKr9OsL8HIhWDQyL+CzzI65keQdWub678aRlS03Lp1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718357796; c=relaxed/simple;
	bh=iy+3p201t7O0SGPBzTa45QUuSpDXc5cs9aoiVifuhxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOhwdvtr+L//r9HU3bJTXFi/r9vf5Yb+8dtEHV/X5E9LnMcXD+02EqlXCDlGAL9lT3akiPWIeMf/O4BYs5ruYIczm93YVQNrkDXgGnibOtlC0aWAEVjjhmfS9jnxwTCwXUssYaPzlGNSlnaVpQH+B7zK+8qddXOlUjjhvTDf2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id EAFF61C0082; Fri, 14 Jun 2024 11:36:31 +0200 (CEST)
Date: Fri, 14 Jun 2024 11:36:31 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/213] 4.19.316-rc1 review
Message-ID: <ZmwPHy0XIndXjwYt@duo.ucw.cz>
References: <20240613113227.969123070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cYVwTws6yiBpPitg"
Content-Disposition: inline
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>


--cYVwTws6yiBpPitg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.316 release.
> There are 213 patches in this series, all will be posted as a response
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

--cYVwTws6yiBpPitg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZmwPHwAKCRAw5/Bqldv6
8rUqAJ91I3fRxiXEBM8r910lBshmCXQsYgCgu5GsyLxKtEhQHu5dlDqtD3pbAJs=
=04g7
-----END PGP SIGNATURE-----

--cYVwTws6yiBpPitg--
