Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A3C192B83;
	Tue, 20 Aug 2024 14:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724165035; cv=none; b=rnH/ioEp6gptKjnXBYyQpEwCLvailIplXZfCi4kFaudcVAXXSRGLAfCxV/vzxpcnrrRoyPk+oN7XvecJjxXhNxvf/qprwy6YZn35u13+AoW2uaP6JLa12AKOQKUnDkytAm19AfXCqT53+NpuVHIUe6SSqV7Er0I+sMg0PXLFuZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724165035; c=relaxed/simple;
	bh=W7ZCCtqep2N7YC84maFuRBR9W86xcb4AH8v0dpyHReY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H42yMD3B1e1ZT8IWW9Qm6XlxeXO+3IDv6hAGeflWhZjh0dhmo93AflxXuvhdPtEtJepa4Tsu50MKUicRT/+Z1EKfWrJbgvzciKmVBA4eONui+9x7kszf2FFFgAl8F0+OXvIfvfj+A7cNbnwiiEAPWEN0BnJA0Bqa1od2tz4D4m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3JD8ob4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3JD8ob4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AE0C4AF0B;
	Tue, 20 Aug 2024 14:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724165034;
	bh=W7ZCCtqep2N7YC84maFuRBR9W86xcb4AH8v0dpyHReY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d3JD8ob4MFmPvROFWu7vomdTt+bpkgPEBjVHYFCugq+o29YVB5yuKcb7kVUXO/sFU
	 WPbweC5GTT0Vo/r3ac/F3TiRl79x+U7fn8nGMW+jRb9uItHUq79ox1zMuCws7IcfVK
	 Y1KuN1eQGEY8Qky4IdSiivliWdiJ17tiHpFetmqB+V9rnpQg598RQOuQE7YG2GLSK3
	 wVxqhtaCD9CluazTHG1KD3hiDHGYaG7kXSYDEjPlD60Pk0XiS3lzMH+fsdB0tfRXsa
	 BZIaDl8xsn0UwxMNM+b4EHe8lh1zVXDtTlbUwj/7hvi9EF2cqwWi5RVtgwib0kf1l8
	 lmBmUQZBW1uUg==
Date: Tue, 20 Aug 2024 15:43:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/479] 5.15.165-rc3 review
Message-ID: <1c83d94d-1b56-4bd9-8a96-c5062c238c06@sirena.org.uk>
References: <20240817075228.220424500@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PfIcW7SysGFheIkL"
Content-Disposition: inline
In-Reply-To: <20240817075228.220424500@linuxfoundation.org>
X-Cookie: You are false data.


--PfIcW7SysGFheIkL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 17, 2024 at 10:00:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 479 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This breaks the build of at least the KVM selftests on arm64 for me:

In file included from dirty_log_test.c:15:
=2E./../../../tools/include/linux/bitmap.h: In function =E2=80=98bitmap_zer=
o=E2=80=99:
=2E./../../../tools/include/linux/bitmap.h:33:34: warning: implicit declara=
tion of
 function =E2=80=98ALIGN=E2=80=99 [-Wimplicit-function-declaration]
   33 | #define bitmap_size(nbits)      (ALIGN(nbits, BITS_PER_LONG) / BITS=
_PER_
BYTE)
      |                                  ^~~~~
=2E./../../../tools/include/linux/bitmap.h:40:32: note: in expansion of mac=
ro =E2=80=98bit
map_size=E2=80=99
   40 |                 memset(dst, 0, bitmap_size(nbits));
      |                                ^~~~~~~~~~~
/usr/bin/ld: /tmp/cc4JPVlx.o: in function `bitmap_alloc':
/build/stage/linux/tools/testing/selftests/kvm/../../../../tools/include/li=
nux/b
itmap.h:126: undefined reference to `ALIGN'
/usr/bin/ld: /build/stage/linux/tools/testing/selftests/kvm/../../../../too=
ls/in
clude/linux/bitmap.h:126: undefined reference to `ALIGN'
collect2: error: ld returned 1 exit status

This bisects down to:

9853a5bed65d507048dbe772bb84e6f905b772a3 is the first bad commit
commit 9853a5bed65d507048dbe772bb84e6f905b772a3
Author: Alexander Lobakin <aleksander.lobakin@intel.com>
Date:   Wed Mar 27 16:23:49 2024 +0100

    bitmap: introduce generic optimized bitmap_size()
   =20
    commit a37fbe666c016fd89e4460d0ebfcea05baba46dc upstream.

A similar issue appears to affect at least the 5.10 -rc.

--PfIcW7SysGFheIkL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbEq6AACgkQJNaLcl1U
h9BewQf/UoUrlE9AVYbakAIiMPXctHgee/yuja880P8DisjuiAd0s5VWr3sLfQc/
QYm7Y/xQwso2hl1e8+8MvTUL0/EPVwSRYGTvhHvPFP/qIN/mUe/ED8Kyzh7xNay+
PfOqs/PyPzIoLGmkzAHfhB4nl3LrBqkl4cRqrJlXA3K4mY72esYHgU9Vpmc4k5I0
lAKCW2eSNaGeqCrOC0oq3PTQjj2rsdHmie4CCe7tH+UT2+5LLXHPMjlFuXtrvK3I
twUZG0hD9Ylnl8TI87QtO6A7JnyMiVrvfdEpGthlLiAmhCH4fGUhK++XzZ20HQMR
iFykVdY8WTr7bv2pfQC5cLAmzEJ2hA==
=9GlQ
-----END PGP SIGNATURE-----

--PfIcW7SysGFheIkL--
