Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC22617BA1
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 20:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752610819; cv=none; b=DUOaVyZ6qEM60nVcsnqmIcpWB4pNF0cizqaTmoJEliePpyMZ7fY8Zgw+Z0cZ/jnpG/ppFSz+tPkaUGqjkHk5PwOY9vFJ3xlCkjwCX1TAKhDR9z+bl/xCPpH6oVEdEUjV+I+ocJmatYVxtOaQvXftlbycUO/03aJSh/6rptQgSkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752610819; c=relaxed/simple;
	bh=82dh6mXxzgool741Tp2b9ID7hUl6Ys+rldzp0+2gDog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l97EOYlJdT0E+8a5B6INz7SGDBj01ZLDTfEtWl1O8cHEukIXIA4xOX8s6Dzm0H4RwjRzxdyfrsmW+CZ2SVyv+hn/EetRIrDwNwsJH3Pdh/RpAOGC4RB5ET3D62wQQjw2timnq8mTwh9271KeTEBUmPJUEjVUNsqKvk6IOH+uJfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=XdNnf+kk; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="XdNnf+kk"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C02F71027235A;
	Tue, 15 Jul 2025 22:20:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1752610815; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=hLScYj7rME9Eh39h5hkrPBR1W+hf/KGmj340jGhaQSU=;
	b=XdNnf+kkAdLHA3kZo13rvzYOgARJuwMBNcMvIVLg99N7pj0KOZpzqKkcYcV2xhrdGCsZqc
	wjbZrnZWl/JHqjrzzRMxW4C4WAjl9OJiKs7MKr+2nu1iAvu1jQ2jAUmhWtE0Sw1GAeJEVg
	sC0ypP8M0j8vsKceVfUU6kUEKWTtlcateZ+PGqhM6UIzVgzbsyDc1mhicdgeGNTg9aOWOV
	whjifib1lC8g4ydo6FH3MwPRYPIqLMb+v5XO2jd0djBP7ZdUWsnW/D/IIVnSctTdAdRKGI
	JiQS4dpEzLyHdxWuD+REjAewirwoPhf4UaXe37F6XwjQ4VRcKcT3M7scQuhAWw==
Date: Tue, 15 Jul 2025 22:20:09 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/163] 6.12.39-rc1 review
Message-ID: <aHa3+VT3RkEmuTc+@duo.ucw.cz>
References: <20250715130808.777350091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xhbr9jlV77XkysF3"
Content-Disposition: inline
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Xhbr9jlV77XkysF3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.39 release.
> There are 163 patches in this series, all will be posted as a response
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

--Xhbr9jlV77XkysF3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaHa3+QAKCRAw5/Bqldv6
8sV8AJ9tplw+7ZqQfENBgdsrqFBSJ2heEACaA+vLTgTQGIeh3F4+Nho2QuTBa1M=
=muUO
-----END PGP SIGNATURE-----

--Xhbr9jlV77XkysF3--
