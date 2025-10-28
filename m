Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437B13C38
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 08:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761638990; cv=none; b=lkjNduzOhbgIgNFZ4FPE94cpa71e3otYNfS9GgKYJCT0kd4YC1gT6SX6KZ6sq3ROY8OIVmwmsa+x07+Uz4nucc0wMr2Vn0bAewQaAkEsqcwqEMiguNkUlAjOdQrZja7tqrHtx4WE9KbXPX2Co0zcIwTesV4U37/yP2WK0tjJud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761638990; c=relaxed/simple;
	bh=IlErAmjiA00Nysk4jg9Kxt8XW3suEYjjN2J626J0C14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OdTsMgwnFmjsE2KlscYl7bzhH51vUufmXRVletoLUuyo4v3Jd0JNnykbwD19wxCUbypd67kr8cw4ZrBni81Vb/g4uEdpSlR4AGLoC2c2MSgmCUjrUQYHbC70tRCETIA4BCpeBdqMtXpCnya4dcRb/TPOVA0+R9TcwRIfVKOz6SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=XJY81++n; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="XJY81++n"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9F0B31038C10B;
	Tue, 28 Oct 2025 09:09:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1761638986; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=BRmY2JQYIZZCQ9CtA4hDRHYx/CUBo+xowyisdYQUqCM=;
	b=XJY81++nYHF60AOUvD+AfuP698hddMt/nIrgjrZp/4nK6yordLqYKMrMwFTtNGlACN40Yd
	FySKQwda7Txyz3QIC/3N2bH0rKkFzBb0E1BUCfP503E15Xk8QASjDyEEbdMcXvAVpYrW5G
	+Q4YB0kp1OPvRDmYx8XM+m746Wz3jAfC5CSqdyKMyNOsr7x8GYz/1kLWTat8UsPh2/LQK/
	S3ZvcTpes8qpT7znQSUmLVPW4SNaNMmySQDKQRBcHyo39ckgckdplnxIpGo2XsBF368qX7
	Do60knxRcASDzzt1rY8kRJYjfo1HOY/jETyKL0vEm/x/qy8/w7VUKMAoW89m7Q==
Date: Tue, 28 Oct 2025 09:09:41 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
Message-ID: <aQB6RQfAyhyscGcE@duo.ucw.cz>
References: <20251027183446.381986645@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YFPvWxrb57hv4umP"
Content-Disposition: inline
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--YFPvWxrb57hv4umP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.15.196 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Same problem as 5.10:

arch/riscv/kernel/cpufeature.c: In function 'riscv_fill_hwcap':
2328
arch/riscv/kernel/cpufeature.c:107:16: warning: unused variable 'ext_end' [=
-Wunused-variable]
2329
  107 |    const char *ext_end =3D isa;
2330
      |                ^~~~~~~
2331
arch/riscv/kernel/cpu.c: In function 'riscv_of_processor_hartid':
2332
arch/riscv/kernel/cpu.c:24:26: error: implicit declaration of function 'of_=
get_cpu_hwid'; did you mean 'of_get_cpu_node'? [-Werror=3Dimplicit-function=
-declaration]
2333
   24 |  *hart =3D (unsigned long) of_get_cpu_hwid(node, 0);
2334
      |                          ^~~~~~~~~~~~~~~
2335
      |                          of_get_cpu_node
2336
  CC      arch/riscv/kernel/ptrace.o
2337
  AR      usr/built-in.a
2338
cc1: some warnings being treated as errors
2339
make[2]: *** [scripts/Makefile.build:289: arch/riscv/kernel/cpu.o] Error 1
2340
make[2]: *** Waiting for unfinished jobs

BR,
							Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YFPvWxrb57hv4umP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaQB6RQAKCRAw5/Bqldv6
8iXtAJ9IRuDLQAJ7wIedwzT3KvCwCsomLgCdFgzpyRi/Hd8MSXEBTHFXCjY/FUI=
=yEZ3
-----END PGP SIGNATURE-----

--YFPvWxrb57hv4umP--
