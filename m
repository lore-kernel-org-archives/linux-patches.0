Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE3168492
	for <patches@lists.linux.dev>; Mon, 12 Aug 2024 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723496047; cv=none; b=LHVnJPh6YMBtn5Vs2RFU501vak+okzDVPvZV9fbq45WUzpgGiF59snEfrIVPoFHynTwr8H3ZYPyfFv5pwKZAScQjllfZouEwVPsmW42NDodoEhRZIkBExhUeK1NCM/rwSHMppMN3yvvJEUf7kQTjS/0A8z7xFd6vaO6GUwJPzl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723496047; c=relaxed/simple;
	bh=tVJnW/HDo4hPUZ72MK9zQCOYRnYRrZDhd76yH2rKY6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqEmsGqJz4VwG9MFeJVowATtLRXrtc25Up7vmtYlDNgJAdHKDiDKZWRHN2Snx9qgu/luimpPAadP7UMbfoBVOftIGHigZPtLN7PJszhCoLJfW+oqT7MGcTMezNnZCnuQFktdxJBEWPCP0rMn3aDtoT6wGhM7Bl2WOmzfwx0DRcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 584A11C0099; Mon, 12 Aug 2024 22:53:56 +0200 (CEST)
Date: Mon, 12 Aug 2024 22:53:55 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/150] 6.1.105-rc1 review
Message-ID: <Zrp2Y89TvO5mcOIW@duo.ucw.cz>
References: <20240812160125.139701076@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+cldvk8K27Z+gG7m"
Content-Disposition: inline
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>


--+cldvk8K27Z+gG7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.105 release.
> There are 150 patches in this series, all will be posted as a response
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

--+cldvk8K27Z+gG7m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZrp2YwAKCRAw5/Bqldv6
8iljAJ9J7Ltt8yWAtnSuba266TUgIuL0lQCeNPXceVONV2c15lUZpl3aAun5es8=
=jo7I
-----END PGP SIGNATURE-----

--+cldvk8K27Z+gG7m--
