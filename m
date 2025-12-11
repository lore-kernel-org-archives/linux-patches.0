Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9677285C8C;
	Thu, 11 Dec 2025 09:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765444321; cv=none; b=PJyn5q6JxjJmFiTfIU2YXPkDBOFS70GvFiB5sTRng9PhmHOf8qU5njeIAMKhQvemxPHg/ESUfjLckaDlHmyNBK1i7A8hRYhS/zcGgQLVVT8JvBdpVtjtI9qXq/RstvUuMOc6X3b1yn8VhbuFqbnos33V+f+n4bz7Y5j8Hnd9Wyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765444321; c=relaxed/simple;
	bh=m3Iy9Q3QOWrZpxPlnD75vk6J0hXoLUMOeqZgiVVxM2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JzfBvWb+8RYnHDid3LRAlLVLKrA04//TUqAUwm85F4NfjUpyT35Fp+8CIUuheJe8HV3Sfs+h0MTNfCSmXFkEd/0XgfFbCItC0L+loscjxdRx5Uj0f+rd7Yq0M3FR2C0bbiZdG6qwz7jk0bbtc/YE/lKXDexS5Pvtg2Jm3M7Q/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0Ar+Ya4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0Ar+Ya4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08BBC4CEF7;
	Thu, 11 Dec 2025 09:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765444320;
	bh=m3Iy9Q3QOWrZpxPlnD75vk6J0hXoLUMOeqZgiVVxM2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0Ar+Ya4AeuBgUWCy4Jpv0yUutWMgrPNjaP37pbHy6IhcHbB31BmB6BinGR/j9Z5J
	 5xth4sEBPXTkwhjmaF/+ZFzVY1SvqLb7HIQUST8k0NnYkrgH4BctCoLHRyT2wkbo0Z
	 I0GstJ/NZGSXJMb+bZLmUo+NC2uas/GK4IMYlDunAkYh7B1RuISZdZlFW73yqZ/WUW
	 ZU35XlSNVDUFXgXQ7Nte1P8D3tj7j0o2ORZ/RCzApNqbhahYu96aQ2CVF+wlUZXrzn
	 nTwtSSF3oyifbW5LIWGe/bL2UKaZmg/C8H5YkWGzS3CI51eLO0jMsrjqunK2k2PXJM
	 VGg8lFg3WfDZg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id C67281ACB974; Thu, 11 Dec 2025 09:11:56 +0000 (GMT)
Date: Thu, 11 Dec 2025 18:11:56 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
Message-ID: <aTqK3DSr78oRd4wd@sirena.co.uk>
References: <20251210072947.850479903@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cscb7idF/I/Urmmb"
Content-Disposition: inline
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
X-Cookie: It's clever, but is it art?


--cscb7idF/I/Urmmb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2025 at 04:29:30PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.12 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--cscb7idF/I/Urmmb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmk6itkACgkQJNaLcl1U
h9CXIgf/bZQApCqEpMM0wlH9aASXAJw7Su0OYDZ+brPCeLtMbB5GqJrHA7RUahAn
6aj+j9mvd6+uODuO3SaNvFdR+Z6p/0yu723dxnZoKGbjU7YxGWIo2MyirvtDs/2Q
z1liZW5kbI+l6T48OoeGnR55tTg6YK09nQql8NDsIgA+RltllfcAHjdoXUqjcDvr
3QDsHE4o4u2LyPASb9ALDOwXFdIbPHirxpioFPtSqXcFgg0eSmNJDnMzeX+NI88j
7xCEpo7V8PUMv0pdgqDyIBgclBI5PHNYNcIf6GYFrgDDg2Yq5W9e8v87VAlOSB6j
x/Q1MMaSu0v2yO8twRhUQ907sc3jpw==
=WvpB
-----END PGP SIGNATURE-----

--cscb7idF/I/Urmmb--
