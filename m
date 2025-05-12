Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F7025B688
	for <patches@lists.linux.dev>; Mon, 12 May 2025 09:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747041698; cv=none; b=kSTkaEZtJuUT7MrTjkTrEDrfbFn68S6ks40GSTDYYl97kjX0rb8YADKHK1YJ46wdWzPzg81N+D8eLQQe5WT8j9rB3ICVGezCJMyyPgWIghF3HH1AClb1o/KEFUVdgtt/k5UgfYKeZHXjdvNg4JnhL9nCSKLvHEM70kaxnO+XizA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747041698; c=relaxed/simple;
	bh=BM3gRkXxpP/SAKqky4iMMr6XOm95AlJ/4pnaReE+WGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3h/Mi9Qrg0QeieTqguXTEgEK49b149lu34cW+gY1Ag+qko+OeHTTepw/bRH53CfKlwyXF8AZPaWLsV7g2kqS8cJFEdRs9XWxATiMv5lVr2gf/A7dpTu20TnHCRFwWtFlC16QZnHOGypDoL2rCcBcL3sHqJhMYdGslkZ/GCKUF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ZlSnRaJK; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ZlSnRaJK"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D5FCC10269581;
	Mon, 12 May 2025 11:21:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1747041688; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=v9XjcCc4+Cf0EOOdbdHT18QGrQ05At74v3TRQYv6bAA=;
	b=ZlSnRaJKukyx7PnElNEJGOPHXWwU2zZi4dNgGOO6fV7mnefUhhTe8OCaXdDhsA7jiO9i+u
	W9FmNFjPVp0onVkdA2KaBgu+Hwf2Jj2b0eIV5ATFP2rTZUnZ9yjeiVOO0LBohADZI4S5T1
	sVat7kRNqXblIrt6ky7Q9PYVnl639uSGeB1I6hAnl6OhAoWCEF6O9/RJbUCl7fsLGi+QG+
	pfgV9M1X9WwYGU+2UfXvJSDfCgAxpCutGtpFQOpQi5UQjpvJ41SL5ihq1uqVPKfGtjeghx
	zPGDRUXP70VnDRasaVdfh5dCioYzNzCqXHXngEeT0iTSkbyALQpRc2tHR0ZKlA==
Date: Mon, 12 May 2025 11:21:20 +0200
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
Message-ID: <aCG9kFjnZrMd4sy8@duo.ucw.cz>
References: <20250220104545.805660879@linuxfoundation.org>
 <80ab673f-aa94-43e2-899a-0c5a22f3f1e0@gmail.com>
 <2025022221-revert-hubcap-f519@gregkh>
 <Z7mXDolRS+3nLAse@duo.ucw.cz>
 <2025022213-brewery-synergy-b4bf@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nPmsm5nd9fp/OMiG"
Content-Disposition: inline
In-Reply-To: <2025022213-brewery-synergy-b4bf@gregkh>
X-Last-TLS-Session-Version: TLSv1.3


--nPmsm5nd9fp/OMiG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2025-02-22 10:39:23, Greg Kroah-Hartman wrote:
> On Sat, Feb 22, 2025 at 10:21:18AM +0100, Pavel Machek wrote:
> > On Sat 2025-02-22 07:28:10, Greg Kroah-Hartman wrote:
> > > On Fri, Feb 21, 2025 at 09:45:15AM -0800, Florian Fainelli wrote:
> > > >=20
> > > >=20
> > > > On 2/20/2025 2:57 AM, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.1.129 rele=
ase.
> > > > > There are 569 patches in this series, all will be posted as a res=
ponse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > > >=20
> > > > > Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> > > > > Anything received after that time might be too late.
> > > >=20
> > > > And yet there was a v6.1.29 tag created already?
> > >=20
> > > Sometimes I'm faster, which is usually the case for -rc2 and later, I=
 go
> > > off of the -rc1 date if the people that had problems with -rc1 have
> > > reported that the newer -rc fixes their reported issues.
> >=20
> > Well, quoting time down to second then doing something completely
> > different is quite confusing. Please fix your scripts.
>=20
> Patches gladly welcome :)

It is not okay to send misleading emails just because script generated
them.
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nPmsm5nd9fp/OMiG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaCG9kAAKCRAw5/Bqldv6
8nz5AJ4lRm+kLJxoT8iH3r2OS+x01g2/pwCdElAtjh0eJDbRTA3b5dOr3cnBK8s=
=ctRF
-----END PGP SIGNATURE-----

--nPmsm5nd9fp/OMiG--
