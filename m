Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FCD275867;
	Wed,  9 Jul 2025 08:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752051056; cv=none; b=DyhnH62F0LfxdLTxmMJgWPYrLZKKcxn2aSI4Q5VeBvpx96wFLAoTGrhCK8tu7U2iBqozqvi8++KBD9VBehnli9vdJH1F9IbG/53iFhH0zt0uXsVgoATBWj9wGHNsGJ21BxMr6zPOcVfXtvQIUGhAa/4u97bSS3OAm4dzR3k0juc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752051056; c=relaxed/simple;
	bh=6WW73RHQ5+v7927tZdT44K1IZ701zL0rJ9JiMGlGqvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kt29E0ZLt4JV6VbiCZVpfLKp4pQbYcMjLezG7G2M4VNg40UeqfkX3QTwkKcd7lJwmBgyCdYbMmHrhG8xxpDKPQFpFysVuBJlfc1de16CSRdPDKS0NHlFn6kihvz7flX8ZFRoukQn94wyrYNY63xtxgJkLPdOj6V7b1fFxvakdD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNPKeHzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNPKeHzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84488C4CEEF;
	Wed,  9 Jul 2025 08:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752051055;
	bh=6WW73RHQ5+v7927tZdT44K1IZ701zL0rJ9JiMGlGqvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pNPKeHzSwOwNHDjZMD4gXA/fGCRvw8zEUlqlC5es7CpjE8Rl8k0vEInO0L/pY8An4
	 pEeoGEYh/HnzU3iYUTh3GiWEylzGeZhE0nGDtShjWwX5AyLtcaIrkfbVfZ7kYAjxr+
	 GpJSc6qG/XsR4PUjm7uOHCoqcyeiUM+0teX0kLECmLeGBEs7BP06B+vtQYj0BU8pBs
	 UhylnlvXDsAamViqV0sg678z+4g7XpqPKR7G9ZQ0obBNudZb7ciKB9drfBy8rxJPW7
	 cQpW0Buc8/FLm5XwlX57gxMUbo3KN0vfiedFoIBQUWmEMwmuwlbV6HILLVhS//2NFb
	 6za+aDlYAA8Cg==
Date: Wed, 9 Jul 2025 09:50:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/149] 5.15.187-rc3 review
Message-ID: <aG4tbBOv4-10L8fe@finisterre.sirena.org.uk>
References: <20250708183250.808640526@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/FbvQND06Foej1RJ"
Content-Disposition: inline
In-Reply-To: <20250708183250.808640526@linuxfoundation.org>
X-Cookie: Do not cut switchbacks.


--/FbvQND06Foej1RJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2025 at 08:33:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.187 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--/FbvQND06Foej1RJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhuLWsACgkQJNaLcl1U
h9BoUgf/Umlalfyh9xPNhXvzXjar1lb9XYPRgohc5JT+56atxGxX9TJ1ChVy835X
4kBWgOzSqvdxmDIjVzCx1OH14lbyaGJ4NBYQ5Ied4PEB3836R4ZrKkLeBzuC+IMa
rBRwAwy8+hRxN5k51uLK62ditZ53J1UVR7sYjNxLrZlBrbtk9Z4wDhjhmiZPynru
sNZMjJTpKYPGaGDKnJgeH1SBGny0YAijHYEfQ8HL22Fzg2iWVzY17d/i/n9+3TlV
E9vTkklxRnvRQ4pEiiUEk22eN3NFX7ELs/glfvoaflunK7WHw94uyscwlJydVPQe
oDojr1PpLgh7l0XiCt10Vsu+70I/Cw==
=9hNw
-----END PGP SIGNATURE-----

--/FbvQND06Foej1RJ--
