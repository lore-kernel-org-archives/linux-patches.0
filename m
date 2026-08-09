Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306103C1D54;
	Sun,  9 Aug 2026 11:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786276544; cv=none; b=R/XAnxnNGyvqLns5x1YtFCGeqgg3nHwFZ5EOuDh7EbaB9CaWVpkg3UywwsKUSn7cNcB0GrWakNsV83PiK8jFRZFDV1PNv/+w360A4q+xTyqxg0nfsX8V8pSQI6KuXnEXN5OShfYKnYMnpwFqWiJmmH5zd8F3IwLD5WzlgFj2yHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786276544; c=relaxed/simple;
	bh=SVe5ieLcIIMtqtYJ90IlqvWZ1tL1OVfttq8B2mZA2Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8PmRssLUeCK4OPVBnWWA/cSKi2gQS8SpJtkxN3vX7rfVxfBkuChynQbz55ACiUHKTyrmsa6BirZ5A1ubJsfqkPO6ZFDtIE68+mL3JPZpGWp3nbb4wNANvuSHZY9yYArBKU5izddmA+c5TPYf3rsnB4XSbPtax2S5Ga1EIcWuC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1+pzMzD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1+pzMzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B831F000E9;
	Sun,  9 Aug 2026 11:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786276542;
	bh=u6ZGJgajsf8ZW+aynThvKrp7vvQoQ1+V5ONDoS8lmMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O1+pzMzDw//2CpNH5YH/Oo4ZsJG58gql+Q1hwcriyM1LixKS9U1HF7Ps6MtTMEOEI
	 GzCH0SxWUahvtDuk0mvyNyXgPG7F8CO/f8y3DAHHSDBtAca2rKp8d8ULfm9QVukhlM
	 7h6BF39FjkeQPuHqBJwQsJOkzrjeaQFTdeHB7tXTomX+8AjYkLtIMlKzPWjVbj2r5k
	 WsUCihwMJVRs/QTwUrA+eCGfIgBzW221+kxOmpGC2p8Fo93Ac4PgTem0Yd+s56irHO
	 oBo6mz5rSAWjwLwytzHA2YPrdBjT+PaYlNRuV5jPetm8CpMEyvWYuURj8oB1EWcGdH
	 2L0Kxqc3VLWXQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 89A1B1AC56E2; Sun, 09 Aug 2026 12:55:39 +0100 (BST)
Date: Sun, 9 Aug 2026 12:55:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
Message-ID: <anhqu9v9w_8PB26K@sirena.co.uk>
References: <20260807143415.358597922@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vXnnEzZOAmr0pEV+"
Content-Disposition: inline
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--vXnnEzZOAmr0pEV+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 07, 2026 at 04:35:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.151 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--vXnnEzZOAmr0pEV+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmp4aroACgkQJNaLcl1U
h9Afzgf/f2dQBiiRWgLv2m8Ijlgs3QoWEqJ08S7N0JMj4qiomMNqH+BZkWmlhzqI
u+okW2Gvu37QM2ZgjS1u47clkWo51U4xxw5jSLON36ZuL6KxcCU2TMFH6Fjlm09G
wML/MWKH91RyQGvOlF9K/UvOpb7qXYn3Ww+wZI2M6BvbegKVDGt42e4puZylz5iw
WugBHrCo8/AbSRcpSZBFT+P8/iQo4a5JmNkgbkFMPXcifYNOHy8mQyAc7NhPQG+J
SwCptExW4YR2/IPEUogHQWiQBqwXTioCE5xKIiq863UNq1ocAmxdNgzSlEKZKWRm
MYQVKOT63w5NekFXJrNmtI8gEVcSjg==
=4b36
-----END PGP SIGNATURE-----

--vXnnEzZOAmr0pEV+--
