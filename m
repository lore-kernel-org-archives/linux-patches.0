Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043D198A0D
	for <patches@lists.linux.dev>; Mon, 12 Aug 2024 20:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723496088; cv=none; b=BOXoAkPurg/MIo63HGRuiFvRQKMbIVugD1rjA/hY/6dI8gCJO2EFzcLi1J05O0YgR4/VUZtZgUXN1o4G5YgxzG6qJWhRhyMp4LSc60eYeDASzhB78T9+Lkz/6ghLY3zhrcS41hbovHtGGi2mvQf4uXDC3bLyGssjX/A0XFaXGNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723496088; c=relaxed/simple;
	bh=OwsiZnunEauynsbrUTX6Kyfwgir0S0mJwiIuZgkYrZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+F+K+ByPlhW6Lk6POczEeywkxTCYjF14put8AGOMyfsVOqAIU1ZfpSjfXrFLAFk7s8vvajq0w68pot32kiIlrFidfSF8lAHW2138xi7150DgOBEEXlEIuXe277tGaKRsC+J5uGNi//vly4/WGSlBKCIGgNR5NTRBG8xLUzt8gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 642281C0099; Mon, 12 Aug 2024 22:54:44 +0200 (CEST)
Date: Mon, 12 Aug 2024 22:54:43 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
Message-ID: <Zrp2kw3N8Gqn5lBe@duo.ucw.cz>
References: <20240812160146.517184156@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEJ+c8NJ5YuClCWC"
Content-Disposition: inline
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>


--yEJ+c8NJ5YuClCWC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

6.6 passes our testing, too:

(single reported failure is not kernel problem).

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yEJ+c8NJ5YuClCWC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZrp2kwAKCRAw5/Bqldv6
8vquAKC2YjTvxl+c8NEZxuRClG0Ky+0hMwCfbEzpqyWT/46BgBF3kkzELIYp9fQ=
=uo0M
-----END PGP SIGNATURE-----

--yEJ+c8NJ5YuClCWC--
