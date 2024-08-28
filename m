Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBA816C857;
	Wed, 28 Aug 2024 11:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724845270; cv=none; b=s5smK6drvU3PWCj+//DSBTtYyuZnU/vxD2uC/DOHifgVhQn65r9ndBnQ02C4k67cVVVRmvfJrBP21xpkjCOs0o+TVRh+0KzF/bdNTFCQoXbt9Rb8LAUPJpcN9W223ZAh5GymxBN1YZ5Ja/u+npzERnEoNYRvq4zgGpPWH63UQDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724845270; c=relaxed/simple;
	bh=sA09cTgbVMRdDOVHDj1h10nyAt2IBd0xNvrNb7mM+AU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxYkmNjLTge7G/TIr2MsqpkLXFHSsfpOpvYVZVdnOMz4WjdPpKeqAi97Z26RAd+Piv/xWCQnA3kCGj0wHKpgBPg8O578ShqbKhlPI0j2YaeHrVOTnf/rMLXXn2OQHnwPKOfTb5vfne2i8uSmGGlQXa0LKk1sqU4QOCENz8avLlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQKfrbpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQKfrbpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB25C4DE18;
	Wed, 28 Aug 2024 11:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724845270;
	bh=sA09cTgbVMRdDOVHDj1h10nyAt2IBd0xNvrNb7mM+AU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UQKfrbpE7wb/SazkTF+0vVgctMUKZajHmG16dACWPHkoWkzJpiuYUTusrmpV7FBzR
	 gEA1xCOU9sE3wM8qf2sqSztZL1yMFlsbv+vhJRWuTGnQaifnUNovFUU2bWZn74Txue
	 K1KI1OFcpE+HkmaFn9iU3SraO5t0VhUGRhmATWAUPHeS+fOLszZHnqDPgEHp2JjT5E
	 56yzhuqWNFvJLv+K1tPgABZZUfVFh5iMAHKPAQvVuSewil3iJv8RN+3kZvVbd1Ysup
	 8g4vAUMnocgpm9bpW91dkn+oBzo7q8SVOw/ryHYRUM0O58nTey4zig4nOb4V98KiJX
	 4kVuMQukvLG2w==
Date: Wed, 28 Aug 2024 12:41:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
Message-ID: <8bc449eb-c9c4-420c-bf98-d909311b55ff@sirena.org.uk>
References: <20240827143843.399359062@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1FFMRptj4rBabd61"
Content-Disposition: inline
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
X-Cookie: You are number 6!  Who is number one?


--1FFMRptj4rBabd61
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 04:33:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

As others have reported the ALGIN macro is still broken, it affects the
KVM selftests on at least arm64 too:

In file included from lib/memstress.c:8:
/build/stage/linux/tools/testing/selftests/../../../tools/include/linux/bit=
map.h
: In function =E2=80=98bitmap_zero=E2=80=99:
/build/stage/linux/tools/testing/selftests/../../../tools/include/linux/bit=
map.h:28:34: warning: implicit declaration of function =E2=80=98ALIGN=E2=80=
=99 [-Wimplicit-function-declaration]
   28 | #define bitmap_size(nbits)      (ALIGN(nbits, BITS_PER_LONG) / BITS=
_PER_BYTE)
      |                                  ^~~~~
/build/stage/linux/tools/testing/selftests/../../../tools/include/linux/bit=
map.h:35:32: note: in expansion of macro =E2=80=98bitmap_size=E2=80=99
   35 |                 memset(dst, 0, bitmap_size(nbits));
      |                                ^~~~~~~~~~~
At top level:
cc1: note: unrecognized command-line option =E2=80=98-Wno-gnu-variable-size=
d-type-not-at-end=E2=80=99 may have been intended to silence earlier diagno=
stics

--1FFMRptj4rBabd61
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbPDM8ACgkQJNaLcl1U
h9DXDQf6ArrOGAkHsi7D8UCgnq7pX2qwA5PfxgVdbe4nwEzFOTvvJ6jSZU2m8Yet
ppuA3W4SIjzERZb+zJZY9b3I65nXfN2ET0UZyr65kryAUD4U72n+MrxahIwLj1jp
rZMfB/MY7DBWvEDnmp4VZRGrC+Fy1nfjOhXdDR0KplKvN2iCvtM5GJHdyalwHvMb
a9HSixDxZ0RVLIp4ZxBp2RCNePwUpU4mxYm2nhmQLEyPUeEnIt77m7Zan2pV0w+n
exz1qMMRTK1DbzC/f2M/bKvVWyKBlaHRRnv2Fb8wWriHXMmDV0cDJ5vl5B9B8aur
5A4HuYC3TuFi/B3/1Co0IV7sLJld1A==
=6mBj
-----END PGP SIGNATURE-----

--1FFMRptj4rBabd61--
