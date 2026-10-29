Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268399;
	b=1YGZamihvEuYqpIrIAO3/ruO/0YqtEW+f6PJ/YTKZXYvBRLsPUaSfPXDtNmK9LuGTKo6
	 xbao6EnVZvgi+i0MnIy7gz7KBp3EqMItm0Bv6qkoV3oHSWJncRoo80I2XEs+n6YCdmUQG
	 I5xVVn7rokHBq4tCFxB2bsXVRaE1tU2dWa+vx/l0qpO+RsHViNH6UHAzToleBwAzviIV+
	 OI5NhChW3Qg+CScOw5cIYLYzgyELVqw42hoaVhR3/nO9+QRi1YyTjDD7QAPemQMK7HMIT
	 AenimzwtyZFIfySY8VfV5yBog8KEauAlU812kMEnA3MqFWSax6Xz8JQZhWQpM01zR1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268399;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=YcZX13asPHicwggbgU3iu1zB61slnlTiIzdyqnigXuE=;
	b=m94fEElGBogLLit3w+WRHVpXT0klBEt4Qvqr2t2jM2uxGbX/e3kNNDbflanux+qTrFes
	 bzhoJVogTOcZAbeu2ZqRzQLGRuYsTZN/LY1skD/I04ib8ImBURYYeNuCcvYI33XCR4nb6
	 ciqIeAzyXsQWFvRPmX7PzTjFvDhW2xRN/7ERjfarVziHrL8owF+PR/oeWdjykCdo1+suu
	 2ygD4cFWowZqaKppr3aqIPeCJWHU5cdCDptqoGoWmiM4A83hJsMesKv7J7mvkVwDH0vuv
	 LTCcqFRhp6dsTCkRRhSZKCfqfWDv5BIM7LhgH0CWosmruZQnDVAgljywqxIioYcIk3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b="Tg/9nf6+";
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F68606A31A
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:06:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11F68606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Tg/9nf6+
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 800B710A8E1;
	Thu, 29 Oct 2026 11:06:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793268393;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=YcZX13asPHicwggbgU3iu1zB61slnlTiIzdyqnigXuE=;
	b=Tg/9nf6+ZED/l+he501JwsFVBSUCtWqvv5osLLzHGxLpOsuOG3Lm7CsSS4zAf5ff7KfGPf
	Ao/1zabCXhDSZAS3L0t02CmlVB//qOqJOF3QtDHXaxNZgAqTQjVpahBmhjP+G9tHdCebWk
	4XoVdV1iptTyf7Stzu3pEvrWk+QPwCRCxn7uWYwm8sKPe3A+1IK18yjyGsoUI1YePnbnMs
	83Z66nLAdgytwo3gKZVTl0/5BkUNDP++kwgqdDjRM+Z/Pf0xev2JScRQ8l+kqf/R/v3HIr
	0EBUQ0XQUqdophqPERxijil5UebsZ7e/vYDXTpS5rYKbF/sAvM80yvCL1ocbjA==
Date: Thu, 29 Oct 2026 11:06:31 +0100
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
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
Message-ID: <auMap06yesGohGRR@duo.ucw.cz>
References: <20261028165943.089486480@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bqrpMzm0POkdKOCF"
Content-Disposition: inline
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--bqrpMzm0POkdKOCF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.161 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--bqrpMzm0POkdKOCF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauMapwAKCRAw5/Bqldv6
8vWXAJ9gKIrH2NYE3YTaofHYZHe0CmInigCfVs6CQpVcQtmZU2jwLOw3+SNT1OQ=
=Gmp4
-----END PGP SIGNATURE-----

--bqrpMzm0POkdKOCF--
