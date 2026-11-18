Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023669;
	b=zipqwoKO98+0MHrg8aWUQPaKBUjIlwHjifvIz9AQgf2V/qBkfxPy+QEhlXcEm5dLHPLR
	 ++gVSt41/OKQ3Wx7BXWtSn/mr+2ziHfO/qIpgutga8YgaKaV7jufKKAaPv23ICcQVooEb
	 uVXazwZ6IIKlv0j4fLEYOLEwatvG/y92fwzgMnwUGBMkLBUCcngJlkbHQc4v4EflH50Pc
	 URuY168Ex8SaCAfWUeWbcdyWE+hT7VufcUSgrZSZuJhLKFB8Yx5ZTlhwRCt+iCEsPvH3T
	 npf1ys4x2P2sUOg0ENYJy2g1SZ8h7jOpFX+FiwhNLLUnzdnQn1nBwGZ3toG5EhjMZjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023669;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=upovtYOPoJaBPdnGluZPlUCFiHXTunPe4IBWLSk34pY=;
	b=XK07Ca5eGT2dBqHWtFFT/BcY0i09s6dwBw1dRXLeo9n4ESq631leS1z563XzN9P0OUUh
	 yXTL4+d28hsLP5JMeDAd9aCg/NZAqxTTFd6EMTv2KICMG5MjYntKj2Ek+GUTZmMt5TZ5q
	 DtA4P0vqt82GOUnB240pBPaZRx2nNL9AHO8AdQVERRyll+v0wEJqo75foWNyBfRerJEoR
	 h/urmWr5NrK8RwM6XWEKbuzRlCpdczQINKiWP7oMzEwhkdYcQ5VOMxtd2A/eu+azMy6h6
	 uERkbFpf+5XKloxHQvA5HukQdOJqHfbtGeB0a82UcTtoLK528daACeIUCr6h5ngxxtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=ijQ4wk1m;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DA4606A32F
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 17:41:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5DA4606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=ijQ4wk1m
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1055E10F576;
	Wed, 18 Nov 2026 18:40:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795023662;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=upovtYOPoJaBPdnGluZPlUCFiHXTunPe4IBWLSk34pY=;
	b=ijQ4wk1mWWs5VmAST4vVRIBInAugM6Wrvhu+wM7tccgjV3E+XqaCaXoBgrc/2nsw89UxrF
	HgFWC2tenwhZiIu5LgSRneXbEHmtR77UTTXNoAtTPWnnEXJDe4quHpNXSGnp8QuS2s8LTc
	sTgRnCMsOhfyyN0/INUJFOQL1Ls/A23hxns81WkSlAt16NUUnAl3uf6XmYykV6sIFUPC1y
	UTsRw7xazlegnIIhKeuS4kJbHssa8gn1lLru3CMp8LlpAy33364twgE89FBzhstxF8hv2b
	SNolNAe0fFr0OWZZqXqiXPZA+jRFBTw+gmGtcbCUmRTblX/iuwXykZ3Kg5Fx9w==
Date: Wed, 18 Nov 2026 18:40:58 +0100
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
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
Message-ID: <av3jKvNBBa8aiiLK@duo.ucw.cz>
References: <20261118150121.603863898@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="S1FSu5jnmE+flskM"
Content-Disposition: inline
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--S1FSu5jnmE+flskM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--S1FSu5jnmE+flskM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCav3jKgAKCRAw5/Bqldv6
8mJHAJ9IBMUeJ8sOZ/NAJu9t/GIBL7IojwCgpeHRE9YCGeKtSdbdQqh+Dyj0c10=
=wUlU
-----END PGP SIGNATURE-----

--S1FSu5jnmE+flskM--
