Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173760;
	b=UqT/M84OIoRcqPgZ4TjHLaFXXwa4oiQ29uviRl+HbckZWz8t1CzHgmAAzs4tM6fUZK4X
	 aAtkrVlnqT1yi/BeCS5a0yPHxB/ct1TP28cf4aCQEI2DwYW24kcE8tlmGww8HW8h34Cp/
	 IXN9ZtWYW9XnPYgKOCbOUVvDfGN+0mGmV7jKjCWKzP5ojktWdy7DhE7xHmWzfb2cB8VNR
	 QcCF/Evecx9aeuu/Fz3h/re2d1P5ieKkwycfcz3nbtEVLfsJ1S6qXaDkzyAM2JFlZ9791
	 S0Vg8O2ILkRiLdZyaM7ZBEGm4wf+RXe85bmlfYM2tg2SbwHxxt4kck7zr8UyPrpLLDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173760;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=K0f4GyuWmwiU3xAt1qgEIuTwy9fTV0XTeNNsXZl+3Ts=;
	b=hgAsvxbN2SULSIUo7ooe5c2FK6jperurxbaiFrJ8XcVwWkI+QSFkthdEoMyhsAC487wf
	 FYOQX0yz5LR6I0jG0gejL+bBig/hV7j3YKCjDal/9KhxsOnd+jnK8K6QHKH2CQrVNZ9IU
	 MWBo6V/LQUIUxN75EBBsSCk7NzoFHbFXcyWAoOyuPN++EroTRE6PHox9yJD3x1C29CHvJ
	 YS5lYziFVrdLwulVnopJ+z76yp6s/H7WXc45QG+szaQjidRAZnbCjpSklFl+uh/9rhLgc
	 n3xOa0t07+ajujnGUoreedPUVmr8P9R6ILUAVrkBdcPCdCFENJoXzGzngIi2qhUzTlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=M2s+JNcb;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1269E606A325
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 11:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1269E606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=M2s+JNcb
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2C56510D007;
	Fri, 20 Nov 2026 12:22:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795173754;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=K0f4GyuWmwiU3xAt1qgEIuTwy9fTV0XTeNNsXZl+3Ts=;
	b=M2s+JNcbD+sxtiCWVM8jz5IfbpTIjcqntXGnoM3iPEe1IcaWNzrBJUUGwCoisCCTik9Iqc
	c9F7AlvufbZuQDisdhd6IA9gq57eBsU5TNsUUUTJk39QjmhFTtn9IpmhqMxKnVjgzPcELN
	jdzSzUqWPoN7FjOdguSZPNICfM3kDQO3dL2UZqF70eLicuvG81knn9Npgkdlhlz/c9kdXa
	Xvyn+Wz97+uxDW2AHDE42zPkWT4aSRyRmsdA6+tzzdDQXB1xdY6UPvqCLu50vSCWvyApF0
	zzwPHb4t4rv88JCOQ08T6j5rc+EzX48o46y/vXE9Wqy2+L4hBjb1lk49kBBEuw==
Date: Fri, 20 Nov 2026 12:22:31 +0100
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
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Message-ID: <awAtd3NV3kVYbQ3b@duo.ucw.cz>
References: <20261120055248.913352689@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="leAxbMl8bKwyHXMe"
Content-Disposition: inline
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--leAxbMl8bKwyHXMe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.3.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--leAxbMl8bKwyHXMe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCawAtdwAKCRAw5/Bqldv6
8vTrAJwKW+dVO5Vz6iY4GwbYdYt9o+joiQCfcVnPyj04FdfVx78cvby6ZUnw/XU=
=XOCX
-----END PGP SIGNATURE-----

--leAxbMl8bKwyHXMe--
