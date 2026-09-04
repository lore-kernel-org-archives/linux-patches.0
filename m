Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94F0368974
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527378; cv=none; b=djCdgvLUtMZjvoZyexygnXLnrZOOxiIaY8U460xEX1wCPVTg1h7L8L6Q09bwoKV+h3eAiD95Nh1w+BxpWzrZMKuujMzEsyUIhRPE0hTxtsxkb2hZHzLD5GTYWOMx6OAUD/0U2gOmev8CwJ6kFrJ3U/uMuN5mft89/BD0ueogo0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527378; c=relaxed/simple;
	bh=Qd5i+cb5fGH5X5+w+RHN5WSORmzGkyAW4hfj8/3JIyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oaant8klRg2biwazkl5jvyH1KIxz93A+I1zELo8BnX2KsnUC3Zg+Tygk+UYWn1ivzbA+SeOapmhBrbtgC0WnE2M9S+pZSXd5Zi4QlQxndcIy/NfSPyyyltGHyz9gYhUNyOTXbDmF0bfojtMUYCoeRz29gGjnayVsRTnIHx1JTps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=hxYxTIia; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="hxYxTIia"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 70E9811C6D7;
	Fri, 04 Sep 2026 15:09:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1788527364;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=tbX3uI3YtmWwndN6o8+XcgsvO5jSTLypgDRgnKDwzqw=;
	b=hxYxTIiaD9uMewSu0LZWcK6PRs+Zx3ReQw+csbvqu27+HwlYbNIL4Ucy24yaJlhnm9UOxX
	6h4bjs1sXgQiM7nZkTQZYtu0fSpOWA5gRaRMH0TDdVsttiErfJpqjLmqkHFhF3UOtZUHoJ
	r56lNPg/xLvbXowAFnFj+pmv9snBIvDoQ0z0hbJnmz4bZniwZUY1gcAEbrAbFfEpnHU9k3
	YzN/tvComqvLrIJZjP50WMsg7h49abq5a1WwigWto+VN+J7eGZy3x8H7HQUwo+0qBrp4u/
	CCX2FuJ5zP0ZKGqZTP4vqHZrqV6n7p1vc9YsrRJtjzdw6A/lvZCia0ChvOOK7A==
Date: Fri, 4 Sep 2026 15:09:18 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/403] 6.12.109-rc1 review
Message-ID: <aprC_gL7Ft2mYZy2@duo.ucw.cz>
References: <20260904045734.806166532@linuxfoundation.org>
 <apqKYeQe-78JWI3u@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1NZNXXURmQtKWfJi"
Content-Disposition: inline
In-Reply-To: <apqKYeQe-78JWI3u@codewreck.org>
X-Last-TLS-Session-Version: TLSv1.3


--1NZNXXURmQtKWfJi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Dev Jain <dev.jain@arm.com>
> >     mm/page_vma_mapped: use huge_ptep_get() for hugetlb
>=20
> This fails build on arm (config attached)
>=20
> CC      mm/page_vma_mapped.o
> ../mm/page_vma_mapped.c: In function 'check_pte':
> ../mm/page_vma_mapped.c:103:25: error: implicit declaration of function '=
huge_ptep_get' [-Wimplicit-function-declaratio]
>   103 |                 ptent =3D huge_ptep_get(pvmw->vma->vm_mm, pvmw->a=
ddress,
>       |                         ^~~~~~~~~~~~~
> make[3]: *** [../scripts/Makefile.build:229: mm/page_vma_mapped.o] Error
>=20
>=20
> Don't have time to look further right now, might have a look after kids
> sleep if nobody beat me to it
>=20
> (No problem on aarch64, build & test passed)

We see this too, in multiple configs:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/162999=
53803

mm/page_vma_mapped.c: In function 'check_pte':
1169
06:52:54
mm/page_vma_mapped.c:103:25: error: implicit declaration of function 'huge_=
ptep_get' [-Werror=3Dimplicit-function-declaration]
1170
06:52:54
  103 |                 ptent =3D huge_ptep_get(pvmw->vma->vm_mm, pvmw->add=
ress,
1171
06:52:54
      |                         ^~~~~~~~~~~~~
1172
06:52:54
  CC      drivers/pci/setup-bus.o

Best regards,
									Pavel

--1NZNXXURmQtKWfJi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaprC/gAKCRAw5/Bqldv6
8t8nAKCRyYL+OhzyTX9fTm0FgdGMngLSGwCgpr2Ipm/StQzZVnE1J5Pjd14gUmM=
=fXOY
-----END PGP SIGNATURE-----

--1NZNXXURmQtKWfJi--
