Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528CE49638;
	Sat,  9 Nov 2024 01:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731116635; cv=none; b=tRNnrDU27K4LTq2I/fC9PS62FHNqP2+eofCbS/FvfNFZYeBdLErYbiFVPBZnWRaTa20ABPZZ42jAvBrYDSl1MbBpKbaHEItmUfucoC47A/WboO/FSDLv8IpCzE7HYZMtchudqQeEsTPlANOt9XPHkEEfjworcHBOE1hWujz78x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731116635; c=relaxed/simple;
	bh=+sGgH0FFnKGEe7Pugli7z/v8f1d76lkdTtqOR8CYkZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNXa+xF72KXn4xBA8G/KP8qVHhQOHoKpFUfyJpcr83dU4paUbnwOYkfmwjLqY9YZ6KEqw68vZDaZObionfXcTbWiZIwtzXVj0lW6Lc3dbFkpDBJaGWfoYwylxDk80PVeZHVQYbZdevqIpS+c755TVr0AtMQxQYX+LHsmamqhax4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyO8Tvpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyO8Tvpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D319C4CECD;
	Sat,  9 Nov 2024 01:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731116634;
	bh=+sGgH0FFnKGEe7Pugli7z/v8f1d76lkdTtqOR8CYkZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZyO8TvpkkWEQQhpKHl5AtVIun/tuW4C1XRvAY5xo8l/cALv0fA9qkoiEA1/dVS9D7
	 ZsrSMYC+LMEgqWyEkosRpzi6JULccCsPeiumxjlx+/6lh+dKMdC94fk4IVgzR5/w0H
	 jVsrUPWZWkesqqmjiYezHJW/R3HeutmGeWKfhwRkEU/h5EqH4bsrLKd0ZaLwOyxls9
	 Dmc4IApLMnPxDhNJEmMeO7eT9QWT0bzY2yOfzxSu9tQdf+rPM7TkjoGncs9XkqEjT+
	 twORTM6lgo7R9n63Cn73420T50Dtz1I4hjEZTcO4MN2ik31NtWQHPTDPDuqhZxPGYD
	 p0Vbvp9eE6LLw==
Date: Sat, 9 Nov 2024 01:43:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com
Subject: Re: [PATCH 6.6 000/151] 6.6.60-rc1 review
Message-ID: <9f5eeb0b-1dd9-4af6-a52f-14591b0d735b@sirena.org.uk>
References: <20241106120308.841299741@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nHo1wIfmYNVZLK31"
Content-Disposition: inline
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
X-Cookie: Do not overtax your powers.


--nHo1wIfmYNVZLK31
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 06, 2024 at 01:03:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.60 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--nHo1wIfmYNVZLK31
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcuvlMACgkQJNaLcl1U
h9Byswf+OZMkLHSw9I2jsTxfIoYPHMyGJkfKoZCa5FCVXFMURRA4pqWcfyWFLKp9
eBJ7OjAwdnr6BpSudX0Cp6kqCQMEOf5eun6nsR/3PQG5ulOfs1XaAGsd+wN52DGM
CRyzIX8FL9qWeaT55vpLAbyw6BeHEkaIFNalJWEn8elIkoaNDHfKmIYs0pSycYN9
aUpXqeDFoKOPbPD+ENY53Zn3cDNcVABANtuEPq0PqAjB9QSwEYVerVGUTEwj7/yL
eHoJb/NMbMX8Jk0zRVLhrdT6862VFk/n0nPgFeI10LuiVsNLCOQInoVfekOOkucd
7HjeAIG+4iXx2sCrstngm64IJePvqw==
=PtPi
-----END PGP SIGNATURE-----

--nHo1wIfmYNVZLK31--
