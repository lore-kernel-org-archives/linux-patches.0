Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E793AEF25;
	Thu,  5 Feb 2026 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770291547; cv=none; b=Vh9+USHjFlOny5Vkq0jZOM6MHozDNvU2FLV/HjnD6NMeu2FJE8Zdzu3SUCnbzcv/I2PEoxe6Gp9PmhCZmnRykPGyS2hRe0jwYS/c14plLfhbC9stgOsYozDzdyDQsv5ioOtjX56iSe3cEjFURx/zRPTRK9hk1tre6Ub5QoyJT9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770291547; c=relaxed/simple;
	bh=Bzuu/OEdA+6OKeUhf4P8qNDtactIHkJnwfQJ1suD4fI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZFrfne+MEi+Fe9zWUvGRgc+7NWxd4Yh8HwFnwtYTntGSBlDZDpP4cvYuIcKYC7mBHZuO7PfWohwRVYEraqDMHUl2HKriM7RihYpfzVdL+iOUqYfBaD0L75rgczcH1G2mPrmhnHw3JQAhKXR+60C6RjSIc/TYzqMFS9gaqb5o+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsi1oZy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsi1oZy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B5DC4CEF7;
	Thu,  5 Feb 2026 11:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770291547;
	bh=Bzuu/OEdA+6OKeUhf4P8qNDtactIHkJnwfQJ1suD4fI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lsi1oZy6B+KKWaznQ72Vu3URKMR4OlvCs9/5vuG8+AmF5cFkvCVI20cfSJa/tk6xb
	 98sPGVcMzNufytwSWHMj7I54fvU7nfqXaNcfMNiIKFhRwgFz7ZW3qDBgIK3ELfanlP
	 HDMpZJjV2x5QatpyQbU4UBkV4dAALrUsL4jMXM7wo1gc0Cl/GCd73DiaGAuFNu/0iU
	 a2Gs9JMgD6jLHOO8AK4aTK9BJ4fbkSdPmtNIsh0ukXH4ZmX5dyPzDmxT/q4y+fDLH2
	 TFvJesl8CU0Otyz5sLsa+jf7s3LvYhCbMKEPWxWhppCXNYlMFwERHtgRJduXIwHV3N
	 45xY4T8pDSCZg==
Date: Thu, 5 Feb 2026 11:39:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/72] 6.6.123-rc1 review
Message-ID: <04a88611-de7f-45fd-8767-4752c1f53d0a@sirena.org.uk>
References: <20260204143845.603454952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Rt+pOEgIJYS5xE1u"
Content-Disposition: inline
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
X-Cookie: Non-sequiturs make me eat lampshades.


--Rt+pOEgIJYS5xE1u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 04, 2026 at 03:40:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.123 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Rt+pOEgIJYS5xE1u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmEgVQACgkQJNaLcl1U
h9CU+gf+LNQLTFala0els2idtfpmbrRw9ADZppxsSwte9zydBSj2kCvYYhzkCL/N
cUapnPtcYGat2vylYcNW7dsP8X+QhxGpmpvpLpKarkUW7DU1syaQJXA3q+D82fG0
PhOyCxhNTIxTe6xRHCeFFvXP86W7BYmECr9GwYrAzBAMcA82WRK92ToKe4VDo58D
ZUdwj+kHA6zXdie0DnK/yZyV9rEZ6W1COXqrshWKKYWvZf3Al0QLxfqhyiAodnJV
stBP3Gr/DTPUyQBd2Kf79pI/FfLc5ajeYl/dAq1tcCgK7LusnKKj0HX2j5NlZgsz
dTaOrZheIcIkEwQpzDbEfO7lHQurlw==
=nv31
-----END PGP SIGNATURE-----

--Rt+pOEgIJYS5xE1u--
