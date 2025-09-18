Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A322D7DD3
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 19:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758223809; cv=none; b=EUifRB3adbtAucpwt9pt2gZIioWxhq+cKNLNqyMLnuIWBPK5/NtfpGFbudsz3my7iYGrr1519HSRe5VIeAhycLZYdAT7W4DovrA22yRIuLaRUdeXZhySd54EfTIz4nuFzaizwKDKMBcIk1ashwFkSwkjJvfeLQOAE1lTqSR/T5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758223809; c=relaxed/simple;
	bh=FKEsOI56LS7/xDemYD92KQM+hA+nxZmj/sFLXz7IVng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQBG5Yj+0v0bSWa5lrCI0wZwA1LfIPeXOV9HSM2uzOgnU5O7QLPIuqcR66TkqSWjlwDJtqHKMutsHhXmqX5GsCcszTuahzAUnqqU0Dx+CzylHc7LvOWHIyfZ4gDNuuiCi927ybGrWM7DmozEDU7ZhKSaxtcRe9jpQnA7g8HbYIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=B+TI3dxM; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="B+TI3dxM"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 95B09103F5657;
	Thu, 18 Sep 2025 21:19:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1758223196; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=mqawtjNdYjxOcZsj/aHFQs3RwMbOOeXPmpBsrg2jLbQ=;
	b=B+TI3dxMYGUQp1pQ3dZGrPNd6engZDdWBjIBS2whQ2KcdnC/fq/OELuVd3FIq304wDrVsX
	PjVwwmo2ztUx8w+l2616/BY6T4bol1Ft9blEknD/uT9OJC0oKRym8bkeGAltSqwYMTgiCr
	CjvzB+KqRzMrJa+sDK9xG2iChdgB3sqYskegXMdGJSdcfxv4D6CCeQB691MCervaucuIc9
	pLMbGkRqhUPacI/WNC5fU0/N3kew/xFEF7vejO6wCO1C3iWO67mBO6wrr/lBEiTW0TagiI
	0CBoe8/1VyEmKYNnfq2lz2T7uWk7w2mAXNGGEoY+q3vz+OzwIFWZv41t3QoB+g==
Date: Thu, 18 Sep 2025 21:19:47 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.1 00/78] 6.1.153-rc1 review
Message-ID: <aMxbU600M1vskjuD@duo.ucw.cz>
References: <20250917123329.576087662@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4+k7PLNDGLOn1DXT"
Content-Disposition: inline
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--4+k7PLNDGLOn1DXT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.153 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4+k7PLNDGLOn1DXT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaMxbUwAKCRAw5/Bqldv6
8vyNAJ0WtAHn1HJ+LIpWV2GJsRHhk5o4dQCcDQoRr7WbRysnLG/p+8kaKglrwpw=
=9OPJ
-----END PGP SIGNATURE-----

--4+k7PLNDGLOn1DXT--
