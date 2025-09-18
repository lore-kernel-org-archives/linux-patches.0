Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D67A221F29
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 19:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758223232; cv=none; b=d8xBGcfxIL5/hkHe0Y94R+mmAwFf7gv02y524AIG0RnHlYdE0xVPLqVxddcXOWs+ihSwmuYLM08t5Jnax9YsVX/q9uIeclQzxB5xcBgrgezVebhc594DvltwGJGecF4BGOMpNScJ4mhc5+bhgOWtZpsD4/ruD6Fk8qxBb6z4+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758223232; c=relaxed/simple;
	bh=6X+0UhYu7sLzyvZNV8RvBo1en/SsyqjMWJWJAT5BcIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSXsNRWTKxgpk2RZ2Uy73oLeevELXX+seRsjZxVNzCwOlEYW4P++boDHL7/kdYyAKk6j5c2LziA5W28llTiUdIga1oE5Ra0kNrjUMyqdFfpaKPHk+GNcDoo0XIVHqMIPtU12Dqi3/pD3XH93X5Tq7AwsyAUgFXBZZ1br21T7bQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=TGfATnKd; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="TGfATnKd"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B35D71038C109;
	Thu, 18 Sep 2025 21:20:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1758223228; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=8z+Boem7dLOmHClsueDWmqE+iV8cgbl7cA8sHkxe2Zk=;
	b=TGfATnKdi+nOgNe7aSlq92Qasopo03sOsiDEAbxxGJZZKzPU6gulRKOSX9IIMOXwYlDUDT
	mv1qCJvcBYpu3TpIaV/yFVAx5iysjV6cqMdKU03HRoYp+gaZ01W+DcdW7YPxmf/riMwQIH
	BNba6F3fFbenYsLWVOOej79wl7TdLeSW3lAa0N1hnTxKYYED+4y63iUAVu/LwGGSm/haEV
	LIE1A+oBcwRgKa7685FUjUPZd5HfqLYrEJS/rp0cUNufuIIAR7Vt6+P4DeilXpTXH6jWRp
	a7fQ4IhIEP2GN4MFoYljcjmynYMDTfTLFqerm2QTOVV+tY3bIRiqfsqHz+C8MQ==
Date: Thu, 18 Sep 2025 21:20:22 +0200
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
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
Message-ID: <aMxbdswogissQ6pE@duo.ucw.cz>
References: <20250917123344.315037637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CGujPfFWIRKlyd+0"
Content-Disposition: inline
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--CGujPfFWIRKlyd+0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--CGujPfFWIRKlyd+0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaMxbdgAKCRAw5/Bqldv6
8io2AJwLyaYKeMNYBUn1WhHBG+KA1xTJkQCggCG4ZDsqaaODGPyhDzOJ248Tqfc=
=wGsN
-----END PGP SIGNATURE-----

--CGujPfFWIRKlyd+0--
