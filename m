Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3798FBA45;
	Tue, 10 Sep 2024 22:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005780; cv=none; b=VD2n5pU2Rv6uxV0DDI7z1k8Gtntn4+lQOlnjcj6tqedRLoeEk5cwtht60gAhhDWKEH/0fsUeAS2QA4UwSUD/ecbjIGyLtxQgDZNs2Pya6MRHUyc+Ndhn3H23zoH03Sk9F+rkXhe6E1MvbEZdtJXPyPfxSdT/OVVwZ6EYyvyHWc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005780; c=relaxed/simple;
	bh=Z6tIaiSp98oSKqpYr2vdmN8U/P+Vdic/4Z0+xItMoZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSd8+o+F7ocx76rP6PSoFR5/G78RnQ1xLcA159OuZIZoEcbIpAmx59+oYmrzQnYlbYh/g0LENXvPmdI9Hr0Pz2K/ym6LNKxZN1P//klrvqKZqaVaFtEh6kkgc0F/tvng8uuYdsUEoV3kXslNhv1JbL28WH5Pk7A+gqtHxAcDBTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNPBSD9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNPBSD9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F865C4CEC3;
	Tue, 10 Sep 2024 22:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726005779;
	bh=Z6tIaiSp98oSKqpYr2vdmN8U/P+Vdic/4Z0+xItMoZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dNPBSD9tuFQpgFM+qI19OLhGGOO3X+KE8pjda2dQSW00Zwb3i+Ijcv47PUcadgtcj
	 xVYCeHytM0UHM8vQBgdqYH8dELUnC8BgY84WRmv/FG7KZzHbJEewke08ZKgTtxfh7J
	 tT3DYlE7x9+/c9450ReDp2ClJpGrB1zPW0T12nTPddRMy6M8E3zvdqiZTzEgq9aA6P
	 gvTy/Dm9BBwsPwROezTA/vj/IUyCY8JPbSWCrb/QjZ51+2H6EO9136CbDTq/ezQmXz
	 b8KhPgZgddBHSKwyFAJYGegpuONsrdFmMyBWgeHPlW4wKibYllqu5RRAxqaPVf3Q03
	 bDe0OQZ1iOuuQ==
Date: Tue, 10 Sep 2024 23:02:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/269] 6.6.51-rc1 review
Message-ID: <e563066e-54a1-4bb5-bbe1-b742a9f61810@sirena.org.uk>
References: <20240910092608.225137854@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ynf752tbp/hJv0fS"
Content-Disposition: inline
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
X-Cookie: You're not Dave.  Who are you?


--ynf752tbp/hJv0fS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2024 at 11:29:47AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.51 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ynf752tbp/hJv0fS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbgwgwACgkQJNaLcl1U
h9BUPgf/ffiHbf9uHPsv3IK4kXA4uDUk87tHVlYM2Ihh5XaMoI2hhUtxrEaEG6Jx
/BP6yg1IJE/uD14u6T4K1Mb3iEAHtiLS7bDNr5XlSfBF3B/sJjxkaehBxPU6Drqm
WVvJwXmVdY7RPYFfxxvzNQkX2QbSJOnqbBMMdlC9qf0xRaeUGdaDIhnVqJ+362jl
KXPAZUM8VaK3HzoEjl03rB6SNymRUfBAWd1j1keExf7I/AaUZT81E2b5c/Y0p//Q
qvHWF/nQzijtqRs5/c+sQjPbDq2tfw4+OYEPEbLoIquYtS23UzlD3F9DQawCFaul
k3fFfuy10M+5oOm5xp7MxVKojSyP2w==
=YW9L
-----END PGP SIGNATURE-----

--ynf752tbp/hJv0fS--
