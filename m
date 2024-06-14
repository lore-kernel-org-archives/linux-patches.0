Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A33BE5A;
	Fri, 14 Jun 2024 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718374494; cv=none; b=beZ7Z2oiTNc5o9XSk9Jwv+FazrKkGySUElVo46JZRYjJL/+tYsz3GK/UdxEV1L192fMIW8A1mYOQjAK1Sti72QW3Zb9ifi/RPn8jT4MfzNqS2bVJjSxTAUW0dRElzrvEjksMOBAVOFI+sj6UA29TDz6tQBSfyYuFAwEFn0KSuas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718374494; c=relaxed/simple;
	bh=9w14X4PUB3jOaFtvIvVRObrP25eIa2c8pFntEXCq5zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGJ8nI3q7Wcz2/yir9OoJPNlhOWQB5UqyngYWAKuXhTt2xwmJ8ZPFu38js5bjq6C+a5DKQ0RHQUA0v2Ee++nVbmI1AZs5ea4rwRDyvl6olpI0AIFH3HvOiMSBx7dDm34oh8Xf8kG03EJxX9NTHH7JFmUDgKtXAevP1XeJgfpuS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/gIhrSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/gIhrSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD62AC2BD10;
	Fri, 14 Jun 2024 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718374494;
	bh=9w14X4PUB3jOaFtvIvVRObrP25eIa2c8pFntEXCq5zQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T/gIhrSsNXv3NK6WEYJ2IXVjSXwXH11BbbJVtbmFNOQeKFsScHAC9kxtBneYFonTt
	 H5ypsHzwiDwWHjGmbep9cvvOWgdMMQzmaqpBQhtHNFr+udrRhuJpQTie/kBOX2LBur
	 hvS58LWy6mi5ptNujd1AU8JyRuVFQxAc84ZcoZ+QU12QQtGQhEgnR4UulT7TXRtIhV
	 T/ab0umTWiyz9uhhmhMZ2eQRHZKevfqWF3+7SYDeblKFHJdHIaNm1SVPLs1NZB/+iw
	 xXClc3QhswsBwskpsbZfZi+/XVmgcI1IjRbTmRyZcbCZhz2xyvZQB2R/T+J2lBlHEe
	 2TXK/0lQUmiQw==
Date: Fri, 14 Jun 2024 15:14:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 00/85] 6.1.94-rc1 review
Message-ID: <ZmxQWvagNLsWJ0VF@finisterre.sirena.org.uk>
References: <20240613113214.134806994@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="baeijIjUNt8JFn9L"
Content-Disposition: inline
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--baeijIjUNt8JFn9L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2024 at 01:34:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.94 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--baeijIjUNt8JFn9L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZsUFkACgkQJNaLcl1U
h9Chegf+P5JSxsIsLw5zLadTcKId6cbeN9kfjJwe294vqeiSXp68O5y6C6rW12BE
CLN6/cC47WNvtNzKFnaxkyYay2nruz71DlWCM1caBJgPCNLh8z9KcEDbhCmlgcrV
TPNiUn/sGuoliAjKPLrrs7f8hbVw7449joMJF6k+KzRaGhFe721G0F1tCkuGm5xi
vwWdz+szDL6nxppTX7Fytt8y7yCKA9aRyIg28OUAM+G4iWD3WagKwA7JXAhUwPE1
zDnWgYVUx0WCqaoguCAg/AZJab3vHzmo5l+sJ9Bt3yZ2nFo3yRqe1a3nzis+17y3
2DEe4MNnloWib8IVZAbP/DGqceCBHQ==
=2Rae
-----END PGP SIGNATURE-----

--baeijIjUNt8JFn9L--
