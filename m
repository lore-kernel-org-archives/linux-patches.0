Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C402F2D46DD;
	Tue, 10 Feb 2026 12:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770728396; cv=none; b=Toh98pUvRBwevL5upw1BgLHWcl9qHhCXk9DESQGzMUz01aghSTOGbp/Ic6Ua6pZ4W1ULwn5DViJ+1wcn3r6Bg3ADcpwtwZDoNEO94VS0htGNVFOb5yM7KRLrJmqPjzOjM/80b/kyg4xTAd+KNPL7OO6rwmmfT4Wpx/D2K+vRP8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770728396; c=relaxed/simple;
	bh=0/7ndOTSZvCBcktlC/GmS5pJnuNUOBDTNeT/SdwF7Tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wij+ldk1rhSjeiBw5g+DOxGnDFEz1SD6eWcckgEs+wm2l/++ceCj9mZWh73hZZvndAT+LASsDLtSt8N0CNkVu6lV1vYKx7/zs8WXWKyQQqKbO2P348KviAAfHTGELN6zjWjg7FIDCjSQLtf4GnnxolS1hDsBpstd/kLe1yf/vHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFecSo7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFecSo7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3750C116C6;
	Tue, 10 Feb 2026 12:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770728396;
	bh=0/7ndOTSZvCBcktlC/GmS5pJnuNUOBDTNeT/SdwF7Tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UFecSo7LAV+pCQVpDNi6MMPUJhvSbP0mFgJ9rvgDTA8+dKTsUhRxBKdTU1x/G6yQe
	 vGZeUAhy7nE+itUeJqyXnkIhf4vlrlNLCAoQcXO8SdtocBgDVDV1rUo/UPzcda9Fn8
	 gV/ApNd3kRBDFEWutW/fOquzfgcGw3AriqTs4vM7NmTlJ/VYO0IF3SYKBHjaCl9mH+
	 neTnhCA73YAYDJ2qxamazCwcXFf5WYksS1g0zrn5p3wIFJKMVOwylaAPzydyuuro9C
	 Wj5Ce7sUCx4KCMDbyu9qF3pMVmS18jOnIGXiXMWb6C3oRz8hCqAwW8iSkV2RQInhf7
	 S9//F1k5pUfAQ==
Date: Tue, 10 Feb 2026 12:59:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
Message-ID: <1e3cb3c3-c9da-43a9-8600-81c8c0d46de7@sirena.org.uk>
References: <20260209142320.474120190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k6N0zwBMXqFw7ere"
Content-Disposition: inline
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
X-Cookie: Spelling is a lossed art.


--k6N0zwBMXqFw7ere
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 09, 2026 at 03:21:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--k6N0zwBMXqFw7ere
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmLK8UACgkQJNaLcl1U
h9CWyAf/ekztqf1XIExfD++iBBCaR2YcUCoxGOR+SQMsONe6DHou8kQvyIXjtr+E
k05g7sycILpPXmjd/aJPAJFfxZsbz8ZJf3WcxxhZCPumlVtYYQXH9pzb0QhaKLV7
NjEJfW7RkVQN7s6+s/OA1Ejv0WaR7lWKcQAh8QPDydeYh0nWeZ7aFy43pUhO3eii
BL7yMT1BZym4VBPn2RSMGCKGRvI+vF15U+DbcOqe6OD31w7KGfyj22UADV4DEm7n
Yzoc6ggCpTJ2/wFT/Iv3y05s8+eC64iNN2UEU3oJOuL2SgsA9HrwXefQgp8LhZdS
sVHt09CVb5EceB8rLjLRe+R+gAcxZw==
=GxoG
-----END PGP SIGNATURE-----

--k6N0zwBMXqFw7ere--
