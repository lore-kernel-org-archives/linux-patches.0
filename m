Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57AB38F249
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 20:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784319725; cv=none; b=trvZ8+DeSRPAuo1DLhK23XVIHNteFK/FQTYHBgzKfOupwyK4LpPDiQNtR/pQD0LGWmME2HA1zFItOnfxj54of1vAFf9Go8ik28JTj9vzG+GkVxtd8tR2gDmKItG7K+SyDE/qc7+HucCvDOAmQ7FPEk4zxFxfk+KzudjU66/ZQj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784319725; c=relaxed/simple;
	bh=ene3ossYpWLoNNAxhXW07PeSoYoHGOav73X3mBdjRYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuyQXPg2WJTVXK0ldzz8lzSmxH+SqcvCoFpr5sfFDzMwtbTubK4wCzirFFhH4mZa2fm3MIqZoNWf1lmAxq36iNDjSpoTROdCegE1Mp5QyMkbfq+J3EZTOdIc4+vEkfM0UGG6b4jZtpiI/z+YLYamwYtbi7ZRCndDxbwYlj7GBpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ZEoL+a96; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ZEoL+a96"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B6109119DBB;
	Fri, 17 Jul 2026 22:22:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784319721;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=FvI8hQcETezgMYz7EVvImW4DXJUpxT+wZplHHMekyuM=;
	b=ZEoL+a96FJPgzYGUc1QSAsfR11Sz9ZTE+1+WuXY4EXZsUItZ2l2Q38SHB2ubfXIl790K2o
	j1EbAwZES9xGiPSlo2Z9kGydIHcHi5ReSi3wkKms6ZTGVlFU5GR+zrH9lrOUdurlsG+D1L
	6ZVyuur8HuOncGpwF9QEnoNX2emFT62WTwl/jsvYRS2YquCs7sIQ1kceU7Bea/DbZC5xIs
	mPIW9WrZwoXjRPS+JgWDqgwR69CnWOFR1Pi+5rtfNxtlLJ/qH4q7s7rExOJeVVwh2RdQd4
	ZxSBzNjeTl050dQG0sjAOjnL2RowFa/bRqfkOqeqIac1pJX+m8cU1wgZRuNvhg==
Date: Fri, 17 Jul 2026 22:21:59 +0200
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
Subject: Re: [PATCH 6.12 000/357] 6.12.96-rc2 review
Message-ID: <alqO513njzmY6UAi@duo.ucw.cz>
References: <20260717101823.379399592@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fIeVAr3++FFYMJm+"
Content-Disposition: inline
In-Reply-To: <20260717101823.379399592@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--fIeVAr3++FFYMJm+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.96 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--fIeVAr3++FFYMJm+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCalqO5wAKCRAw5/Bqldv6
8nPcAJ9U9ICbucrPWXpKh0VlQhvGooDmNQCgt36Yw/6hWnEzp7DtcnjOv1EMwFA=
=RJGB
-----END PGP SIGNATURE-----

--fIeVAr3++FFYMJm+--
