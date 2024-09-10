Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4078617BB3D;
	Tue, 10 Sep 2024 22:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005915; cv=none; b=O0n+AqwVGZ3l5gRU14Ipoc3AL+ct43bbmjDhedjf1jw0ytTTjssi37wgnzJXFETcSiax1nFO2ko71peCjLCFNeGHitp4X0fPmgK5ZsP/Hi4K9xyYc8xV/y5Oz9pK2jV/Ttzlm9DcZYlR00rm4v+WINdJg7pyClNbLu2LKv4lnz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005915; c=relaxed/simple;
	bh=NRLEHkoUp4iA1+zIm4JewpKZibG28aKp1yzvDTqM6F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wbv6rzLAxJnHH7RNsEQwu7XKcqv9P4IL/UQ4Bivy5wOGfrB6NEEC3uQ42p/Fcj+9LKGHPig77BSbf1cHuwIDRk0f7qgdyJ4lgNlr2STgOdRraEz0BT3781eewl0Y8wB4tFNBiBuMoh8D6RiVR7J8KoCyRbyeg50bsY+Q2cF59fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfpDMTbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfpDMTbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC21C4CEC3;
	Tue, 10 Sep 2024 22:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726005915;
	bh=NRLEHkoUp4iA1+zIm4JewpKZibG28aKp1yzvDTqM6F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QfpDMTbzaIFpaCUfJciulQOrsSBF78SGRfK2Cxmt0YGdI4vpyzJftvvrKD3v4vS1E
	 xoiHPaerNZVdaBfFzS+QVJjePMvaESihhtP5EWnhOQ1+B8F0qOdePDwlM9txshaJSh
	 XdhlEpgVg8ghClMj1Jh44vVneN/T/Pexqx1TpoqnjOHj6FSaMwavfe13aUAnkbFWMS
	 OiXiRMTyaqhGj8Wz2xo12o94/qypYiOIi5YTtHAINI/5K0FOmD4vjpIibWHgcScR9F
	 wHM5pGBihAvuf7aoF/2VpmfJxq2z37jkwtJ1wVohHdCQdUnZVcE90OQoZbzfP4dse/
	 /EES3xDlZhomA==
Date: Tue, 10 Sep 2024 23:05:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/192] 6.1.110-rc1 review
Message-ID: <ea450041-b282-4667-b29d-22e633e2f034@sirena.org.uk>
References: <20240910092557.876094467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RhBarRI6VwanoEjX"
Content-Disposition: inline
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
X-Cookie: You're not Dave.  Who are you?


--RhBarRI6VwanoEjX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2024 at 11:30:24AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.110 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--RhBarRI6VwanoEjX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbgwpMACgkQJNaLcl1U
h9CLswf/SxTNjChCzJGQauDu4Yy+LP1470itfUPiXzilyZpn9fY2qrb5Fy+VjNSO
UdeCMgdUdXLJgSpysdmo3x2L6fPUGE0pY2Aqd/AZ6Tp1tUYXV2FC6PSF0GTUgmf1
gh1t1qFKLePZ2qKAbq4Nk+NChWHNB+ELYxs0SmEJGoa3sXiYVK9dEtI8yHTN4Sox
3a+6kVgJJu3dqSXOUS+eo4Olbrw1eY7+L6v7h94WG5/LA7RHvnThp+3bpEz4nuNI
zBI42PtYEGS83gtDkBis2g6ZqplvZv98EmivjVFWx5Nl50UckaqCvVlVHPVatHqK
3NI8nkQZRnxEkQNX8hZ0OCGQD86Ymw==
=R0/4
-----END PGP SIGNATURE-----

--RhBarRI6VwanoEjX--
