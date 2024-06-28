Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CF274BF8
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 19:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719602803; cv=none; b=ZTIlPOW+cVXemlzE628CYOuA/6pqcD4PR3ITlwRNnfMdqEVDsoQ4DH82FHp3tQL/qiUP/8/fBfZWAcChyijKaYbsA+Wi4+6r5ssLURAnKr/JGmuk0WqpPOkg+QmvqMTHMDHVgBUrrLdbR0JoKI/ZZHIrCnrkCMWS7K9KlFR2DLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719602803; c=relaxed/simple;
	bh=Y0QvLg6bXlP/3+Lp7CNqG4UnW2xON9omx8EiHg8pqg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKkmITZtH1RE4sspYrs1pnaAiSUH3GhOMmaiv472NAmJ9BmE6yEbC6ia93YzSfstnFTD9TNHIOr4Pub/8AuUXHCI7ELVgHmIefE2/IVXa1s06pn2kPtKbXoYYVl/9cfDkDrKQi37oxmcRfmzdWqgbab4NAMeuNGJiPHWzToouNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=ucw.cz; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucw.cz
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 308601C009B; Fri, 28 Jun 2024 21:26:40 +0200 (CEST)
Date: Fri, 28 Jun 2024 21:26:27 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Message-ID: <Zn7nDgMdq+qyGX7J@duo.ucw.cz>
References: <20240625085548.033507125@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j4z3n0NlBc9JNXrS"
Content-Disposition: inline
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>


--j4z3n0NlBc9JNXrS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems on 6.9.7:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

6.6, 5.4 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

I expect 5.15 will be ok, too.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--j4z3n0NlBc9JNXrS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZn8OYwAKCRAw5/Bqldv6
8gcLAJwOy6wMbFn4D2uR7pexUd4YeHv2xACfaZEW1WJ3TJIhliojRswQutAc6vU=
=d3U7
-----END PGP SIGNATURE-----

--j4z3n0NlBc9JNXrS--
