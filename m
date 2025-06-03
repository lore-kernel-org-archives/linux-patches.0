Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FCB26ADD
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 08:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748939490; cv=none; b=XDNnmdDaTC3rhxxmm+CrrkC43xFVB3c1j0q/yCRtHqzEwpsjWq+BH1h1AMFv2wE8wkFCDb0uvKww9t2SOd94CWh5Q8hMtU18rXBibxu3iDWcQKF4qa9hByJMqARR1/XijbLSK7AW4+kRMzMfSvCNFoyqLF2tGGSmLJcPegx4z1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748939490; c=relaxed/simple;
	bh=HheOo5YuAtAmDCb1jF4h9J8lfz20UvG6MpDloPcdgOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TxTp9FFvaz7tyogDBTfnLDbhcyQISI8QLMVEpa0bT1rpdlgMnyKhgxrS9FnlKrZR9iWkfFTTvOa3YFywTc2nPfhtHwwN6ekG8AI53jKmX6DXZV3txLZUVMhDz2OCwydx4XPZQ/nCT1a0odEPHna7efTotOLw+aUd+UtLdY6ymfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=QNO7LIhT; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="QNO7LIhT"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3F8D210397298;
	Tue,  3 Jun 2025 10:31:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748939485; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=lwtgiEj0l4NYmB8WZdoVL03wHDt5Np7apMU6CZvW0wg=;
	b=QNO7LIhT4A4iafBbsksg0aWiONC1M2YtiG1tjgCbPPLP0ndtWsHnZDfuSXlS3mwm78TUt8
	a6Wjyfiiz2WP9WxTto+YY1exAlrLI8+rbLUSzCqDkidYlIqchY+OfbNmmMLnDMdXdYXdaO
	HJYhhLupp139iesY+v/jhMeuSWe9/mKXikgF6RxBUrtQM4/+dMZlC+Mh6cYbvfHIqekZf0
	7Lel/226XMm8w5WXYnCqcMg7tCEvbLzx+nxOzTzQAE9ng1p3mZzyB/06eUqYP4CmimaPkL
	hOG3wUh/cVNttqYCg9S0PQsHVdpiXweN8aHM4QUdigwwstRbOew3z4MizpCWxg==
Date: Tue, 3 Jun 2025 10:31:18 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
Message-ID: <aD6y1skdsk62obc1@duo.ucw.cz>
References: <20250602134319.723650984@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JGDaLo4SJN7NeVGd"
Content-Disposition: inline
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--JGDaLo4SJN7NeVGd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.141 release.
> There are 325 patches in this series, all will be posted as a response
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

--JGDaLo4SJN7NeVGd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaD6y1gAKCRAw5/Bqldv6
8lZeAJ0dfPXzrP4su6T3bKZC0ZQbuHJEoQCgj5zajr+tqbEvP9yB9ylLZe7jGu8=
=f08x
-----END PGP SIGNATURE-----

--JGDaLo4SJN7NeVGd--
