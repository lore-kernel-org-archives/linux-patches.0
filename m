Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F537331ECC
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 21:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791752871; cv=none; b=QZ4Xxtrlw25KdqpJKcJ4q2l9OUC8W6fJK6t1E4JtKR73zLcQf6WMfb2f+qtSZYfcq979ntcg+q/gbUYjm7wMPIFbL++Uo1qYFznpwNW3eazcoMzCTwH0EKhRDCr7puWlg+XtKe/v6HWYhw3JtTg3YsbvovKDF8ND4gUDL/2++J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791752871; c=relaxed/simple;
	bh=9naaY6un2oQwRJ+nyFCWXBiruXzgMa93PVGUcstbW58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzn8ENCcMyekJWcW0EFOZjnxQb1kWvk9TUwLrMjqtkzpk0Ks/JBEP5uhxl+0CepZyJgfmcRuVPjEAY0wHcNGaH8Nwk3mx20Gi8NRG48sPHid65BxpFQEOEjc2HFB0KF/QTJrZcfMINrd4oOjmJULq3/F502nqn5DtsRDqvouPWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=JRYAg72x; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="JRYAg72x"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B6DDD1070BA;
	Sun, 11 Oct 2026 23:07:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1791752856;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=SAXiL3zjJ/W+XIS9AHQqVwhFCPPlwY0Ky1Lo+aYYbu4=;
	b=JRYAg72x+yLf+6n3O56DyvcJfVcOJr76A393YMUrb1chetfIB6/nGu6/aOJPvyQgfNc6Fm
	BXMdPpRdRcX0cw/UInt6YKIY2XCAMtScNNQsaxwDERS9YqdEJaPc4eWgB5ipLEaE3RMxu7
	xKC+JoD15Y2VIV7hi71DXtDYIVO6jT3k9zQ6J/sH0H4kB1tJXJx8009+UPW6JR8+Thf6+J
	4ooIAIBarA2xEQd0pxyUM0Hl30nz3NTV9srKQWoWiKmodkR1gehuR6DK3vvVDlsWs1S+6K
	Ob4+4PG/rzK1aorHQQFtaobZsSWwTHQ1jnVg2gl4XJeL1rVQkuh0UiXwyjR4cA==
Date: Sun, 11 Oct 2026 23:07:31 +0200
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
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
Message-ID: <asv6k7_kpfE7dfSd@duo.ucw.cz>
References: <20261009140946.008206689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EYzlBsBuIfi4hx90"
Content-Disposition: inline
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--EYzlBsBuIfi4hx90
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.2.10 release.
> There are 428 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.2.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--EYzlBsBuIfi4hx90
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCasv6kwAKCRAw5/Bqldv6
8lGwAJ4iLEHC/0R4r6mHwjG5mVJFIjWwQACeNJD5LJT8rXjnRc4rJDpn4cUmJXs=
=V9Ym
-----END PGP SIGNATURE-----

--EYzlBsBuIfi4hx90--
