Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCF1324B06
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 20:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319515; cv=none; b=UzAIQ9mWQkLGRkYzSvNP2GLPk579UDPRdBj1H512m5BHTeHTx54lZoL378F9PIem6KyzpZhGiuuQCP5ul3VaMJXTICRAU2cuHmJiprbiRiggABgqGbs8yaYceoU79dmwOJ25FSwBPy+JBdiEoi08MwKYhimI6Kk2MeCrettdqIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319515; c=relaxed/simple;
	bh=3ZU7P6DDmptsDou2WsA/6HlyD0jzKDzuCd3uK9RzrgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PaBcXOzHxYrDaik65UmWTY3VTEh6N+IPmwOXAqEJKyRZTGL2JiueRT0G7LZxIB3/6FH8+suNU2bDFX1uyKf58t5G0UGZ0wjE1E1qjbyycMB671ZRhGX/MFxlSlFGkxXiGu4iq7vfyjaKb7EbzJyZy8b5XIXUA5OOV3wbTgxp42k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cl2ebiy9; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cl2ebiy9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2622511A325;
	Fri, 17 Jul 2026 22:18:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784319504;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ywnV2+gC3IPCsOYna1FCD4oxX9f1gpg4d/FqQEx+t5I=;
	b=cl2ebiy9I+bvh0dHTHKLoJAQw0NTXPuWtlHfmqPG/SOaL9RvHpfOxGeY8uvqECOKS7jUQh
	WKEHgqjEDiygdhc2GyPwmbyGDYERDmovsv1jCd3Z7qSakx+zKn3v4+SrDVLeK9BipAIUAW
	oJmopC1TfjNWwF4yOJ5fQWQMUY6hwIW0HIEZJ5pLKShhWqI3iYNAnw4+GYxRz+mPpnU3ZL
	phclIVWRMAghphOcf6hcltKhJLNuWlGDtgGX4PbXvRs31F+TayZM2k4LaBroZF/OW4WeJp
	U2fCvxB9x6o1Zuml4BDaolVZ0o7Y8uTgcYwk6a/JKt2dpON0Xwg1r2XNXTKBfg==
Date: Fri, 17 Jul 2026 22:18:20 +0200
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
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
Message-ID: <alqODO1ptx4F394h@duo.ucw.cz>
References: <20260716133047.772246337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RwwfNTKNvHvOzMMZ"
Content-Disposition: inline
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--RwwfNTKNvHvOzMMZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.4 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--RwwfNTKNvHvOzMMZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCalqODAAKCRAw5/Bqldv6
8lWuAJj8f+I7c1f7gP9s9wlTerfCEgUBAJ0W8A0f+87gf6eAOCt5jOTGd3QnZQ==
=Hoxt
-----END PGP SIGNATURE-----

--RwwfNTKNvHvOzMMZ--
