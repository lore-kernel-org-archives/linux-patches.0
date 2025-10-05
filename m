Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7DB25A642;
	Sun,  5 Oct 2025 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759681517; cv=none; b=sYZboRr2H9/83AFCN7f80FhQENNH81eYv67IWrkENKbHtIEq1/L0tcS/T5AU1UECvV40aJSOEFRrBfz9FREdeP5GGKdSJn5HvYgwVBu3a9T0IF8a5LNUIjum3mfmPSAgUgAZ7RZg5fLm4mUjUt7xuZ3fjbAWSelvrXPoGhMABsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759681517; c=relaxed/simple;
	bh=O5cw6AjP+g4Jv2oI7RHoHKpIOvkcfYKLcEW7fQtsx2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eD2OuYitTLVAlUDC5i5ALOuKeHPpwSyGDDrrdcmTZpydUPyeLJa8m9qJQQHp4ZDHxa6+lpVvn5FM+krW8vnUI2+6og22fmGU9xMHU3zF7YcLsJ5jKMtxJ7Nc3W3bZ6dU6B9adDGbs1yqUYW625QPznswxpK6xR2KVCP7VBjRsBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrX3v23h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrX3v23h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80001C4CEF4;
	Sun,  5 Oct 2025 16:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759681517;
	bh=O5cw6AjP+g4Jv2oI7RHoHKpIOvkcfYKLcEW7fQtsx2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VrX3v23hYLJOPdWWdK1Tbb+vwLW0c0fQgQ5kXCHy8WTzMIAL5dyoSL2g0kSb4n02+
	 4kOsckvlrZzww02tX3bB/Cwh74BmI/TJpuzbagncKfOnynojgJ3PYXwQPNUvBFB3GT
	 0HEiiU77FOW7/JtoaeCExdEN0xF7gDEI/V9zYOrDYahVI1B5HR/iglS3mIbZvHci5u
	 7Nsz+nv4mWQcLmyqOgDJf8TszKh/s/XdNKJdfwcDTR9LYUq5jwaxRd4vmCS4UN4DoE
	 3SsaJQyTxCj6wHsyi0GlmQon7E1OCN3EaSgwMelbjFU40l9Z7W2WcFbVtTdeOkV8dK
	 DE6YqTZLjtM+Q==
Date: Sun, 5 Oct 2025 17:25:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.16 00/14] 6.16.11-rc1 review
Message-ID: <aOKb6a3LqJti-zKR@finisterre.sirena.org.uk>
References: <20251003160352.713189598@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="suZIh+RR4STtFfUM"
Content-Disposition: inline
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--suZIh+RR4STtFfUM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2025 at 06:05:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.11 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--suZIh+RR4STtFfUM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjim+gACgkQJNaLcl1U
h9DUrAf/VG7i9f5Ygbw8FfUj3xN1KqAZJgequx6giYOS5aZRMNbeOmz7tKkvFR1f
Nx1b1wEtNWK/3B4kmgv2RI1w3FX9BBgX3qhEGA/hHD1unEKtoi+5BD5vQyQ0MlEz
0bp3IOFUz6geRCTIJ5OImbmCvYx7sPHQk+qUd+9poCKZHKGl/BEVOGTO9+Dk5A/B
1FMsBFvbSsDh3U4Bv7JeupMEWUCWbrzjmP9r+WC0QV+Pjs4a1x1+5/CBcT1z0L+c
DmKkLxKiyX2x7YkpOOPtpO73yHOE7QemF6iVVcv2+wqILHV/GVD+VNTYFkvjnlPL
yMsiJM+fRZzzOo9Xf6lD3h/jnw4APQ==
=Iegk
-----END PGP SIGNATURE-----

--suZIh+RR4STtFfUM--
