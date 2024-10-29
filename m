Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90529208201
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 20:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730233755; cv=none; b=Lp4azBqYGoXSsC4EXvML0uKkd7ltpnC8yeH9pYc0j7hurUCZYc+s42TDPR8/xHOfQuFeN3MrFa6Jt1ATfdSqJb7/9Bw2LebJamejMRHonJBtII5cFJPmtdLxNt+FS5o4xSn5b964jJ1u8DaVRPzBniyJPoLelFr5/h2JXoBaevs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730233755; c=relaxed/simple;
	bh=X9amSME64Aubj6meV8ZaWlOmLqO5bfIO8YgAkHvGW/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvJ4dKi8xfZdY1QcWPkZA/WDZEhP+ZHkxXKkm8/bcQDXC59Tt9oKQq+P2Wzqh6F1Rf6wCAx6IA+yQaWhx0VWdFVAPZNnFCHFB0aCWIkjEcWl0tCZwny3xBAl1FobqhkHBFUsMqqW52pIz8CKGWYK/7TVfLBLHXwNvZUQR6iElmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0BBAA1C00CF; Tue, 29 Oct 2024 21:29:12 +0100 (CET)
Date: Tue, 29 Oct 2024 21:29:11 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
Message-ID: <ZyFFl/TQeQHfprd5@duo.ucw.cz>
References: <20241028062312.001273460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7XXbQHsdIGhFzM7t"
Content-Disposition: inline
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>


--7XXbQHsdIGhFzM7t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.11.6 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.11.y

6.6, 5.15 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7XXbQHsdIGhFzM7t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZyFFlwAKCRAw5/Bqldv6
8lE9AJ9b34rY8AOwfe6diU/jgrSb6MgRZQCZAQLpy8S/o+aHHyfhbvZIBE7+CWY=
=wRYo
-----END PGP SIGNATURE-----

--7XXbQHsdIGhFzM7t--
