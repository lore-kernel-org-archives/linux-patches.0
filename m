Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70F74A2D
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709058710; cv=none; b=sSKIjOOJQ7hbHkmmkEn1xmE1M1EKBc2fLWGOmsNGqltYrKw3HONyX8/n2PxRbvElO6J7VxbyLXH5+4nHHJRtW7Xly/5hSrvnDj6PW/wGZTfFXnOvS3MhHxqhxW2CkMtTh9ylwMkCmduzEp4vGOLP3jDOnorNL15B7BuXVFEnsFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709058710; c=relaxed/simple;
	bh=Z8XhcB7OuJgbBQJu4/2Vzv0I/wM+4190zRkgaTUtx3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msChhHbVqgqIGLoLzWCfOWUxYOW/wKFoYBciINUfni2tfAMFR1LTF30XBpnhtB64yGOLzjxE0pU39lW6NCtNEYQweC0H0/eRcTgCTdBNW/QCvISq/bcXPsVK6E57JPqkMUEwE/dpAnRrcHvolED7nTi2Usi3Z1ppSGU7122qMqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 26CEE1C0087; Tue, 27 Feb 2024 19:31:47 +0100 (CET)
Date: Tue, 27 Feb 2024 19:31:46 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 4.19 00/52] 4.19.308-rc1 review
Message-ID: <Zd4qkgueW1OnfuNh@duo.ucw.cz>
References: <20240227131548.514622258@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4pLTpJTU8o3nN5wW"
Content-Disposition: inline
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>


--4pLTpJTU8o3nN5wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.308 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

6.6 and 6.7 seem to be ok, too.

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4pLTpJTU8o3nN5wW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZd4qkgAKCRAw5/Bqldv6
8iRdAKCXlSm77CRhPym+SRL0vtTdmMT7qwCgiejZYVtqsM8yfjJhc3MpXWUdI6g=
=Qjw6
-----END PGP SIGNATURE-----

--4pLTpJTU8o3nN5wW--
