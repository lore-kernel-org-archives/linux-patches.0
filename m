Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901932AF09
	for <patches@lists.linux.dev>; Tue, 14 May 2024 19:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715716072; cv=none; b=a/APU/CT77HwrEiayNA2kmsAy4ebtlrU+zp5jzS9/11R9AINlGxXTK7G695U1DttWyJCJXd6P+vFnOuTIHHpwtlNpaZUkaaSpJwI/T2mlupFM9ub+HVfk8Bc4fo/GzalTnboEglmPMFrg1N2P8IqYN20fcfuOMk7eI1qC+6CEuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715716072; c=relaxed/simple;
	bh=zvyqoR0pAOWeQw9bGL+bI2kZ/Qx3hCO4XLckJSozRHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WRZj3tbMdXBlJmygciOfAxysBjGAONxAvGcbd/eq5Vo8TivyBdf1VtBvydWlkd4nPJTAS+wx4NQsrkkxZAV6ToVr7GYw77rKKI1Plab1PdpCUpoc7fW4U8pCQHuFPv+oRcZSk+yqc2PkZ1JminNdgVLIo91T8QiwNfH80K5d9U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E3C2F1C0081; Tue, 14 May 2024 21:47:48 +0200 (CEST)
Date: Tue, 14 May 2024 21:47:48 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/336] 6.8.10-rc1 review
Message-ID: <ZkO/5CJ0M0VfK9p8@duo.ucw.cz>
References: <20240514101038.595152603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LTTWuTFqn242T+fu"
Content-Disposition: inline
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>


--LTTWuTFqn242T+fu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.8.10 release.
> There are 336 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.8.y

6.6, 5.15, 5.4 pass our	testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--LTTWuTFqn242T+fu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZkO/5AAKCRAw5/Bqldv6
8gS5AKC3iAo1D6kKPjYGqd7q4EeCJL8KHQCfQAw3HSb7JiwMbnj0EO+itJQpQT8=
=CaAI
-----END PGP SIGNATURE-----

--LTTWuTFqn242T+fu--
