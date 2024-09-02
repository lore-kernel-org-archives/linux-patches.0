Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A50A14EC7D
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 07:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725261016; cv=none; b=km3W9MdN1u7oLAOyCeBFtb/W9L17Scn1+GT6CwV3RZS97Bt7KgLONLM9KniB8fMks8ODM3Mv3c/hFR+Fkc4GxQojqa/sNDVhCUic8dnbffP62CAkupl9vGBrP9CAmw/q2W3nSuW+082MD0ArGd0G/iDKdQ/YGBqCZwX5hqGUWHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725261016; c=relaxed/simple;
	bh=YPC3VoqsD87Sp65DLyc9F9bwPyq/jD4yZxZdXmDVhQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ShhZ40ckLWAR/aDlGt476nTUViB4OiPX0WN4PBt+xuOZYEKqRmBeNBiMvry8WbFcU2CtiV9AQTgKxczON12Gg/FxqQE/eaPrmIgqYtsfkkowjhAaZvhw7jMC/KDMy+sgWKjOKE7f0RVpalizRS+7ppb/VCB6hlA6wynydks6Em0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 9AD681C0082; Mon,  2 Sep 2024 09:10:06 +0200 (CEST)
Date: Mon, 2 Sep 2024 09:10:06 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/71] 6.1.108-rc1 review
Message-ID: <ZtVkzoOn+V733ARk@duo.ucw.cz>
References: <20240901160801.879647959@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WK/NPMud4oG8IuvU"
Content-Disposition: inline
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>


--WK/NPMud4oG8IuvU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.108 release.
> There are 71 patches in this series, all will be posted as a response
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

--WK/NPMud4oG8IuvU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtVkzgAKCRAw5/Bqldv6
8u/2AKDDRSTD7UgM+CrsppyGHKbPCqWcRgCfT81t4ywhysaeJaILeIcJ6l6XIco=
=oMLD
-----END PGP SIGNATURE-----

--WK/NPMud4oG8IuvU--
