Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F4670807
	for <patches@lists.linux.dev>; Wed, 14 May 2025 18:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747247445; cv=none; b=RTd8ne6zPP/LnrwKeTCvT7IAyJlvI4C0dLAGSc8jkqBWAXAw0r8HabcVchVkZfKViBnLVjlBvnfOIQj71/NLID7m3rHasKCbDvmssFzjGf6wtzsibs07NRRIPuOm1K5VZI8VMcVLwW2Fz1M0zj0xtdjldVBjmTQf9B882xgaCVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747247445; c=relaxed/simple;
	bh=pSGW7o8RmgVXrLWoJVEtzwXBi8/aCvFu/6yaeM8lTRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1EesMR3apHBjJqjhz1uX/uZQnkEZWafoySH8FkOb00lezvcGmX6ElRSZDGSZ2nbsf6D+mcIBNQVy9YJPGtwD2CX+cBW6UyeXEWYvuDrF/O3N152avxeO0j8cbRf1+hUnpSGY4cQQ1ha26ds7LreHXGvnJVT4NZW1CzUoGDmwTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=UM0iiqCu; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="UM0iiqCu"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0CCD010397294;
	Wed, 14 May 2025 20:30:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1747247434; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=osL0bZFOeaJv8bBxeSyMxOdWP8kKDBIobUjea/j1DHQ=;
	b=UM0iiqCu2TvrbQolfB7lFjvPbH5EYlQ0mM4Ku/rFzEJAl/oseGdgPWGy0vVGHJxbf9h0YH
	nKlitRU9fpyS1RUNavigGeWX0omS1Wx++dPPMAnzxAFpmB0nzS/40+Ri9cUuUDvhSwzme1
	HkisTaCN+6kuo9w85xFubUhmCagfyDnZRRKnnZw7Kg05iOCQlpiCbtcWWOCSMhM7O+hX11
	nlM1Woe7OIYD0ZIF5rDJ/jo9ELynKI9O9C9uPzkgQYNYhnKqOphetMwRx/oZrxWzkB3Ha1
	5hkHfoguJnvplt6YkXbCUcO6S4EncomiURVioXcRSQoiRo4mTVRQQreW9NG3Kw==
Date: Wed, 14 May 2025 20:30:26 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/96] 6.1.139-rc2 review
Message-ID: <aCThQmLufsIn4ScI@duo.ucw.cz>
References: <20250514125614.705014741@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7FoK957au6Jh/RDf"
Content-Disposition: inline
In-Reply-To: <20250514125614.705014741@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--7FoK957au6Jh/RDf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.139 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I still see problems on x86:

  CC      init/version-timestamp.o
2609
  LD      .tmp_vmlinux.kallsyms1
2610
x86_64-linux-gnu-ld: arch/x86/kernel/alternative.o: in function `apply_retp=
olines':
2611
alternative.c:(.init.text+0xa09): undefined reference to `module_alloc'
2612
make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
2613
make: *** [Makefile:1258: vmlinux] Error 2
2614

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/100351=
17383
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
817477509

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7FoK957au6Jh/RDf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaCThQgAKCRAw5/Bqldv6
8qaKAKC8Q1P9aop1NdhDQQbrIrb5PJ9z+wCeOhrDa0g208SE2giU03n8m3GYpx0=
=bkqE
-----END PGP SIGNATURE-----

--7FoK957au6Jh/RDf--
