Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA8B195;
	Tue,  3 Sep 2024 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725363896; cv=none; b=kJk5DIMn3mpI1/Ma6HIYgjmW4Rqr1cwbo1dozaO+eo/z8aH3Owt+qF9Zcg2lgNC6NlHNIjrbB3dGOKJdO91hGwWZiwr+2W/25moCKCOkCB02jXbEtQ5imyx0SPb9uT/i6EjAOu83lGAkv/E6SG8PJLHvAsRYP1eiGPqSbZFZnuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725363896; c=relaxed/simple;
	bh=S7sFXZyOY6qhsDcxYfEEMJKv0UWaedalQn+JPZElnjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1P9MlZGrZJHGrzPepjVyXI5povSODJYuIPKge5hSw2HlC4AbmGj3s39Y8MIURa6+FWpkudohn8ZbWWKR53399GKqsKfM88fB6C0Fu3HoF8Xq3QU7DrSo4ccQugEUOyhr/sAr0N6BXYowQkPm1Sh8s/u++9VnCOhUkBELh86N2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDtud6Yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDtud6Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80BAC4CEC4;
	Tue,  3 Sep 2024 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725363895;
	bh=S7sFXZyOY6qhsDcxYfEEMJKv0UWaedalQn+JPZElnjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lDtud6YyuUdcRU71/BQLW6A82SxyrVuQnTPNhoFFbIfBZ+lEICze9YXICJ2krsCQ/
	 LKu5sh6vUB6LdJYV5Tnk61AWIo4dUgyWhlJd7NSXQKFh3nNh3QC6L3Id7NwJBTFdk7
	 CsFVwLy6XCE6efuTQMbfyJgSf8PjabbVaMoMBwaJQEFc7fx2U8jlbG5ERhUzfP97MI
	 NdaTdcLcpfEB9GqMhscksUYvkDbQ4zw8fGLWpLNdls2bIvjK4q0G8T9rhODXpdAX0D
	 dJEvukBpCpGu03Rm3EexuVjvBcyx9BwlvGMFMEGPStFV8/58MlOxbrH53hh0yzAk6V
	 DB30tRacJn32A==
Date: Tue, 3 Sep 2024 12:44:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 00/93] 6.6.49-rc1 review
Message-ID: <d4da2ef6-2fb3-4174-806c-1003f3483bb0@sirena.org.uk>
References: <20240901160807.346406833@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6AssrCnOMnoE/sme"
Content-Disposition: inline
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--6AssrCnOMnoE/sme
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2024 at 06:15:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.49 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--6AssrCnOMnoE/sme
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbW9rAACgkQJNaLcl1U
h9Bf8gf+J7zRRaCws8RTf/8g/SIUEL67ETY4OwclVGToGLso2yyX/e19yGZDU+6S
SpKXVs+xqINnlyW2zMx5+aGg0XoL+PMX6mQx15lYbYpzUHcBQgnNARNVHBEZirHH
L/eyyTabvSmHH7JnpY7lYtX9BXvtINFomkqywTq5SZj83/bKWbmZIu6S2dCiyBHJ
8IVb62TWeZH2FJXMvy+6ScBSNn8aa/YnKYOgC32Y2/b1S68xNjipuVlsZwihoveN
Gn6z4PRP5NpjvzJoepQsajys6MdW56s3BBru7txiiBQYWiX+sppHDNQbDgCcWvAV
9PaHmcGy5f3NAG088mz0N6Xki2LEuw==
=It+R
-----END PGP SIGNATURE-----

--6AssrCnOMnoE/sme--
