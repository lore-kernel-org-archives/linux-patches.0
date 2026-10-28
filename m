Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793225825;
	b=3aniUDdCiEpPwpJ6go8RsY4m8pOrJ27jWgplvSl/s/lifEl4yhlyKd3dJR94/lXPaF9K
	 P1oyA/5YY3s6RZu/6J1d1+EFbKykYKPThJUQCUUK5ZR2ADYToI1cjOxJArrqqRGYIHd/2
	 RAQ6yV3AvLUNeZ6UOKQoEx9Mem4OtZg8F44juuOKj0VLXiKFUtNoCY6i1Nh15qNuBJ09+
	 6uuWjyZrItffh0zWVlitOFqf2Jzbu5JzBfRcT+DwOsr1LItuZmcRcVhspU2HfBczfXc/Q
	 mty6Dc7yPn0Itrhr1H/WHmpbN1mBBWhzij8aaL2AaycQ1SI3i/Wd8QG1bH3rDDWjWyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225825;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=AIOYJkWwbEOOkbiH4WpG1xz2/8Lkxz/T8mPLVYlLKnY=;
	b=oge9zEMRgoXOPGt/MvJSCvzeQdaTHMGc9PcVXD36PFu5zQPcxcCBQTLgTF9viM2+QBAS
	 yHPHASwzEKatuCMJdZLuFqitQJzqoLAnCUAw3J3lHTTo7nHDEX5wX8mH3vxLRuhfJ9rrU
	 nkbEKzQfxxAr8unx3GdxPA5zXgQQpUoWSfSdS8eipUAFkMt/N67jkz6OrVzQ+8KngIJcL
	 vt0qlnNY7yesOiug4DTYPpkutu65iaFm2CXt6VhXDsMOl7evBa8NPjNItEawoI4fPVWel
	 LIQDnDPOZ0wT89mtBALwFrA9jMie0X1F5reX84uJ940afBD1xatnixwJE/7Wdud5PIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Ms1SYUza;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9160606A31A
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 22:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9160606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Ms1SYUza
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 155EF10BBEA;
	Wed, 28 Oct 2026 23:16:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793225811;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=AIOYJkWwbEOOkbiH4WpG1xz2/8Lkxz/T8mPLVYlLKnY=;
	b=Ms1SYUzaEvtxsqJTPN28S5O+IA2XTkNAs091NLwFWs8H3ASD0N50hIahpi5OXUIf5OJ3ku
	evesGvygvdHfGEi0kdLyoxL2RKBSaMXHiJtaPTDW0UXA7KZ/xfIPzhZyoxS7F2v/yMa7UW
	LHNi3JMkmwYPL1dM7CN72wyWt3pxZzPMqhlK4xr0cJmECL7DFTkUu7iI3RhV91d0y9aaJO
	191pTaJie8uRKxSS1B68SF8YbBWfbkumePY7/V1WsCG4fe95RKSEJvzPe4eIH9DR8CC4OI
	fPIjFkof2skBkywO2qDtec94sfHjCsk8px9cjd6FzsPky5I04ZwxygmI4dulSA==
Date: Wed, 28 Oct 2026 23:16:47 +0100
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
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
Message-ID: <auJ0T2vTCe4Jhomj@duo.ucw.cz>
References: <20261028170459.200466217@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="9ogCmrLrndZmYNnj"
Content-Disposition: inline
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--9ogCmrLrndZmYNnj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We get build failure in Bluetooth (we probably see the other reported
bugs, too, I did not check):

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/17550762421
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3000620758

Best regards,
									Pavel


net/bluetooth/mgmt.c: In function 'set_mesh_sync':
3514
18:36:58
net/bluetooth/mgmt.c:2188:36: error: implicit declaration of function '__struct_size'; did you mean 'struct_size'? [-Werror=implicit-function-declaration]
3515
18:36:58
 2188 |         memcpy(cp, cmd->param, min(__struct_size(cp), len));
3516
18:36:58
      |                                    ^~~~~~~~~~~~~
3517
18:36:58
./include/linux/minmax.h:92:27: note: in definition of macro '__careful_cmp_once'
3518
18:36:58
   92 |         __auto_type ux = (x); __auto_type uy = (y);     \
3519
18:36:58
      |                           ^
3520
18:36:58
./include/linux/minmax.h:105:25: note: in expansion of macro '__careful_cmp'
3521
18:36:58
  105 | #define min(x, y)       __careful_cmp(min, x, y)
3522
18:36:58
      |                         ^~~~~~~~~~~~~
3523
18:36:58
net/bluetooth/mgmt.c:2188:32: note: in expansion of macro 'min'
3524
18:36:58
 2188 |         memcpy(cp, cmd->param, min(__struct_size(cp), len));
3525
18:36:58
      |                                ^~~

--9ogCmrLrndZmYNnj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauJ0TwAKCRAw5/Bqldv6
8lNxAKCNwro5vRWYmGRoD7hzhrUD9bvdcwCggV4vp62bwTvnZs4qwPmR+wYsufE=
=SIkp
-----END PGP SIGNATURE-----

--9ogCmrLrndZmYNnj--
