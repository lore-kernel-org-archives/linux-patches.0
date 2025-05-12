Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F019E25F962
	for <patches@lists.linux.dev>; Mon, 12 May 2025 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747043762; cv=none; b=mcdxMBZnAg9Tskl8D+kJGiqCJiUvpjsq09Hka2vB9lskqxv1zkokCIHh3sXrMDD3HvzYEop4bAcYyzzV+xbR7nRoFI8LahkurvrCoHtq5Dp5p2zWUC09Z6YiTr+zUx54apBd1XvCyiLSoZGyXrLp7cGowKdY5PPYku0He6sBuGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747043762; c=relaxed/simple;
	bh=T09OpNp+FNllmJC9eYYpHGyRexTCIm6KmP6tjZc0pjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxLpCmNhFWL9e+46t7VbXvA6Q+1KON5l+Vm4R3qLW3PubBPcdag9yvFO6G0IwkSue+3pOuZDTElVLsw6UxV7c/QdgRQPN8VtLisZmPudt6qfVFzbagI7l0EcELz5efQ3KftASh1MskCupKY2yo89gH3ZDfMo85LmQU+3IUo586A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=R/ZrP73b; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="R/ZrP73b"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C5A4210272092;
	Mon, 12 May 2025 11:55:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1747043758; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=a2idZBdlZFTg/YbhlRsED1K0jykkLCJPk4JtmA9TXLs=;
	b=R/ZrP73b9jX4WIfnSjXMLZOANedt1Idj4lQHG5FCmsUb8MFIFCM27gAmun0KscjZ+TJx6S
	aAwQXa88arCHeXUwX5DaNlJp6TJFPCIcmQmoqq0lfB//f4DvCewxJ2oHxPs9s/adDPFeac
	LESUTyFscYisYvfV0xFGe23I71gW490iXMLj9NK3nenEW4gEpa7Ne5jhjHFXitGXE7dUU4
	iqGQwtFZ8o0PO0H5DyTFqhEvAeY+cgxlbPGCbAVCIcOVukZ4c+xcvuES0ZLDVe0nmDVsvq
	xeOuy58NFd7O+9L2ZsXsESKkbkHOT4+MGLsU9nXT6a7Y+LJ7V55EJPYS8Cp//g==
Date: Mon, 12 May 2025 11:55:50 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
Message-ID: <aCHFpvebEucllGq5@duo.ucw.cz>
References: <20250220104545.805660879@linuxfoundation.org>
 <80ab673f-aa94-43e2-899a-0c5a22f3f1e0@gmail.com>
 <2025022221-revert-hubcap-f519@gregkh>
 <Z7mXDolRS+3nLAse@duo.ucw.cz>
 <2025022213-brewery-synergy-b4bf@gregkh>
 <aCG9kFjnZrMd4sy8@duo.ucw.cz>
 <2025051205-return-blame-ba79@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2O7SBi5KcP6k6vqT"
Content-Disposition: inline
In-Reply-To: <2025051205-return-blame-ba79@gregkh>
X-Last-TLS-Session-Version: TLSv1.3


--2O7SBi5KcP6k6vqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2025-05-12 11:31:20, Greg Kroah-Hartman wrote:
> On Mon, May 12, 2025 at 11:21:20AM +0200, Pavel Machek wrote:
> > On Sat 2025-02-22 10:39:23, Greg Kroah-Hartman wrote:
> > > On Sat, Feb 22, 2025 at 10:21:18AM +0100, Pavel Machek wrote:
> > > > On Sat 2025-02-22 07:28:10, Greg Kroah-Hartman wrote:
> > > > > On Fri, Feb 21, 2025 at 09:45:15AM -0800, Florian Fainelli wrote:
> > > > > >=20
> > > > > >=20
> > > > > > On 2/20/2025 2:57 AM, Greg Kroah-Hartman wrote:
> > > > > > > This is the start of the stable review cycle for the 6.1.129 =
release.
> > > > > > > There are 569 patches in this series, all will be posted as a=
 response
> > > > > > > to this one.  If anyone has any issues with these being appli=
ed, please
> > > > > > > let me know.
> > > > > > >=20
> > > > > > > Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> > > > > > > Anything received after that time might be too late.
> > > > > >=20
> > > > > > And yet there was a v6.1.29 tag created already?
> > > > >=20
> > > > > Sometimes I'm faster, which is usually the case for -rc2 and late=
r, I go
> > > > > off of the -rc1 date if the people that had problems with -rc1 ha=
ve
> > > > > reported that the newer -rc fixes their reported issues.
> > > >=20
> > > > Well, quoting time down to second then doing something completely
> > > > different is quite confusing. Please fix your scripts.
> > >=20
> > > Patches gladly welcome :)
> >=20
> > It is not okay to send misleading emails just because script generated
> > them.
>=20
> *plonk*

Yeah. Cooperation with you is wonderful and I'll gladly copy&paste
=66rom the internet in case you don't have internet access and remove
blank lanks for you next time you ask.

BR,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--2O7SBi5KcP6k6vqT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaCHFpgAKCRAw5/Bqldv6
8m7SAKC1gQ++k6DXs+0CokEuWs/nHR2xYwCfSuKLefx9tNtHUmrhTVmHZaulW30=
=B+rO
-----END PGP SIGNATURE-----

--2O7SBi5KcP6k6vqT--
