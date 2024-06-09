Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5165717740
	for <patches@lists.linux.dev>; Sun,  9 Jun 2024 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717961653; cv=none; b=JIRnNre0d+v7jbm8wdt4qVrfgOR33LXVMBS9bzqtZ5/P7OOjLJsOs7xdVIi3V1oYKz8os/9TF9i4G0TrUjMA0+oe7PHUAh2RmuPRaJxxkOeko+RrD3eOhJH62VRDynmxrQLCVzdUerliKVJn4ZWsKE5Dik9b9hRFh6df4vEdB1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717961653; c=relaxed/simple;
	bh=xSi7azQa7o090Xk6FntbBTHKlE0uCQeUm2rNJVsEfFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nY0hiaYi/eKBwD75+NAAwFJMxMhdMAEPe8oJsQLbdjUplKd6qyO38avsl6Hhb0rpkD+a7IytqTaYRr3x9w0Lpi7vTURcVZ45w3Bc7c9u5yCBVFPr5BzHn8Vy+8+nA71gmYFcM/ubKyJr9YZy+iT/fZTm2z71X5ugJALYc1c2pAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id B3D2B1C0098; Sun,  9 Jun 2024 21:34:02 +0200 (CEST)
Date: Sun, 9 Jun 2024 21:34:02 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
References: <20240609113903.732882729@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CCIc0KBtCtSMTYEU"
Content-Disposition: inline
In-Reply-To: <20240609113903.732882729@linuxfoundation.org>


--CCIc0KBtCtSMTYEU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.33 release.
> There are 741 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

6.6 seems to have build problem on risc-v:

  CC      kernel/locking/qrwlock.o
690
  CC      lib/bug.o
691
  CC      block/blk-rq-qos.o
692
arch/riscv/kernel/suspend.c: In function 'suspend_save_csrs':
693
arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' unde=
clared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
694
   14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RI=
SCV_ISA_EXT_XLINUXENVCFG))
695
      |                                                                  ^~=
~~~~~~~~~~~~~~~~~~~~~~~~
696
      |                                                                  RI=
SCV_ISA_EXT_ZIFENCEI
697
arch/riscv/kernel/suspend.c:14:66: note: each undeclared identifier is repo=
rted only once for each function it appears in
698
  CC      io_uring/io-wq.o
699
arch/riscv/kernel/suspend.c: In function 'suspend_restore_csrs':
700
arch/riscv/kernel/suspend.c:37:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' unde=
clared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
701
   37 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RI=
SCV_ISA_EXT_XLINUXENVCFG))
702
      |                                                                  ^~=
~~~~~~~~~~~~~~~~~~~~~~~~
703
      |                                                                  RI=
SCV_ISA_EXT_ZIFENCEI
704
make[4]: *** [scripts/Makefile.build:243: arch/riscv/kernel/suspend.o] Erro=
r 1
705
make[3]: *** [scripts/Makefile.build:480: arch/riscv/kernel] Error 2
706
make[2]: *** [scripts/Makefile.build:480: arch/riscv] Error 2
707
make[2]: *** Waiting for unfinished jobs....
708
  CC      lib/buildid.o
709

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/705322=
2239
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
324369118

No problems detected on 6.8-stable and 6.1-stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--CCIc0KBtCtSMTYEU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZmYDqgAKCRAw5/Bqldv6
8tHSAKCNgJ04hz+h5sBNTNuKdN7C2FZ/PgCePYUgJW9c6BdSP02m6rcgbf57x4I=
=qIjz
-----END PGP SIGNATURE-----

--CCIc0KBtCtSMTYEU--
