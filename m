Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFC6200118
	for <patches@lists.linux.dev>; Mon,  3 Feb 2025 10:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738578328; cv=none; b=knAHueuoVBMI48naa4HSel9IzEDDu8f/8LDobxMqLwEZMwLUMY6EawSuVCktt50R9fIXftzSZ31f5SyJD9OK6bNpZ94xyclOnfSH+TwzP3fp5+kuxNX6Qc/xQWXk+p23LV4gErpCNBScgimHfY7a3V1jDr8hGJBZiOGhvXgmF60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738578328; c=relaxed/simple;
	bh=8/fUTzKy1MF71wYKcPFhSwEBzx24YLOM/aFyLuKpmos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mw8l/5qsgRr+VsAGsGuUsLwPW/2U2c6rce4d+RlSo27yd5FUCjY0RE8PTYo7V3NiVPa1LAcmySwOJYXmwAFpg2YpSFQHgi85jOiqKXBDBXu+YDqjhcEO6PFHUz5n8flwW1tilgwlqg7HJW2JZKYcyNkaGsXFN/7Lz0nkKHWVFuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=iYDYxmKp; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="iYDYxmKp"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A339C10382D0D;
	Mon,  3 Feb 2025 11:25:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1738578319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L6NLy4tPMvGPZS1BPxy3IPZATwSK5IX2UjuVNeKK0Yw=;
	b=iYDYxmKpXRJ6+7QLyvFSDFMMoxZtriFmxUTpagPkkGq6yBAUe0emhFHocTEQxOyJkb6C5U
	wstV3qBg0MNoO/oGee70zmw+EPYsyW76PP6cw4FxXZvRYtHRttb84LUBRgPfwYwNLRq+Dp
	JiOLQ5CuZeRH6uTHJMsPuO74BkjC3YeXWu0KraD/liJkj+iEKDXAwtO7/rkRaFxtMzMYTc
	vnzkN4gzTxmE0EouE1acFs4uJNnMqsy5hs1l4HvFB7JZuFlo05rRhzaRM+4oamCFo01Rdj
	2y8bvv+jc3P0dtz6OhLKVJabfZ/u3pMJXcVX+9QqY3E4aSpEfr0pb07chov3NA==
Date: Mon, 3 Feb 2025 11:25:11 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
Message-ID: <Z6CZh+2NVVp6nwte@duo.ucw.cz>
References: <20250130133456.914329400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kd9VI+nPNDmTcI7L"
Content-Disposition: inline
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--kd9VI+nPNDmTcI7L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--kd9VI+nPNDmTcI7L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ6CZhwAKCRAw5/Bqldv6
8tzRAJYpGK1aHcYpbt44DIEkOb+zAjDgAJ0bfZVE/bkbkHFwDXvDMl4HyyxT8w==
=hQaF
-----END PGP SIGNATURE-----

--kd9VI+nPNDmTcI7L--
