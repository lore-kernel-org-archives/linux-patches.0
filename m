Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDFA194C9E
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 10:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729591222; cv=none; b=PccJJ0aVP4CJXQWZo56qTshBSGs4eAkBnWPg1marqr6MAG0ZXHovcDHxtZyiPYmvTdIoAcqjdxSQ1PBaatA6/ocrFKvHqnrpMP5aI88htg9vwh8RZm6JcGUvk5MBPDNLmxCH5i98WAYLJ6MfJBnuWhiVQByN/uqAq5QfxW6hE6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729591222; c=relaxed/simple;
	bh=m0jciRWov6/Pb0WczR1f3Lnq/y1Tdtrih+STLR9VlJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1/8SlSwQyH56kmPoQ4Td7aXURgcOPq34MpPIHei+DBmx6NZ5r6vFYU2s6aRtFp+sWeQAp0qr1MZHmpHrBUuaONLzmDh+8U+OeH+HxmvC2CTb0ePrqafwwoa0F38txhoqdWRuK+uO+Ce7sFxCtCe3qT0eyH/j7jRMMH4ZcezsPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E9E6C1C006B; Tue, 22 Oct 2024 12:00:18 +0200 (CEST)
Date: Tue, 22 Oct 2024 12:00:18 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
Message-ID: <Zxd3skksiPPTYZMV@duo.ucw.cz>
References: <20241021102249.791942892@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pujFqurOXd2c9nDO"
Content-Disposition: inline
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>


--pujFqurOXd2c9nDO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.114 release.
> There are 91 patches in this series, all will be posted as a response
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

--pujFqurOXd2c9nDO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZxd3sgAKCRAw5/Bqldv6
8n5oAKCeLZWZSYnwkLPsGvu+M43IMRHeaQCePcyyp4blxEr1GePNTb9nxQ7bUTA=
=z2vA
-----END PGP SIGNATURE-----

--pujFqurOXd2c9nDO--
