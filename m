Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950A92F2E;
	Sun,  5 Oct 2025 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759681488; cv=none; b=fxLcBguajWKwjFOg4lo3MswMWT7gtw4PkqYm2m0p4AkHQwZki42HJ1POxR5q8J2GMGZtwxJ7W8v6MgInu6FoSSDOsIjT7+UNuSDujlstWsSM0rD0LOpD+l7+h7GRQTWpC13ICc+49k9ABZsImLGyjgOhunXN6UHfCgxNT6pE2Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759681488; c=relaxed/simple;
	bh=9+hpfP69M2Ej3lHh1koZ+ivKbp7SeX9j6wr9nZxrl7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBclZEh1d6KMy/iekccuxIv3KYOSQRzVLp8Mo8ti9gJv79tIjCOZ8p+H2LEvf6GX+tJAELUNpv799K+gE0d1aduV0i2Byah75LNQUtNN065eoxdK7GOe2EGXCCKeeMrP/HzyQIxkh4M2I/a94sA7ugKV0uq/gF3bTcp8fw4K3jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d19qAI3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d19qAI3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D01C4CEF4;
	Sun,  5 Oct 2025 16:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759681488;
	bh=9+hpfP69M2Ej3lHh1koZ+ivKbp7SeX9j6wr9nZxrl7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d19qAI3mg4aePXd2ng3ixgwP95wd30nhRO17aYfJ9XthX/yTHjHK2fVC7GuEa2S8D
	 KNmsTOmi1kBUkYtfON/tyol2n7CnYWM7/q23Q9gGPIrLR3A38m5/KUd5NyTB2l8v/y
	 mHD9E126rmw8+ojX/gB2uf1GiaVkmnkyoPbLfRbVAsjZPsMbWHgwwIfLOUSFA9vaem
	 btgIpZkf3LRuo0M6p2FkHdKKFuQaQlt0txy31IG+2TYvgU2iYx7Lxzs6WKmMtWmiZm
	 MiEXHZXXTX6XWmUYIHdxdMdYH7bPS47AX+t5DXHulB++2kW1gHY0WCoVlJ7KlpuMbr
	 REjKqV9uvgWsQ==
Date: Sun, 5 Oct 2025 17:24:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
Message-ID: <aOKbzLGzVpmJaPjk@finisterre.sirena.org.uk>
References: <20251003160359.831046052@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ibjF+CJc8CdDAfhS"
Content-Disposition: inline
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--ibjF+CJc8CdDAfhS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2025 at 06:05:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ibjF+CJc8CdDAfhS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjim8kACgkQJNaLcl1U
h9AJigf/UYK8wD/zetjKUCQMT4FJF7Apn6GCbIjJeX1JQDIXEEM4KsONkyUPJFjm
dWBZMZvogs2gYg6ZyVOHIi1UuI/tJ4QUKhX6MKoE79JLdGVuiWvMrxp0YFkpV4xq
Uhehu5NyIdQpabPWFfRoZTV9he4npi9mx/LUXsIm7SFfavhOeFfYd9ZbMWPtlSwQ
tx0dBQOquicS9lOgSsUkB11UoRW//dAgNnCDLQS6xWZTxTrBRZCjmuZGSPeRLLMc
aySRvajP8tBW+eGM6Mi2fHiIIJqnPpd8KKWJLxSFdyBqpUYtDFWO3PpX5ec61vFc
9VzQfUlrpTB0/daB9T52/oPty5o6KQ==
=QaYt
-----END PGP SIGNATURE-----

--ibjF+CJc8CdDAfhS--
