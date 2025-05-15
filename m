Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1D72222BE;
	Thu, 15 May 2025 07:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747294951; cv=none; b=D5eRrl28vcGUvDavuiR/AQH/sdHKcI6oZB5PJyQgWpSf0ljDvOKqbZD/XCNHn6y+LUONx1JFdw5abSAae15BTb7aPStj1o32X33MamGUqBVv+J4cwmvnjYe4rMFS8L7z/+ppsKuOYwbc8kV+iayFmQzu0FQzOLPX1CIim/i4o+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747294951; c=relaxed/simple;
	bh=GBbnWPBL5bu78J5Q9wv3xjjgq6DoTEwpwsTgPX3y324=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtI7UriHUHr8gp7v03L/+Yjf25ZOnIRWPQl1zrZw1B5NczD062/JZovfx3RmiOPDaCk/vWlSzivLDu3oKbw17RhE7MeZZDYDGxqf96AkvpUAs98OGSTRLjg3W0DNAiymaTpz5JaP0BIa3MlKIVOCCUgv1JE5xng90wkxlV9DhrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1D1dnzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1D1dnzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D948C4CEE7;
	Thu, 15 May 2025 07:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747294951;
	bh=GBbnWPBL5bu78J5Q9wv3xjjgq6DoTEwpwsTgPX3y324=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I1D1dnzqnMNJ6OhYH8NlPYiZwkDsPl9R2rkIf2/d/s7gt/zWN5CWiMTfJP7DyZYx9
	 h/XuHF8mp87nYfgUAOoTXY980KFzpODJxwabMp2JW7dnHtABC/Z9uRIRg5eWXaPXqC
	 H9kL/37W3UgoIMT6TMx/35Q/8POL6Fd8DoPTNW/YAFKsXZKMmxRK1b3+C/duUameyv
	 gK8WnYT148STshNkXzOe5vSY2WPashNGKSe2PXvKBQJiKSR1wgTr68ehwFRKOXlbJi
	 08OChXGjWWJhrxJ2xUnRhDD5Br1zJRGH5xGvDecAr8t/Me5eGhCJCDm+ZDChl6+4w0
	 fAWkkLigrlUaw==
Date: Thu, 15 May 2025 09:42:26 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc2 review
Message-ID: <aCWa4oEr7PJNr3Y-@finisterre.sirena.org.uk>
References: <20250514125624.330060065@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ddso/KxKWhEitAKw"
Content-Disposition: inline
In-Reply-To: <20250514125624.330060065@linuxfoundation.org>
X-Cookie: Well begun is half done.


--Ddso/KxKWhEitAKw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2025 at 03:03:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Ddso/KxKWhEitAKw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmglmuEACgkQJNaLcl1U
h9B22Qf+NSb0zhapwhCnGigw74pXTbExdAsiMr6gCyLF333ubXHO3YrQslH99Rw3
TPHLwU1FIPZvjdV23u4eglUPmqG/Ku22HfX2onz95V/iL2c9+YjT3nPUHaNVWOJr
Vy6bEg0WUusYaLvKEgusfVhnMm9It+F5FFBn/FUYHkp6PKIoZM4OUJSUBB9nnztD
TM/EkUkIUCSnfFQyk3q2JZpYD39FndC/ydLSRE2eGeL5PjkAGU174qKFBE+VeWYm
bhTRudaASg22nPUj5Vk3W+HK6fRefKnadkZ3lhFr1VAXBYy6riHzs+cpd7bHev9I
zCwjKNi9ZzsAKu1nzOnhvXdzqlg+3A==
=hjdg
-----END PGP SIGNATURE-----

--Ddso/KxKWhEitAKw--
