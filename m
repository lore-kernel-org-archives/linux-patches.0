Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E8C381DE
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 10:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721211265; cv=none; b=nc5Nlmz7JsLi1rdHNmG8c5//NZjkQfp7M2PzqpUzFXiAdJJ3fUL8rjXX6LjuSYgdDjqOidji7UvqyIjOZ7yWjq2ZpLTgYnlZZg3Im3fOfiLfGqt5+MWrjPUpNL7BD/gT9fBekAZjbAvJznmZKlS1+Wvg7l4toQMgV/g9HPTv+xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721211265; c=relaxed/simple;
	bh=KLfYBROAVzEQxMT/bcJZk7bme2CD0dWiftFcImwlEhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqRfqr2dJ55mJQlKchdhj3JtEinsuJaRT/GtVLN8zLmL4dqxMxeMLmRM9nsTOQiBFucj5sjtWwm8NdlB+oA0v29Iex8btJxYXdQNi1KqDysBCaMX7BVTvGo1/DxnpO+5NFDwF7JvyS8bO3C+BrteWvbAnZBlzoXwudikbg6pjGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 920741C009C; Wed, 17 Jul 2024 12:14:22 +0200 (CEST)
Date: Wed, 17 Jul 2024 12:14:22 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/142] 6.9.10-rc2 review
Message-ID: <ZpeZfvXUVrVmb0m5@duo.ucw.cz>
References: <20240717063806.741977243@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SImE79dpAgX/N+q3"
Content-Disposition: inline
In-Reply-To: <20240717063806.741977243@linuxfoundation.org>


--SImE79dpAgX/N+q3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.10 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

6.6, 5.15, 5.4 pass our testing, too:

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

--SImE79dpAgX/N+q3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZpeZfgAKCRAw5/Bqldv6
8q6aAJ92gtiaeCXcv5+Y1HNU3E6aFUxkxQCghvN5jDm688rH3DYvQjXfaHPATJk=
=W4h1
-----END PGP SIGNATURE-----

--SImE79dpAgX/N+q3--
