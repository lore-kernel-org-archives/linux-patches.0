Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5650382F1F
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785448144; cv=none; b=fdHrusqr38TGlw2DoGl3Bd17sgn74dJIESCAkR38IEGZMJ8hltrHSu8fmwep+Z0l8EZSFeEfBfp15Uaj4BqEUXHY8jPUrbLKqU9XVUiwYmxuT09qE3Tw3OPgVsvxDgCO/WZGem91+M+TmMD4x5nRRP1PDyzjrjrBY/1vl3X1vEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785448144; c=relaxed/simple;
	bh=PHLE7Y1j/Osfdxt/4uNTjEWiA7WoMxr7jy9JEibyDaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMlF2zoNGAWTPz7qhcl2XXV8HoFPLW8iqcAaRrVg0GHOvG5Zj/FyWqGkk0bbgD14XHusp++ZbdG2yqKkSFd2GzAGrkSt7kV9yNMtSWZ7uPSH3ZLTHtHxkXYgOYo/dRyd2/Fv5clkMMuXwoNVjOfC9WgGSFA2yidLnsnI6zr6npw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=axYj68ij; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="axYj68ij"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 13FB611B92F;
	Thu, 30 Jul 2026 23:48:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1785448135;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=gsXBKQPIB19jfgPyHIYge5N2KsQW4EWhtXRT98lohdU=;
	b=axYj68ij5CiWEW8dybrqV8/sFFE13r2CuXa+ekYj6xZKlA4m9/YuEEne4njCmquACPfLqO
	eaR9GrcuZUT3utJbHaWNEWXtHBq3m2ldCbNoxMDvKvJNemL4k3y2gIc/EW/Li1NKdbesqi
	E79ES0uKU5DoCGx+3Dc8f04rD/U1/+lHCNVMHHDcBdOJPM+28wQmWG8QfeyMIZDRiluO5k
	dvu3XfFO9S/QuWflvG6j/dkmX9rH+RKP+K8xVr4oF9O2fR5bsDNpdcQZT+d3eHhb4UVJhi
	NnnizVkjxbFSlgT1yJzcdM/WZsC9ZdzsVg/+Tz9P/z4Sho7V5VWMP15r0iLyqA==
Date: Thu, 30 Jul 2026 23:48:50 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/602] 6.12.101-rc1 review
Message-ID: <amvGwv4T4eCKv7IX@duo.ucw.cz>
References: <20260730141435.976815864@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cnYJN06TSRH8zJHw"
Content-Disposition: inline
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--cnYJN06TSRH8zJHw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.101 release.
> There are 602 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--cnYJN06TSRH8zJHw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamvGwgAKCRAw5/Bqldv6
8h1zAJwOlCer+uNH15pRyYSpz46jIlUC2QCeOWiwceWU8wRPl1U13mtqmVQ61Gk=
=FsOh
-----END PGP SIGNATURE-----

--cnYJN06TSRH8zJHw--
