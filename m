Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41AE158D84;
	Tue, 25 Jun 2024 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719338579; cv=none; b=G1c+sKP0u7N5LjnASVWXTQss84DtVI+yoNtxxnb4UThrzdtuskRaWGGmDfu01mMA2ZpkUPoF63HcJq4e0wULKOd4fQhvm9iQ7iAgKr13L9+2+VCIhlugErl/DIMCG5HaPPAI6M99Yg+2Ldhs6UOLHlT+1RnqUDaDF8+IlVAJXOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719338579; c=relaxed/simple;
	bh=Nypldngfko/cg/nm0LKVgJS+xVYSNbX3uiY/Z/d4h8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ER6bMxA2d7xoMSFFPfTKVsXOvrtU4zwtGIKlCLaL2tByvJA93mp0t8BisiGRZHJunQoZZeXaybtrcaXCxILG6cW57swguegBtGIhEkY5lBvktfyBe5mFASlAC13HD06jee/qH8zPw53C2Pxn79DxbhqJ6Pp33GDGG6pW89cBnio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDgj3+yW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDgj3+yW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02429C32781;
	Tue, 25 Jun 2024 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719338579;
	bh=Nypldngfko/cg/nm0LKVgJS+xVYSNbX3uiY/Z/d4h8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XDgj3+yWj14u6tAvXhxYqNGLRFNhIXuHLM6IXj2RG8QG9DVhStXhy3EflW0019w0b
	 Fdv0sxmPtKZhf5s9mQvQT126dX6RUPYDmJmfk/3+jlftM9id4auMiXPFr9BoZtvwkJ
	 1gG97n4E9C/ERpXznH5N0ruKAxpTGHh34GBaazvnyRJRk2IFEI3rZHSJNMzLPGOE7P
	 Q+2L5FLu3pwGbUfcy2PQ8OFTY43EQvlpzcZ2ygcNuSe/qZL1k9ULmk5kVY24KgUOHO
	 wCVHEJcBtymdNN+5qIo1ypN8B5n6pL+Z6++dcC47GMF79Wzig8EAlG/Wfj8ZRlB/nH
	 Pqs5Nf9Ml5tmw==
Date: Tue, 25 Jun 2024 19:02:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
Message-ID: <bfbbe7af-82a0-41f4-9bde-944584ca9dfc@sirena.org.uk>
References: <20240625085525.931079317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Mn9uLE8gir54HadX"
Content-Disposition: inline
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
X-Cookie: Results vary by individual.


--Mn9uLE8gir54HadX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 25, 2024 at 11:32:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Mn9uLE8gir54HadX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZ7BkwACgkQJNaLcl1U
h9CjVwf+Jw3I2bLpSUX9barL5TMNiURIEcwYFDv7ZvM4118HtVCxH2kk7SWVKIQ4
PYGiYKiZ+D6CMh/+vHL3t9WIhxL0SQjhRlxuPYvHjL70fRZrC8rErNvkgiGgXtaE
OAzrPcjR3Wrstl4Lz4omW/dl7jpGkwZE0GWjDyLcqrAvgU7PXsNT7CqRAR0rV/yy
dd38E1piJjI/scnOslkJdN0bF1yxFgE7Txxg/z2O1T1QjfL+Y9TgAcjdn699xRYy
UPZCLLh8Lj/q83m8k7uHkdEJ2wAupvNkPKXlC2Kh/pMdL7kUnNhWWO40K0xeY18j
TgX1XQ42KF4CwTu+IT2Ty7NggGeU7w==
=onHp
-----END PGP SIGNATURE-----

--Mn9uLE8gir54HadX--
