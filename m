Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1884A19580F;
	Wed, 10 Jul 2024 17:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720632053; cv=none; b=I3BGKNhZBooYdfcr5+PkgPllRssgtSn+Px8BB0S5l7r1+TIY2dRlMFvGFyY+tjnwoodECkRWW7JIpwJGRV91vQG1UpHZqbC9+eHTbtE881rhdiiUcdcXoyAUCo01VS/r6VQrPT5NUxQtbCK2+eePyl3rvC9gRt3WG2nCReeiI0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720632053; c=relaxed/simple;
	bh=rb42RhIoXqeY6d3mu58OrK8GMi/G3ObjVhuM25pbjwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ekb5n1wnIsz1hVjOJO8T5QD6SvsxtIT91gRyIZ4KlutMya1WkCig34WIOlheEgEBtxhsUV1sg07DryWjkjqVeYCmU5wqkmGDZkMZQcbsFMRQ9y1v74y9G9reKFF7EryS9VeQzipvp46NLnXNXQgYe6ap2IMMtJTxaP08xsn81CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lY0pkjCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lY0pkjCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06834C32786;
	Wed, 10 Jul 2024 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720632052;
	bh=rb42RhIoXqeY6d3mu58OrK8GMi/G3ObjVhuM25pbjwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lY0pkjCZ6m8F0TnvvKWK+LWxgFP5683shIa5FV6Z50MhKwl2d6fQmp7CFYpsZ4Uhc
	 CVXXnN2oDsXFD9gR/JSnzmzzPlStrr026ogVwfX9lqDRbPbHPJD8XafYObDSTipI2H
	 VoIQAy2cq9q7N6bCK1X8k4bgPG1PKX2xzO1QPn/6iodn7bfPS1zWyA64KA7O++6B1I
	 U0G10G49x84TDKDBcwD/CpXc8zyQ1I68hLcnwczqNurs2WTWlpNfPumOaEi5iC971L
	 IujjN3532RYTVhHsEufw58gdJ5LiunqyOBp6QolKxXHW9qR5qZ37j49ez2PffCgKmt
	 zfP5oAAvfG/sQ==
Date: Wed, 10 Jul 2024 18:20:49 +0100
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
Message-ID: <Zo7C8W97URxXYXd-@finisterre.sirena.org.uk>
References: <20240709110708.903245467@linuxfoundation.org>
 <Zo6G9C-AzU2jBrOt@finisterre.sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q8Zrf79JJXTQqdty"
Content-Disposition: inline
In-Reply-To: <Zo6G9C-AzU2jBrOt@finisterre.sirena.org.uk>
X-Cookie: Your love life will be... interesting.


--Q8Zrf79JJXTQqdty
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 10, 2024 at 02:04:55PM +0100, Mark Brown wrote:

> # #  RUN           rtc.date_read_loop ...
> # # rtctest.c:95:date_read_loop:Continuously reading RTC time for 30s (with 11ms breaks after every read).
> # # rtctest.c:122:date_read_loop:Performed 2954 RTC time reads.
> # #            OK  rtc.date_read_loop

> Bisection points to "selftests/harness: Fix tests timeout and race
> condition" but this looks like a test bug, the timeout for tests is 30s
> and the test tries to run for 30s which obviously doesn't add up.
> Previously the test would pass because the bug the patch is fixing is
> that timeout had no effect.  I'm also running the test on other
> platforms without it triggering new timeouts, it's just this one
> specific platform that triggered which is a bit worrying.

> I'll send a patch for the test.

Sorry, spoke too soon on that - the test is explicitly overriding the
timeout to be longer so there's something else going on here.

--Q8Zrf79JJXTQqdty
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaOwvAACgkQJNaLcl1U
h9BNKQf+MAQs/CgxWnTvh3OsE4hobSoPByQlOu7/LGEq7ocdGNLJh7Njdoe3j4iC
4LilAWZK92NhF6NCl5ND5h+2nx7ME9Gjd/Mgfi6VhHKZ367LOmBT9O7lT1jX7vnO
snCOxmB6zZtL1Vo3VgUZTyYH2Qjs+i6LZEi1OxAwTFqAEwugImmUe+i/U1FQEFEK
AvYKzIEPx54o90TVWJ4o0xtJ290ypMMjLmKUOCcAqOEqvrDL528COGgqT1lSXVct
0AF6njZxW6MqNIfhW4ARtGR7gd2N53ssm143DLIeNv7wZgVJ4MzG8MIUnl7BGauL
QvUeLZJJcIHKTp4qNPiqBpL76u3hUQ==
=KSPE
-----END PGP SIGNATURE-----

--Q8Zrf79JJXTQqdty--
