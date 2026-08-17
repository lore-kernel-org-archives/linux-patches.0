Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB59378D87
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786989354; cv=none; b=DuT54lrEuPNUjaDhFQj6f6FYfy4iEbmVhP0juAUfcbf4IgFZHSLEDYSXwWiHeMxoxbZiZPp6SY5tE0ywm+i1DHH3Vp+sLqiSg71+0IFsReElMzwuV7Gl/jRRplMMVTDzR9T5eqPGccfg7bFx1rqORxLnJy2uOs8bDO5l2foZ+NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786989354; c=relaxed/simple;
	bh=Q8p20LXimLWSr8KOBCfnn7xOqRubspeeotAgSL3rRxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbO/gNulSc7mR4R5jrNL5RxjWV4C1yaaUau1VYKHSaXTw9O4VvQ0TQHFrOpQnC/wlCLUoELpgGq5uhNl+8po2FGpK1PwiznbqQsOOroSeEPPXYjof5xRf14wY0AJfilh6Qg/icIHEeGgqK3wRLdcIwiaqwCn/BGOXG2o1Tjwgzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=HhNhd9J5; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="HhNhd9J5"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1D62011C2D0;
	Mon, 17 Aug 2026 19:55:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786989345;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=PNtXWt02/2FrIdZfI5+TJ6h6f9oxtvKMJFyij2Oz+yU=;
	b=HhNhd9J52RLj0I5fD5hs1RXgVM7Vl1+hiYq/L+SUuxFHqWJfC3m77CPO/MOb8X0nkDFJPh
	rXmh03xvZXsXr6PgMD5hthjJGqAF+d4b4RHluJmh/irIqdrtCL6BldkKodV9jsj8W84v0o
	HpETogbAtklejNEDDqP+fEQUfrcW7cCPLcFujwC8uVfoSKkYrwGOJU15EkLdgrdRKGv1Io
	B89kPeeMdmvZ53suQzMXt450+6sCEChAlQ0Ri+hH8Q4/qeV+mi8WKxpSoBvkfYDWeaJUNj
	IrY9MKVT09sKJbTSHjf92IYdTSC6T7TS6dCJkyo/3zpkVS+xgFI0YVgzIbbnVQ==
Date: Mon, 17 Aug 2026 19:55:41 +0200
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
Subject: Re: [PATCH 6.1 000/609] 6.1.183-rc1 review
Message-ID: <aoNLHYNsevJf8w9R@duo.ucw.cz>
References: <20260817132543.039278408@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VhZZrgNwuiCUo4aF"
Content-Disposition: inline
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--VhZZrgNwuiCUo4aF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.183 release.
> There are 609 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--VhZZrgNwuiCUo4aF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaoNLHQAKCRAw5/Bqldv6
8mgzAKCXk7wdBgKvnXHKez7S6JiAX7GUpQCeIPfhyqCSFag/CR9Af2dGqhE+ifY=
=WnqO
-----END PGP SIGNATURE-----

--VhZZrgNwuiCUo4aF--
