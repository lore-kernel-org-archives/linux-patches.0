Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29748301016;
	Wed,  7 Jan 2026 11:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767786590; cv=none; b=n7FAIrRStHLH4Kk2+R+ShYjjzcoTNs9jEXHN7yYfMbe0jSyEc1UmmjVmKk1lARJf8bgR5AQcXhoyA2DuTbLhkTnSnG3eI1NgnEHTBG8CEH8cN3pN0TnI/cFeUGg1djbQFMNWkgP5UCQBjv+7JS1NpbK23qxxAUNqrx9P4/+iMFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767786590; c=relaxed/simple;
	bh=WSdZjmhXyn580OMhUBNNyUD+VZGi9nnjl1noW2QEhLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEwC3vi4ni4gcWw4liD5zb+yTaHzsRVnSuYEzsiviLUqi6oA8U48w7X9ymllqfMOHXnDtLVJ8qBY6nXfz7oSA8O94U3xkPLquSqA7L+yymTc0/Y9o1NmfyhzofIxdjii4xzjVp3YylA6UN3S3TbRhcTE5vUUyaOxzS+3SlXg0Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oupdxflb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oupdxflb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34155C4CEF7;
	Wed,  7 Jan 2026 11:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767786589;
	bh=WSdZjmhXyn580OMhUBNNyUD+VZGi9nnjl1noW2QEhLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oupdxflbv2NaRfKZcSETkC52W+aepYPClqCAT6yI//dr1n5ks3p7N0DvP9UQmGqrK
	 DGYXdGYspm/ElLmp+ycU56TDs2RNXkKa1oRIxXP+fN12bDzf0bJVc+TgkvBq+uq8t9
	 92W6Ru6ATJSV25Eng4Qt3uKwtL4YtVk3aTX42F2MMPK4bW9e1fbG+YFFywcr/jjGUa
	 7/EY61lTtLUu6pBlvK/sYgsA2GIJjQEoT1qVNCmeUIcU9+++xQtpszY+x1uPAGoqCX
	 LgR0NIMGcdAqhQV0wK3J8ByZUM78gM5UNUhfdlZBQLzrOAZ9pscYJcowjFvKKVfqvD
	 0wYrPME/+2SKA==
Date: Wed, 7 Jan 2026 11:49:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
Message-ID: <a5bd832e-6d43-417f-a250-385e957e3a91@sirena.org.uk>
References: <20260106170451.332875001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VqLXHwF49Da4oSRs"
Content-Disposition: inline
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
X-Cookie: Is there life before breakfast?


--VqLXHwF49Da4oSRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2026 at 05:56:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VqLXHwF49Da4oSRs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmleSFYACgkQJNaLcl1U
h9A+2gf/WqZ5PIgQ/aJNfCwPLVW4F85Cg+dKMKfWduZbAPpzPDv6GBk4WO2LOErQ
rizwkMSda0RHMcPkO5rSKcddsuFz79g3eb9FSFnci+hsnhKalGMgJPAONS/pJzeA
f659Yg2/OfiA8Wxl1rlug2iVVZpTtyKTyVUmEyVODyROhbSk189hVNamf4URYG0Z
YEi5Q9my987LEmqRMzSWslvVyBR3ewgNdNWJxs3CQHzFBjvu2owz0TiQ9e4b8EuM
6Ln6rJRbE+cgxc0pmRVy3Vmwv1EucVVgJTskzm+lB+KItccKjmLJ9CQGdpoLPQI9
GL03//NF0BJjPDuVf9I9pto7a4ylzg==
=uWQr
-----END PGP SIGNATURE-----

--VqLXHwF49Da4oSRs--
