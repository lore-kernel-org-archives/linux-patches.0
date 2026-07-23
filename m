Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4381E4DC53C;
	Thu, 23 Jul 2026 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819259; cv=none; b=hl3dUhjEtH4KOXxnpsIPraC80tre4xkKOvEBMqkML7/3Vhp6lnO/TmA7py72KeIBX0SxRfMZY84zcLFc6vtzNuPSo7RNFETRv4bT/3ufrpHTleX9SGxOBRrGKBL6uIZYabg6LJgN2mtPtR7AUCKUrqfgCc35D0PhhoCONZEZr5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819259; c=relaxed/simple;
	bh=HQSgRj/Zy76C+ILavfl6DZHTI1RJeNZIKbo1YWA6lfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+veJKHi7Zkoa/emo1Fo+ja8OxvckbE9YkcDmy5+/92sloRFxY62sdJeOpeWkUwCWep7sCd3io90ewEor8fNQb+aJy/v1QN/Q55B9lPEzrWgEeqQM6WaMZ+mO1yduI0wAIqh6+1oAHjzuJsz4ZX0bN1CTuQEvnTowfYztimTzws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B7E1F000E9;
	Thu, 23 Jul 2026 15:07:33 +0000 (UTC)
Date: Thu, 23 Jul 2026 16:07:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
Message-ID: <f473ab1c-fb7e-43b0-a281-b3cad46aa95c@sirena.org.uk>
References: <20260722142910.893804136@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="spfX6iAM6s27mqfZ"
Content-Disposition: inline
In-Reply-To: <20260722142910.893804136@linuxfoundation.org>
X-Cookie: (null cookie


--spfX6iAM6s27mqfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2026 at 04:31:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1624 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--spfX6iAM6s27mqfZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiLicACgkQJNaLcl1U
h9BLHAf/fNTq7uhNrmyWd6EUPDC2C9Q3NB/r/Ov/oOw3PvQ+ZkI51Gt+0ewerM68
YylGI1e+oCN3qkhYJFldo3CnMzaGbzC3uL+jRy2pBt3FD41cxE+tbe87PvG73Y+R
SKRGxZiHBMrRjsPMPm+ySi7C+n9juo+eRBGlTqmemj5QH+xv0FGM4HQlnNB5VKNK
Rfjlpg3GGpIrP7+QUF5DZQG+gpgzFGx9bPKLU8Z3oaQH27AxZd2UTtETvaGQtq7r
EiwwTvRKD3Uxj+MfsvjS03KxlDZMiFwolCAwXvRUnYsa0xnnhOUkYxxtcyX1YA20
XQwr/oNveTYDqtU2ZxjHE26Ctw27oQ==
=skBQ
-----END PGP SIGNATURE-----

--spfX6iAM6s27mqfZ--
