Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFDF1DDC3F
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 09:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783071855; cv=none; b=hb7frjcHjqbKmmSLCK1l+e5gjMkNkjkcWANvHWeY+yWfOOSHanT3yythqVKCXdKXE7mD9uR+8L2IPZCTiwPOsOEF0JanejALBg/lYYKJSY2AFqkMnVDMOhjAcqB7yPyuWRx7xg0Ue6G1OjEljRo/TYsoTQ++3PUDADLMFa9bjs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783071855; c=relaxed/simple;
	bh=rOz5FfBkUlwVLXQc1tsSJWc18jSOX2CS59MEDYIiUE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlvtJGOkb5olYRrVg5ojBd/GuECOg8He4TPweGiUdUl+X/wXxQwDXEwi2HS8TszgDZFiJ7nPC+99VpapEl4t1f9wk6cjCe0ZRdD8zCcv41P7eQZQ4P6yTfTaSwnVLGTdBWUFvbrsHP5w0GTd4q+GtnbXX18W6nrcwYeQpRh5M9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=LdAYXZHG; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="LdAYXZHG"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3F6FA1129B7;
	Fri,  3 Jul 2026 11:44:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1783071851;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Phvv03RvcAwn2d8uwtgJwEfb7Saefm7a9LdlhWcNrmQ=;
	b=LdAYXZHG8/yu+84tM7ncLjJiMirxOMgpzyNFBZ/obOnKX8Evt6RcREzIdgOyHg4zbtMa5z
	NOMM+nhGVI0kbl6SSjcnLnIYmu88zQ6Fz1LxYH48LC99MVAapV7B023NP9fdHu+g3B/45l
	A9rIif8dbOanyTHUjU1GSGxTnOOBKsOGYTBXtm+ah8Lf1Cc9DFB5PcuxnDeZy1KCdCT7Jc
	+EFQGjvrT8xDWzhX8rbZM2KZEX7NXOYj1gsWyCErFETih/sohGW6dERGWbZuaOu1WsbHA7
	XTMFPicrrdkxBOqWDWhN//v8y8cSPQvV8l4TNEv0MzlbgIKgeY9icuMF46viiQ==
Date: Fri, 3 Jul 2026 11:44:08 +0200
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
Subject: Re: [PATCH 5.15 00/95] 5.15.211-rc1 review
Message-ID: <akeEaHImC2K5r5KX@duo.ucw.cz>
References: <20260702155109.196223802@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="urSuZ4ToW2vFXJFq"
Content-Disposition: inline
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--urSuZ4ToW2vFXJFq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.211 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--urSuZ4ToW2vFXJFq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCakeEaAAKCRAw5/Bqldv6
8kHHAJ994cKfrCJUmujTe9qNVL1Tpqfq0gCdE9tiDAheTapYCzaS4dV+nckq5pA=
=jGU5
-----END PGP SIGNATURE-----

--urSuZ4ToW2vFXJFq--
