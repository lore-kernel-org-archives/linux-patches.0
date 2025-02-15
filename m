Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491034C8F;
	Sat, 15 Feb 2025 00:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580236; cv=none; b=E5Z8pXFdPE31SvJA44wAotHgMC2qN7YR4Rbt/e8ABAqFXkjnEv7V2yIustwCwZ4rTvyaAK2RX1CQAbv7/ZGvRIU5wROwLUQxHlokNM1WTZ323u224phx+DwbYp7xkXyAiB5/mz6WvZO6+cFONVSmgrj0nnMBjwOpd6LYYa0zA9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580236; c=relaxed/simple;
	bh=Lg2KBYgTP6DSZbw8H9xyEYu7CAsTBt9CPAZb69EX0Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VS+sUjSKXU2P/BZps+n/ynXSlanvJhc/olCBn76Tbehmk2uL1m320bqpqctTmEnF3pl7Jre1bk5xtXa7Xvtw0UFOKvKzOFPQUhhThZquRCsb3xFI8NxllhSmmbMWxyfErJLrGWW79tTDCr+hvdKCpGP0kenTv6HPN/mYf95imE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIbln9A2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIbln9A2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1CDC4CED1;
	Sat, 15 Feb 2025 00:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739580236;
	bh=Lg2KBYgTP6DSZbw8H9xyEYu7CAsTBt9CPAZb69EX0Ls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QIbln9A23hCf3e9x1ErSA/Fnf3gJJudEvVqyEDh2dCRJGXzkwaOp2VP0D9/Wmsp9x
	 q5P7fh+nK0gOnyXtlHSXZlxVek03n3MiW4PfMtid1LjS2u0mGNZ635SreWUyC/iIEL
	 av3JNvrEnhWIQM9puEz4BFUMXR/Hn3dqTZth1AE9LoYb9VVYDlvpaTHyKhh9K+KCE7
	 EQAUC6DizC5ORJnJG7jQHbgG/Cc0cTe+N4uiJ0Mo8K7LtCtaCAzc4jlmh5dAqu9Kl3
	 i1NzUSIbgnz/xmyqokmyZSAUoNfcGUqF6DPhZ5Ns8eE545GpDcir+fvVsjcShPQ2Xc
	 fuPXscGCqLq8A==
Date: Sat, 15 Feb 2025 00:43:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc2 review
Message-ID: <Z6_jSDxUowQpJ7qx@finisterre.sirena.org.uk>
References: <20250214133842.964440150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="olmlACVjamj9Rcp4"
Content-Disposition: inline
In-Reply-To: <20250214133842.964440150@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--olmlACVjamj9Rcp4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2025 at 02:58:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--olmlACVjamj9Rcp4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmev40cACgkQJNaLcl1U
h9ABgAf/RXjtJJCLtkKINZgfgoxcMZ212Ey/z7rQ2tPMfAt/4QfBUYu6HnV2bHtP
udSiiIOfTc70hjbbgpRvyl9QTfweBpyLPPD1vAUBesEHBDYpN40dGO6oO8VXh7Sb
A5bicYZpHrxJffiWj/fmcqlbas05II8iK0a00F0/Wd5AdATPEgRtCt/ai71w4t4F
OHz1Dxb0PG21YNyUc3nmnbMOGXnRI/KlX0HzaDplWiZ69y0JoajF0hpWBivsiwRT
lMNkCdhDQu/MeQrpuhcHKpJBPlStbhZZx5qYQEVe8/pQ2OrZSn5MbVvmo0L1wKNp
jRcW1My3VmRytRsc9Ad+OSf+B+4y6Q==
=kDaN
-----END PGP SIGNATURE-----

--olmlACVjamj9Rcp4--
