Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD1127453;
	Sat, 29 Nov 2025 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764378125; cv=none; b=T3w2K17h3q4xkes56WLfMhJBMXhsDDkxp1qhb/5Hf/DdJuYuLjvjYM515dpbmgh67jdE2LLFS1a1E2zjOUr8Ene3jvfXSVL4JSUjYfAhfUf1kVjCWu5M4kKclqu8UF1f6dVP1DWE4cwOJ8G1JMXNXfsh8QPgCDzCsxCIMwX4REI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764378125; c=relaxed/simple;
	bh=lOXnQSYSRjLd+KVrhn9EL3YfkLcIqbWJWr36TZYNdF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMbGRKFAmDCjTL+q1u+f8c4QvrQFwHCbA2IqJZccmVvISUZ2sxChO/giMlzzrOkbYJ69VakTmjys0eOFhkiI9Xi0kESW00lGVRRbbK63hxryNzIKkNy2ML5D6WDxj7YEDW+pZab+V9IEfpTAVJuYkKEzSr0LJgl8IEvivo5X11A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cI/zDaXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cI/zDaXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A31C4CEF1;
	Sat, 29 Nov 2025 01:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764378124;
	bh=lOXnQSYSRjLd+KVrhn9EL3YfkLcIqbWJWr36TZYNdF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cI/zDaXTNkw8OxepD/pZwC4y284cX+Mxb4NDyLlpm1QVnFRzf1tuLwoocFvtilMW1
	 LNsKbG56N6fW70Sslh1+yDcpybfqBzVsqivdVxlGFsFJXm27OiLsY18xp3vXMLyyzE
	 L08QhVmdePIDMakeSxMWUyd1DL5YrSgXrtH4VMwwM/o6il6VSQFL4D9oCV/1BThgXi
	 jO9FtjxAuCTfBKetFY2qs2a+2vIxaZ1UQGoTMI+kkxgNee+VQrFz5VZ3dYCFuWeOhc
	 vcGXQXd6DamB9SHCPIWCHCADLt0MJlgdVMYciYW51HDIYqfTI9WDHhduXINt78fUwF
	 Z/X7maKxwuSxw==
Date: Sat, 29 Nov 2025 01:01:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com,
	Sebastian Ene <sebastianene@google.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 6.12 000/113] 6.12.60-rc2 review
Message-ID: <dfee13f3-8c7f-4bfb-8b73-84d32f4ada6a@sirena.org.uk>
References: <20251127150346.125775439@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="K7XtjsEt5ljv5XD/"
Content-Disposition: inline
In-Reply-To: <20251127150346.125775439@linuxfoundation.org>
X-Cookie: From concentrate.


--K7XtjsEt5ljv5XD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2025 at 04:04:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.60 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--K7XtjsEt5ljv5XD/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkqRgQACgkQJNaLcl1U
h9BOLgf6A0syhIuP4xPqD+2j50zz48XRim7R8Od9iUi3RpWNzxs7bTDlkIHBRHeW
wKcb7QMc66kp3lmHemdTyYEBH+SNcE/Iu6TpZOvc/lWcuN/yuJi+17jdWuR20kWx
4oWFjIrtv2rfBXXKHvu2Oo8FbG9CEv6foYTppcBHeBkqOU2ARphzIFUL1YiIbovb
gKZv9hvIsKHKwVrUlb4nTCp5XHh5Zjx2NDPSHHJODr0mR2zkCPV/n8ckL2SsfVqI
KrbkaO7cnjESWdk3phGXH7mqAbUKQp6bjWIREsw2aYmCR0qAXdhVW8YrM14eQFSr
+Kg59RLp6CPGOhwFOExNxOf0LNSlqw==
=JgIn
-----END PGP SIGNATURE-----

--K7XtjsEt5ljv5XD/--
