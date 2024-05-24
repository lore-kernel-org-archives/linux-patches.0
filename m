Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191B643AA3
	for <patches@lists.linux.dev>; Fri, 24 May 2024 18:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576464; cv=none; b=nOn9bfVqE692A5PnXyoHMoMa4BQpRyuipPnIGOSCLgqI+Q9GmD+nPyubFQ3ZpHN35GHqOqc8G451Uy1QpODCXYzsY1r5I9neUTspk9TQtfjB0dzNKvtIhYGouWG5oMZhioNNKipFND0sR90tQjd3DKUoKYK0rwQMUFkgmF7XFYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576464; c=relaxed/simple;
	bh=H0d5UkGL0Q3b1gWFoaRHDwqYOH4N6JLBIDgAWXyVK8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekgyGaf2KWArpMuqBrD9XumANN4pYEgyE9VOGx/U6tHE1R/L6RLUDz0Ljn9XmmjyqDfszgt5Ew0MEJG8TAgrIEFiuskO7KpwASBC7dsMqYh3yBVfPmddns2dM1SrIEgzD7cHa4oYBf+Iucdq+WlIh/8PEIhewNrsdHBnukra8dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D11031C0094; Fri, 24 May 2024 20:47:39 +0200 (CEST)
Date: Fri, 24 May 2024 20:47:39 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
Message-ID: <ZlDgy2Xg40PmmVRg@duo.ucw.cz>
References: <20240523130330.386580714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="we+3Jk5TNvblIb1W"
Content-Disposition: inline
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>


--we+3Jk5TNvblIb1W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We are now testing 6.9 too, and it seems okay

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

We are seeing some problems with spectre-meltdown checker,

https://lava.ciplatform.org/scheduler/job/1138103#L998

while it passes on v6.8.11-rc1:

https://lava.ciplatform.org/scheduler/job/1137807#L976

I'm not sure if that signifies real problem.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--we+3Jk5TNvblIb1W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZlDgywAKCRAw5/Bqldv6
8mF2AJ0WHccb/X35mddtQ4Y15r1pWfukxwCeMavXVE+aF9y3LeF/gdgRWPty0/Y=
=v20g
-----END PGP SIGNATURE-----

--we+3Jk5TNvblIb1W--
