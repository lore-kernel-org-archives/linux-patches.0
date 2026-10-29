Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268523;
	b=x48kvWHqMfdtsQ2aRfH4q9Ng6Se7WM2nz6W65MAVMVmFT6Mz8r3whfktVsICmhtflBWA
	 GcqMGf7oJ7jHLFHHjpaSB+QefyzfMEKMxO1XpdXba52WJ45ooD9H2LjeiAr5e2MCXIuDO
	 4AA0LLUjuq9Su/8QYHQ3fcp8ZyQ3fIFA+RNHjZh5EiYhOyDU/tZzE8Li8/nJFeJNp4/5n
	 b9wubxckiXIpyF6Qnr02G4gK9UktHkhuzJDoazkHJx13LFdNO8dExzdK4qrIRsup3skHz
	 7/iHh6zOZkgnS5Pv5R4d4HJhBTizm2NX1fpzrUurH79e0T4USzox8fIS/wukhsZaUIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268523;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=eosUoITMXj8VMDF/3azuoUYzLX0vIMWpx74JbGi12bo=;
	b=Ovh0uGmlG3mxPUuQnj5+6Qn4obfSOn+Fe5zEuyMshEJdCNYySmpfPoIIphhdlWyNZesn
	 O5+cKjENVTpWsSwOGnlzkd7/fNXhIYsVlI7RyLH2X9ylEl4DB1tt2y+GJJO9pLX4Q6ndy
	 nq26rWEVMc5RyiQhGfKsBpe6T+BaZi8c2yMqMLdwXoNWfUzvJn7veizj14IlMGqtO2Jtf
	 kLE99U2sAl1NBfsOmrPo7xhsH/uhhoI2rFCx+//cyOdmco6fMt0/JkAWsb6pNyRtuoZQG
	 1shnwdA3/YW3d3T5tGPJ5kbRsdjNXDW8gN+oNsgOUTzenq3sJhoTKIa4ETaam4g9KpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=h8G1CfxT;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807A3606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:08:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 807A3606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=h8G1CfxT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8424010A8D3;
	Thu, 29 Oct 2026 11:08:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793268516;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=eosUoITMXj8VMDF/3azuoUYzLX0vIMWpx74JbGi12bo=;
	b=h8G1CfxTTRmIe+vbklar85FHS6Qev+ZMTM4+qDezVMnZA6wVu/uYC7Fm+h/77NcdvmqpQs
	cYzSpt/rH565I9PLobRmjkd29F191S5dci0WIO9S9IjOoNH9lvJTgPdLD5X9+URTbczg2q
	TJ3Q4+Jgc9tUB9Iul2c5MOMN33UM3hYU+0Z5eDPq/G5+k2+Asi4/4VZdNK6vGjWMB/sNI3
	dVRpOWtXQEsypXcBrQGifRLrrfKQXiD/4vmqEkrN3F1vAOSOlnFwOoF7nJFXUtpHp/+MgD
	SdEMuQyN9V5fdcMChsSse0xzI4ZplGkbhQw46S/LQrucUzd2EGFLMSUvxznHIA==
Date: Thu, 29 Oct 2026 11:08:33 +0100
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
Subject: Re: [PATCH 7.2 00/88] 7.2.14-rc1 review
Message-ID: <auMbIahCi0rVbEBJ@duo.ucw.cz>
References: <20261028165942.107695352@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="9DXD7bMrWbrjGVOj"
Content-Disposition: inline
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--9DXD7bMrWbrjGVOj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.2.14 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.2.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--9DXD7bMrWbrjGVOj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauMbIQAKCRAw5/Bqldv6
8oZKAKCkTmpGyiO6MRCMY8GnLkhdKaHofACffqAbX8B43zJSW2iDyrsyrGSuhMo=
=iWT0
-----END PGP SIGNATURE-----

--9DXD7bMrWbrjGVOj--
