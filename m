Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749122820C5;
	Wed, 18 Jun 2025 11:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750247887; cv=none; b=bNTbYJ264zqv5NJMbZcGj2ghbokhLn/rdT5Xh9sNG6MioVJ3tv8I2v+pXxAvsTxSSe7wet8UBJejhz9+NcVVCfuv4i0FZhAcA62G0h4ioprdS20vTXdR1aWJ/ach1IKa56ndkh1U/Yj5fn49tP/w5YVTCAUrkPxNZav0etmY3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750247887; c=relaxed/simple;
	bh=6zxqJ03sGm1UOu0tkuzgnOGXarWDitWIqwPWPQ4+ceo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOP7pK91pNjJ0ZfNpF0p9NV2SgidzyBKPIdVeg3Y44RCwb0ImTd8Ovx2fXGjJ5PE8zlSpH/VM9uh35onja/UeIkCIKUmNU1pumB3pbMLyTcpjfk3aIyeJFVOKtxql+ut9FeICMKjwQyd2z8dS3yWw1eIZgVOPEEbSRKX/ixn00U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHsJBYN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHsJBYN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE1EC4CEE7;
	Wed, 18 Jun 2025 11:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750247887;
	bh=6zxqJ03sGm1UOu0tkuzgnOGXarWDitWIqwPWPQ4+ceo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jHsJBYN2Z0UnGW0uAjnq5o8lP1xY9C6l3o3qn/v/s1bb1z4WARPnm4W+jJbfxngE0
	 Ty/uTk6VtpAWuvf67m76zDXKN5qVgNZ7gZnB4xP3nxC2O2KkzH7AJKTUF9v2LkcBqY
	 J8AGEmZDXyzAfhrHk+hR+sFhGsMqiaOkqeS8CqFMrD0+tinBWtKWeIeCiVxoQAwpNl
	 XedmJT1/4F77Fgl+EekHzZi6K19D8/4wDpyc9/3sBIWejZCL/wxAuZyJ/nIB6Shi5K
	 xXnYQ9kCGmFPYv2SOWUWKhLYT1vUx6ngIjB4QajdVPNPgEeDGT7EmCKoX5HMbNovFu
	 WnBsTK6UdFEbg==
Date: Wed, 18 Jun 2025 12:58:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <cc048abb-fbc0-4a79-b78a-90bfa3f8446d@sirena.org.uk>
References: <20250617152451.485330293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RMlmF4XGeDLp3q1s"
Content-Disposition: inline
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
X-Cookie: This bag is recyclable.


--RMlmF4XGeDLp3q1s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 05:15:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This breaks the build of the arm64 selftests due to a change in nolibc,
it appears that "tools/nolibc: properly align dirent buffer" is missing
some dependency:

aarch64-linux-gnu-gcc -fno-asynchronous-unwind-tables -fno-ident -s -Os -no=
stdlib \
	-include ../../../../include/nolibc/nolibc.h -I../..\
	-static -ffreestanding -Wall za-fork.c /build/stage/build-work/kselftest/a=
rm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fork
In file included from ./../../../../include/nolibc/nolibc.h:107,
                 from <command-line>:
=2E/../../../../include/nolibc/dirent.h: In function =E2=80=98readdir_r=E2=
=80=99:
=2E/../../../../include/nolibc/dirent.h:62:64: error: expected =E2=80=98=3D=
=E2=80=99, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 =
or =E2=80=98__attribute__=E2=80=99 before =E2=80=98__nolibc_aligned_as=E2=
=80=99
   62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __no=
libc_aligned_as(struct linux_dirent64);
      |                                                                ^~~~=
~~~~~~~~~~~~~~~
=2E/../../../../include/nolibc/dirent.h:62:64: error: implicit declaration =
of function =E2=80=98__nolibc_aligned_as=E2=80=99 [-Wimplicit-function-decl=
aration]
=2E/../../../../include/nolibc/dirent.h:62:84: error: expected expression b=
efore =E2=80=98struct=E2=80=99
   62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __no=
libc_aligned_as(struct linux_dirent64);
      |                                                                    =
                ^~~~~~
=2E/../../../../include/nolibc/dirent.h:63:47: error: =E2=80=98buf=E2=80=99=
 undeclared (first use in this function)
   63 |         struct linux_dirent64 *ldir =3D (void *)buf;
      |                                               ^~~
=2E/../../../../include/nolibc/dirent.h:63:47: note: each undeclared identi=
fier is reported only once for each function it appears in

--RMlmF4XGeDLp3q1s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhSqccACgkQJNaLcl1U
h9AdtQf7BYcKrhzH6wbxKoT5RMQq05tiI2iUaA3k99PUHTrwhg8f+RaCj4PrEkTb
xlqJPEc3Dr3UNmcZAdLDjBzM8rYjiEKPPc23kMJ6IjnuIgmlHtGbygKHfm9mZTDF
VdehE6YThJlA3I5PVpTldS1rDKzgFidSND/J442MCtnteUVpvLy85hPj+5piQhFs
jdzKpsuWG+LDLH6ZtwPvrxCKsKFmwcqlBjtrdR9VLocCxAOkiKdLtmKpHqInoOEf
KT49DBiERBD0+nes9UpUw+Fq58Mt00qdYnAxoqBeEopWUxB2jC21XprMdVPm54Lx
6O6HK3+hHACcnPQhE7ckAmtrPmnSzg==
=xR7l
-----END PGP SIGNATURE-----

--RMlmF4XGeDLp3q1s--
