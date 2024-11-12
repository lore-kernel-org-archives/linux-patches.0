Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF52918BBA2
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 20:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731445020; cv=none; b=YJOg+9rXIrByVlKg+M0fZ/SC9XrEDNpXNE9CKdwbTvqRalOCiUjBkpUZs/i9ajwfWE7NcrntJuh61kou3jqV6v4DZftBUh7gKLP8E42ohByuA4fc68r0JvCqblfZOmyBuupZi5FihH7G/0QaVPitV7Vbh+EyIoMICTNFvT6v3B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731445020; c=relaxed/simple;
	bh=LsFziH9V2G80jWh+DJjqQjMT/BZ9BCusKRnehDv4Iz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pxgUy3o19Hr0uhtEcPOondhtoF3jg0jd/UH7OgedVlBUmgg62+9+cweNM0jhlXtR1vDffSQYRcE4FrHECwjIzQti1pMzn6Cb852qdF8fno/C9mrYfOHLXh9uGgeP3+HJm5wM7n1V+eRwdNOuZUOo/4nHxLHru47CwC2xL2FC0SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id A747F1C00A0; Tue, 12 Nov 2024 21:56:49 +0100 (CET)
Date: Tue, 12 Nov 2024 21:56:49 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/98] 6.1.117-rc1 review
Message-ID: <ZzPBEbmSm8Gv9IPr@duo.ucw.cz>
References: <20241112101844.263449965@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dwRW/Cj9fZDwGIUr"
Content-Disposition: inline
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>


--dwRW/Cj9fZDwGIUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.117 release.
> There are 98 patches in this series, all will be posted as a response
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

--dwRW/Cj9fZDwGIUr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZzPBEQAKCRAw5/Bqldv6
8v1/AJ9ip34XPbA0Rk3F81O7Phnk8IsU7wCeNT/Pra5ig3i80y+xLaeqI6EPw/4=
=GAgn
-----END PGP SIGNATURE-----

--dwRW/Cj9fZDwGIUr--
