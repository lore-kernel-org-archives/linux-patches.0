Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED371804A
	for <patches@lists.linux.dev>; Wed, 21 May 2025 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747841926; cv=none; b=RqKvgwNh63Ibm7wDcEc9UiPOAivjUvfLLcyPgtjLl6ltBILI4wQIAfcGSqFDOmd/UHNoLiPXHPbUXE5W0ygVMwbZq5vFZE8VPDSlHFL98GRihoMTS09RnKBP1jiwq6+gzzkgaS5F3/L1Dv+v0+HpThewygZ0KXEAMrm7Q+ux8g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747841926; c=relaxed/simple;
	bh=PTX025higgfiVJV/H2ZoQOmewRxlFy3bJrnMoGbZ6OQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oxXnCLE9wM26QH4BJrLGLh+O7nGgvRue/F8g24rUOPdcSPN/3uXQIrkT4b/ceu+2Cl+U5i5/OLCqHzImz2t9EYf4/M3gmjpeH1d5T4e7hvmO9GPVD6d9lZDpcFM2/K/zWl68KjTJxuAfpWRbTqw0dXpNvH2/nsztaJB9pq2C5iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=GRMrsJRa; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="GRMrsJRa"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6A2941039728C;
	Wed, 21 May 2025 17:38:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1747841922; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=7rLP30jivhSXxGxmK0/4iDagKg0IOY91vTVP7E2pscU=;
	b=GRMrsJRaALKKXzx9osgt9vXWhW6cIl7qLkqvlq0idkwi8lLTEtycP6niRktt3MzEnzAaGH
	/f7JJdnwwzglAo8ANrA6dqWh2+mazICODBmG42udjCguTXjrikD0beLlAQ6MKLx0JMjmOd
	4gJUSfSNsNnBkaXustEa1cfNRYPD0yBoYNzwhpXd1tuv/FiNK99uMh6PcptFC0dmg4iQQW
	BRDgHl+mx94vVSuz8DMpSYyKpkKgkvKFqoMOuqy7N6JOD9bjPCTVaIA/cd0DbafhM308e4
	sGrvPXXBgfzQHTcUaciurWV8hm2VZrHg9D/7Y0nXijqT4+2q4IDNMpSH4VIgLA==
Date: Wed, 21 May 2025 17:38:36 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/97] 6.1.140-rc1 review
Message-ID: <aC3zfDn0nylOsK51@duo.ucw.cz>
References: <20250520125800.653047540@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YIHR8/QkgoVUOGnE"
Content-Disposition: inline
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--YIHR8/QkgoVUOGnE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.140 release.
> There are 97 patches in this series, all will be posted as a response
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

--YIHR8/QkgoVUOGnE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaC3zfAAKCRAw5/Bqldv6
8kptAJ9fISqWJXe7UrOT6WWYNALSgm8K1gCgmVnSyqX/UVU1X4fFfs53lqQ0sBs=
=stm8
-----END PGP SIGNATURE-----

--YIHR8/QkgoVUOGnE--
