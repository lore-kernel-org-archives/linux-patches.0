Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD5014A09C
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752673967; cv=none; b=USfVkLjdLl4hACaYRkHul7UMwCE0JdQARNfEP/RiGc3sPDo2qzDo5qBs2n+C9iPkrltI0aA8VGyUBLX6L8T0oVttTD/CnXBA0o7Kw1QFmWPGXvyoYcGgwcApS18bMptkfQtQGkJu2MOxwFKvFv6j+VGWG0KFIqX8QJotLEWxVwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752673967; c=relaxed/simple;
	bh=Nq9yEx6E31jeoRxH8hd8CORaLO6Pd8p4ium4hg+EfwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYEy5Gvh7Sgsxs7s9qHuXRxxJuFel7ufA+HHKBx8Xp96j5pRG8ac0kNKlQQzW2fQ6o7XG1cXFuVz18hni7UKSQp9v/4sKM26n4nG+j5S5te986SWmwXxzD/WStNEEIag9PSnn8wwSMb7uhczNx+DWvnPGkbwwrGCRBodIb6mxdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=LT5qDvnG; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="LT5qDvnG"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3DD5B1027236F;
	Wed, 16 Jul 2025 15:52:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1752673962; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=3hFOaUq2sywSBtyfecXmN4EjwGkkmHEspyV74gBX2jg=;
	b=LT5qDvnGCfK14KHGyejwu/QoWjoUdnhFqjNLCtGm2CZmrD5AblZiN3Z2IrQdSIlLlW0+NI
	4Y6k25VKAS7Fx4pMDHjEsDGrEEXEgqj9kbd+ocqdfUFrSiwaWLd1m+45+fkDIZh6W35B90
	+UzAeCtcjf+tY9k2a65gdQBzP12VVpjfMtUx+uwCiFQ94bXMwyl3UG5e+QtnLnCii7ZSi/
	mYJZ4wUsUkHigvfmSv1uqdTldXOvJXzYdL2EBy+3ze0Q84Vx759QLz2zotanO57TYX9xjk
	gxX/AY1OfQNfnv4pgOAEjAehtkaMA7Kgb/FWLVdcwEMo0/I1WzwqSq/e8epRhA==
Date: Wed, 16 Jul 2025 15:52:33 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
Message-ID: <aHeuoVVk5AxyLgwr@duo.ucw.cz>
References: <20250715163541.635746149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q1K6pxNsDL4JnDNC"
Content-Disposition: inline
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--q1K6pxNsDL4JnDNC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.146 release.
> There are 89 patches in this series, all will be posted as a response
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

--q1K6pxNsDL4JnDNC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaHeuoQAKCRAw5/Bqldv6
8lZDAJ4qvXoLtpQ2cCMaFVZbkQuPLh4MsgCfZ8+PDbZk0AsblafPhgS1ulpXBqo=
=3U5u
-----END PGP SIGNATURE-----

--q1K6pxNsDL4JnDNC--
