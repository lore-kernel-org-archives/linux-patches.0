Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBEC227EA4
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 07:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759475091; cv=none; b=nUWr6jcufFqulz+un5YKIiaK8jh7p8Zju1e7NWGoHo0cOZvAh8zUNlJb82niKAkbCnDON0XNaiboEU6Taw8W3YxHiBk1awe9fLwUNKsQOpXwRc/z8Mv9hRjzjlPRXn52schIvEhIEaexsAFPJm7qGs2To6yfATSz/RThQxLXwnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759475091; c=relaxed/simple;
	bh=3tIslANnWNayD90+jyp0Nty9jHvsc006JGvvbAQcfrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YG91bezJvG9uJyugfBt/2fpVP9penxZmvTFNKOY7eO0+BLMHQXcQOenZmR4QcBslxRXWqPk6LJwP3DiRUG0iqliskpAsI6rwh0XZJFjA+R5NTFCe2YnVS0WFQ96siHajNgyyly6SD8Dm7U4m08c8dsVkWps/vvDlTZPSnWIFcBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=hekcm+Nd; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="hekcm+Nd"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0DBD4101DBD76;
	Fri,  3 Oct 2025 08:56:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1759474614; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=sG2UwrD9Ef3Q9/EHHbimv8ieJGOVacnbyOZSNg0QEJ0=;
	b=hekcm+NdFHhmrQOhunVTYlhIzK9pOiAYhFuT6rh7mIq+xcm6U3YvLF5LcIEs6CGi1PeQPE
	QfIYIslv6WVRDmoh1kIgpXvnBPFieRz7TwqOBCUb3fGFjFWMNtnNrkYEbzWXB1PfxMSJ+F
	fNcOIYudb2PcgyR3vJLNhIWhhvdY6J1K43WHDbmwgBO3AvDXT8zVmus3Wzj1BYl7vqPHbM
	SckhZWdQYv3OUGXLzQgPChq8qu4ktclmxhhHinQNvi/fmEphVr69Y19TH/yQ/3yBZ5e1VE
	ngSLZxG31Gyp64OHMmbSL5car73G43Fbifi47AZ/r7AAFaUNXX2n2oLqAcqieg==
Date: Fri, 3 Oct 2025 08:56:48 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
Message-ID: <aN9zsJblYLCQqRl6@duo.ucw.cz>
References: <20250930143821.852512002@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dLhoB2bpvRytRt1e"
Content-Disposition: inline
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--dLhoB2bpvRytRt1e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
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

--dLhoB2bpvRytRt1e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaN9zsAAKCRAw5/Bqldv6
8rypAKC/zUFSc1UT4rUVaOtzV6oMArMEQgCeNzB9QV/1UVQsEa4BhuVqvoHKxkI=
=S9QT
-----END PGP SIGNATURE-----

--dLhoB2bpvRytRt1e--
