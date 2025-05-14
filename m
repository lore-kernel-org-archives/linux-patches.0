Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595382882AA
	for <patches@lists.linux.dev>; Wed, 14 May 2025 18:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747247651; cv=none; b=i32p/gVsk/YVh/Upx19TWGvnPnM69u02TVhq/wmVp5CD2fKBk4cCFxgwOQzhMs6L/ZmhFZDiZT0/G954Oshxat1TfrUQUAcUQ/Rkn0viOjSjoxIQOz3aXW89xmPTUMOUJz7I15dfubwAwcMfjwm3CVLqPau7OP6o1WTYHjLRkh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747247651; c=relaxed/simple;
	bh=nZj0G5QM6vpK2m+vpsdOm0Mbn7mbBap7TfFsV51jp5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7LEARuWppgw/i1lTLh10A4UKKcrbp2Q2Hbpva6j9jgVXCLEpQQMOWhZYA1E58wDro53z6FXW98/+jFiUcHgV/H2g5UvO/QQyPpTvq8vEqkcoIv5FQ8La8akpq1yNdEgwEnbQm1neBSUoZeMfnjVaN92tNgaGRxzbW4mHNr3Zxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=gZDbjlc1; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="gZDbjlc1"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B4E4F10397294;
	Wed, 14 May 2025 20:34:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1747247646; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=wKvMZacTyruhf7fV0xooNgqWSx6YeNGEBpfE+WM4J60=;
	b=gZDbjlc1OZRUzyNr4YVgWd3NHII29KF6lCNPo/U9xN0MCeIrIBFgsUV5S/Jx7nLN3WOoKH
	lDcPJ1zct72fugC42giOiWdonTLBUtPFr2LY0nqdxAMNDehcEEii78dZSss6Ca1yZ5MnRB
	NYv36hlwF7Zc+Z04TXeG2NRsAJEgw4r0XT/8Mf9M5TyfzMaEILFIP577yapdXGnkF9ARpo
	PS2brIoPqz0GaRpzb7KsVIW+mIuyhSziKUUvz4Foewu8dchryeI4U3B1VG/Yr3gYPnnCAD
	iV5D+ndOXJP1cNSyZDMgOxhSEPiCQh7dgOwTeBU1hwojyNzzWqu9Ff+Aap5C9Q==
Date: Wed, 14 May 2025 20:34:00 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
Message-ID: <aCTiGAj0Zyc5zxG2@duo.ucw.cz>
References: <20250514125617.240903002@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P4pSiVEofYyPKbEO"
Content-Disposition: inline
In-Reply-To: <20250514125617.240903002@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--P4pSiVEofYyPKbEO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see same problem as on 6.1 here.


2697
  LD      .tmp_vmlinux.kallsyms1
2698
x86_64-linux-gnu-ld: vmlinux.o: in function `apply_retpolines':
2699
(.init.text+0xe4f5): undefined reference to `module_alloc'
2700
make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
2701
make[1]: *** [/builds/cip-project/cip-testing/linux-stable-rc-ci/Makefile:1=
172: vmlinux] Error 2
2702
make: *** [Makefile:234: __sub-make] Error 2
2703
97739

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/100351=
25670
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
817478653

5.10, 5.15, 6.12 and 6.14 are building okay.

Best regards,
										Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--P4pSiVEofYyPKbEO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaCTiGAAKCRAw5/Bqldv6
8jwAAJ9sP3njaflG6Gf9zePWrEywgIPh+wCcDnz2kTXrk9fBLGRfz6w7DUFz9p8=
=obNb
-----END PGP SIGNATURE-----

--P4pSiVEofYyPKbEO--
