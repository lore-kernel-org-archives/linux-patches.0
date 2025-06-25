Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5301DD877;
	Wed, 25 Jun 2025 22:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891061; cv=none; b=ih+UjQ1EuEwLsTGB1KkcRoVZB5tEyqX1xpqv1QR4zvEcrDihM/6rjDpq929vYWABFwexcPVe+xyiKer7H6z+UEu/762QDvbM4eWypcEEmOLK3hQpCg/thp9+1L4GfEjX2p4iKdvqjCcso77UuC4VWvbw6eJM5xs7EghED0SaWGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891061; c=relaxed/simple;
	bh=IeaHNsOHxJ6QZgYk2muRyxwjUrwKc//+F9/iLH5Xu+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jaEJ72MFYAegqp5vMWQyw4li0KltG+11CE/p5r/Z+LZUYtkuNvT/OM6P8jT4AyQS1RcqoGcW7zcpeAP7H6frOqXyLBARtAkAOmeyQNLCrCtwkbVObmRJZoaUxBtTIINEspDGkZ5XkY3ajw1Wq/gfiF1QjjqXO9fbsVc4q6UxwpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsiE86lX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsiE86lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D85AC4CEEA;
	Wed, 25 Jun 2025 22:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750891059;
	bh=IeaHNsOHxJ6QZgYk2muRyxwjUrwKc//+F9/iLH5Xu+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LsiE86lX9UwP+FNhy0nEsuM6/JqbMM0l19J/aNxv4OaZOr/+4mh4vmW8KXiRS3EUK
	 8JaRgxoDSnc3dztrXvcZHpYw/FWVyPF8UXjRMztQiTDN3sBOGQUPrDvoQf9ctI4fy/
	 nCdyYnjYg1lZaLkVHRvqz8rAKrFUIAr3OaY3lblh5uUnN4LKtm629HGyC4pDgDbTMp
	 TVyQqGSpluLOMZFNiRvhondoS5ohzxciIvehekxjl3M8ioIG6wFlbXCaEjaV9z6O3a
	 9lmbegFWctgutJU9ByAoC+mvX17N0x1cBPbVU2khhZIWs4WZddDSo/SnxjjGiTnxin
	 42C0TY9/kDo3A==
Date: Wed, 25 Jun 2025 23:37:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/352] 5.10.239-rc2 review
Message-ID: <aFx6L-nnxjWm97AT@finisterre.sirena.org.uk>
References: <20250624121412.352317604@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wWBjF+YG/IIIn9Us"
Content-Disposition: inline
In-Reply-To: <20250624121412.352317604@linuxfoundation.org>
X-Cookie: Do not cut switchbacks.


--wWBjF+YG/IIIn9Us
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2025 at 01:28:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.239 release.
> There are 352 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--wWBjF+YG/IIIn9Us
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhceiwACgkQJNaLcl1U
h9AMqAf+PQjES6/Z6oEcQbWZ566NGwXdlp6rdpH55Uxl/oKK5W/oBarzXQ3i46Wc
NwQpnJTSSXTDwOcSTZ85G7rPs097nqSfu0t6RiR7u1Xv9az7ecuWrZ4vMtVDFBIh
lYLZhgSvwpoQ8NNBs2lxmwVuuUoJa7/KyoWLHwsTFLWThdu3rHS4WH0vluOTc19z
XfxfgY/clE6n9sKiieJU3CYwEYPlc1rNZA4AXyT637/jqGaOzLx7au4WDoCn4AIt
cLIpKATWt9sgzw/5918WK5bhkrhFp8D8BMm06A8yL+rnPODk4xdhc3cJzOFiT+sh
7C0JI1KH5DfQddB1QUQcv/Jy4GRE/g==
=Kqg0
-----END PGP SIGNATURE-----

--wWBjF+YG/IIIn9Us--
