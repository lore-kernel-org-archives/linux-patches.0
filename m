Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5413B280;
	Thu,  3 Oct 2024 15:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727970863; cv=none; b=rso00lvgF/0onuI8k+MQ59mXISvDz7uLOG5sEXQz/EBO9kvE+u+BntaVSOsS4OW0+wfGrsKOOtYyn+31JcLafdYSndPnfLoO0o2jSdLDc2Wz5QMAOB5VJnGbhQu+orBkcZzJZT9hpy5TV2RsCbOQylakuQnZA1bryx1AlaoyJgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727970863; c=relaxed/simple;
	bh=HfYVStyslJI6MxSfOY6LsY7aD5pd1odJYDXldH/cXhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FG7j5QwPw1DltzloB9yuW4xSqc/+cVFASblOeHk9PK15t3+sk8HA1D2HD/i7cMO2ksw5SErjSCHlhks+MTIYdZ9Zc7eg0ksnLGvSQBH/JjRFkslJ4M1mex7PIoc6ZkWHZqAZ+rEqnTAO7Ua75gXGJBha5iiZu0GC+4QK2jGF0xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTqDufGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTqDufGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F956C4CEC5;
	Thu,  3 Oct 2024 15:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727970863;
	bh=HfYVStyslJI6MxSfOY6LsY7aD5pd1odJYDXldH/cXhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RTqDufGkYOLWyoPn6ajttltjMs2Donxq/+NkIlzxxa22KjUJrkp2jAJ+Ruey8rmxr
	 yslJQ4Ts0uoH8AMiTQ0oym9MP8L1uavjagcKM2Xezizl6eGWU/9+KIJTJkuiq3o2BC
	 3qKJK9ag/Ucp2UKT+9sIO/2rtJ0Zc+BkinztN6QaHRnJx/DuK1cnAoD9Zj0MJogdO4
	 ySZP6iO05vnHP2Cppw8YSz2cj6TDzV9Z4vPuU8vTePamSu65NJCD7oELMsxiy2y4K+
	 La58x5B+DZGAZQyrLy5hdPb0Ancx80LdZZw6EaAOMjrUJVIDjF8d7jXFG8I7NmCPBR
	 4s6SfXk18U0Gw==
Date: Thu, 3 Oct 2024 16:54:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
Message-ID: <92e2153d-9259-472b-9480-0258ad862968@sirena.org.uk>
References: <20241003103209.857606770@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="V0G9Etd7bcY+KGUC"
Content-Disposition: inline
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
X-Cookie: Batteries not included.


--V0G9Etd7bcY+KGUC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2024 at 12:33:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--V0G9Etd7bcY+KGUC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmb+vicACgkQJNaLcl1U
h9BSWgf9EU8iv+dhKJ4v6V75kQVIKcJwtg9byi9gATpcdLuL6r76JIbk4NcNNbXY
yscLz6XKVmK+YQISIZzd4mluWdUhHw8OF3vCQQYOebLz2xO4DmhzjcqJ9ythZ/Cq
5NMSz/MhH7uC1X/9diP4Gftx6zzANvrYelzolA3XX2iPjBb8rAjPCYldZf8gf5Pa
vipynF+GxL3nWESTnrdOznv2qfqAHJZjJtBYuZe3U94yjQdYuHNPy1A1q+1+QEVT
pmsd2EG2BDVmUtZOrjPVOLHWAk8D+8RSuUgl6ax5b+kNDIdp+fbuJ0NZHFoNP7aj
u8H6Ytx9OLE8w3uKNuj90LKjW15kdg==
=GYYI
-----END PGP SIGNATURE-----

--V0G9Etd7bcY+KGUC--
