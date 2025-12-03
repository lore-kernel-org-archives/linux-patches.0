Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6A732D451;
	Wed,  3 Dec 2025 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764787572; cv=none; b=XXE5cvG+9se3OXHhlcx3XzKImugroH9AkfcPeOfVjmsDI2THH5HRmBQhrxleZ+3XeGZFTJM9VQDPnmIm5p6rx3g99CNVf03+MC/kZRcJ02rj20f35jM3r+U/QLi+d3mREShRSimokGLkg+XabYmrN+pbvljz+0SdRaMcqsjdxls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764787572; c=relaxed/simple;
	bh=dlCl0SsztsKcfBO+hHSX/gfE1kfgMM5sjttheDzoGM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMkB+8TgXBwUT/SyKlvVVEe1/mBbcxLAzk/6zINa2z86YdpkL3XIqbQf882rF8XKVbFBmszUJ/bDfIPg+40nNTo/kbMnTkT6Ug7U4JPjJrQAVcg7Uqecj165dFQUfn4w78qp/jV4k1mqM1shgn1Jm7OqpqYhsxqGXvzW3DHR/Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqMtxLu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqMtxLu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6223C4CEF5;
	Wed,  3 Dec 2025 18:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764787572;
	bh=dlCl0SsztsKcfBO+hHSX/gfE1kfgMM5sjttheDzoGM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HqMtxLu6G9dgJyovMQTjgBWWNZ+Rkdigl9GTG5XVCo8kNWk2ls2OYpPRUnWMwBdP9
	 MJfBOIQ41UMl+qZ7xY8mg923z5yS4RygDFbT1NKbgNxetek+OSM4OyDs75m9XNEI3O
	 kH39b8A05k5+w9rP9ufcPyYi81f1p5YmJyBo5neXwiBXJBENBgDtKdnsoFCmbzHiEf
	 cVYEjmAzuuDwO5LKPIlU8ytYkCYzA2rEYnJKIYt8SckP+d151RmhE2yoIy7M3pMCA8
	 nnSNk8UaLlP94Em1fsLm6QjtqICW0KA27E22SWI2jSdw8RTwRn7aNmt3C4j+Vbwefb
	 m8ph04+i0tPMw==
Date: Wed, 3 Dec 2025 18:46:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
Message-ID: <41e4124d-8cb3-44b9-871b-8fa64b54b303@sirena.org.uk>
References: <20251203152414.082328008@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CAbLOMJ2sjhmb1Bh"
Content-Disposition: inline
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
X-Cookie: ASHes to ASHes, DOS to DOS.


--CAbLOMJ2sjhmb1Bh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2025 at 04:22:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm seeing a build failure in the KVM selftests on arm64 with this, due
to dddac591bc98 (tools bitmap: Add missing asm-generic/bitsperlong.h
include):

aarch64-linux-gnu-gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu9
9 -fno-stack-protector -fno-PIE -I../../../../tools/include -I../../../../tools/
arch/arm64/include -I../../../../usr/include/ -Iinclude -I. -Iinclude/aarch64 -I
..   -pthread  -no-pie    dirty_log_perf_test.c /build/stage/build-work/kselftes
t/kvm/libkvm.a  -o /build/stage/build-work/kselftest/kvm/dirty_log_perf_test
In file included from ../../../../tools/include/linux/bitmap.h:6,
                 from dirty_log_perf_test.c:15:
../../../../tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsis
tent word size. Check asm/bitsperlong.h
   14 | #error Inconsistent word size. Check asm/bitsperlong.h
      |  ^~~~~
In file included from ../../../../usr/include/asm-generic/int-ll64.h:12,
                 from ../../../../usr/include/asm-generic/types.h:7,
                 from ../../../../usr/include/asm/types.h:1,
                 from ../../../../tools/include/linux/bitops.h:5,
                 from ../../../../tools/include/linux/bitmap.h:8:
../../../../usr/include/asm/bitsperlong.h:20:9: warning: "__BITS_PER_LONG" redefined
   20 | #define __BITS_PER_LONG 64
      |         ^~~~~~~~~~~~~~~
In file included from ../../../../tools/include/asm-generic/bitsperlong.h:5:
../../../../tools/include/uapi/asm-generic/bitsperlong.h:12:9: note: this is the location of the previous definition
   12 | #define __BITS_PER_LONG 32
      |         ^~~~~~~~~~~~~~~

--CAbLOMJ2sjhmb1Bh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkwhW0ACgkQJNaLcl1U
h9AWJwf/fANM29w9iucATPWzAnz6NnQhfZI6mODbA4M6mu9/us8Ey+2xEgrd76kC
VhvgMVUbLhwiQ5dxef5F/8HzhxFXpqpTKHD3pwXFED79ptP8teuOj2TxfouACIb9
TSBrKsIG7l+ohar/k6VezY3zJ63rJCBy4vIFK0dNQcIaSG9ZfT4ZHYE3trgEE3fz
IE5ncH2ReAT09sMsLgRyD9fnWYIA1+AChkoH3qQyoY8TwNahmJ3+dN1WMBdreMBe
+b1ZjMdVf+MxSI0tavHKNUuu+wxE0IiqXmD9hHDD1Kpv0QrLnUacuju4tehhF8wo
7IFriVt5/zvFIyGe50+kneHyrI2VRg==
=/yWr
-----END PGP SIGNATURE-----

--CAbLOMJ2sjhmb1Bh--
