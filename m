Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B436D29E
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 07:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713943695; cv=none; b=FAEz9my3x12rr3d0m/ZPDPYXZ+b5Q24ZKw9+QBHPkFpXdHuWdwQBaI+znINiZs2ZukJ/COFv8vG9Kp4zFffMp8Wf40+dwLJ4DxMY9K0stVe8h22qaWSgeoLvSPX9ADw+NhoXx5JXLWrzi4JGb0ltBbEr2pDI38cmA3Vge8mID4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713943695; c=relaxed/simple;
	bh=VblaPkz2M+x/B2o17KTSp7PJSPr89iTr0i3x/hNomCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YleucXsbhAD8tlTR/ewSj7MUC18iWwsqQGr36NA9sjzcO1oUrAb6UvM0E0Fcu+Vsj9fh9DoSctnnGkcaXyTOcKyCyxKsoxl5IVNCXjEJdVOsqv2A07bEV0mTB9nXEGP/7kMQ6xGZtTwc3j375w/dZKZ9jzmSl1XBnnuWhRpQAMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 9A0E51C0080; Wed, 24 Apr 2024 09:28:10 +0200 (CEST)
Date: Wed, 24 Apr 2024 09:28:10 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/158] 6.8.8-rc1 review
Message-ID: <Zii0igG0SBKoNfBn@duo.ucw.cz>
References: <20240423213855.824778126@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Det3Y2CjCsXIUhin"
Content-Disposition: inline
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>


--Det3Y2CjCsXIUhin
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.8.8 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.8.y

6.6.x compiles ok, too.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Det3Y2CjCsXIUhin
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZii0igAKCRAw5/Bqldv6
8rP3AJ9JxRp/y05xyEmTwqVrAySMEwhEZgCeOf1Mq4fbTg61/L7krZVRxVm1P4k=
=/0+P
-----END PGP SIGNATURE-----

--Det3Y2CjCsXIUhin--
