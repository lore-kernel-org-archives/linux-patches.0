Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0282D29D28B
	for <patches@lists.linux.dev>; Mon, 12 Jan 2026 10:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768213599; cv=none; b=MUtfdDLdYuYwW24yfZ9j20U2Kpz7eu6T2upyeo3DmWrhkw3lvwVIDC915zfcTktkQZyBt2CtrudrsOY+VnKWl/ceUHQmF+XdP9V+9ugrXPv/nEx29TC5RwD4Hi+gUpzK3XIgJgYy+L5xC0naOTQeBugFBByZQuFgm9nBxYhyqZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768213599; c=relaxed/simple;
	bh=qRYXZ1C2+SEbjnErAPumGf+Mkf6g7iq9IP47NeEPv2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDtJUdYqwXmW5va/KZum75I8ssCgkmByEPNLr21iDgyn7Z8g6tNQy/YDaHIz3lmVJQNk3bwE+048TTlprgJK+R7T8eBZmgPdJN+IZKo0gxnBdY74pXVkU1ptE4TewCDGO3N/6fMe/rn2PFNKd1US4OuuLfcDX2qsdC42OCst/c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Sk61vgTg; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Sk61vgTg"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 619AC10840E;
	Mon, 12 Jan 2026 11:26:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1768213595;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=t0TOx+9co0EzSsTl2yfiMPWqtWmhNs5B61d93rWuRsM=;
	b=Sk61vgTgQrXd2y8s6qhnqM/TaIedryYgM80jMmbu9iNmM/+D5eOjr/AC3AHz2/z0DX6qxE
	yL8pKGBjOFKN6IfefWfbuCIJ3M+PnUyC/FvwVT93w5QuJq3xELvW2nkjwxGc0MRLCOjv9T
	v/ah5EeQPV4l/NuofhBl0VGLQhjAvDpGB8MjnDE7xmHqifEoNVFVyHiAKE0H2by8G6T4JI
	KhE16E42JoezMK5li6EMBN1o16n/a79DCG8sKlJ3FqhOL9WJts7dVaDlxLdDR1FKsJJ7HN
	N385FW79Pu0JoVzI0kYduJo/j0mhVAjg5YDSaGQV/xYogpmNE/a6k6p+7inPGw==
Date: Mon, 12 Jan 2026 11:26:32 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
Message-ID: <aWTMWGfVS7YrJEwu@duo.ucw.cz>
References: <20260109112117.407257400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KrA8+BEfZSBfjWZk"
Content-Disposition: inline
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--KrA8+BEfZSBfjWZk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.160 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel
--=20
In cooperation with Nabla.

--KrA8+BEfZSBfjWZk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaWTMWAAKCRAw5/Bqldv6
8pFXAJ9j4Epe1l7SfVWjWX4QSBQtvx8VhQCffRIvUGNiV9UuPHyatW34Jo5u2gU=
=QFsy
-----END PGP SIGNATURE-----

--KrA8+BEfZSBfjWZk--
