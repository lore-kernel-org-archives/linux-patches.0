Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6917315957D;
	Wed, 28 Aug 2024 11:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724845052; cv=none; b=WicbN0zeGoSgfH1FzdytVh9MyT+nOXlfJnsI5BPhszeeWpxeMsobns1onmTn+BcvCQ2Jfr6MlEkEIY+TileeOCwMiqZK16EM5cK6pyp+HmYaYVHilgL9FZXAVB9abE7tbDCkWinXea4e+iFKnssHTpz5o+1oxb2oLKL6zYBxTls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724845052; c=relaxed/simple;
	bh=39VJUr0HdNzahyme9JRpniljA6+xvqRUMsneXMlbVIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YL5ijuRiyJnKFcBd45yI349BSqnSH75EkJarFfd/DLUeHxS6gZzpxGJutn9ORj3UtRbfLRhGCRBruQNyeKPqc6xBxBnglVTHT2NBY+TXxu1LeVqb9CHQS7EEnWz809rRqDBOStyeA8jxDHfOFrhHlw5XnnAcio/DBk15vsDYtkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgnmkV8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgnmkV8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595DAC98ED3;
	Wed, 28 Aug 2024 11:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724845051;
	bh=39VJUr0HdNzahyme9JRpniljA6+xvqRUMsneXMlbVIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HgnmkV8nCEmPXc1hHRRQUNeH6+U+ATEJ0mvCKsx7NoTJD57kEzBgfjQwe7nAGgbkT
	 T4MgVjtI3KgGWRgvqkpvEhwDh2UxdgG1/6GavhI9B95aM4mpQn7jniN6S0SpJdUKBX
	 X7ybK0i2PKxE9HfOZb2/euP/1VQJjHLz4FW8b3v3BhbNyMQEZBj4HVodaLpZW+Tf+p
	 tGFkUlEUGUkVn8de6wh2Q8rJFLbhgLXa3IL1EohNPVRFRStJwrbYYjMkwVBI9Tktxd
	 fC1rFs8BuaYua/QWAbJhee9yT1q+oIKpsNJsJ7+xpneeI2pRvDYrszxD64z65vOKI8
	 IdK+wCT6Y/7Lg==
Date: Wed, 28 Aug 2024 12:37:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Message-ID: <a800e655-1828-42b1-bb5c-678c03d00a6f@sirena.org.uk>
References: <20240827143838.192435816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HRHE0Op/czxIxbCc"
Content-Disposition: inline
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
X-Cookie: You are number 6!  Who is number one?


--HRHE0Op/czxIxbCc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 27, 2024 at 04:35:08PM +0200, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HRHE0Op/czxIxbCc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbPC/QACgkQJNaLcl1U
h9AVywgAhLUhDh5X3Ku38Sd+vqXlyClWi16JKVHxytp/YYdK1KRnLeWTfDEi6wDe
aTaVmD5RLaPoXTcIfeR3lEkeH0lvqkago62y8pgkSNi4W9gX6+sVFuu/NnonPBJp
OD2wXvSCXYpWIV0ifHyQEakFw1/c0kJIzggtpsEEMqnNocI6V2FG/7uYbD6EZABY
gdvT5adnWrBpTx9uE+3FwMDxBwvexGGvSPe0xxx0uFS+pq47BF9yeHRCkrvM1oxt
FjT9vVyZE668QYpvyQVm9Bx1xHi6PEprj/1K8r6q7RdGmlK3ii2vWZn7rakA4cT8
RKfduE+dFIkmGyPn8peLOm8ozGJTAQ==
=9cB6
-----END PGP SIGNATURE-----

--HRHE0Op/czxIxbCc--
