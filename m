Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A64158A2E
	for <patches@lists.linux.dev>; Mon, 16 Sep 2024 21:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726521257; cv=none; b=fniCYN55f1hiRrjxhS6qkIxrwKkjFjgAupfqgEUUFuiKCauSpDjtt7sF7SkAIxC1VwTSfOj3HB8KQinFRi3p3j364voiUV+f5R9kCueP/ywL5Ntl20FgNuZL1JpIzKQk15UY0sCXiASmj/pPqryphWP3h1eJgnof7N/yY4CgS7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726521257; c=relaxed/simple;
	bh=5IpUJ+P9FLCecTIxh8N96RSfCvX1rwd5L8hBRG35KPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8CTAF+C/yAI9UrUXT9YTi6bth1unsJtfasOAyLt5ZwUhuO9jXIXZq8ZiXYR6ltNq122uVxY519M1JamyspnymeGdHSbSsSdZdHQ9TPV2tbhE3wVNrBXziCa945hxALi0bF0Fz94PVkfEZGvlEN+FFDDNxOQwImtj7afYBUK6Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 53ADC1C009B; Mon, 16 Sep 2024 23:14:06 +0200 (CEST)
Date: Mon, 16 Sep 2024 23:13:38 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/121] 6.10.11-rc1 review
Message-ID: <Zuifgl+Zs84Mt7nd@duo.ucw.cz>
References: <20240916114228.914815055@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jdx0XYfleK5lv4lu"
Content-Disposition: inline
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>


--Jdx0XYfleK5lv4lu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Jdx0XYfleK5lv4lu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZuifggAKCRAw5/Bqldv6
8sjAAKC4vLLVpztmbHeKinnoRlN7i1b8sACeOe7+LU7DCebu1KwuOo5fWelPPXI=
=n0Hb
-----END PGP SIGNATURE-----

--Jdx0XYfleK5lv4lu--
