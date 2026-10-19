Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428963;
	b=kl1aHdO6XuIi6oOycnDJJ4uvVC/4U6+IN6/DMnPQvmmxm/jWCa8Of+fX8axeMVrwviji
	 MeHRrNL9fT3CkfFh+qtSdte/jggLqY0xNvr+IBX2Z/U0O6DS8AqRPEALSjsPTDXUrzzs+
	 lrQSak04rHiC5RJeuhWG+K4Kv7zY+FT87jExFVk/3YrkysrA2AihG9eGM1lKhJRwDGP0a
	 6r8tzlkBebWhYOZi4j8KLE04Kg3TMcPkgN/9A7b1ttFPIfy8fvsEM8X1WZ1HYnz1e8c5t
	 G93yBDg/VdA4UsClAmvU3Fk+9cqBbUQKVsQpomTY4nLnfKAstviNQr8kgNlASt+M/rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428963;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=pWNLaLprKVtSQha+gsTxyCVSf04Xp/iRSxALG2dYFI8=;
	b=Ty0d144mhw1vUHZlUqAr+NKKOR2+td4P/Va9cacopKYHQmGqOL/TDfWuEqwkGxbIib2a
	 lK+KVn4I5QFh7ofd9adY4ro7vS6lQR9ceeZIzj2J5HHew1vXGXnGTcYgbKH3UeR3v4Ufk
	 ENfEU7JFzhfuBNHujiEE4yj5Li4r8wybeDa4sPJFaPac0+QIAwkjFf3LI9NQWcUVJza8H
	 qZC1c6sfyHy/STZsciMpC7bK4DdPpSeynbAL7MlZI2jkCW0zoPTSKqGabNgDhiYgGjo3m
	 6/F+IrpAek1F8rl37OBNW/hLqV6EyXzIyuOP2vSHppe8tZ68dBx3NSFsQxYAsGbAiRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=OP7oNyuD;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF79606A332
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DF79606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=OP7oNyuD
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7A3D9106C76;
	Mon, 19 Oct 2026 18:55:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1792428949;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=pWNLaLprKVtSQha+gsTxyCVSf04Xp/iRSxALG2dYFI8=;
	b=OP7oNyuD9ApTZ/WJseQlOEvG+Fw3ySbP8+ppLslwQR0qyUSsrMxNq5PN4KIdqzXITjsvF6
	jAWaqAGKz0S6Fi7XbAyLi6Tvgfpy4iOjgSWuxssPkVJbOo8mDyFYt49Qlwruewbt1zjO+m
	P6irWdhvtR6yaiXr2Oef1j/WdCZ0os/NU5GHqJwx5Zqlfxb6BlS4Uh8A6cDAOmY3QwGlUt
	H57dVL/eR+eg4mbFh428OXcJu/O5ngABXNUHWvdP+9l5FcfaWKISgQnsIhcZWDC0V1hDAP
	57hYleapFwppyMawgrhOG4bTB8gViC1Z7tLkC8uml3rdx/lugNI/yvzMjU9Ljw==
Date: Mon, 19 Oct 2026 18:55:44 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
Message-ID: <atZLkOhmDdg8kWta@duo.ucw.cz>
References: <20261017160431.119607952@linuxfoundation.org>
 <8e765406-3ba3-47d7-bba6-e15a2cb56857@nvidia.com>
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
	protocol="application/pgp-signature"; boundary="lXgem9aFCdTh2lr2"
Content-Disposition: inline
In-Reply-To: <8e765406-3ba3-47d7-bba6-e15a2cb56857@nvidia.com>
X-Last-TLS-Session-Version: TLSv1.3


--lXgem9aFCdTh2lr2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 6.6.160 release.
> > There are 1674 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Mon, 19 Oct 2026 16:02:05 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.1=
60-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-6.6.y
> > and the diffstat can be found below.
> >=20
> > thanks,
> >=20
> > greg k-h
> >=20
> > -------------
> > Pseudo-Shortlog of commits:
>=20
> =20
> > Pei Xiao <xiaopei01@kylinos.cn>
> >     mmc: atmel-mci: Fix use-after-free in atmci_remove due to race cond=
ition
>=20
>=20
> The above commit is causing the following build failure for ARM with the
> multi_v7_defconfig:
>=20
> drivers/mmc/host/atmel-mci.c: In function =E2=80=98atmci_remove=E2=80=99:=
                =20
> drivers/mmc/host/atmel-mci.c:2661:31: error: =E2=80=98struct atmel_mci=E2=
=80=99 has no member named =E2=80=98bh_work=E2=80=99                       =
                                                                           =
 =20
>  2661 |         cancel_work_sync(&host->bh_work);
>       |                               ^~
> make[6]: *** [scripts/Makefile.build:243: drivers/mmc/host/atmel-mci.o] E=
rror 1       =20

We see the same issue.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/172922=
58412

Best regards,
									Pavel

--lXgem9aFCdTh2lr2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCatZLkAAKCRAw5/Bqldv6
8tkYAJ92E+/f5/syjnUfezutntnaKg/axgCfZy4EUCD48YjO9a3S9QcI3e/WC5Q=
=cN25
-----END PGP SIGNATURE-----

--lXgem9aFCdTh2lr2--
