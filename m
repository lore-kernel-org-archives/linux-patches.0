Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A5424A7DB
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736949443; cv=none; b=HbjqlcKlDASmiZqTYU9C9kYVE5PGJqz9R+cCWX26Upl/L2VcpO5BZ0PhyV+PG7zVb1slusXIIS40HkVQuZ0XrwQka0JjP2uTqlSZot4cTMO6vVFJ7Y2aZgO8jCmHoWxx6o5v/2r0alf6vY9TqK91SXs1MFizLbDfPJIkCucT0es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736949443; c=relaxed/simple;
	bh=xsueNlgaO4lHmwYGsNwzstra4lwV+BstbfLnhlnUbvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ST6S815WHPWry9Fa5dRZgqra+ueY2TKe2Q64jHXQVLqn9DYJZytBltXwm0/Y84FiHGdfU19jf+XZkgcBDfOzEcowUA7KfdyOexkg2mDCFC95p6aXUKGNCnfp6nBpTTpnwR6bzw3AO31q5mW3i6GJTMIcW3R+PEoVsg/cKKw3LB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=DElsc2IM; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="DElsc2IM"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4965110936A28;
	Wed, 15 Jan 2025 14:57:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1736949439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HnIyYy5OoCw3JVEKlEB0Dn3MEZs1ZMNeQcFfJLgEviE=;
	b=DElsc2IMjfjJkOgiiOqMHpNiZF7W/6rpBNP3B7A8LfcSEwEUHg0+lsLKmWNI7GfprfpM8+
	vaFQ6IrKJ6/VdLnW1BISmxtsjrEQCWO9Bihp15eLRoCHr9HlkNTaEJC1T9+gduoN3aYNSC
	lM5Nm/JbgFiqzpAh2hQ2UTLO+D6jFSHdhrdLlJqRitMj6KcarMG1YuxWudDWunb/43wbww
	ViwvIYX+URXoeA1650nOC2C/8WzmIn4auAupW4J8y6/cUCV3P/w6SXU1jHCrp2CdBQ3H57
	WPwoxZ6Z70LD50IhLS6DohHx68utSQxdknbfbe4pBs/pOeiv2jy7VrlgUx2hMw==
Date: Wed, 15 Jan 2025 14:57:15 +0100
From: Pavel Machek <pavel@denx.de>
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
Message-ID: <Z4e+u8gj6BV37WdM@duo.ucw.cz>
References: <20250115103547.522503305@linuxfoundation.org>
 <Z4evJUkzHauW+zOU@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HVp2IUYe+ed6RFex"
Content-Disposition: inline
In-Reply-To: <Z4evJUkzHauW+zOU@duo.ucw.cz>
X-Last-TLS-Session-Version: TLSv1.3


--HVp2IUYe+ed6RFex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 6.1.125 release.
> > There are 92 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> Still building, but we already have failures on risc-v.
>=20
> drivers/usb/core/port.c: In function 'usb_port_shutdown':
> 2912
> drivers/usb/core/port.c:417:26: error: 'struct usb_device' has no member =
named 'port_is_suspended'
> 2913
>   417 |         if (udev && !udev->port_is_suspended) {
> 2914
>       |                          ^~
> 2915
> make[4]: *** [scripts/Makefile.build:250: drivers/usb/core/port.o] Error 1
> 2916
> make[4]: *** Waiting for unfinished jobs....
> 2917
>   CC      drivers/gpu/drm/radeon/radeon_test.o

And there's similar failure on x86:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
626266073

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HVp2IUYe+ed6RFex
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ4e+uwAKCRAw5/Bqldv6
8rV8AJ4+JHBdhU6raVxZViIRJbJ0PmD1LgCfWPsET+KFvytJfFADq+aKxkCciC0=
=l90K
-----END PGP SIGNATURE-----

--HVp2IUYe+ed6RFex--
