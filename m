Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89D0364A0
	for <patches@lists.linux.dev>; Mon, 30 Sep 2024 08:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727686005; cv=none; b=S2lPn3sPaogof5UvFbHKCQ5rHfCse+bTCN1ZKn1xX3oE1cAO/WdMV4V83f5bhk0P8CqQWulFVF5nF5U6u2tczPjIEixQ+NtAofB/ZtTGpmg6dOJ6DnM8UJlHF05b7HXT3JxNOQZ2UaUIw1eTbn/5vS4AFT+g/lzzkAv+whxQu+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727686005; c=relaxed/simple;
	bh=sfhw3/7e4tY1piYiXmSX+tTjbvSXZTSpMQDlfjPKY6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4wgr1Io4LeZeQSlIiskY5IgMnzWJ3ih4lKFXHQm+Hen9FP7ur+Q8d3WxTsaS6OPx8ijOFcZEGDCemyRcC5tS0MMWFnCbOVw2HZ9eyJSToVyMtiK+WxI23fxfuzP/5bLYiRk+jKckKUwbloTWJS1KOgsSTblR0q0xGSphfiaj50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id EA6901C009E; Mon, 30 Sep 2024 10:46:41 +0200 (CEST)
Date: Mon, 30 Sep 2024 10:46:41 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/58] 6.10.12-rc1 review
Message-ID: <ZvplcRiVA0/j0xf/@duo.ucw.cz>
References: <20240927121718.789211866@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17EQGqeHyWbaDcrQ"
Content-Disposition: inline
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>


--17EQGqeHyWbaDcrQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.12 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

BR,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--17EQGqeHyWbaDcrQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZvplcQAKCRAw5/Bqldv6
8g2BAJ4vgkhZePHIynINbnKwlHg2N4afwgCeNb/ZuJPts17fAc7MLnH4VUW60Bg=
=ncq1
-----END PGP SIGNATURE-----

--17EQGqeHyWbaDcrQ--
