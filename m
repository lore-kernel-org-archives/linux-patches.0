Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1E8179950
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722017567; cv=none; b=swbi9f/JoCgY7TTfGarXWZXEjLPIx4SeaDOocSkCOP9cL+l1TYQaGtxb546nXdlNKiF1UpSYqOQV2BbdIe9QGnrrJ0UH72XKAh3sd/Sc2j2t+wTaZRTLGzN1kqm+9fW8ylObv0z2XvbgVaSl2QqWqK9hcb7vt0gs/719u8/xxcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722017567; c=relaxed/simple;
	bh=msXhPBFDvzZuVhoI1C0PLzJit0dqtfJ3wu/wvv66kkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhKB6FDqa6Riu7BFZw64R80UFafVk5sN5n9fK9bdd+aWMX7Tg1iLsP5xSMD0UACZSeI2NgkTa13agZHGGo61w565v7JrEvQ50yyhCjTCPjWSOKw4uqCuKBZt0uFOkFd1sPtsemDinIiKjeRYNXsjmhOjq3QoeXEr/oxAZvqLbCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id CD4E61C00AD; Fri, 26 Jul 2024 20:12:41 +0200 (CEST)
Date: Fri, 26 Jul 2024 20:12:41 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/32] 4.19.319-rc2 review
Message-ID: <ZqPnGVVBdpkNhCV3@duo.ucw.cz>
References: <20240726070533.519347705@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMMmQsNv5h++zohk"
Content-Disposition: inline
In-Reply-To: <20240726070533.519347705@linuxfoundation.org>


--NMMmQsNv5h++zohk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.319 release.
> There are 32 patches in this series, all will be posted as a response
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

--NMMmQsNv5h++zohk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqPnGQAKCRAw5/Bqldv6
8v2iAKCMDY9LUbO27hITN4+rATK123v/JwCfY3do+diwNwH1PkOXpQBFyg6Htyo=
=UWUC
-----END PGP SIGNATURE-----

--NMMmQsNv5h++zohk--
