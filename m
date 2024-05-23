Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7704733CC2;
	Thu, 23 May 2024 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488463; cv=none; b=FrTAzim7G9gRQZKpPZeyj0rTXV6/sR7Gu8cSlbZ9//vzKD72EJEMLT+8cVRSbgIJhPetxelcmfssyGLTW7cBpFtfmF5p257FDKpAeIpa1yGQ7lS5M0wSLHatllUF5vd+fdA9RFWJVKklMH7+nOxy5JHKQPJmoIRyWfPtkVAkojY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488463; c=relaxed/simple;
	bh=dVR2A6Dg3v31aOwj1MtrscTaJOdnIAsfN3RMo0aQBqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOpvARRxSkbrOt1rLwKvk31cJgUqjpe3pqX+PJMoMOWgF1a5wPjowDa0AHG/i9Oq+EU7Tp6xIUnTTPFHH2D1wBrm7WaO/PZ30DJEq3220V/38TvYO6FZoogG8tMcZJJ8UCHXHkXVHcEk1kH2WgkvuE+lyNr3/B2REKQilZL1cJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vgc9zXsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vgc9zXsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB81C3277B;
	Thu, 23 May 2024 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716488463;
	bh=dVR2A6Dg3v31aOwj1MtrscTaJOdnIAsfN3RMo0aQBqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vgc9zXskH+eoKfro0LlYoOuXdremOPSS57dEktOrnqNSx9MAHKYiK+7TrQ2y7w4lP
	 PQLaQ+4NF8ntLuYbZRPGtrvAVfVfL7h+BE+byUSO7l7fIKuk5rTGkB/KKZ7dLVLeOh
	 3z0LhmP3RAfcBx8vMtbNasBBsh0pDQhS1hSwaeOZApP5U7lKzAF9U7Le9gpvvdxCEd
	 RIazSzEe7vgp10Yk8/XCen8wyLrvDoCQoDP1zZ2A2FqRBe4x6clCtfDvzw04A3aMAr
	 KCLjYnSWBLQCJck78tGlXWJPCT8q2wJiwGzPGn86Dgd7Y1jRKHJoQsE0iyyBY8EO5m
	 zS07lVpxxdo5g==
Date: Thu, 23 May 2024 19:20:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.4 00/16] 5.4.277-rc1 review
Message-ID: <b2ada876-17f2-4fe4-82f7-036603a8c9ad@sirena.org.uk>
References: <20240523130325.743454852@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w9IZO6FsyZEzRO4V"
Content-Disposition: inline
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
X-Cookie: You auto buy now.


--w9IZO6FsyZEzRO4V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2024 at 03:12:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.277 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--w9IZO6FsyZEzRO4V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZPiQgACgkQJNaLcl1U
h9Dd5wgAgxfI8/6WEEjWks21Y2KbjRgO5mCzydViGPOsmSmjEvvP13X4kVeaZ7Em
l7UYcu15JCCmjBSwljN8KT5aAaanBoHrmr442wnP0VKFwqNf9+dmN8AXzF6KIYsv
B1FDa6QgG1Cnr8pJ/adbpo54XonFI03ZMgTiyl5JgU4kKqOlKAZLvHfLgVbOMjVo
u1+9NuKdFu2oA4lvHF7wK4XFZ2wCGwCedc69CwYHfJP5Mtg0fioVdMrG3X0x0qS/
1FTXeOQ+sw0+ZYJV26qTMtAqRr9grGojVkeBP+Ky57nYVMPz5PXI5momUIuLSJt3
z7C5jCdkgw6wTjBk6IoiaLrQi1u40g==
=eUnW
-----END PGP SIGNATURE-----

--w9IZO6FsyZEzRO4V--
