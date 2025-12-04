Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AAD2E091B;
	Thu,  4 Dec 2025 23:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764891928; cv=none; b=RPwwNdh3a+K5vz/qfuvkmBrVgIb1js+Op5ZID5CqE8COZCqf4RCq0LjPXxHuo39YotMmgTdUWAk0e9fMYNMb8hAESdvuc+VEpfNNzbe8OvoL0gUXE069pDGboLRDII9K2mafJ0wj0VgZYmM2r0yFedf+J6Gq2ChvMtgNMb2ASBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764891928; c=relaxed/simple;
	bh=YIuuNYilXTvWMYhoAXfIbIGu7LsHdxSPU1LWhwPHs6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8LVVgeWB3xV/t/hOnXZLQ+Rsrqh8Gl6/c839aAr5L4RXg1o/Dr/IwwTAMSfZfwj1DZlQi6GqPLwDNWsvBp7C8BHPMUSrRGvKLujrL7IudvJXHhv6tUW9gMq+aLzN7fDy3sUQJkuc6vs7ZIsy0JSnlj4BTDHwOIoZkkgzmupy1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFxoNdun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFxoNdun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424B8C4CEFB;
	Thu,  4 Dec 2025 23:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764891927;
	bh=YIuuNYilXTvWMYhoAXfIbIGu7LsHdxSPU1LWhwPHs6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cFxoNdunX0cNPQo5ZbipKKDjSpTYYcIkzqrQT7LATV8+wTA6GkFknEYFFgu+bf9lR
	 0F6IdCy9m1pqXM1HnSQ/Q8gd1aEFNf12uMtVMFD8Rw34bCYbeA9ZOACpq/Ibisvg7S
	 AM1pkO1ujV8IHXmm0bSLjZmYXei6SkAEw5mD9q/BMF3naOePGBMY87f10ASfY6628l
	 uk5II5JZRdN+xqZtKwugtDitpqiILx7DGgLt81Wwk1e/jqozyv598zzWmW5WrRog7D
	 oGabdxS1yEQrtk4folwOL4F/l/EUeUmYmeDxgssoJGiWtOYt09NVnD6MCFnffQFTa0
	 IIfTxsbFh5Nzw==
Date: Thu, 4 Dec 2025 23:45:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
Message-ID: <74a8e607-3549-428d-9322-3d69d4d600a9@sirena.org.uk>
References: <20251204163821.402208337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VP46MTmk881CP7Vq"
Content-Disposition: inline
In-Reply-To: <20251204163821.402208337@linuxfoundation.org>
X-Cookie: volcano, n.:


--VP46MTmk881CP7Vq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2025 at 05:44:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 387 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VP46MTmk881CP7Vq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkyHRAACgkQJNaLcl1U
h9DNjAf+NvL69nEVlJnNa83veA5aEveKx1iqx0FBbbHuFmbO01BsPCLcbrVA1QxX
XURIMh9f5ZlM4jxf0IDf1W1FI2xae/lv/l5zLGu+cl0booiupQJH9E8EAenNGBk+
H+XRF7RcufigGk9cbA+HRq5zwVRmekx3NJyD8FTVGE0tSMCYNi4UipZ7pvDNbuQj
ou2x7a5pw2jmJuBrxXjC6ja+7erPJ9qRTK3uO7Uti8hcrKzU2+LKHbN9KaXPF/Pk
VIzWgokzrCHiO6sTTuGaUxEwC0/4JDcIyyhMvPZR1mlNJN05ZMg2kZ55HnTkP6mD
jWZgr31cBAV/48fDHRFrW1osCcJj7w==
=+Ae+
-----END PGP SIGNATURE-----

--VP46MTmk881CP7Vq--
