Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9617039061C
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897215; cv=none; b=kys5IDaFNAz8uulrxu6LoiINX1zJnVfynBcRV8OqgxJOjsm/VbhYwFjEppvEqaYDuDEsVY2nWL3fknFR8+3HwIS6yZIp8goA3Nig1Rk/pBinbFhqA4O83NqF4/ayXIT0f5a2BMwr/Y8YfZYpGcNQxKP16XwpBA8o8DpIAH2FGJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897215; c=relaxed/simple;
	bh=oSqzfpW5nTbwNrZBL7FSV+YIsqZvgcikk1ymv71OOVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAHvp2Qu0IaLBB9jbqs3sLNOzSEisjFrDDvJVB1DDGTkBEMh+NQhxGyJ5AmOrvNRvmDjhV5WX4KA5X8gaYzIm+DvX7nXYIuNU92xoc+ALuie8xiKSz4IXz/VGFD8x96ao/0ufGVFZ7loE7bxPtp1sCCtpVdmJx971ebWcoksuVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=CHm+2Tgu; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="CHm+2Tgu"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0339B109293;
	Tue, 13 Oct 2026 15:13:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1791897202;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=iiIT6zWZ/KVEDN/d6m/g5jw3NGQ/LPd5aQ4Ylyijp44=;
	b=CHm+2TguNGzZaoJQpj0YRLONcrZfKddU8CkddpE5j44aKktVRIJ56BVCqELsdw5Pkqz2gl
	nuaTOPQxBUVM+D3/d0jjK7ZJN0SuGQSwhYL4m8nurXhPk8yu0JV8+Z/TXYCfep6wP2UfE8
	T4p4fr/uA9PNL4I0sWAHFkyWBmdiNUpFVJ+uJ774bNVQMvdti7kxhP1ZVlcqbK1KYLo6Zg
	htG77n/+jJhNmRzSTgZbTUTDNUVvxprphp4lmR6ZUhqhOV9XgLxlpXhUec7sZvMLCGPSR8
	gpOFRf1FpdgQd7yXrBEmGO7HMUfiZGOgljK66aDL2ztNhAe8Ljh52NLfJM2ntQ==
Date: Tue, 13 Oct 2026 15:13:17 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/621] 6.18.57-rc1 review
Message-ID: <as4ubep0jWRi-b2G@duo.ucw.cz>
References: <20261013112920.855194808@linuxfoundation.org>
 <as4kGIjqjrKzu0O0@auntie.librecast.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b/mMEdGYDAzhgiIm"
Content-Disposition: inline
In-Reply-To: <as4kGIjqjrKzu0O0@auntie.librecast.net>
X-Last-TLS-Session-Version: TLSv1.3


--b/mMEdGYDAzhgiIm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2026-10-13 12:29:12, Brett A C Sheffield wrote:
> On 2026-10-13 13:29, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.57 release.
> > There are 621 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> > Anything received after that time might be too late.
>=20
> Build failing on amd64:
>=20
> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gs=
s_krb5_get_mic_v2':
> (.text+0xfc2762): undefined reference to `crypto_krb5_get_mic'
> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gs=
s_krb5_verify_mic_v2':
> (.text+0xfc293a): undefined reference to `crypto_krb5_verify_mic'
> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gs=
s_krb5_aead_encrypt':
> (.text+0xfc47a1): undefined reference to `crypto_krb5_encrypt'
> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gs=
s_krb5_aead_decrypt':
> (.text+0xfc48f8): undefined reference to `crypto_krb5_decrypt'
> make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 1
> make[1]: *** [/usr/src/linux-stable-rc/Makefile:1272: vmlinux] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
>=20

We see same problem here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/171391=
16508

Best regards,
									Pavel

--b/mMEdGYDAzhgiIm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCas4ubQAKCRAw5/Bqldv6
8tCHAJ9F+IraIEYRLM/Shea1iZp/uEN8kQCfQxo9tfvh4Hyp3szwrr1JCyZqRa4=
=duju
-----END PGP SIGNATURE-----

--b/mMEdGYDAzhgiIm--
