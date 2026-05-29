Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5649133F5B0
	for <patches@lists.linux.dev>; Fri, 29 May 2026 08:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043260; cv=none; b=dh9C+uBA54BYd7m4OI1izJ9Ltece4mRSrH7N+bQiUo+yPNHzqWxI+502PVpJTwYIEFpgSPYyJfQyRKRD9wDJNIbGx9UUk7XQLTXnP+xEOdpZBLFYezsVNRQCnEMzX5hPNaaLst829LsycuOo+eB6FySw/gXvSieN8dyLCiMIF8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043260; c=relaxed/simple;
	bh=eZPDRrZAgAZYw9/zdoO76/s8Sls3KbvKcVi/azdKSxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEGUFKIrF5DTfGWQ81xEpMqfchZivP0LadJfyKKs6UnLXDLg+A5sT6ewDPI4lvEXU7EVj0yBt2glZdTxEy9JxhCXaEqjRqPGwyiXLBhG4jsut8pno6/Yhy7+R5bP03r79l8okQoW34uLDFUrxMhc2YymTaa16SBMK7zAR6dlKHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=Q6Hu6kin; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="Q6Hu6kin"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5A4A4115799;
	Fri, 29 May 2026 10:27:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1780043250;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Fu92N19MSffikCHEnPXV/E3bF4MY+txwWr/Oeyobw34=;
	b=Q6Hu6kinkDiAJ72zL1foun0PD/4q8U0n2Gay/Iv1O24yVU17QsfzVtdk84sDz+j/0dUS/r
	o40ErHYVDdVVBksPG0WPsMO4YTbDqyUyRtm+qKK8bRM1gS9hVb35HzzRvV7IFw8QYYB/7x
	IIXoUodLwc0SPbkd8RX6rojZeULYYrQ0UaqbVzVgNEKzO2L4YVtLJ905jtzPLwi1KkR+01
	Zj9qeRCMUZyXqn2LJzjqIbkgLHTR3Psw71klSrXSu3Yi9PLVaAu1n5LM6Zz2vHTQC+8qLC
	9qdcemGmaUNsbL+v6MuRk9CScreFL1qP3Pi8bwHAm6jWStayQM066fFPM9Tm6g==
Date: Fri, 29 May 2026 10:27:21 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
Message-ID: <ahlN6TPTgMwBT9_d@duo.ucw.cz>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260529060918.123155-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VCB5S51KOtzjewLJ"
Content-Disposition: inline
In-Reply-To: <20260529060918.123155-1-ojeda@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3


--VCB5S51KOtzjewLJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 6.12.92 release.
> > There are 272 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 30 May 2026 19:45:52 +0000.
> > Anything received after that time might be too late.
>=20
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64:
>=20
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
>=20
> I am seeing:
>=20
>     In file included from kernel/trace/blktrace.c:23:
>     In file included from kernel/trace/../../block/blk.h:5:
>     ./include/linux/bio-integrity.h:101:12: error: unused function 'bio_i=
ntegrity_map_user' [-Werror,-Wunused-function]
>       101 | static int bio_integrity_map_user(struct bio *bio, struct iov=
_iter *iter)
>           |            ^~~~~~~~~~~~~~~~~~~~~~
>=20

We see that, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/145923=
68004

We don't see the problem on 6.6, 6.18 or 7.0-stable.

Best regards,
									Pavel

--VCB5S51KOtzjewLJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCahlN6QAKCRAw5/Bqldv6
8nWmAJ9tSP7O4fleRuae2Fh0Zjw9Ju2vZACgkFoGeiljJKAhNQxf2xUT4hhpQSk=
=zhks
-----END PGP SIGNATURE-----

--VCB5S51KOtzjewLJ--
