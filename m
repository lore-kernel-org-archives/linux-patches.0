Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DBF24A7E7
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737029385; cv=none; b=SCOHod7ForhxNHn/fxsq4jeaPvacJe2k+1wgOi4dkC/93353Vj4EYWB5uOoHnsdfmYy796qK2bkqvEezGYqV2JmEGFGrD4+NQ8KVXi8Vs0ZSQBXQplQKGgUPMmO/94wzdN/PUd47UHZXRmUrRTh0w/emOY0VvQCzznEbVdLI4/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737029385; c=relaxed/simple;
	bh=EQKmTDhoOpbRyCLRnNrOvU69bg1jUIxBVG3r0YZ8wAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrjN3D1KwHqAjEPQUV1aT7+Gzl0tmEg6X3inuoO6iskGFIDREToFQsCya4A5ThaQhOAoqQKLpthIOCKfsEw6qg7Sz6xCKnevPcx9X6xR81G5xbPEa/gcH271+ROGIJEUwxJjQT+3hqI7rkfTiV3fR6FL4IUfiPFcuq8FigIN7N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=TgMGgJah; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="TgMGgJah"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DDEC71048AF7C;
	Thu, 16 Jan 2025 13:09:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1737029379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q7RlLEoBHbQoXSZxdKGyCvsk7MvkhahjL/goGwieX2w=;
	b=TgMGgJahLlMc0b0vUXjaNPFR5Z761P9nQkPZI7n6StsWj447RVfe4UaWv/L4MZbhDfvg9a
	bm8mFMPDh2VHAsanBBZe17XmIlZ+Z04/1KtpPdmCkWR1u3qsU9bZjCe2j5M7fuUBtrTtJA
	E4qt9el12sQ6LQUxRvGt+m38bZzd76zPq6by7CrFNsHCvPAmYWa4fyRES1DvxY8k8sflM0
	X/H71NgMjTtToP2S+adaNeMcpZhJg34GYCSh9kTW01uttnIuLG2hzSjASut2/1KYnrTNmK
	y9XK6L21l7+U1O04qUN1A2RLv3+6kCU3NDVQOhmC4583RMx6+H1yrDdFEqb+sg==
Date: Thu, 16 Jan 2025 13:09:33 +0100
From: Pavel Machek <pavel@denx.de>
To: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/114] 6.12.8-rc1 review
Message-ID: <Z4j2/VEVaM12YTjy@duo.ucw.cz>
References: <20241230154218.044787220@linuxfoundation.org>
 <a1162760-b451-4c11-b5ca-536ede236bb2@collabora.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GDXAtDxa71MD7/D9"
Content-Disposition: inline
In-Reply-To: <a1162760-b451-4c11-b5ca-536ede236bb2@collabora.com>
X-Last-TLS-Session-Version: TLSv1.3


--GDXAtDxa71MD7/D9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 6.12.8 release.
> > There are 114 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.=
8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-6.12.y
> > and the diffstat can be found below.

> BOOT TESTS
>=20
>     Failures
>=20
>       arm64:(defconfig)
>       -mt8186-corsola-steelix-sku131072
> 	[    6.051924] Device 'adsp_top' does not have a release() function, it =
is broken and must be fixed. See Documentation/core-api/kobject.rst.
> 	[    6.064309] WARNING: CPU: 6 PID: 74 at drivers/base/core.c:2569 devic=
e_release+0x170/0x1e8
=2E..=20
> See complete and up-to-date report at:
>=20
>     https://kcidb.kernelci.org/d/revision/revision?orgId=3D1&var-git_comm=
it_hash=3Ded0d55fbe89cd97180e55170f9f3907b2aa5f91d&var-patchset_hash=3D
>=20
> Tested-by: kernelci.org bot <bot@kernelci.org>

I believe we usualy don't add "tested-by" tag when we detect failure.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--GDXAtDxa71MD7/D9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ4j2/QAKCRAw5/Bqldv6
8i91AJ46S0tSm4yYE5AI6I3ndjl1lMVpCQCeNGh03qHQT2IDXk5M/IlcwFILl2c=
=01xz
-----END PGP SIGNATURE-----

--GDXAtDxa71MD7/D9--
