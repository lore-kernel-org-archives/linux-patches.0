Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E0D2E0405
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 07:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756885533; cv=none; b=ZHCUOqmKwR3M81qed1yRK70Lxr3cuR8dQlIOaHkuRxcye5dMtYruUXANY5Bajak4TO2GGIPv+IsltNiCmYMJOnGwzoQAESredMHK0fbe+piurWDSolKayUqzRmSHs0eelB7RJ1uxWGf1CmboCG6DngJ8GQVoykDVhcVe6pT/UOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756885533; c=relaxed/simple;
	bh=W8jUJ0ZdBW50Fci9MyTDVczGBHLQzeSVg3IJ2oh48ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W28KfvrHTJnddsN6zmsa5m+s8/FKag49aOKFTjpySczf4yqBkUAjP6E/ocJQN1pLEIrNx8s9BoKz42PqixltGgXOCpRnnMDgAIFc1PiXdcUI0Fzdi5NkA9Swo89QjzjdeSnmmQQMLizc+hBdNVwUnzA4e9ZMCjzRyASrxvkf93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=YDYXpmer; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="YDYXpmer"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6EEF410246D8B;
	Wed,  3 Sep 2025 09:45:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1756885529; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=DIqWAG2HGLWxMY4IYF3FpYDCxuSJMzAGC+ogfpL2Mxw=;
	b=YDYXpmeroAgToKvL3CbqRdMSCZl6ikDJo3jDHPPRP9TqEoVNpftSTXve/8dlGuQBjvr7pY
	GylIfqp7Vo1+tiyQLwTHJdMVVkUsOf0XjJcsGHvdj1hmxh9Qcvwhvshe0xpFChj+OnRTdc
	3G+DRrt7YYmjcet6bVR06OMsNRiQ2hKbYF1N3ChLN1oNIFZjvLnUQ2bO59e4FCEh3bbp3q
	9/m+Qk7a1putzDCWU88m/IfxKxbRTq8wOpHS/83nDoIJsm/Msv5/vGaeWJ1pnp7mgPGMTg
	jkDShbXk5yYFHE/RyhMC3HviNsaeVyeVDx/NafGhOo+bV6KUln6zP8OPqxkMwA==
Date: Wed, 3 Sep 2025 09:45:23 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 5.10 00/34] 5.10.242-rc1 review
Message-ID: <aLfyE4TI1KgeLF0V@duo.ucw.cz>
References: <20250902131926.607219059@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NVDqz0bT9lKZZHMQ"
Content-Disposition: inline
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--NVDqz0bT9lKZZHMQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.242 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NVDqz0bT9lKZZHMQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaLfyEwAKCRAw5/Bqldv6
8mHfAJ4rL93aeNqHzZqR4j26e/gQnHt+vQCfa9LIYvZPS0u0PcMtgFf0RW56GvA=
=l9Jf
-----END PGP SIGNATURE-----

--NVDqz0bT9lKZZHMQ--
