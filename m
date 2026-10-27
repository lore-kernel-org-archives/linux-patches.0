Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793123759;
	b=tbU9TyWnj/yxC3ov13VjGDsTqKYC/UAqaF7KOzHXf1FwOqJabdPMSb332iQDr9vPHBUP
	 3/uSEF4lmKK2Xj/a1q+WTywafpkSl+/lPQnH4pYeoGcFqR27+F0QQmXlsm2BiF5nXcPw6
	 hKEyG42QCewaxa0xL8qmn0dSOnc7tV5jNugztiTHZWuMnf00agat40BrxAW8o0ZdGjfv+
	 D6Xuus0i0lACQ93lirx53YlmfXJFaItu1IkCZBj3uWSTpBBI8XF5HJQ5PBIgusyTDgIX+
	 e1rUWG1kiSFDNhkiXSDWF2qfDxUbKiOXAgNmlfurIt7JvUzqirEL+TgjWt7VxTNHsvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123759;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=v/Bv2s5RaJFiWDM0uX0J0oT4O4XbTScBaMgsYE1R3KM=;
	b=HeZRjGuG1ra9f46XaUxpQWhnMLZzbUYPW1ynZZHOqDvsWzXxQ+6Vwmrryw5Y6qoy+UsY
	 CPUq1bp9JVLJklIja5AUhY7P+edsL5TPQAOnuBU0NJ55ABPIvqDwSO6BXRnP2Z1QB/6xP
	 Pt5fPc02w6iIVFuBVbk9qAOU/3BT1+uRNZZbk58T7rcIQp7b4pGOwIWj6AhkN3OtC+9IO
	 nqdrmHC+KaxGfrH/NgwQa4aktAsR0y9G7RK7FujCsogOhCATKi2A3zVFegKOQSmYnFPiU
	 QOzJzVdhJECPzM2vdOLr1PB0k5k5BRJ6Zw6pX8RkoDeVN7a3M9g6/rY59L0jc6fHE4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=UolYGaDN;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A18606A31F
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 17:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3A18606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=UolYGaDN
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 07C7E108D54;
	Tue, 27 Oct 2026 18:55:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793123752;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=v/Bv2s5RaJFiWDM0uX0J0oT4O4XbTScBaMgsYE1R3KM=;
	b=UolYGaDNIWC9E50Y9cmM7BtASm3btxoQlN95xDsjkUA8jzFpyRGYQocPH0NjYZjqohfc/f
	f5ASPYfijTh3/Xo9XyWWJ/7X4Gq8aDmWTcMH1DAnf3MVXPxoHkdwwX1DvvBPqexIxCqbuq
	58jA7dLNIRBPrf7Zj4qqVoQAW5gJFUGq1nOjXvETEzi3+Nsi0nEocSDrxI6TkFxPFU4S3I
	fsY7SqeOgG6zde3ld88EvTdb1sQGBtju2xUYK2JalODVTlztvnu/ENXpThxjlihaI8hdwA
	7Dyk+/siPSnz6qaRd0BhWqT7ArF+AurveILMgaakINGTmG2dp9F4RPS7Etw9rw==
Date: Tue, 27 Oct 2026 18:55:47 +0100
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
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
Message-ID: <auDlo1LuocyDBmS6@duo.ucw.cz>
References: <20261025125805.309934791@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="LOree2NpcLncJNom"
Content-Disposition: inline
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--LOree2NpcLncJNom
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.2.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--LOree2NpcLncJNom
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauDlowAKCRAw5/Bqldv6
8rc/AJ0ezYraoY7J5uD8d4MCo34euM+wvQCePmKxEqBtJsVwHTVQSyj3y8+08NE=
=9jR6
-----END PGP SIGNATURE-----

--LOree2NpcLncJNom--
