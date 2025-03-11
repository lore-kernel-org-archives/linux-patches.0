Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B394122F3B1
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741686165; cv=none; b=h4DYnqs92CW3SV0YcAnAw94ey678vc5PKebuNzpfvFK6/dVM/VcQQPLieYaaQExvgfEYkQo+WQNGevodPYzb/3lsT1flHvQpNfxg6wp3NFdBL5ntNmoFkQ1huPlCv0QcxBX+nUayxTGiT9QD1BjYQQgmgsyMPr7zMbPbzyfwGeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741686165; c=relaxed/simple;
	bh=L5Bw9UBbZSq2OONuxWoDsaeg1DTWC3b2DYoYYrj9MBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqHDA/yXZ2e/pNlX8hATcQ9SCvmr99MUjm+T27HGmt8G1zndyMZGKNe+Id/B5ZtN3PggZsQtNGBdpC5J2HccsTkr9lTpQIJ3k35TdR1DbsavCmzzO19EwP5bXXiVPBU8y8Ftb0tiDpY97x6CX/gE0aoqUC9N2j3PSLq5dM/VghI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=SZP9YVXH; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="SZP9YVXH"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B0C3A103D3303;
	Tue, 11 Mar 2025 10:42:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1741686154; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ee0GouMttyoAI0zvBvt/JOBCHGowOvANqdNioGonbio=;
	b=SZP9YVXHZk/yq4RN+3uIEDDZAtJqeOuemEx1bQ0ajxZ7hufQuMOLljjuDIoyT3KfOMH7ah
	7Sgx/dZZzqvUXuppsQUfOOxYq++AC+RvyCSK2DxfFcRzW4fIrTwySsUXojItGeq5nddkKw
	ZY+Od4qOCCpk1fHDZN6O+uXn5V6YhsKJVsOcDm9rlAPjOlFp78bll9CXaB+QhtjKRvQWX3
	kiTuE++esGpUan9HglpvMBC0fbnP0dIqJj/Yp0raP4BIBlMHmG6tJ3HBPsaPJ3dYJmN8C9
	JVuUmFxEoh9SwiCSUxnSCU7Ql++qw06Xy9KXwWCifxr2Ibivj7K4/+uCQJ5DYw==
Date: Tue, 11 Mar 2025 10:42:25 +0100
From: Pavel Machek <pavel@denx.de>
To: Ron Economos <re@w6rz.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/145] 6.6.83-rc1 review
Message-ID: <Z9AFgaBYY/VoF7X8@duo.ucw.cz>
References: <20250310170434.733307314@linuxfoundation.org>
 <81784d87-b837-4476-974a-87b0333e7e38@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MoM5oHu0BFGlukw+"
Content-Disposition: inline
In-Reply-To: <81784d87-b837-4476-974a-87b0333e7e38@w6rz.net>
X-Last-TLS-Session-Version: TLSv1.3


--MoM5oHu0BFGlukw+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 6.6.83 release.
> > There are 145 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.8=
3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-6.6.y
> > and the diffstat can be found below.

> The build fails on RISC-V with:
>=20
> arch/riscv/kernel/suspend.c: In function 'suspend_save_csrs':
> arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG'
> undeclared (first use in this function); did you mean
> 'RISCV_ISA_EXT_ZIFENCEI'?
> =A0=A0 14 |=A0=A0=A0=A0=A0=A0=A0=A0 if (riscv_cpu_has_extension_unlikely(=
smp_processor_id(),
> RISCV_ISA_EXT_XLINUXENVCFG))
> | ^~~~~~~~~~~~~~~~~~~~~~~~~~
> | RISCV_ISA_EXT_ZIFENCEI
> arch/riscv/kernel/suspend.c:14:66: note: each undeclared identifier is
> reported only once for each function it appears in
> arch/riscv/kernel/suspend.c: In function 'suspend_restore_csrs':
> arch/riscv/kernel/suspend.c:37:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG'
> undeclared (first use in this function); did you mean
> 'RISCV_ISA_EXT_ZIFENCEI'?
> =A0=A0 37 |=A0=A0=A0=A0=A0=A0=A0=A0 if (riscv_cpu_has_extension_unlikely(=
smp_processor_id(),
> RISCV_ISA_EXT_XLINUXENVCFG))
> | ^~~~~~~~~~~~~~~~~~~~~~~~~~
> | RISCV_ISA_EXT_ZIFENCEI
> make[4]: *** [scripts/Makefile.build:243: arch/riscv/kernel/suspend.o] Er=
ror
> 1
>=20
> Reverting commit "riscv: Save/restore envcfg CSR during suspend"
> 8bf2e196c94af0a384f7bb545d54d501a1e9c510 fixes the build.

We see the same problem.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--MoM5oHu0BFGlukw+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ9AFgQAKCRAw5/Bqldv6
8q7WAJ4qfchFT3jtZ4DDJ95rONDfKRmv5ACgi4BMYshb0f9+bnhBj0g52O+Qbb8=
=xFsN
-----END PGP SIGNATURE-----

--MoM5oHu0BFGlukw+--
