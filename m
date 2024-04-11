Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7767814AD2E
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 12:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712836955; cv=none; b=PPezGGMZcoBJFFUC8fur/rsoEL+D3hL9kx9NG60QAuncWMp1zeHZigmC/TIg1GYLd+YduLBtQtSzYzLa260t+JyqXqQXpSA8OXcF8xpzCEn3h5wL25xqVbcCazrCirvUeNw2T0l/ubXqEFKQrLN8E0h3ecWf2kwLOGVooQTLXtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712836955; c=relaxed/simple;
	bh=gxI5+0Dn5mWbDTfvB3eONfE1f2LbwsZP1tpXLecbyBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/VRLtU+jxIqjRQuvsd4WROlkW8gztvwW6wo27toM4mlCHI0BJNm+s4usLExI9Qtjg94QMR8qFwYhsi4F0oM9annew/LaIt3uW2VehfqLID8xLlKjO3VI8naKb79avWnZ/6Yd7rNEektcJJwiJuP4u2cLbFKFfEKTpwCfaFZLMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id B688D1C0083; Thu, 11 Apr 2024 14:02:30 +0200 (CEST)
Date: Thu, 11 Apr 2024 14:02:30 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/294] 5.10.215-rc1 review
Message-ID: <ZhfRVlCKzFaN0dXA@duo.ucw.cz>
References: <20240411095435.633465671@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r1RiSgh2TGGxITmN"
Content-Disposition: inline
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>


--r1RiSgh2TGGxITmN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.215 release.
> There are 294 patches in this series, all will be posted as a response
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

--r1RiSgh2TGGxITmN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZhfRVgAKCRAw5/Bqldv6
8n1CAJ4uMnAIOAdXmZoUWwYPLKrA/0DXTgCdFrrgLqspyprX+FZlTu3AKgI/0cw=
=syai
-----END PGP SIGNATURE-----

--r1RiSgh2TGGxITmN--
