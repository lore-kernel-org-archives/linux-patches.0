Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8688C46434
	for <patches@lists.linux.dev>; Sat, 22 Feb 2025 09:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740216091; cv=none; b=HA2REsvRa9+HoDI7zR3sVCPOXv872AjU8TNzJm2RYUP3wolC8iCUiWq6d0xyIEqnSQH9gOhI/7bbrRy1q2P/5ZDKapesOIj2Me4E6AiYt132BkmMYBtjBDaszyxCSE+N2bgCDYVuCvsI1hg0sbMAMDUysSg9irn8k+gz6s5a4IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740216091; c=relaxed/simple;
	bh=qlH9IIzw3P8bG0Y+0Ym3bfM7heifGiP46tWEKwRCeDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAEp+seQ0Z0Lo4ws3n3B8ol3x05RONPW3A3q6MmCS02B+OlQdMP2HxJCV9hkU6O0+rk8xdXIvJvJmpgpN6l6/gVLtHzTB3qfnSWf7vCOdYWpzu/OgMefhws+SRg9wmFVJ/+Hv3NFlVZNNHdXqf9Bw9aX2wDpnEX3w22Pkeo6vj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=QC12IWSl; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="QC12IWSl"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5553510382D37;
	Sat, 22 Feb 2025 10:21:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1740216086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UoUQ6xgBvQ4zPUsBkMw3Rw1y1WZnoFmf4uRXsdLpC7E=;
	b=QC12IWSl8i4pbwqD59DEIsZDB0V9HjZHCk0b5/XMoZw7JGGwYBCtriZD6NPQhyCp9rta6f
	i2m8dd9dbY/46Pz/fheaQcDBDaS0EUO2SmYsDXhaDqFrJpk8ZA+GqwoOCPSg5Yge42/8Up
	uyNJGdWxzo1xzuWpuhgxQ7nAXdKmuNziDFGxB+/ENd+h25bx5x/nP0d0KESaCGUXRV0pj+
	xYrbEe2V4NZ8rg4s1d2qcPTEPOoaDD9nrkAVVUOWQvM5X5dOdnTmSr/s/a6y57Ic5+R/ow
	QIEg6AWAVW6bkicuxEurwlQ3PojwqEwuZw+fsDjYfMxw6um6QYZ6cPIO3wpOaw==
Date: Sat, 22 Feb 2025 10:21:18 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
Message-ID: <Z7mXDolRS+3nLAse@duo.ucw.cz>
References: <20250220104545.805660879@linuxfoundation.org>
 <80ab673f-aa94-43e2-899a-0c5a22f3f1e0@gmail.com>
 <2025022221-revert-hubcap-f519@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WnBP1FLzBJ0x5Zfu"
Content-Disposition: inline
In-Reply-To: <2025022221-revert-hubcap-f519@gregkh>
X-Last-TLS-Session-Version: TLSv1.3


--WnBP1FLzBJ0x5Zfu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2025-02-22 07:28:10, Greg Kroah-Hartman wrote:
> On Fri, Feb 21, 2025 at 09:45:15AM -0800, Florian Fainelli wrote:
> >=20
> >=20
> > On 2/20/2025 2:57 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.129 release.
> > > There are 569 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> > > Anything received after that time might be too late.
> >=20
> > And yet there was a v6.1.29 tag created already?
>=20
> Sometimes I'm faster, which is usually the case for -rc2 and later, I go
> off of the -rc1 date if the people that had problems with -rc1 have
> reported that the newer -rc fixes their reported issues.

Well, quoting time down to second then doing something completely
different is quite confusing. Please fix your scripts.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WnBP1FLzBJ0x5Zfu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ7mXDgAKCRAw5/Bqldv6
8llnAJ9sSrPxmuiGUCG4udfEAn54Ow/FPQCfdSghReCJWRAH2GRnAj+6HrgvEuk=
=98kv
-----END PGP SIGNATURE-----

--WnBP1FLzBJ0x5Zfu--
