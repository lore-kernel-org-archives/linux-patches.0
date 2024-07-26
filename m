Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA18B7F8;
	Fri, 26 Jul 2024 11:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721993739; cv=none; b=DqQD+CuAJn+SY8Q/rWImYvqHe0YVQjDU3g/yKl2tfAMM7IUWrxHINEhvPtw7P7AKqZMena+CLpXnHMLwI61MRXL6r5t9yIrQgTA9xF81ut1IQPumN87DOE9NX7ZgLGmq2YH4EtWJwtpdwHY0O5tFT2q+/qZ/rcKWZB5vokdkVJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721993739; c=relaxed/simple;
	bh=LD7TLNNtkKxXJ3/zNuhaoPP6BcdevAO+oUiI7KQbCT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vE/nfPizXwcPMo0xeqNRSw4K2/N/NK20wLRqux0dHkILTwovx33pBUeEuch1HnZbxPOv5heEP1MgpKc0lfr6BgRx9wbxOAPH1JVLoX5fMejDOjbvsbnYBxcyTZAEDQ0o9GwS4w1OGSrTrLrIW90niJgb8GYA6C0B1tB644gBMcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gg6Z/0X8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gg6Z/0X8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2908C32782;
	Fri, 26 Jul 2024 11:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721993738;
	bh=LD7TLNNtkKxXJ3/zNuhaoPP6BcdevAO+oUiI7KQbCT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gg6Z/0X8RWUhY9ZNZWcD3pKnQDZ7h3u57s34tltr04mJZiKU6UuLQqGJ3moIUg9sa
	 8sYfM9oSR+Fht176j0W1bQyfbWX8IBkp/SOppMGNfiT4jA8MbZ2YKihvQ2SYN76r78
	 lFRTbmZDSp4LTFTC2mDpf8A1Y63swOeQTWcB9kBMR7Wl4XRLB160oJkcLGLtSsmGmY
	 DBTpStJSKuU+wQ8n+jagrvnZaRMXGtux31pzgAgqAQNHLtfApmxkLurgtb42CMsjEe
	 g5EGEKBu0l21Qy4mhfKhJcviQ01+O1ODYm0SkeYiyj1sZeoS9hZ80WLyG7FWfJ1+Bt
	 noMtj70/0CYiA==
Date: Fri, 26 Jul 2024 12:35:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 00/59] 5.10.223-rc1 review
Message-ID: <1b75abb2-6ef7-4d58-8d47-e169dc2cf7ba@sirena.org.uk>
References: <20240725142733.262322603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="T44G+3X3pqKmie04"
Content-Disposition: inline
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
X-Cookie: It is your destiny.


--T44G+3X3pqKmie04
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2024 at 04:36:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.223 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--T44G+3X3pqKmie04
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmajigEACgkQJNaLcl1U
h9Aqsgf+PpE3UYFYkYdkLzEyhr5OO0Xuw3tWjM5JZ1G/gZtuZMV5GT7+pdGOnTQd
PsVH43ZLmIYgOId5hKKehxFkI3YRx/2vizxh9jkDlsEgHz/dub5FnBIM7BiYjf16
KPSZHmv+qy5zYMRMQhXIfXHDM3RGFCgWRFmJYjPyG+P3Wq7/xq2sEnYjsmg93Hvj
KDOppzHgsvhs0c9iv2Ro3PJXVurAxihynre/QMa+IN+/zp0m2V3/io/0o9oB5wR1
RD9M3QXYdmq/8ba7B0wK1fEwwocXMo/vyNnRfvidym4eoaVtnnPN+/bwEEI4meS4
4sMwoUA6JDkha6LdNX61DArP/ybasQ==
=vMJH
-----END PGP SIGNATURE-----

--T44G+3X3pqKmie04--
