Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6BC4315A
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 12:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738328248; cv=none; b=Ld4lq38hy/4Da9eJUmCJLB+0U2ACjQBTbZkCfnPZmsD05Z0ToJyobu/cHOb6BesYVdQ4degTK84lUcvQaiu9yQxdGGCqpRpGSpOfrF+1RrKf6eqo46OYPYOTfH54LVdMxTa9IU19L5eqyOVZ1ul8F51eKAJJkA3yRFcwJkrc0pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738328248; c=relaxed/simple;
	bh=MWTOPnl3X0L9s26UuNZ2IT1yaSFBGFMGpeah3n4oGTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgOnX/Pac3gJbH8ReXxGw9Q0/2ZQ4fGkiu1lf5IxRaftfY6OgPfjWxYKBBS5xOuyuxgB9ySu9SyyGYofDd4zgFqE9J7k+ggfLZQHRuRblGGSTn/F2+SCYJSbQjThBrjygCvZ1gwrxkqNFy5gaahfoxx3B4US8IhQYznRza2GNbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=OiLmHbsZ; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="OiLmHbsZ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id BA28F10382D08;
	Fri, 31 Jan 2025 13:57:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1738328245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PK0Mz0MEhUHvpJqzb6RF2PW2DlrRtcfGTBmOhZQAc58=;
	b=OiLmHbsZXs78XwsxAum2p0e7pOqahRfqx5BbamxMAI0im7pNHiAne9ui1krP7XmwhxoFsd
	4FVChTTPNk+9ZBAQleIojvXolSFnUOVlVYOI5c/kveC+t3XPS0VQrGvMgF/1lg1mKHWDIx
	kCpwE16lEY7AEkbLAMh0PFn67Nr0/3XbXLu8Fmam50drilhxOaXpW8mUOwtIN2WPqB+Vxw
	fSqwIAq44tP+M9K+5FUNhuf3LuxDIg5taTSkEcyIL6AwpavcARvyxeEqrhhz/YjZbkK4gY
	HbJKEOjuCxWS5GUVuUrL1PhYgNIEJN3T3ECBVuJn8tnBPzTEGj7i0Y6rogJSiw==
Date: Fri, 31 Jan 2025 13:57:19 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/49] 6.1.128-rc1 review
Message-ID: <Z5zIrxIpEuMMNcNk@duo.ucw.cz>
References: <20250130140133.825446496@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ia/kAMmuGVx1omxw"
Content-Disposition: inline
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ia/kAMmuGVx1omxw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.128 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:
                                                                           =
           =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y      =20
                                                                           =
           =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
           =20
                                                                           =
           =20
Best regards,                                                              =
           =20
                                                                Pavel      =
           =20
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ia/kAMmuGVx1omxw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ5zIrwAKCRAw5/Bqldv6
8mfrAKC9PuY6YXvBjMZCUhBqwdOv7dK7ogCgoZt3kgndSEULr3qt2ey8qVEo90s=
=6XtO
-----END PGP SIGNATURE-----

--ia/kAMmuGVx1omxw--
