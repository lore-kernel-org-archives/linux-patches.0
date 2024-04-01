Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6B9446AC
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 20:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712004729; cv=none; b=LTZ+KzKJzn8vlscto3YDJW/5lzRJlhjNqF/jY7y75ytZ7YF/y+v5EwmAGGz8TklydbS2XQgX+46Ke1hu8v0mpjXSzkIg1o4VDRBKP2TFdqhj0Kzn6RJHN+yAjIeHAdeZ2WJBBtih67PltAEyFXuC3VY7cmf5X3b7zweIB8eqa9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712004729; c=relaxed/simple;
	bh=RZlg2tayKusF7kQBs0+2viuQvrK/GRKLePa+7q4QBDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhIxcsC4o/WmnIkiKzUtCDps4k1ZJsLWC3Hkvy6mT8RrrxGkHn6HTqHlDsNRUv2vXAfIroZR1fGVD5SqspVhcsnhXMBSbZX0RBRYUX2R56pAbIjaDtF7TmGkqckRmt0ZCBvVIeJ4NVm211BgXAzdOUrccgsZxLYqWwJVYcX+be8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id BEF9A1C0081; Mon,  1 Apr 2024 22:52:05 +0200 (CEST)
Date: Mon, 1 Apr 2024 22:52:05 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
Message-ID: <ZgsedQ+tN9lQ6Z0B@duo.ucw.cz>
References: <20240401152549.131030308@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="REZ6x9MHEV34UQfL"
Content-Disposition: inline
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>


--REZ6x9MHEV34UQfL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.8.3 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP runs testing on 6.8, 6.7 and 6.6. 6.8 and 6.7 tested out okay, 6.6
is still running last test.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--REZ6x9MHEV34UQfL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZgsedQAKCRAw5/Bqldv6
8hfrAJ936elqL3nGv/nZPWys/ZK0DwhR8wCfTqK8NSxrl3jcdn6AEH1DYrLcn7Y=
=0CAU
-----END PGP SIGNATURE-----

--REZ6x9MHEV34UQfL--
