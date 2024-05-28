Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A7113A868;
	Tue, 28 May 2024 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716904953; cv=none; b=Af8OTZQB8v1t7wB73a2RLXt2KCcq+wWzb6gp5ctfYnCF9XizQP/9L09je2xLzm26v2Yv20PZf41+Kkel2cGjH7JWVF+PAwFNRdOWjEtYw3b7lNrZdMBAbbRWEeTuwT6dJ4TBhwaa1W2HcaRK/TRabhgxiwxwEuAFCCdWo+hPUr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716904953; c=relaxed/simple;
	bh=1nTwpNX2fEcGksZvA2aCXqbGsWmTpVGwwLqvc2N6kD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5sloXO2FOqa2mQm6VE0ZGZuUHZ0ZUAufO3Ewws8gEn0tOvWOgQ5pKoROI+0fxQa7VP3ST9mUrQm2KnsSqCL8RE1NvoVRfFYavc9jTP+fTR6CfYA+Pv4IoYRO/OHgfwN6A3IQUKaDajPVSNRSzcJFgBsghpIgeWN0s2kq/wZl9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKBQyG6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKBQyG6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1A8C3277B;
	Tue, 28 May 2024 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716904951;
	bh=1nTwpNX2fEcGksZvA2aCXqbGsWmTpVGwwLqvc2N6kD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZKBQyG6gqcJrVGz3ddXWHb0HmAn3BG8BEud7YjbI8Ec5EfQaGCW4J+tS4YZcYd7di
	 y5tYjOs7F9L1sDVxXAn3fAuJc7CE4GsNOoHa4Uvh1nH/IOihr562mMA4PXsAcQr77g
	 ntDAu3c9ghDfZbk1G/vfiraJRcquSvldYESabLtZ8QZUV6XifCjKu0ir3lmPL91jS+
	 Rendw1+TsjV28MhiXfsUUd+UoZw4W+mxtXYppYZsnC2Tm6VAS0qViqoJyXo66naBjb
	 lp7O5k3KYbzjZT7DmWOS4746nGci4z+/8qc4e9rql8nnJnyVlZD5gBUr+wPqDmXIdl
	 w+cuZnW648i4Q==
Date: Tue, 28 May 2024 15:02:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.8 000/493] 6.8.12-rc1 review
Message-ID: <01b39434-dd43-4fed-8623-f14201e18948@sirena.org.uk>
References: <20240527185626.546110716@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xAlbQCz7q9EYzYNU"
Content-Disposition: inline
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
X-Cookie: How do I get HOME?


--xAlbQCz7q9EYzYNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 27, 2024 at 08:50:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.12 release.
> There are 493 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--xAlbQCz7q9EYzYNU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZV4+8ACgkQJNaLcl1U
h9C6Awf8DjlmQvnXxDDUbYtAAugG71mDH9FAaIlEfYCr6rdI7J6UrQQPzSQkpFvd
CkWFO+/uVaFsXTaVByo3IFenL1yaKA7AqRJj5rrPHHJZYuJrXecZsVHMEUSADPU2
FLnCMh0Bu5Zx1Naj+oPb8IXhLS2QZtOHqVIsSrPUhHujsgP7ce5saplq77cygnGL
yvGReWiMEPaGogI8FLcjiTCw52s1NmY3qaOcjdpElaVmFCsdhfj6vg/Sd3FWjYim
/wBjnsjkits3FHccuL3Vd5hNHptjPYLVJ6XheJ4S9KzX7zbTpelRQCyKOP2M9l+G
DLJqM5/CuKs7J7hqsc/du0Ge7+2uFA==
=acos
-----END PGP SIGNATURE-----

--xAlbQCz7q9EYzYNU--
