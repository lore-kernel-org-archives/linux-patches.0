Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A502955898
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723748084; cv=none; b=DOGq0L208xPVWwsXuvXrDg/biU/hBk3FfyS7YevzAWSHPoVTXnzQJhgNmo0p717ljL8h2QrQxnTI5e0DjGKM/DJjPJZPeGFt2iQ0n7PEyK+pK0KORzr9psOPeqz8x7cqwZWI2W3kywsCVPBK/kE9L+yq6pzhMWdMAIFCy/6z6P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723748084; c=relaxed/simple;
	bh=ZnTqkbaOd6hcnesgLFMCEx6KNpxhiE6j5gnQH0o/J8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbEDCfdSJmpaO7ZAj/+vzq5yiI5cFODfpwOq3IePyfWacp3EOXD3eyd5664bAOows0pkW4mYqrQqc6FLXGHiX0xuV0s/z0fqtRYJ46mkE2orwHtDmqP1AgaWORJNyBjULBP7p73yVbnnOd2oLhelXpS0hk/n7yG7xNbalsrrQAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id DBBEB1C009C; Thu, 15 Aug 2024 20:54:40 +0200 (CEST)
Date: Thu, 15 Aug 2024 20:54:40 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/352] 5.10.224-rc1 review
Message-ID: <Zr5O8ANwDKgijOHb@duo.ucw.cz>
References: <20240815131919.196120297@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jXasjNTxnUw2tUFw"
Content-Disposition: inline
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>


--jXasjNTxnUw2tUFw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.224 release.
> There are 352 patches in this series, all will be posted as a response
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

--jXasjNTxnUw2tUFw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZr5O8AAKCRAw5/Bqldv6
8hruAJ9WEmnBscs+R9DxEBsjDXDN1P5dtwCeKryFHb+fvGCFEIlL1njqWnxQQcU=
=Y2Gm
-----END PGP SIGNATURE-----

--jXasjNTxnUw2tUFw--
