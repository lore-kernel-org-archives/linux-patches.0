Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5621038B14C
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 08:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153777; cv=none; b=KbyfkcKtSZgS05EhMizmx2DlAk6b0JPDBp4wQP0nLh6PugUStI+l93X+AWDleSl4PeQehmejewz1dwCywVDjZ7EgnOSgff9uBPiHAZl0ynkvnZQcV0qvKQ7SMHKNB7ZHNpe2h24ydE1mM/Y7StvdLKHXAZaOIiyR48oKDJ6OC/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153777; c=relaxed/simple;
	bh=TgZ1xryqhH3dhCiAul25nJYvdwZ1cXIBuW/9yPoctCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yh9quEHaOJrj4Oz3FYC9tU2qIyUvW5EUfnNCzRxmtrc9UY5Pl14TSraEbbjKqAGvfdjN7p7HQ6Ss8qcIymDKtu03I6L9vTzfz5uCgxAIuhrXvOJ2fN4WPBl2MTL43CPZj6ih/BIoDxpzCI3u+mmGik9dMPHnk3iWceF6g1IA2tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=T15xJmLv; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="T15xJmLv"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1D720112404;
	Tue, 14 Apr 2026 10:02:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776153763;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=1gupBawJhk/S1dJ63WSl3J8HMDhD+h/6bK+mZY9+lhA=;
	b=T15xJmLv1FBZgFYYI3PjqbKA+UAApe8tHoB3G3LHDOw4FABDvvxvcuIYfEuSsShldeBEfM
	hSVYbcNUR7Vh6oXmXMEdmTVWvoRNQtusBAo45+aMMW2H0QxO/5flBUQTC5OAvEVBYwm2oP
	us7sdEWbTvKEaQftMv4vYYv3YBc9QkqiE5NLnaZ6zD0HXdN6rTfBmn1Bt/gfwU2fMzlclg
	uCG9585AhtcgnT2X6Bo/auP6GffsAA2ijjLiU0nU81yXtl+IguRp2pKcVihRL82Tqiq2Fe
	rKmtnlXQV9RpSX3C91pTk9q8khLqZiYu6VEjF1JUOABzI2w3rzg/mh7Y7UwS4w==
Date: Tue, 14 Apr 2026 10:02:38 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/491] 5.10.253-rc1 review
Message-ID: <ad30ns8QQDzk0h72@duo.ucw.cz>
References: <20260413155819.042779211@linuxfoundation.org>
 <39e878af-7418-4538-9e1f-8b62de3d1e3f@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6ifr7Q8hCnjDix33"
Content-Disposition: inline
In-Reply-To: <39e878af-7418-4538-9e1f-8b62de3d1e3f@nvidia.com>
X-Last-TLS-Session-Version: TLSv1.3


--6ifr7Q8hCnjDix33
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2026-04-13 19:52:08, Jon Hunter wrote:
> Hi Greg,
>=20
> On 13/04/2026 16:54, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.253 release.
> > There are 491 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.=
253-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-5.10.y
> > and the diffstat can be found below.
> >=20
> > thanks,
> >=20
> > greg k-h
> >=20
> > -------------
> > Pseudo-Shortlog of commits:
>=20
> ...
> > Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> >      bus: omap-ocp2scp: Convert to platform remove callback returning v=
oid
>=20
>=20
> I am seeing the following build error due to the above change on ARM plat=
forms ...
>=20
> drivers/bus/omap-ocp2scp.c:95:10: error: 'struct platform_driver' has no =
member named 'remove_new'; did you mean 'remove'?
>    95 |         .remove_new     =3D omap_ocp2scp_remove,
>       |          ^~~~~~~~~~
>       |          remove
> drivers/bus/omap-ocp2scp.c:95:27: error: initialization of 'int (*)(struc=
t platform_device *)' from incompatible pointer type 'void (*)(struct platf=
orm_device *)' [-Werror=3Dincompatible-pointer-types]
>    95 |         .remove_new     =3D omap_ocp2scp_remove,
>       |                           ^~~~~~~~~~~~~~~~~~~
>=20

We see that one, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/139011=
55305
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
450043152

Best regards,
										Pavel

--6ifr7Q8hCnjDix33
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCad30ngAKCRAw5/Bqldv6
8rxYAKCxwHUuJ1AM452hBMTY6vKmNZ+3IQCgwaxjVXJxZT95XYc9TUuSm70yvvY=
=5fqQ
-----END PGP SIGNATURE-----

--6ifr7Q8hCnjDix33--
