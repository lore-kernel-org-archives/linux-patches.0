Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4DF2DEA9E;
	Wed, 20 Aug 2025 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701005; cv=none; b=iYAChFqzf6dVfg8723vxc6xIWythQoAfcU9jJMLaCKulr4lmHsw+5vH02aD1ZeBXH4cy/JWl5erVOp0wXiUqec22ybpTrSd8ZlJcyUFdaVYVE7a74HBEa0MVmNbLYyAf9ghpxLeKB0tPMTQw5jiNhLAY847O76wtP4/1jB1y5Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701005; c=relaxed/simple;
	bh=TVyqAws6QuuknA4pH98NxkvPs/O8JZq9ZXjSiLwMeQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oLyhNMm84Vak0LoyfQ4w+lfslK6LcM1XrqWpU9a9UQ6GnUQjNi0yPtyOoDPafiNsvnWXtkngKFEqaOPfbDiC6JYNa6atRI3nYruuj0rMIFdTbkQUxHg9IwABepnLuCG26QXVn4Av/ppggNzY+x+wVUvxRBXYaKYdjqiFw/CA5dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejkJaNDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejkJaNDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAE7C4CEE7;
	Wed, 20 Aug 2025 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755701005;
	bh=TVyqAws6QuuknA4pH98NxkvPs/O8JZq9ZXjSiLwMeQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ejkJaNDrX3+spM8sWmGt+EdvjiGp930EZRM9GjefypKjGybT0NJsrw8QSMWciy8EY
	 6Si4Ww15DYjKWuhcARh5vMX48nBB8uKlFGBuJnXfKx0loJMqXNMi1JG862SNsjJqcH
	 oIF/Z+u6ALVxa9pYC+nzn7A8noVXFs0kcH8uQki2ckFBz7B2QQxo0eNG3F2y+/lsDD
	 fSO9ve8XuSJ0/joFSvd/PD1CnI1l/4oodCUCJPsAhp+/lYHTP/nxb4Vllwy3AEiKtU
	 W5X3zOGkYzt4ZufCPROzsbVat5jIXjxEgkUXUTuDaVpZ181UjWWWVEiDE7PDqQ0Fav
	 AgZceSf4jw5Jg==
Date: Wed, 20 Aug 2025 15:43:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
Message-ID: <3eebf8d8-fc2a-4e33-b884-ec02e012d91b@sirena.org.uk>
References: <20250819122834.836683687@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QmqCD+huUMrWYrQ2"
Content-Disposition: inline
In-Reply-To: <20250819122834.836683687@linuxfoundation.org>
X-Cookie: Semper Fi, dude.


--QmqCD+huUMrWYrQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 19, 2025 at 02:31:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 509 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--QmqCD+huUMrWYrQ2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmil3wYACgkQJNaLcl1U
h9C7Dgf+NUgspRQGQvh1DYTcjMVkGtbVvoF8MTvfFaxFQaVjkhkIb8xSi/djvIhj
Zqfl0HYcYGx01pR/WHzXb3yW1E3SVzPvUWO7BCsYn7Div48lAXo7Fked426snIeO
LPxk8ewr0K3FZkIN4PKCxggm9I1PbHXbvLk9tmRWeZoqGqNAZnUQGFHJfcHPbUjt
MzGJ/bXXxHixbY06Wvk+ch7lhvdL1NYkxsZZSA6JByAn9QN6/7HYJpJJ0i+Q/qrR
NEVKwpjt2cyvAbuADdXQ7QC5aVi88DO058H0oncuBDttwlZlS95USfZW9j7KxS0V
TmwyWzpWej98wxjAe/e/kW92B92+Rw==
=UED5
-----END PGP SIGNATURE-----

--QmqCD+huUMrWYrQ2--
