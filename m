Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D569B1953BB;
	Wed, 16 Jul 2025 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752662293; cv=none; b=nPYfX5HeWDeu8hpvAvgFNBBU1m894AKfBXZMh/ONTV8sXqqbxSWlU1o1zoDgjCdbhgB9qirQ0H5NQHPEyNPTaXzD8KkXybuNtEyQebNe3GaydQa/u4qArJGPNBnW/2yasFaSErfNdfLfPIRa3Kc/81dwqsozelY2vKxvhqOx9kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752662293; c=relaxed/simple;
	bh=Giy9twegHvVp9tB/XktoHGZWJLtHODjLeTrzpsW4lsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cW9qXa0r1Y8eTHoMM52qanqG5LJSYLv1xBgR48JLOcSSrFX+MopjkTxSOAu+tI73WQJ3Tja3zA0xrFll1xfW3YZ3TzDVF/M6pteGtSfle32kWdSWTTQ2N21z7A48YyQwik8rB0y8UI7IcVwbV+jPtAWt2ORkrSdTBgiCaOYg3Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIqMt1cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIqMt1cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C0DC4CEF0;
	Wed, 16 Jul 2025 10:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752662293;
	bh=Giy9twegHvVp9tB/XktoHGZWJLtHODjLeTrzpsW4lsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SIqMt1cvbSnTPCaq811I2Bhdg3zTtLg3fJy6xKjfGjnimLSNbp7MD7PGsTA786IdR
	 72QF0eIMpHK1xH4Y5Tu3kWYXzSgosw2nscRrtI+vTIoe9hjarHecIrQkKowzbEEcjb
	 g6u2LVhd4cK5Q4Uy/X6KcYTZhyNoSLD61DXy6WIwJ//QcwDsLeEWenGpcY+sQDsWSc
	 O492TMWkynGSwWs6extRf34FnCAWp9YWLHHW8gbV8HkxM0D1ssob6DBOh1odThKf1w
	 lGfO26cKEZU/LpijqPiSPkju/ejp9cJAJPq137akKnaN+s5fT4zZBBYDg4wrdojYyD
	 umzigB6GjYXeg==
Date: Wed, 16 Jul 2025 11:38:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
Message-ID: <c003b980-5a66-40ab-9ccd-6be52f8ec4d4@sirena.org.uk>
References: <20250715130814.854109770@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="U6jH5E3IO3KQASVI"
Content-Disposition: inline
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
X-Cookie: osteopornosis:


--U6jH5E3IO3KQASVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2025 at 03:11:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--U6jH5E3IO3KQASVI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmh3gQ8ACgkQJNaLcl1U
h9B1Bwf/WgbN0B2A4YMv/1GADiHFkOrS9gwB4Nyhx3wmL3fK7bMIxiFZQbTmO0vv
xC6riR5XmfZ8ntlnnhFUS6YK9nAkdz3WcQUygf6wz+5yhusGF3vQQhtQShHlSY6u
pg/Sb5fcL/M7GQcnO6WLuOxKX7AHH8U86PQn8futB2QJejIaHdN7mLKAmYvQSVzI
AsavzFYY/VVAST/Awd853IyV/Ag9GUgmdpY631mPC2jKw642v5qA5fmr2RyewfZd
n5mW1jxJ1uCG9BJD/G5fLq9OCNcCcHj757P24wsUEUwcJ18z63P81LnVwk7rPw5q
6D9rNQuq6o2PBLpRaAjIZoYHDPwtvQ==
=BPp3
-----END PGP SIGNATURE-----

--U6jH5E3IO3KQASVI--
