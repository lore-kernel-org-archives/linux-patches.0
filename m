Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021552;
	b=oE2KyNqixtup7JsR9OLwPvyEJBl4xhDUdgsmTrzZQ4B4pz/Zihiwln7CWqV25M+m0Iav
	 iVyFynCvoPfR/87RpZJnu5qV/IbGXju7VRSkMOgKh8Olpb4IWRlrsB+6Yt0fz1Sp7Mr4X
	 ydI+/FscbHcgXiMuSO5LAsr6rEGoFaSmwqDQ5KAc1H2uvQlo++0Kxgm4E41CB7EG/p9RV
	 Xt3UbABgsTlm+rZGb0lrgdWQBtGDhuWo/OtIWPDxdVIm0T9MXPzjTczd8tBqJotsdbiz2
	 gskMnGTK+ocJ1kKR6Nvxh+Dd2exsWQZJSEHWijPTtkSc0AZrNiss+t21bGDhXGe1nlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021552;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=BzhgYa1unzhI3g0jhwkxjiti8vrG+zesnQxHS14lDbA=;
	b=HQstHuhnBH0wlrHO6p7JDpa7LqFNRqthnTO+JxlsEcEJ9O3TIfVi/yv/PERrnl11R2UM
	 ueVnFbP1uvbrEMEtN5zZjKtdONQ62+CcGJ0puTHfxSNpSfEhn1kcy1WFPqRuSty9k65Mq
	 vesRuNWoIANA4TFKQ704ICoNYNQDZblnDUaVEOm86ZgkQISj2M6Hba6EVK+FkAdBXhrXi
	 Eyy5pJ3sIXZJykEKnaJ/Qp/cBUkXNL4bdPH98ClBfYAmqe1fThJKacoOsfatpaddNTwc8
	 FD5Krf/GJUaQ7r7QrLz0wm3LgSA3uRm8tFir0RCTZBX8AX369d1istAu2/+nCb7ECYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=TSRLCAOJ;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9EA606A33F
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 17:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A9EA606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=TSRLCAOJ
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1E05C10DF33;
	Wed, 18 Nov 2026 18:05:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795021539;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=BzhgYa1unzhI3g0jhwkxjiti8vrG+zesnQxHS14lDbA=;
	b=TSRLCAOJxjhntG42pMnFewcIYIBx0ST9rWAgpGOdJOOL5mvLoVM0L8icYCWEzi1+FKetDm
	5cS5gKSsbOQ6D2EFBvd5xRP0CnkSzyq9mpL/vR2YgiroKo8+V2FB3+7lYMHp9j1vdNpTcW
	RZFaWub47zVxDnzyq8FcBhjd3dmy7ElqjDOIOqBGcksv4mCXK5DIaaLPLoE8KCJsv09XM2
	IeeSYYomlhjZ07FDvLI2LGJHOk01hngYyNUPpy7NkwtyDKX6GCJAD+Pk2V0pHfdDkvgkYY
	ROkE3IGvBDNI2pW1CVGZreCuRJnkjRLgVrOi81kZdG/QB73f0M3LGF3eW6drCg==
Date: Wed, 18 Nov 2026 18:05:35 +0100
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
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
Message-ID: <av3a38u7mlLN6yJL@duo.ucw.cz>
References: <20261118145911.150052362@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="ih/tdEP5PrTSaNaH"
Content-Disposition: inline
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ih/tdEP5PrTSaNaH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.275 release.
> There are 1848 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We get build failures here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3=
084757694
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Best regards,
								Pavel

drivers/dma/ste_dma40.c: In function 'd40_handle_interrupt':
2300
15:17:13
drivers/dma/ste_dma40.c:1695:8: error: too few arguments to function 'pm_ru=
ntime_get_if_active'
2301
15:17:13
 1695 |  ret =3D pm_runtime_get_if_active(base->dev);
2302
15:17:13
      |        ^~~~~~~~~~~~~~~~~~~~~~~~
2303
15:17:13
In file included from drivers/dma/ste_dma40.c:19:
2304
15:17:13
=2E/include/linux/pm_runtime.h:42:12: note: declared here
2305
15:17:13
   42 | extern int pm_runtime_get_if_active(struct device *dev, bool ign_us=
age_count);
2306
15:17:13
      |            ^~~~~~~~~~~~~~~~~~~~~~~~
2307
15:17:13
drivers/dma/ste_dma40.c: In function 'd40_hw_detect_init':
2308
15:17:13
  CC      drivers/clk/imx/clk-pllv3.o
2309
15:17:13
drivers/dma/ste_dma40.c:3306:11: warning: returning 'int' from a function w=
ith return type 'struct d40_base *' makes pointer from integer without a ca=
st [-Wint-conversion]
2310
15:17:13
 3
=20

--ih/tdEP5PrTSaNaH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCav3a3wAKCRAw5/Bqldv6
8pM8AJ9aZwC1BB337UtjjjfB5jxxK3RzUQCeO5mPImVqPf7Vn0RuWN/BwJJwjIw=
=XRvI
-----END PGP SIGNATURE-----

--ih/tdEP5PrTSaNaH--
