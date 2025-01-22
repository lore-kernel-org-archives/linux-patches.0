Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C9E215769
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737575805; cv=none; b=sRqx3lFZC75kL+1sDoDB4W9SJVMUG1CsaszYn/ZeD+5huRxKyghhXfiRQIYiCKj4V4K3cvf6ToKq3M2Khi8N0GkceIZxoaphFYe1ArghirxbezdJQisogUaSvGzL9hhYSxdk1xSnQ3ml2MT+1AjQLAbhuq5rOfdxQ0ch6DiNp2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737575805; c=relaxed/simple;
	bh=XC3r42SIYZietkN1h4UcaPkAw8SYYwYJQ3gWVUBFrC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4V/nUeNpycataduXzgi+hzSKOosgHYPL4q+90IgQFiVGl398GwYUvaROGcZ562YNVktMuMLLERc9N0GBeHskmrYgc7KRgmdZ4EH81F5i4g1K0cSj9uscRSSrQbnleZFApPzOzYY/m0btJR6wQZRsXEVWF7N+/5hCZMlhdhnByQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=arTgccGC; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="arTgccGC"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AA855104858BC;
	Wed, 22 Jan 2025 20:56:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1737575800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LN9jpEkMvM6XLEFTPaF/Eqg/KZXCoYNRJBCIYSwxTjk=;
	b=arTgccGCq/9SmV7ppGGaOCF0ZuD+fkSHHq2ZhfehUSnPilW0BKhrBlMUsAlqSkhL2uYq5V
	uexYVe4dKlpL5TO9nAL4VIliV9TwWyjTICf/ascsqalQ6ENYqBPD4DnG2W5zmErsvKRwyy
	CcfwkbPuQvABRuGi0U3OE0h1Rjkue5Lm+xCZxZbXJE9ymxLUp3gHTVAT6/nkqtxdGtLc3/
	dMK75p6vAWkoMpCBscYsSUDvMq3GxkGVlLXz3WypmzJJzO+kpLIC/hC5rUDVjkop+uCySE
	Jbh8eqtnJfGnhSBnpIkUz6xMRGU6PFR/jr3eTZSjEmPxZzXNtWHWGSmtLeftAA==
Date: Wed, 22 Jan 2025 20:56:28 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc2 review
Message-ID: <Z5FNbP8Mavw3M2BK@duo.ucw.cz>
References: <20250122073827.056636718@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SXQB6mp3LGiS5xp3"
Content-Disposition: inline
In-Reply-To: <20250122073827.056636718@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--SXQB6mp3LGiS5xp3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
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

--SXQB6mp3LGiS5xp3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ5FNbAAKCRAw5/Bqldv6
8mHCAKDAPc3mTwKVsDFRGCTfIfniVNOA1wCgqK6jp4ET7bHAhjDkK8L8Kh6Lye4=
=XNVO
-----END PGP SIGNATURE-----

--SXQB6mp3LGiS5xp3--
