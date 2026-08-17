Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AB237AA6A
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 17:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786989474; cv=none; b=FYl1CHMsNgSPiViQRbxGp7Hk+7MKZ1W5lYYVi3wMATHbrbQyAG67hI/1xyVSDL4Yk+nZvMlb/ezGcNyC/ZPYpBjZWXk8JBIfCXnN1wom/D9asMb4wehWGt2vofDKTsGtAn46YYHj1naZw4mJCPpMe3Pnfw9UrtHVlrsivljJQtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786989474; c=relaxed/simple;
	bh=1nvJNOjfOrNCDNTjtMTpapI8YP+pS7CDrG3Kx4oWVlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Msvqrlh9cZKLQG1h3ast/bylyvc0PnpPuytlgHSybdeTdMVpzh2djGEcjbQ/oGIErBML0JOdnDDWeJKUm6FHZjcMWDR+QEuuHqQxrRiz1I+ORvD0pOh8sNESsJZjqSxMglHB8RSzpF1ZtPWgFa/ygRElfTpwF4vJ15YNK6X2Wf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=g+0m+1nW; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="g+0m+1nW"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3BD5111C2C2;
	Mon, 17 Aug 2026 19:57:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786989466;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=q70I9pCUSMR1roxCaId9SL38wwG1om92IAed6nG3nek=;
	b=g+0m+1nW+/bP4jhbmn0Ek8X1nRndGqsn6TlzB6W0Je+4SFrMkONyJ7rIObMVN6UH+aOdCz
	V11V7zyyxcW7WwaM8iSN5XehwfX2DAA4ktcHD4VlNPhpczGKKGWwcDaUpl3iqgGCFqrHzE
	uUWIA534JO67TnG/5ejovGzg1nsHqYZsTin6J1c2tx74M3t45xvCsQML1Kw+buNHOrOEfR
	RbKYB9oQGsyP7OEMI2POx6uWz1Wsyh6xQtbhDe41Nj1tkjC+AvqUQX4WS2rSl2SfO/4XgQ
	DBR/rktoYG7VHkEz+966l9KENDS1qWjU2GJdoW5C2w6Gfk+psukTZnZsnJ2yCQ==
Date: Mon, 17 Aug 2026 19:57:45 +0200
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
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
Message-ID: <aoNLmYsCjQ-4801M@duo.ucw.cz>
References: <20260817132536.752504388@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bQSFx4AgSKHYKCZ6"
Content-Disposition: inline
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--bQSFx4AgSKHYKCZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--bQSFx4AgSKHYKCZ6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaoNLmQAKCRAw5/Bqldv6
8s8UAJ4sEJbuYvLXOrkmadh0OLXGJPcUDACfb1WYrHqVH4dueJQHmv7bBjaZ0Is=
=3x9U
-----END PGP SIGNATURE-----

--bQSFx4AgSKHYKCZ6--
