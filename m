Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021691;
	b=ksWrngGe+NLN0WzjuEXbKSLAfA6dYpNd3IPuW+hCDS8aRVZzUsmRoZM6MjP9vcMgHmcB
	 lOhxMVju/WY8rGW1WpTZQXCosCBUfER8gI2ni11jRpkX74sECd1eNneenp3WMOaA8GXd3
	 kbmRJVIn7xCOkrMwj+SfibC5sf9SXYWrH+NrAWz/1O+uEYPfjvR/WNxxJaKdCX653o6kE
	 Lx8FQcbc9AZ43JGLZzOB9BhgWeI/UO5cO8BNiKKmWqCVkO/kiir2dssPmDQv+qa5IcbSe
	 HP2fhDN/lKRofSKIfw25qJCp69rrQBdxIRIpiSp0LtEzX4eQjDSCNxz++O98f9UTJEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021691;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=aseNCq+n+5bjQaW0Vanm4zTvexhRPXNbk5ZXU5gkWPg=;
	b=3uQMTbNIt+indj2sSLJDjBZuZbelMVMIw2fdJ5dbsKl4cUTi8WWUwNMsRqcdmBa5OBt+
	 A9+gfzn94VQ+SkWTMn/autQebcV2l4GtV4proap66BJYkok336A0gIVo84FQ1M1qliFsw
	 wGcuWxy57LaCE4HPSBG/MsgJ32otHTojF18uw7n8P5BKjVkwk4RgmcEI/TB97cbWamE4f
	 RPY1PeTiWfilPaSXqTUgNoplBIa2y2DatVyhttF/p5T3OWDn6b6mF6GS7o0t0kQQcHFTG
	 vh6OT7BOeSqqpoeI8beyd3eLH2gvOwvc8sHne/ni193D0e1DYlTd4nJbwy7AIrEJyxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b="Xye/kTc9";
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F49606A32F
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 17:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8F49606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Xye/kTc9
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C6D7310E048;
	Wed, 18 Nov 2026 18:08:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795021684;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=aseNCq+n+5bjQaW0Vanm4zTvexhRPXNbk5ZXU5gkWPg=;
	b=Xye/kTc9O2lTy9sT0HMZ6Hacufu66cq+QObbWSfDMP3YKMYVLhNsEYW5sGb1oXGLv9fL4f
	bFk0MqOOOGtcbQghKUpV3YLxH1rxhXAC0rKwCLg3aaSDA1Iq3bZR+pAtoDshMTOiU0VVOs
	T3lZG0l4S2XNtuOtzTZhjq3Zn+b8SZzS2nj7m/QBA2Ru/WovNsWNWySHVSSLJlOBiEsPHB
	IvrRdr4TMaFYVSCsnx0Wp8uInHVNzDO8EFyym0v4f8ZRoP/X1q8+2KbF44ZUk8gyvOlcTl
	ZuozZIm/FPX/UURubRRH259GzGzw+zHJ0ur8Jxvo1vOF3cEaEtuI92aUBxtZow==
Date: Wed, 18 Nov 2026 18:08:02 +0100
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
Subject: Re: [PATCH 6.1 0000/2857] 6.1.193-rc1 review
Message-ID: <av3bctJT9Ubq2j8q@duo.ucw.cz>
References: <20261118150201.293410965@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="H/qvEaJ/bP24KPwm"
Content-Disposition: inline
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--H/qvEaJ/bP24KPwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

HI!

> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We get build failures here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3084767168
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/18149480104

mm/mremap.c: In function 'move_huge_pud':
1175
15:43:14
mm/mremap.c:395:19: error: implicit declaration of function '__pud_trans_huge_lock'; did you mean 'pud_trans_huge_lock'? [-Werror=implicit-function-declaration]
1176
15:43:14
  395 |         old_ptl = __pud_trans_huge_lock(old_pud, vma);
1177
15:43:14
      |                   ^~~~~~~~~~~~~~~~~~~~~
1178
15:43:14
      |                   pud_trans_huge_lock
1179
15:43:14
mm/mremap.c:395:17: warning: assignment to 'spinlock_t *' {aka 'struct spinlock *'} from 'int' makes pointer from integer without a cast [-Wint-conversion]
1180
15:43:14
  395 |         old_ptl = __pud_trans_huge_lock(old_pud, vma);
1181
15:43:14
      |                 ^
1182
15:43:15
  CC      fs/ext4/migrate.o
1183
15:43:15
cc1: some warnings being treated as errors

Best regards,
							Pavel

--H/qvEaJ/bP24KPwm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCav3bcgAKCRAw5/Bqldv6
8vjWAJ9X09ClZ7hI+kH6TC0PWf9aMBdgMgCgu6mIxCPLwtFrdxWFgv1+zfBzrPU=
=uBS5
-----END PGP SIGNATURE-----

--H/qvEaJ/bP24KPwm--
