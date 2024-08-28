Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C267715957D;
	Wed, 28 Aug 2024 11:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724844899; cv=none; b=GD8kmdLpL4rLDWOvzr1H+BqeEpnJ04nv/hXXKRxFrBIceSi6B8Vn+IIvJ17xXEKC1YgOr2/bYfDZ/+sPs3VyjGhqOy3E9tm1f2AwIeLsXb6TBB7YCJ1apM/IXH5suY4cLKbGsDdWKzDfOP97lUk0abpAaceY3copWvys5fTrBCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724844899; c=relaxed/simple;
	bh=EjdnUbOCuNRFx3X1Km409VCZR5nLzntdOS0yq3rhUKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oka2BB+qdqNryJwGytNsmo4I8KNQJzOnHvUQWT9PIG5AwpU48r6EgqdJWOiyIUOelcFEq9WhKqcDkmQ/3272gsKVzdLWkChfoTwnvJL8NtXF/gZ/2Vuy8y018NnaBU12y8aQRYaKxCGTWETmvgw2LciauoybROT47RP/bI+WnXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sjy1oyPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sjy1oyPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9275CC98EC2;
	Wed, 28 Aug 2024 11:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724844899;
	bh=EjdnUbOCuNRFx3X1Km409VCZR5nLzntdOS0yq3rhUKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sjy1oyPcmUKxRcPI0bSlyHLt75NOnriPeTvbtcTNMqqijMj9+FHxGDAVAvne/Nj/P
	 EYl+rU4p4jU6BFD8UJWualk0vqXX5VgehXMhQfaW5CDFM/nwD4oIId/G9U7SJyO3K6
	 7F3yKs3S79M7HfQd/mkNUmxVf27YsAoNb+g8Rfnlf5e01thgvggu/CCatWqk/sRgO3
	 TYx7PlmhgRQbcc2TSH4I2pzw5jm+PTo0VlJ1g2lfPwY2fVXfvnkgMyoE2iXx9tS4fZ
	 18zuNHUmO2zdUPc2PP7kugaykACb9IV+5IXbtF82iVy0sZsJSRFPglhNOlKf3qdlBX
	 M/GnEDn90Hg2w==
Date: Wed, 28 Aug 2024 12:34:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
Message-ID: <43923adb-b9e3-4fa0-8cb1-368cef2ace28@sirena.org.uk>
References: <20240827143833.371588371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A9JFEmmAeyhiVDAm"
Content-Disposition: inline
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
X-Cookie: You are number 6!  Who is number one?


--A9JFEmmAeyhiVDAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 27, 2024 at 04:35:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.7 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--A9JFEmmAeyhiVDAm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbPC1sACgkQJNaLcl1U
h9BTPQf+Ji/EVWQU4q140tHZ34QQGX1RjlKgsRhKG4EZ9bJZS5LuUIiAg7KkcZB5
ChUca5zE4T8cC7yqBO1tA1rekJwQ2bqTLt2ruPpW1J2THiWz57821/W5vLi90oHV
HOaDtS63IB9JS8KUM/EURWAiauTDlrdFSBbeZAMY02aIhDxoKnlWAca4DkfkQgZ1
fO+6kN8agGmcZuNZX1eUXxOcOzmsDVuxa891OdfsFYzrqTYaL6dPGNORRpB2wYAh
3AbIQlsU18OUmCid1qkoNBqgYCQEdVQZvxHk1IdkHLGDly7F8KCrdSfkIOhTia8m
97FnSOIGka1lhkgsh0yCn/il2UNX+Q==
=WjEt
-----END PGP SIGNATURE-----

--A9JFEmmAeyhiVDAm--
