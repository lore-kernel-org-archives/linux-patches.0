Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BF6433D5
	for <patches@lists.linux.dev>; Sun, 17 Nov 2024 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731850224; cv=none; b=jL+CaQ5eSnP6mNDV05I+JGpdHtJT8JaY6enxuXTbPRJIqhKHOnIZnmR8GfU3FDHPeARWLm3/BwZZNHCK8/n34PcIaF3vk0q7KpQKHsSul8lFgrYb65PIYGK5ChPuoiODGeGIASOJfVt7m+UI4SsNOPHBblK8R+YjxzlTi6MFkno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731850224; c=relaxed/simple;
	bh=Ys2TETaypZnRTgEeYiNUSUGMQJxOUgO07xbQTqSq7QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDN8EAArnAFvGRGDgy5pjBdqKwk5BAdH9Dbiavi6KgT+W9eMAjH4PM/wYPG71X/z7igBTSzJaj2CmsnxaLe6t8X8HNXRh0AIRhL9BTyjYgPwbJjwqj/DKebI6gZ+W36CESawaEpBTDDNbXR0ufypjqIzE/UQbaQx8VtsLhP3fAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 91DA11C006B; Sun, 17 Nov 2024 14:30:21 +0100 (CET)
Date: Sun, 17 Nov 2024 14:30:21 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 00/63] 6.11.9-rc1 review
Message-ID: <Zznv7ZQ7K1CYuS5s@duo.ucw.cz>
References: <20241115063725.892410236@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wu3pQFBYKXSmjAPP"
Content-Disposition: inline
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>


--Wu3pQFBYKXSmjAPP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.11.9 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.11.y

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.11.y

6.6, 5.15, 5.4 pass our testing, too:

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

--Wu3pQFBYKXSmjAPP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZznv7QAKCRAw5/Bqldv6
8tR2AJ4gbLbaN2z7p81gp6WypQYu8SQOfwCgoBb4Q7F7UhsAYC0q7BhBBfzw/4k=
=cCNI
-----END PGP SIGNATURE-----

--Wu3pQFBYKXSmjAPP--
