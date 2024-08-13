Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0121CF9A;
	Tue, 13 Aug 2024 12:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723551801; cv=none; b=SjsmifJx3gJUVA6XQt3fIuxa1LcN9Eqbkn8EwMjmk+3ccFYD28ZW/C5omXFEb5yiuLiJItVa3+PIdjcCEUUFA3W8j3my9qnaMUoNQeq2FB6/CD/vgpyiNg5nx/0wGJKmkHTX32Ag6Sarvh0l6cwuNpkNEP/eAiji60DuWHGhbZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723551801; c=relaxed/simple;
	bh=ymSonT8T6qomlnFRfpcE9r9zqEqxNIAluUl4XMBE18E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6VJeTvOw3eZGvbO37ASEQBJ9rwum2jhGSTGoPLpFSEYNZ8iGXN81U+uCF3QqXIlQGsxfv2jrHtIarBoGKge0UV7rBUKFnbjJft6JepDsV5hDCINu2WrnVt4NaT4CiiYnIw3DgE0p5FxJedbD2+MxQcMIRaIpF7eqB+cLtfOxw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfBALhrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfBALhrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9BDC4AF0B;
	Tue, 13 Aug 2024 12:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723551800;
	bh=ymSonT8T6qomlnFRfpcE9r9zqEqxNIAluUl4XMBE18E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qfBALhrztV7ruJdh1AhNrvVzvM0seKVY+EhP2TCpwhZtexCRdFP/H3QzEtEYMFoct
	 IV83B52/LOe5vZXpLdsAQs2ZjoL1elMjjesXdBA81+g/rm1WItGHeSHzTZKByAePo0
	 eKptQf6aV222R4S4i7aLfAFbuQ0bWUEAo6T4mkqSAaYDmhJOZaGbnh8zSfrzQ+dm7Q
	 VOdkijGWkm5+CPbm0dDiDMfFCq02oJxoUSNBW01K9axJKFsXDmrcRNPxjJzNEvBoAu
	 T2cTU170ahuPw2AY8eY8sUXwrGB7wiHQnfvONlLCorQ5fPERsiOVFMZvoe8RnPkyqB
	 IfndqVJtiZ7Fw==
Date: Tue, 13 Aug 2024 13:23:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
Message-ID: <c66f9da0-8be6-4e41-a297-69312edc694a@sirena.org.uk>
References: <20240812160146.517184156@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="T95vhYXTCHZKL4E3"
Content-Disposition: inline
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
X-Cookie: Say no, then negotiate.


--T95vhYXTCHZKL4E3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2024 at 06:00:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--T95vhYXTCHZKL4E3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAma7UDAACgkQJNaLcl1U
h9DhYgf+MenCIPT4aj76h6dnttqLNQPQiaNw9np66ECIzhDzDqizNyzmFbnpeVZg
9upy3BrItyxsMqQ6A8ht5THSz4K4a9g5S4bCGElK3dA323A1qKTq8MAa7moj6Goi
htIB7KMl1Bh4TTP0BZd5zlJw/ksys0t34Ro1D7cp2eLKrF3VEg9Akm00Jy5GRS4x
A/jyFoIYpbBG+JN8beGMezVse//HFiNbst6BQY42EKevbVLPQsxPhoHYPzyAtZXl
CRs+wAGytzJcKhDQsn1PM/0M9TooL4MJA4cZHRyvhUpgSBBKL9kkPYuB9IwDc9qF
9YvMOmwpr8DFL5zGqzxVDzfwN9mPSQ==
=6YIB
-----END PGP SIGNATURE-----

--T95vhYXTCHZKL4E3--
