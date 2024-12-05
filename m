Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96568207647
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 11:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733397743; cv=none; b=L7D9f89rHhqILOik1Ztq7N26FwcoGJtIHW2pL5OF5yNYuN46CuV2YMBTx7UdJuXw7gOoVEN+lN/CSqZbTxoZ+pZBGiFqqFR+PyhJJmYhOAY6hZ9oPIwq4UWBV6J722OddcBDLV2SwEQS2LHYoEBzac/HsE6sSXgLI1soJDy2bQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733397743; c=relaxed/simple;
	bh=YW9IuS9Zb3ODwLDPFx991KnkxjWNPBqyRHiue/8ajfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r61wVI+SSsG0mTbFxJdt1U1fUCOYe7lDrVhLAdxurwCLaXHvheP2hwbV6JoVVCCD8LB8mZNf2vaGxPAo78NYhXIi+PUOOgqbXH/PjOndHoxltfRl985ZLVMb7z1t6CWWFaL1erFs9036TiT17oehKib7DRyeupsTLJq7miGw+gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 2E3051C00A0; Thu,  5 Dec 2024 12:22:13 +0100 (CET)
Date: Thu, 5 Dec 2024 12:22:12 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
Message-ID: <Z1GM5NPajyk3LDWZ@duo.ucw.cz>
References: <20241203144743.428732212@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gHWoR2ZSrZbPX7t8"
Content-Disposition: inline
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>


--gHWoR2ZSrZbPX7t8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
> Anything received after that time might be too late.


CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

6.11 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.11.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--gHWoR2ZSrZbPX7t8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ1GM5AAKCRAw5/Bqldv6
8k5KAJ9zHgHNuPRaLFekFScn12HgqggZjQCbB4/jqFTMFmyYexhK/tbVYxA9TxE=
=7RAM
-----END PGP SIGNATURE-----

--gHWoR2ZSrZbPX7t8--
