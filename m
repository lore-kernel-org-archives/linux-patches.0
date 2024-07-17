Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29603180A60
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223735; cv=none; b=KFBn5aS+lqYXehnea80F2QJga+FULyjej/WuUv9uzfMx6yeqoE5eKt2zvOiG6ao/W+piyWVfVaWCkazlBkNhMvZr5NvDb8XFVhkIJj4//nyHljgbYU9un5fGuX+NIpN+HJJfpK8dySgro0lridMI1OU9kFq/8guSrWv0d8WoOT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223735; c=relaxed/simple;
	bh=ESBtCWTAZOX9RzBK7vBRxLtLCDUTy5DAseYw6edJOkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJpvrcheYy00AOG8huXT5DBxv4aOO1ChYScFjwkBB9PegrHNYLI3hYQA/FMI8PYIQJffTdWa/SIikJ3g/0cGhxQ6dhwFBWvCb1jINfF5XkzGF5Ypl/Ntlt50N6T/fbD0R/R6y0abYO/fhj6E2PYkAm7hpTHMOBCjUnI9ERJJ6Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 723C21C0099; Wed, 17 Jul 2024 15:42:11 +0200 (CEST)
Date: Wed, 17 Jul 2024 15:42:10 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc3 review
Message-ID: <ZpfKMlVYSMVohw4a@duo.ucw.cz>
References: <20240717101028.579732070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jr9iQs9kQIv2xY+n"
Content-Disposition: inline
In-Reply-To: <20240717101028.579732070@linuxfoundation.org>


--Jr9iQs9kQIv2xY+n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.318 release.
> There are 66 patches in this series, all will be posted as a response
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

--Jr9iQs9kQIv2xY+n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZpfKMgAKCRAw5/Bqldv6
8lGUAKCeWW1Bo2geOK70VToYka/Ce21faACgriwUo4+IaKlWKxSHyASYu09YoQw=
=pmLW
-----END PGP SIGNATURE-----

--Jr9iQs9kQIv2xY+n--
