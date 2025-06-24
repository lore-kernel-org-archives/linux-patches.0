Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233FD222576
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750781928; cv=none; b=qvYWr3TjCpsrz+V1xIe8YBeO4OGmuWqCp9L4Ip2/ahavZR/jNwrjGPQ6L9QPV/vvEYyeRr0vHTnPOHloF0yDRIz6fDVY31vQEBngdvVmHuzTzojdh0BTl8QsZFr/SZgfasMuIUXHjTQy5mKdt5whh7NTYKZn2mdzTKm6Pkzd8ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750781928; c=relaxed/simple;
	bh=4ldrUXyzvFR5k0WoR/yiNzjQ9bJModzxmllWvzyOylc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f330HV/gwypbyshb4doVoZA4scL39exglKbLA25LKUALiGL1l7Xo/pG8Wma0Y2m7dijpSl3ROwa7mG8M2lkKAS/u+qJwMdBS7g4BaIdjciqNb3a40VM1jb7GLfjpIY4WmIHjFQoCTW8R8H9DxX/1tS2sz8JGeEXPs8ocHiqtY+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=YSopkTVs; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="YSopkTVs"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 10293101E8F52;
	Tue, 24 Jun 2025 18:18:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750781922; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Va1GElfn24V2n6z7i0LdkveYRP3tydIp4DA9MSZVvb4=;
	b=YSopkTVsf/kFOYTvEMza1G7egcTIIvo+xektTod7f03AAchmfAx5yEMRagxZxkA6V8WeuJ
	o/iCNK7jNRnkOcdN38UfjZXOOvEIJvMPfUdjE6daF2XCr62H4GbyrAMflfg1s+k0CcoAl8
	Pz1fNMok3tQXa6RwZQq9ogF+TBoecpNLl7uLwhEKbn5PJJXdkSNPQBIbpymNyZopiw1UC9
	MF9q4zJL+PxNVQ8XmKV/cLnVmfUXImDNG+USsXjBkK0eauYaA3bf/Iq6RX1fFeUlnDfYm1
	Gi4gMIdh0Y09WezYMjnX/KwJrNX7/W/bacnncr3oULRKzXK5tXuJ7/sGfknpag==
Date: Tue, 24 Jun 2025 18:18:32 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, kvmarm@lists.cs.columbia.edu,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Andy Gross <agross@kernel.org>
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
Message-ID: <aFrP2KAE1cws/Hbq@duo.ucw.cz>
References: <20250623130611.896514667@linuxfoundation.org>
 <CA+G9fYvpJjhNDS1Knh0YLeZSXawx-F4LPM-0fMrPiVkyE=yjFw@mail.gmail.com>
 <2025062425-waggle-jaybird-ef83@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NeDUsWHsbq74XlUI"
Content-Disposition: inline
In-Reply-To: <2025062425-waggle-jaybird-ef83@gregkh>
X-Last-TLS-Session-Version: TLSv1.3


--NeDUsWHsbq74XlUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Build regression: stable-rc 5.4.295-rc1 arm kvm init.S Error selected
> > processor does not support `eret' in ARM mode
> >=20
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >=20
> >=20
> > ## Build errors
> > arch/arm/kvm/init.S: Assembler messages:
> > arch/arm/kvm/init.S:109: Error: selected processor does not support
> > `eret' in ARM mode
> > arch/arm/kvm/init.S:116: Error: Banked registers are not available
> > with this architecture. -- `msr ELR_hyp,r1'
> > arch/arm/kvm/init.S:145: Error: selected processor does not support
> > `eret' in ARM mode
> > arch/arm/kvm/init.S:149: Error: selected processor does not support
> > `eret' in ARM mode
> > make[2]: *** [scripts/Makefile.build:345: arch/arm/kvm/init.o] Error 1
> >=20
> > and
> > /tmp/cc0RDxs9.s: Assembler messages:
> > /tmp/cc0RDxs9.s:45: Error: selected processor does not support `smc
> > #0' in ARM mode
> > /tmp/cc0RDxs9.s:94: Error: selected processor does not support `smc
> > #0' in ARM mode
> > /tmp/cc0RDxs9.s:160: Error: selected processor does not support `smc
> > #0' in ARM mode
> > /tmp/cc0RDxs9.s:296: Error: selected processor does not support `smc
> > #0' in ARM mode
> > make[3]: *** [/builds/linux/scripts/Makefile.build:262:
> > drivers/firmware/qcom_scm-32.o] Error 1
>=20
> That's odd, both clang and gcc don't like this?  Any chance you can do
> 'git bisect' to track down the offending commit?

We see this one, too:



/tmp/ccJcop5R.s: Assembler messages:
2033
/tmp/ccJcop5R.s:45: Error: selected processor does not support `smc #0' in =
ARM mode
2034
/tmp/ccJcop5R.s:95: Error: selected processor does not support `smc #0' in =
ARM mode
2035
/tmp/ccJcop5R.s:162: Error: selected processor does not support `smc #0' in=
 ARM mode
2036
/tmp/ccJcop5R.s:299: Error: selected processor does not support `smc #0' in=
 ARM mode
2037
make[2]: *** [scripts/Makefile.build:262: drivers/firmware/qcom_scm-32.o] E=
rror 1
2038
make[2]: *** Waiting for unfinished jobs....
2039

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/104520=
69686

It is probably config-dependend.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
886959470

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NeDUsWHsbq74XlUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFrP2AAKCRAw5/Bqldv6
8qibAJ9VUVgof6VKLUdQlXbcxcDMnAgf1gCfR41spMnM223GmmrQF68UWgs3GW8=
=sRvP
-----END PGP SIGNATURE-----

--NeDUsWHsbq74XlUI--
