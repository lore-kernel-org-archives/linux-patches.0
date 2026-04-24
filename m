Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DA9324B1F
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 19:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059341; cv=none; b=KOt0K13uxIp2zjJPca59ieHtBvlmnnMd+PwTioEkEOC1QYdsatv6HTc0d70J7oF1W6DzjtNBTT9OCP2nMZ7Rfmfzw4m26+9OkGlYKVft/XE+/8yFlIj78iHjys/zEsKHej+nv8OUmNupOYqPVZtvvUbJ1da1qY0ttP12GHklj+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059341; c=relaxed/simple;
	bh=sMKut2BULLAvFjMC7mXpqy0Uuy/fz0XbW2YnlFMpYA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1wUtY9M7n+o2GY0hTPFv5bflMbAhmu4zjb1rKzotD0JPu1FgVIAxiiYljDdgm2wi9GPLR8aMArXM1Yz+FfE6bFTZLjvMWVbq8gfHqJd4A+j/il4QicmfD683JgYUEJpvjnvKK+ZT2ipHcjStDTjqLAXYZ2AdI4ykFlqtOFuIv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=PctFZPB2; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="PctFZPB2"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 222C5114114;
	Fri, 24 Apr 2026 21:35:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1777059331;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=WWkQZOFo4qmcudSVxHbCiiEg8Pr/H0TKc9kL7JDj58o=;
	b=PctFZPB2i0TxsLBGznJKNqjufuhSCBpLEW9g8iCuNA+PgPQpynPGKq/bNKlt+jrqZIaWvI
	yYUGYAsWazHkODJzWGUs63GlbJ8CqtzmJLT3uNWeOWFfqxvEeUEIqq6RK/msuqkMRPexMa
	iW7vTe6RHE5YEkBdbUZyL6jT1LdGN3u01Pr/23XfOxjiBthklT7pf84InOHGnj786rpNgn
	XazFPspYb7wraW6wne3tDPwcTq9frJZJ7wMWU4fRK1dPEhd3il4HxLNYMgbJBwH4eYsXni
	ilAo8tTYRkBnSaf2jijFp7Hz5OOc7mldxYeCcqt7EGf8XQ8G/9rwXhtLVzIOpw==
Date: Fri, 24 Apr 2026 21:35:26 +0200
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
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
Message-ID: <aevF_pV4siyYmVYI@duo.ucw.cz>
References: <20260424132430.006424517@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0uyIeacIJe4qpIG5"
Content-Disposition: inline
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--0uyIeacIJe4qpIG5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.18.y                =20

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--0uyIeacIJe4qpIG5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaevF/gAKCRAw5/Bqldv6
8ko8AJ4nOt4OJxfWenvMkEbXF51GCeaRcACgkdS2SbdT9RLxZj7IByj37DRUq6k=
=2Uga
-----END PGP SIGNATURE-----

--0uyIeacIJe4qpIG5--
