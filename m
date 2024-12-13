Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699061A8F85;
	Fri, 13 Dec 2024 13:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734096210; cv=none; b=lADCWUqb29xh4pBfSE8ElJUg8To6/Z0C+7l/31nOrnbA5PBQCVjGsK9ICaYxLJJ4sBLyeEREx5N8ImgODjMHejQ7fCJlJBWiwpPgn+If24fuEGe/08TtDp0ZxPAJNtOuQNl6cRT+/bix9u/XR/I/j+W6dD7E0fg1xsxne+ry0IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734096210; c=relaxed/simple;
	bh=F2JHZ3ZqREJM7UXkBh6hU0VBtuNOKKvDI50ITAB9R1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oqi9GoHQ/QMs1AHmWFThwFcwIw+DscCAO0o5zkfmIywErzjunJx3WHjZGI+12lTWvRIQNES4r7z+YpQMS12okw5FIM/zW16MhIe9GUtSKW5ddqI181av8hNzv8v0RZPc+FTV3ymQTjQIs5SGiagsNl+soEKHu1FZMlDsbB5+TWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVWAvOsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVWAvOsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FAAC4CED0;
	Fri, 13 Dec 2024 13:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734096209;
	bh=F2JHZ3ZqREJM7UXkBh6hU0VBtuNOKKvDI50ITAB9R1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVWAvOsfrn+z5H+to4WP9x9cFnYLmbokzusYjkzOMe/w4ztkBy5yWwMhSSRAK7VoL
	 R12dTOc80iw7z8YVnq3grv69rHtDx06XxAzGxyq+bfQtaymF/CVqeUdsgxuLdsf2xr
	 1ByZEN3uyZXTVjOP+w5vcRSy64QbG7QD0UvJF7inpFsVjVp1G66Fxt1QMCthEgxmB0
	 LTGtRN3IjOaJO44PBV+k99x4ujwkSi6UWg6zmLLk8o2FblQ03zGHxHXX+VQesQIBOC
	 FOSFW9oRoFnsW0sF3k2P3NLkwFoZoKX+aDW7ZlK8mDGmMyQq61q4xP5RL1rgx+ZVy1
	 kV3u6kiY7oA5w==
Date: Fri, 13 Dec 2024 13:23:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.4 000/321] 5.4.287-rc1 review
Message-ID: <975004ea-7eb0-4412-a9af-d10486df4bb7@sirena.org.uk>
References: <20241212144229.291682835@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oDESnGT8e7eMbJCA"
Content-Disposition: inline
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
X-Cookie: Not for human consumption.


--oDESnGT8e7eMbJCA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2024 at 03:58:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.287 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

arm64 defconfig is failing to build with GCC 13 for me:

/build/stage/linux/arch/arm64/include/asm/memory.h: In function =E2=80=98__=
tag_set=E2=80=99:
/build/stage/linux/arch/arm64/include/asm/memory.h:238:22: warning: cast fr=
om po
inter to integer of different size [-Wpointer-to-int-cast]
  238 |         u64 __addr =3D (u64)addr & ~__tag_shifted(0xff);
      |                      ^
/tmp/ccGiqYDV.s: Assembler messages:
/tmp/ccGiqYDV.s:129: Error: invalid barrier type -- `dmb ishld'
/tmp/ccGiqYDV.s:234: Error: invalid barrier type -- `dmb ishld'
/tmp/ccGiqYDV.s:510: Error: invalid barrier type -- `dmb ishld'
/tmp/ccGiqYDV.s:537: Error: invalid barrier type -- `dmb ishld'
/tmp/ccGiqYDV.s:1132: Error: invalid barrier type -- `dmb ishld'
/tmp/ccGiqYDV.s:1216: Error: invalid barrier type -- `dmb ishld'
make[2]: *** [/build/stage/linux/arch/arm64/kernel/vdso32/Makefile:166: arc=
h/arm64/kernel/vdso32/vgettimeofday.o] Error 1

I'm also seeing the 32 bit arm build errors Naresh reported.

--oDESnGT8e7eMbJCA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdcNUsACgkQJNaLcl1U
h9AOsgf/YS8f5nY+l2SezJL+QnB5q1p4weA59U3RTuK0voyyziv1T4Lz7TEzR34B
XXYVs3sneahX70nGRUJKqo/wgAoqA1tv8T7etcGfRSLDLMlCaT6W+CL1ZrzmemIN
hBS6tYgnpECLd1xxf6WxNIAdpwoouTZwRQ5J0Rm79KvG4q37HtJGqQ3Jlu0wtXjU
YMIYvnZBwm2atoEJxOExQw0THqNWT0NMqoW2lMCkq1wkeqDj5PQIayWluSN3JphJ
oo7CUClZrXOiGudD4HHADPmXrQaMBSeqip2j9fSUH7xXy2IEdmFWF1mbipLM3Adb
nEQXi0MKiYrnjAVgekMRVZlRt8i30w==
=9361
-----END PGP SIGNATURE-----

--oDESnGT8e7eMbJCA--
