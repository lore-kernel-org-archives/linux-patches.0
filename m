Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3D1195B27;
	Tue, 16 Jul 2024 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721159005; cv=none; b=KJ8pwEGIqMmLp3L5OudKF0SwA9ZfzZBss8FkrUlfeexmNq5eFIfChCM0KnlETy+YUNKRgLnsGIzSczGYGeGLN8o4lO3rE8EFKzTtFpg5mtK+7ped2U7pqAQBsX7pdvDm64XydUS9U0XYbkfL3Y/jI38jDOo114Y4d4Ff5vAbwFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721159005; c=relaxed/simple;
	bh=N1DLYAjNSkmL3ZlMpnusTmfnT3+8W7vAgxCZebBFTDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lw4Thc4o42lR3DiJnTEXGY3gsnYHGhc4o9lKL0/UN0QSiw+HIakKBUsdIbaMuSTyzQeQbyRa2zlgsN/4C0Hxu+dh2V9mH+72BjNzkW1ifZsghWHxX668lNaaXvinH4cRsQu6qbjISWnIFjUVbbRvV2I9tzFTLi53GU6XJ21gjJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkxEFtyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkxEFtyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49BEC4AF0D;
	Tue, 16 Jul 2024 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721159004;
	bh=N1DLYAjNSkmL3ZlMpnusTmfnT3+8W7vAgxCZebBFTDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BkxEFtyAZ8N+WCAMR6qPMljdwiWsTbBUBGVVZq/WBBZvCuncCxVTCDhBNR++sNsOu
	 wE76zNzZlZ1AtI7qXYcbyj4JRZk0e+1SWw7qVSJrFTSXTEfaD/X5H6xSmm9M5KxWYO
	 /U8h892PAahvz85D57OIdQFmSa8spfZ1w8I8OJvNKIMJvG9T6LVSp28KbY5qfSKawN
	 hgAWNdlTSksy3Q7KqYPaUhpzHf8BsQMfGMBMpVjY0a4T6THoSmPD5VlO6vUJWBl0Ue
	 kKcZZOC63Axlw+uOpe2xVSx3VMKoGbd5t72EX9Kfxyu/b8sRlNWZ4UVnC4xvXB+Cvy
	 0bL5g9bXhjXJg==
Date: Tue, 16 Jul 2024 20:43:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
Message-ID: <78475039-0f5d-4bd3-bb57-4047370374c0@sirena.org.uk>
References: <20240716152752.524497140@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="086BrWzPyQrKK0j7"
Content-Disposition: inline
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
X-Cookie: Think honk if you're a telepath.


--086BrWzPyQrKK0j7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2024 at 05:31:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--086BrWzPyQrKK0j7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaWzVUACgkQJNaLcl1U
h9C8igf/cRoQrDOxCOI8fD62tQSa6VHzKv9NKO2yRDiGn/Z+kRorzKzGHAgjr67/
aqGkW4EgwvK60ABKf32HhnJI1+QN1acr3EXke+4VZ6uxqvvxEB47LugxsPQ9suqO
Ii+hiutbkMcu/Now9I5/J9u94rXxT/qKoETo8Ktin1GhmrQ2QrD+OTNxEfPFMkYI
aF3OncetVhbv4cUGksvarSnM6YJZzM76H5FmToNHlNkZUvWQ7j/FksotLNK4p+8c
A22v8HYYlkCVwJs6cPmLvEjIe5zerXu+l9Rrs7Nl5Lie2CcT1i2LnMv1/E2kGJaL
GD5vjSnc3ygkb2lRqklmz11vjFIRRA==
=vn+8
-----END PGP SIGNATURE-----

--086BrWzPyQrKK0j7--
