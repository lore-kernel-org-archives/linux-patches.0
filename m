Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6319B1AAE0B
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 21:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726003088; cv=none; b=I1139Askn0MCgTI5BjJIDpGlsFdLtpbxbMdgAe7smwr6P6cvPV5VhMsAVcMocjZadi+U4R0Z3B2sl8txRsdqhNM7vQnc0oHOvqCFdPsWagoOP/ILDrAV3+T7oI/2AWQL31ADkTAhRfhlKvAW3vvaJXip5kfWML+kR8cMZup64+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726003088; c=relaxed/simple;
	bh=8g9TV2/suphqrvT2OhTPAA8wYMJFZCJAWkQHFG1+mIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+BHvubeaewzt6etJyLKnrcWw7kuQFxkp4fdUGC+IirpEf/zAggWoA/Q+C/GhP3a6eIFLh9RmQL2wPJkNzQ+DGNBPKPuU3iVWzQc3DOTeKyv5ZW3YbQyiCIwE1MaEsaw87IXx+MMwHRkUPuj2wh/VhBip88MQLdoQglnvVjlf8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id EA30B1C00A9; Tue, 10 Sep 2024 23:18:03 +0200 (CEST)
Date: Tue, 10 Sep 2024 23:18:03 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/192] 6.1.110-rc1 review
Message-ID: <ZuC3i1IvbeglFlUs@duo.ucw.cz>
References: <20240910092557.876094467@linuxfoundation.org>
 <ZuAhCgJ3LUBROwBR@duo.ucw.cz>
 <2024091051-blooper-comply-47d3@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0nag7RDMpWKqiaR6"
Content-Disposition: inline
In-Reply-To: <2024091051-blooper-comply-47d3@gregkh>


--0nag7RDMpWKqiaR6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2024-09-10 12:44:36, Greg Kroah-Hartman wrote:
> On Tue, Sep 10, 2024 at 12:35:54PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > This is the start of the stable review cycle for the 6.1.110 release.
> > > There are 192 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > Can you quote git hash of the 6.1.110-rc1?
>=20
> Nope!  We create the git trees for those that want throw-away trees,
> once I create them I automatically delete them so I don't even know the
> hash anymore.

Modify your scripts so that you can quote hash in the announcement?

Avoid using "-rc1" tag for things that are... well... not released as -rc1?

> > We do have
> >=20
> > Linux 6.1.110-rc1 (244a97bb85be)
> > Greg Kroah-Hartman authored 1 day ago
> >=20
> > passing tests
> >=20
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/li=
nux-6.1.y
> >=20
> > . But that's 1 day old.
>=20
> Lots have changed since then, please use the latest.

I will, but matching releases and tests based on timestamps is just
not right.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--0nag7RDMpWKqiaR6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZuC3iwAKCRAw5/Bqldv6
8tl4AJ9PuFMfhI3x0R2NJmJzMoP/fSWLvQCgkVwg9780H4X06uPb293ll+Wtwd0=
=b1LH
-----END PGP SIGNATURE-----

--0nag7RDMpWKqiaR6--
