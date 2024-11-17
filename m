Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D907E79F6
	for <patches@lists.linux.dev>; Sun, 17 Nov 2024 13:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731850118; cv=none; b=S6AOF9TeuVm9bTCBnk5am2SdTDFX1v2UUl40Wn46Lu05npZG5GwJYuC5LamJnwm+jRPhIUbMnnWeVI6Wy3aVkQZO8tTReF4IbfRDXp6CX/E7Ugzn4eGRKkeoZVr0lRM23EzQEHjuZ3nx2NJLOdDDhzvraPGOj8WECVu3ebLLSjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731850118; c=relaxed/simple;
	bh=bx3r4QIQAahFoDG2DBeu+XZjR7UMy/rwEfagxq56LVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upsy0bgMIbTy1wJBjpZhFSZuLhIDOwyTcBvZrDuHZefwe1g0E8bryBfJMqh3lvoJF87OCHbdm1xsteVqPFRd73q/AMhCmCubRn948KG6aoxx6/q8z2y8KlS0MuOk3ZGW8kKFoBJaaxJ0+QcGs0u62UZrti3x/TQcDyO9F7MdHp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 1D0211C006B; Sun, 17 Nov 2024 14:28:35 +0100 (CET)
Date: Sun, 17 Nov 2024 14:28:34 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 00/82] 5.10.230-rc1 review
Message-ID: <ZznvgmzumS+ZS3tm@duo.ucw.cz>
References: <20241115063725.561151311@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ycXsIuw838M306Fg"
Content-Disposition: inline
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>


--ycXsIuw838M306Fg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.230 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ycXsIuw838M306Fg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZznvggAKCRAw5/Bqldv6
8qSBAJ9CFbPWc4s1QV9FZHlvnYK4ghoN3QCfd6VKpwUc8YM9J2P5yaQyWr5IGyc=
=eiwy
-----END PGP SIGNATURE-----

--ycXsIuw838M306Fg--
