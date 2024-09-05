Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C126C19C573
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 13:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725544307; cv=none; b=oZUt5gY57gN7xDIekuDEVWXkzBTOYY+5xtFzjMn/tx1EA09W4/dRn2ak2dMExzb36vClbaTAPe8SOQOF4nALMzbdS1jHU4r0f0XVhaRjS8C6D6mRrkpNOeNzEe5sUiYQW6pNc8TeTRNuLf2csRSIiGJ7gAcH4WLzKSKJvbqCy0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725544307; c=relaxed/simple;
	bh=6RY5hefA3MRNHNn3jbgZBDzDkG9OUuZ/6SvoUBITUSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PSjlV6MCRwS1vPDZ+NLvRdVVgvytuhXeKEfz+jJM3RpXvl3g5RLUuRgqunH3i5Q1sYw09Ec/O7XVb78nf5Imc3QgekCSeoRnN9udMRvtTj35at4gOJim/ypU4E2Ii8RA9gSf0UgBBmZhgROon7EphPdVE7hxemkYw8iENkigf6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 117451C009D; Thu,  5 Sep 2024 15:51:43 +0200 (CEST)
Date: Thu, 5 Sep 2024 15:51:42 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/101] 6.1.109-rc1 review
Message-ID: <Ztm3bvcqag+Mf8ID@duo.ucw.cz>
References: <20240905093716.075835938@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rW670pfDm1CkCj6w"
Content-Disposition: inline
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>


--rW670pfDm1CkCj6w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.109 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rW670pfDm1CkCj6w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtm3bgAKCRAw5/Bqldv6
8rfKAKCX96R70U9okhXPsOUOIIwq9/hP9QCgo3A8pqKqwlvxxOjkqfpvxr3CSnk=
=iZMd
-----END PGP SIGNATURE-----

--rW670pfDm1CkCj6w--
