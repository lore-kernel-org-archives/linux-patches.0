Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E6217B4E6
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 18:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712773337; cv=none; b=aG9L6ml2X96y6XZp8hEmB7X/IPqo1RO1h2VvuRf2vL5cDWY0G1O+CW5StLGQmaq5RiLRzfRNOBq0+q1TRHGUjQM+yQu4Gx/1dOGwJ/vi9dl1pPVFWdoUHP17TyD1YZbzH1zEf8aaJ1lfkuekynLoCtKJOpUL/byaSNooh0MquXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712773337; c=relaxed/simple;
	bh=emCfEmonWuKI46r0+LaWfIDnHM68bwnBZgGxRz3ISV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unMoSVqwjDBN73C/LuhsFhfi1P1wWLOJMSjmo5SSTPzIkOJduQ4x1JT58dXZPiYLw7qYFZPDqXUeuB4XOM8URYdEcPJnXugaZULeh6AgzaFUQgclPjdNqRDS56WHEMkb3MjlPFtsOD4xO5LQss2RCH/wI2QbVAsUZGU8/GOF32o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id C4C171C007B; Wed, 10 Apr 2024 20:22:07 +0200 (CEST)
Date: Wed, 10 Apr 2024 20:22:07 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/280] 6.8.5-rc3 review
Message-ID: <ZhbYz3XqW3zy/sES@duo.ucw.cz>
References: <20240409173543.596615037@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="71Z35RUIFCdqClct"
Content-Disposition: inline
In-Reply-To: <20240409173543.596615037@linuxfoundation.org>


--71Z35RUIFCdqClct
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.8.5 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

We also tested Linux 6.6.26-rc3 (63547075e080), Linux 6.8.5-rc3
(6d08df6c401e), Linux 5.15.154-rc3 (8bdd6a2f1b3b) without detecting
problems.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--71Z35RUIFCdqClct
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZhbYzwAKCRAw5/Bqldv6
8jT3AJYzlOrCNYuYQENESlIawrq+OvslAJ9ybfbA5xvqzzQNrndvY+eEg6tBVA==
=1boZ
-----END PGP SIGNATURE-----

--71Z35RUIFCdqClct--
