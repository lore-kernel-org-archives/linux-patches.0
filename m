Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AEE4AEF6
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 19:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717703327; cv=none; b=d0Ad1occ3SQV65hjCCKjzdIQGRO1YL6AnHJiykiKWU1oHK8C93wh/uxL986lqEeMO0RQcJ3mSGA1so9+lNFGj2YGbrE2lZRPLH7Jk/hYyBbXf2SaYV3JtIO5JWSUSENzvamcb4dO/rCA79LdOezBuyw5x3yIpj0JLrpQ0U32GR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717703327; c=relaxed/simple;
	bh=LebS/2fw8s2Lxg9BC4+yJBaWgY3uUUSnjUqqokjqy4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RykYqvKJa5WwTwaKLEuXN8dNISSJZiYWhw6Ob/9NnXqnDqwRsqlycC1uCmCO21lWNlrMcqLb0lyu9hIuKhs2fXU6oVvu7/+eKhIHftZzL7N0ghenPxgYoP8AGhQ61Ad3BxVXhBmuSK7hV+PaNQTrqF/5mkKaIxDcE+KexJObKGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 84ADE1C0082; Thu,  6 Jun 2024 21:42:59 +0200 (CEST)
Date: Thu, 6 Jun 2024 21:42:58 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
Message-ID: <ZmIRQizxFNmy+Y/m@duo.ucw.cz>
References: <20240606131659.786180261@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HmC9bVVotOoa1DWC"
Content-Disposition: inline
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>


--HmC9bVVotOoa1DWC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
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

--HmC9bVVotOoa1DWC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZmIRQgAKCRAw5/Bqldv6
8h3WAJ0dYJ6eR2CIyzkkTAahqJVYP8DSTwCfYJAXqvLrjXZrGXT1i0cH4dSjBoY=
=J4N4
-----END PGP SIGNATURE-----

--HmC9bVVotOoa1DWC--
