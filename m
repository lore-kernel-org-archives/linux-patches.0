Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E02E27AC3C
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750761688; cv=none; b=OUXWKNI84s814rLsdOL1bg0aXS3cGrrMLW0gb+ovjg7J/c74BrRTNIeUBlHDvJghlD3/Ajgm91kOSFi6IEHYY+sMDV0028kQeu0EfFYha7KJfaseMgxxmv1YiISTA2LWC2X4k0Nacrna6MABO7CwsfDaDttSk1uQiXtWeM4qFJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750761688; c=relaxed/simple;
	bh=mHuFsM00zsmxReWQp0YW0IovyAqAiKaN9vwTtZUpZ1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ok1rhugb4QZHjUMLTPByYx1ESSWSGb4bKkPGElRTa2G5UENqXZOYdv2dsaPbsInjXQikdJ/4u/LHyiT50lAWHZsNF/a2neuICeYi7lAq5Euy+o3fICEIKm8O3AAyH7u14J30TEnrOO1BSks+QIdncnt/gKm1UI/sDh00t8/zBTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=O81Rly9R; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="O81Rly9R"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E820C101E9287;
	Tue, 24 Jun 2025 12:41:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750761677; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=xJNZSdtlkmYSmYR194N6u/IIwvLnmZyLCW5wos6cefs=;
	b=O81Rly9RWffD1vprGIl6wBGzUIqmAs4FKeptoBWaVbi98DKflcuKrXOi/+WfDxvIkCoNsq
	B8YX5tAhGPNXO0jpbhC/kdKkicKFvyZVRlXm9SRLc3BF9elb7QkiVxNvlGVnWXvWaPZoQr
	PKlhnwOnBPAzcW8V9ZXu2vSzAYs5KVeIol/jIMsxD80dsHyb5q7aZto5klDzlZzYDbl6el
	etk/HqBCVUB8AWsw1JI81+euCWs6ThTGgEJzOSX7wi3rT9UDZx5mGPb4EitnFOo/i+khE7
	adnF828od6mJWOIBxCGN7Tz1Cq/KZsqsvJCx9U/xUWgwpH7QtOHheeIaEAf45g==
Date: Tue, 24 Jun 2025 12:41:08 +0200
From: Pavel Machek <pavel@denx.de>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Julien Thierry <jthierry@redhat.com>,
	James Morse <james.morse@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.10 000/355] 5.10.239-rc1 review
Message-ID: <aFqAxKT6C7idQY32@duo.ucw.cz>
References: <20250623130626.716971725@linuxfoundation.org>
 <CA+G9fYt2e-ZGhU57oqWwC1_t2RPgxLCJFVC0Pa8-fYPkZcUvVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="99H4i/IRjps6Yc2M"
Content-Disposition: inline
In-Reply-To: <CA+G9fYt2e-ZGhU57oqWwC1_t2RPgxLCJFVC0Pa8-fYPkZcUvVQ@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3


--99H4i/IRjps6Yc2M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 5.10.239 release.
> > There are 355 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.239-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> Regressions on arm64 tinyconfig builds with gcc-12 and clang failed on
> the Linux stable-rc 5.10.239-rc1.

Yeah, we see same problems:


814
  CC      arch/arm64/kernel/asm-offsets.s
815
In file included from ./arch/arm64/include/asm/alternative.h:6,
816
                 from ./arch/arm64/include/asm/sysreg.h:1050,
817
                 from ./arch/arm64/include/asm/cputype.h:194,
818
                 from ./arch/arm64/include/asm/cache.h:8,
819
                 from ./include/linux/cache.h:6,
820
                 from ./include/linux/printk.h:9,
821
                 from ./include/linux/kernel.h:17,
822
                 from ./include/linux/list.h:9,
823
                 from ./include/linux/kobject.h:19,
824
                 from ./include/linux/of.h:17,
825
                 from ./include/linux/irqdomain.h:35,
826
                 from ./include/linux/acpi.h:13,
827
                 from ./include/acpi/apei.h:9,
828
                 from ./include/acpi/ghes.h:5,
829
                 from ./include/linux/arm_sdei.h:8,
830
                 from arch/arm64/kernel/asm-offsets.c:10:
831
=2E/arch/arm64/include/asm/insn.h: In function 'aarch64_insn_gen_atomic_ld_=
op':
832
=2E/arch/arm64/include/asm/insn.h:26:54: error: 'FAULT_BRK_IMM' undeclared =
(first use in this function)
833
   26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM =
<< 5))
834
      |                                                      ^~~~~~~~~~~~~
835
=2E/arch/arm64/include/asm/insn.h:573:9: note: in expansion of macro 'AARCH=
64_BREAK_FAULT'
836
  573 |  return AARCH64_BREAK_FAULT;
837
      |         ^~~~~~~~~~~~~~~~~~~
838
=2E/arch/arm64/include/asm/insn.h:26:54: note: each undeclared identifier i=
s reported only once for each function it appears in
839
   26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM =
<< 5))
840
      |                                                      ^~~~~~~~~~~~~
841
=2E/arch/arm64/include/asm/insn.h:573:9: note: in expansion of macro 'AARCH=
64_BREAK_FAULT'
842
  573 |  return AARCH64_BREAK_FAULT;
843
      |         ^~~~~~~~~~~~~~~~~~~
844
=2E/arch/arm64/include/asm/insn.h: In function 'aarch64_insn_gen_cas':
845
=2E/arch/arm64/include/asm/insn.h:26:54: error: 'FAULT_BRK_IMM' undeclared =
(first use in this function)
846
   26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM =
<< 5))
847
      |                                                      ^~~~~~~~~~~~~
848
=2E/arch/arm64/include/asm/insn.h:583:9: note: in expansion of macro 'AARCH=
64_BREAK_FAULT'
849
  583 |  return AARCH64_BREAK_FAULT;
850
      |         ^~~~~~~~~~~~~~~~~~~
851
make[1]: *** [scripts/Makefile.build:117: arch/arm64/kernel/asm-offsets.s] =
Error 1
852
make: *** [Makefile:1262: prepare0] Error 2

BR,
										Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--99H4i/IRjps6Yc2M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFqAxAAKCRAw5/Bqldv6
8oO2AJ0THdQP/jgUCOPQIWJxokWKjzBWXwCfbnHq/Z5PGgx+mwo8REY3xKum4EY=
=7i9r
-----END PGP SIGNATURE-----

--99H4i/IRjps6Yc2M--
