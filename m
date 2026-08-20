Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06B5392C32
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250303; cv=none; b=BNtZkYRctTg3v7srmdKmbCQL7mdfvGr/1x/oMUZFuXy4sG10zvrVIxizakgmak/Q6xBt3ZjVCecEs5jhJpBH4g39Acw+vjY/n4FSengV5TIXMb3ZxSa+FMPD1T/ZsryIF/g/uVHe/4Bb6g82jFvjtj2Ft9bgqBhgs5S1Dm9XkeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250303; c=relaxed/simple;
	bh=MkwSlnEj/SLTP2wEFt4FJ3e7cqnWb955dlb+LVwtCTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HceowuhhbmHmhc+z1PX/PDJiIECKIGW0k6TxwCMyN301Y0OGVtFXItLUcEpZ1knm+yxsqqQw8zM7DOLOiXeXhkU9oj20RDDBkBOWdV6b15vql700n6gRcfYDaDhDPA8CmAWVVCnctEZvidzR7eyOdhAtb3yiz+DzBCvUx5RLUS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=KwDvsk6b; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="KwDvsk6b"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5C6DC11C61C;
	Thu, 20 Aug 2026 20:24:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787250287;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=3tbBr0SVYIKDABPTiJbWgBQnPwou0O5/BwBGkel3MZ0=;
	b=KwDvsk6bZ8W6efodi/DUv8/vJmWUVcIBbFO8iry1BkBxjkgJ7Njiz2Ucv9qiLTfVwFKaNk
	GLeIoenuHZ//HF/ynwWgZQGpmNuWTUcxLYU9Q+taie9NalilvzUx1zm/PwWsSTBP7QF0RY
	t6QMTNwC/5IVYJQMPCOdx8YBSXAlJLFJeZp0fv7jMiEQQ9ir78LZPzJNnWK1H7apCX93n5
	Y/jzbB9iJPqHyC3eH0FAL0+psIYpw85uagN0qftwJWrmmLjiBl0mG3UO11wuL84zj/P3gH
	9iY3Y/Xn2VGtmHp7NpCoJP8QXckoztnjBjvsDtwx3ZXwNHS0cu6FYoBSAfii/Q==
Date: Thu, 20 Aug 2026 20:24:41 +0200
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
Subject: Re: [PATCH 5.15 000/272] 5.15.217-rc1 review
Message-ID: <aodGaQjPB3PWsatZ@duo.ucw.cz>
References: <20260820145231.229664293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E7OMBP9afCYcpbp+"
Content-Disposition: inline
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--E7OMBP9afCYcpbp+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.217 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I see build error with this:

drivers/mmc/host/atmel-mci.c: In function 'atmci_remove':
4340
15:40:55
drivers/mmc/host/atmel-mci.c:2632:24: error: 'struct atmel_mci' has no member named 'bh_work'
4341
15:40:55
 2632 |  cancel_work_sync(&host->bh_work);
4342
15:40:55
      |                        ^~
4343
15:40:55
make[3]: *** [scripts/Makefile.build:289: drivers/mmc/host/atmel-mci.o] Error 1
4344
15:40:55
make[3]: *** Waiting for unfinished jobs....

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16011796592
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2776651047

Best regards,
									Pavel

--E7OMBP9afCYcpbp+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaodGaQAKCRAw5/Bqldv6
8pMaAKCw7NLLIwyF84Tr5fUma+/ihcgU1QCfaWBa7r9IlRaye3VX9rWfrDCTr5Y=
=13Vp
-----END PGP SIGNATURE-----

--E7OMBP9afCYcpbp+--
