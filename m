Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20AD157487
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 10:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594104; cv=none; b=PfWexlLwKiyuoxnN3EMMkg5B/5r9YU4NqsTlKAoqU0m8AXJcgwe+xeo3w9vf28Pb5QdZTa3Hp9mxYonGRwEwo8AcQoW6+14PGdTju6Yk+d2gS2Go1IMNN6EtIY7PwUncvIXIXQepYJsb/yhK9Bez3iiljbiZTuIeobS9L1pF480=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594104; c=relaxed/simple;
	bh=EZNKCowmwsmW2ppwIpTwJGPSUrtaB90v7WchKMVwQpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iF8zjNdGJZEYZLWZg5MEONh1m3QcWJfFAOyPFXP5mtnYJY+Q9XYHUDvDhZ9WNJcRASWpr7WhOd8K1Djq/7mcqdatQ3FlTyzOU1UaBAJkbAnJ91Izc8by8gTLD7wNAbbSkOWOzU+FBVLLQ7SDqSvkHf4skeOIpxAsUtuSZtq/rPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id E710F1C006B; Tue, 22 Oct 2024 12:48:19 +0200 (CEST)
Date: Tue, 22 Oct 2024 12:48:19 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/135] 6.11.5-rc1 review
Message-ID: <ZxeC8xmpkioV2t/Z@duo.ucw.cz>
References: <20241021102259.324175287@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BLwQXiOrTddk/bFd"
Content-Disposition: inline
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>


--BLwQXiOrTddk/bFd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.11.5 release.
> There are 135 patches in this series, all will be posted as a response
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

--BLwQXiOrTddk/bFd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZxeC8wAKCRAw5/Bqldv6
8sJ3AKCraf+Cg1Smm/SJ3ic4WinXK/v2qQCeJJOIqB3YQP4cQN7vnZ5g/bQ5Ats=
=xC+7
-----END PGP SIGNATURE-----

--BLwQXiOrTddk/bFd--
