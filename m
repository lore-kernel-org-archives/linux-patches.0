Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41EC1B4121;
	Wed, 21 May 2025 11:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747827985; cv=none; b=A9PuDvAhEBonvbwfjURHRYDhU4sMoPraq+ur7q74w3YDkiKIXmAyp1qTfUCsjeR88Bzx4oD4c9i+hFP9LOrSKXLPF+JLSSiJn8cpzNXjB8hDe15nFP8ra1lDqvNqMrZ4/SE8Y02YonKaQFcIPyFc/WiG90q9jZEBSzY/WfIL35E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747827985; c=relaxed/simple;
	bh=FD5Y1TDqkhgOOYsPNPUpiw6qdwdw6TePirC8tm4vxjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjOEtPPA/ahEZibWnHedIw7DTvrEVKesmMA4eUf8ulfD8RQc7MejaZO4EBjGsaHXzDnGwvjjbEGaZ3p7OaiwDZhu993w6pXpE0Zl68HR0fMAltCpCfLIFpJU9DJRtDHixlk6AIP6YO6VyCQdStP5eJ4ecIZt/kIPsAvxU7a7loI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pmK1+l8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmK1+l8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7944C4CEE4;
	Wed, 21 May 2025 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747827985;
	bh=FD5Y1TDqkhgOOYsPNPUpiw6qdwdw6TePirC8tm4vxjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pmK1+l8a0/ABhUzS3JxSsJU44yil2XeO4uouDrrUIOc9bs8pte12yXuOOMeCI3QjG
	 hPwHXTRLtGxi77INOw/O78FCYIHFpbl4ONNT+TfQDfmIicfuPz2LWwvnZNorrpmwhG
	 975q/UmCr57AGinD5AD5qhG/sKXZN4UyFN3c+5jJ0TBr2hIGqN1cKfIVsEShExy8iu
	 lo9mz8kJJowZZzcKyq8ZVCO7gTaAx6SRWWXDoSbVP4m8R9oVKZIlPHuoXp6NbDjncb
	 CpLbKy5Y/4Yxs9vY5J2Oz8yEdFEa8uMTn/MHiSJFdgMFetW4yR06aBhlrewKnFm6CW
	 CcPH3SAW+jtIA==
Date: Wed, 21 May 2025 12:46:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/97] 6.1.140-rc1 review
Message-ID: <cb05188f-d265-4bb1-aeb7-2222694cfc18@sirena.org.uk>
References: <20250520125800.653047540@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e8EDBAZ7PvKgOLVv"
Content-Disposition: inline
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
X-Cookie: 42


--e8EDBAZ7PvKgOLVv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2025 at 03:49:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.140 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--e8EDBAZ7PvKgOLVv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgtvQoACgkQJNaLcl1U
h9CkGQf+MtrlxV+gWyWnS6DczzeOi1bvkl7oi3r0yweIYkyXlsz60rpx4JGpzBid
jk19/dTCsSlEHehGeiux8y7RoS+vSJ3o5PtsADjuwTE3RYwYzZBMKez0QYy+dcSe
EDmHPs7SU2eNjb93LCvtGTECwXwRGOdTPVjZUuzhcPVjmo3ton0vHH+vzqZiXaOb
Jz860VzhgdK6GLukNyKvB+V3nE2gTGtWN4s0j2McgpTkd9vUe8ZnEjnB3WW5Nsle
D1mhy6eN2BkXhbNeT6o5Kvjk8PakN4zjfbVVX0P5rghA8IFazceIYyzmGSTnWp02
Kf5xoc6E1feVOxbHVe+97ITNit9mRg==
=0hl+
-----END PGP SIGNATURE-----

--e8EDBAZ7PvKgOLVv--
