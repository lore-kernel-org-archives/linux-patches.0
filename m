Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC61E23F41D
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 20:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744144038; cv=none; b=CxKxx2Z577vLKgxW2Zbw6oJMC76syHfzpazLWrCcD2XY/MzWXWEU389j/1A8cwhLrSh6DhrE4qdzh9jo3rOKy4iwvwCRyVTgaGRcfZC51t59CLxqrJjmO7LibbgV2zWJhiInsL4GI76vpvqlCM+r4Ss4NWJPRYVXGjoAZH5W1gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744144038; c=relaxed/simple;
	bh=jlmyjTBJP5R5t3jfNaCh/io/w2i5bY2uI2PlMtGd2gQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2SSUVGwr3B4djgWgL/2dIsbTzezDQtI+GmxW5yls1UYxKLlP/QNiAIvyPHF1EWh/uc+cLQ3m3PdKwivIbxU9gJ81Ut6a+uREIwIqgZHVBjnjpH1us8elZGUPti2AjqnuP3tbRAsAqifMKwAHuo5Z9uEc30RUjoHA/szngcwOuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=CJHUbtz3; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="CJHUbtz3"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 188BA102F673A;
	Tue,  8 Apr 2025 22:27:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1744144028; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=cU9iZhE/mM+SRIcVkqUG49B37dJgawFyqHRBBpou7SM=;
	b=CJHUbtz3z/U9QUu0qRehRN5O9uCrTNRHA3c3T7GMQbR9di/iohPk/JcIKql6TYUxPfWuMn
	NVh6xC9JIpsd/WIuRe5/df0YUHJpeNwJNavCtllh6oFw7Fr0GvHUctkQmLI+vNX557M80t
	Lbj10kgnIWThOD7DiK7vLNYnkoYqrzazPf+S9Pb0pbLgwf9b/pefV3b4xC2Ir+pdfd5eFc
	ZDapaKvpxerCZBZhxT6M5GL43UNJtC+2RHBn/3vTCO8OgvkTm0dbj+VQ+7ED7xnlWZ5Yqs
	VNnjiCTVemoT8Uuoigg3PQ5Ooa1+iTh3Dq23pDPbB0KNNmkKZBEgxIuBpRlqSQ==
Date: Tue, 8 Apr 2025 22:26:58 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/227] 5.10.236-rc1 review
Message-ID: <Z/WGkiuWIGYlJP+F@duo.ucw.cz>
References: <20250408104820.353768086@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b6iNVzDXMYwu7Slw"
Content-Disposition: inline
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--b6iNVzDXMYwu7Slw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.236 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--b6iNVzDXMYwu7Slw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ/WGkgAKCRAw5/Bqldv6
8osOAKCZe7CxRBAyNiVmAVW0XHfenpu2QACfdBl84ywjI4Xpawk2jQw/uzkfAeY=
=MrrE
-----END PGP SIGNATURE-----

--b6iNVzDXMYwu7Slw--
