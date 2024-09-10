Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D06318FC84
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 10:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964559; cv=none; b=kIqFqYzMB5WqJ+Vz5B5U5JbVEn8goumafUcasKkPlT68N2PBAHcqHB4sTwdquWBJuwQ4y7n+YrPlxruZbg6cHBYcxEOPBFTAfncg/cXEgiYEHFJB2wcgyvxhcUEbB70VFxZP27aIavwHOZ5S8K1RSNGdE8C8TBOUbUab/gzkiFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964559; c=relaxed/simple;
	bh=rXp9VPIWYwYxP3tRta0x35hYjF5C4uWsNb8Pc5MPAjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hx/346YZkB17KbdkmlDd1sI1YAszzZPA8mMKuYve2KfFsnoSzWaDv6pFuloXIvb18ME0wLPpCqz/FNjIp1KGHkSuBmaoE89xeLSkx8bnCG9h91QNGSGKyY2TWvD1a5eamTCJAWJaYFgS3slrvZQKhmc4njqkuXvg6cMUzfHfwFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 3285E1C009E; Tue, 10 Sep 2024 12:35:55 +0200 (CEST)
Date: Tue, 10 Sep 2024 12:35:54 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/192] 6.1.110-rc1 review
Message-ID: <ZuAhCgJ3LUBROwBR@duo.ucw.cz>
References: <20240910092557.876094467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZVbRxP2zarSARuXd"
Content-Disposition: inline
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>


--ZVbRxP2zarSARuXd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.110 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Can you quote git hash of the 6.1.110-rc1?

We do have

Linux 6.1.110-rc1 (244a97bb85be)
Greg Kroah-Hartman authored 1 day ago

passing tests

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

=2E But that's 1 day old.

Best regards,
									Pavel
								=09
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZVbRxP2zarSARuXd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZuAhCgAKCRAw5/Bqldv6
8nInAKCAfDzvB/g7di65iJIiWwf1ut9eEQCdHD1aUpkZmIRykjHO2l2uq8zPlU4=
=0bYm
-----END PGP SIGNATURE-----

--ZVbRxP2zarSARuXd--
