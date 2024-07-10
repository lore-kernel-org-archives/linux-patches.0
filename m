Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F64191F70;
	Wed, 10 Jul 2024 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720616702; cv=none; b=takgrk/Jw3ZTGnFhx/3R8E6IkXlSn4LmQ8cjEZ8JpRuMNdboorK2b8VVojOHQQH5ZC7KcfaZBuPbFfjoVXoQbiq3XjCUC4qRl0CxuUPczT3Do25vbZP1YF2sepWeFVIVmj9pKWxpi7WWqvJaxXshAUhckVPkqOWQ6DExBxgJazk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720616702; c=relaxed/simple;
	bh=t39MmqwSPaxrZuPTDtESZrs/I/TqlSQHH2rexBiE5uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxG0mx41EmVkgSnk9CY5jWpbGgQRXcfv5/wFB7fjF2W2OerqLzDnwt45F8fStExkl123/ktnpjY/Oh7JjBaic3ZDuusd5DbtrZ1uAl8Vn3oZ/T1MJqPe6v8Nw2rzaI6B1sRCOGlty/t5k/ykmID8Cg7lvOJeMZbUK9bUX1RLF6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFe895Wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFe895Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A31DC32781;
	Wed, 10 Jul 2024 13:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720616701;
	bh=t39MmqwSPaxrZuPTDtESZrs/I/TqlSQHH2rexBiE5uU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YFe895WtRUX9zFbWxG6cn58NS6JBTJvPfw/+5fJi1Bl+56gkLPVhVJEWEPBUjPL3U
	 GA0xxc/Yg05QHNHXIcEp3r3m5/L+gae3EEpw4TBTbyLab133Z77jRLGsygGMoypDyB
	 zCDkZTmMLi2oP3lf2dAk6McQTG2ezHXBGKr+b4aKwqX0rWlYFVopJ7nF/Zyf3jDHui
	 g/RvEIcOCKg0760T3ZBPpv2uxPMWUt4xbuwkvetKsGexMuAIfR9Nde5eWsQR2sDf2G
	 P8jO5lMVEqXbHbSSDvzysNHVUarwsalpD6VKzQ9eeAezyiZjbbJWcV7hXefHHXcION
	 5jx3MBeOPMt1w==
Date: Wed, 10 Jul 2024 14:04:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
Message-ID: <Zo6G9C-AzU2jBrOt@finisterre.sirena.org.uk>
References: <20240709110708.903245467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7cKoKgjgoj6gFu6Q"
Content-Disposition: inline
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--7cKoKgjgoj6gFu6Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 01:07:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm seeing the RTC date_read_loop test start triggering timeouts on the
i.MX8MP EVK with this:

# #  RUN           rtc.date_read_loop ...
# # rtctest.c:95:date_read_loop:Continuously reading RTC time for 30s (with 11ms breaks after every read).
# # date_read_loop: Test terminated by timeout

The test was fine with v6.10-rc3 (the first tag it worked at all for
v6.10 but that's another story...), but is broken in -next:

# #  RUN           rtc.date_read_loop ...
# # rtctest.c:95:date_read_loop:Continuously reading RTC time for 30s (with 11ms breaks after every read).
# # rtctest.c:122:date_read_loop:Performed 2954 RTC time reads.
# #            OK  rtc.date_read_loop

Bisection points to "selftests/harness: Fix tests timeout and race
condition" but this looks like a test bug, the timeout for tests is 30s
and the test tries to run for 30s which obviously doesn't add up.
Previously the test would pass because the bug the patch is fixing is
that timeout had no effect.  I'm also running the test on other
platforms without it triggering new timeouts, it's just this one
specific platform that triggered which is a bit worrying.

I'll send a patch for the test.

--7cKoKgjgoj6gFu6Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaOhvMACgkQJNaLcl1U
h9ADCwf/Xcr6nSrhNXlBvO9LvYnwTFr5vm7XLa2D4BrIJ+SLvmihiQXZt/jsCnpj
sEeVakh712Z41PKO9+kXvG+fCyNJnnSGj+C6YwMqO3IhfLrmoa392JVmRDB1ad97
YdfDNhTEgisqfMJJyIbzYY6tN0ZpB56DrBwyJIHYJkUL+JaXfbVtGBd1xg2rk5ZY
ONIcxLjrIhdJRbh9pGiUSkYoWM/pQWQNFVFHnvjE1Wkb5XrE2maRyPDJuSKM4/tZ
hxZdqRJQX7UwNwkLrG1GI6OeC1YBGd3pMNuhRQAAmsz/jcHCFfDD+i3tvTk77M/Z
QA3FPmIZwQjoGbo/gRlTSokzwO8AhA==
=K/ql
-----END PGP SIGNATURE-----

--7cKoKgjgoj6gFu6Q--
