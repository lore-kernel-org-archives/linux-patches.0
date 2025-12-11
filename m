Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7060729BDA2;
	Thu, 11 Dec 2025 09:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765443995; cv=none; b=qCIL2Q7kXvSm+gbgCJ5N4VlPIU+F45Od7ov2xr4NftbdcqxOGJ3EHOABiFYKcxZJDQDtr5ETB9G0waWRsP57nigWh/JHk+5o5YX6UoLoJnyT1ML6PNikzQprm+llD+OKXSpVkrX1B5kI8H+p9bt19C+1JRRWOiB25pnDVJ/yXaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765443995; c=relaxed/simple;
	bh=p4awy8SO5jdKknGGEQsF9hOiW8eFUmKHt28BcmTVr8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3CX88uIQfhCWUVmnC2CArMpl1GWoG4BDCRTqqArbP3lzsVmC34SPIZD48FKhWs/KFwCWN5aILzby19jkAiu8sTQi+1Fcocfpgk6vYUXKPS+jmXpU9m6EFYPGCJMX/MOXLX00gttDkAYccXg7fYM2dLZf1aUULbQir32Y2/DIkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rLtOf7LA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rLtOf7LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECE8C4CEF7;
	Thu, 11 Dec 2025 09:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765443995;
	bh=p4awy8SO5jdKknGGEQsF9hOiW8eFUmKHt28BcmTVr8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rLtOf7LAN1UdgdWLvY/dDV63bm4K4QVnfwtmArwtk/Dk2Uf5CPrXimSbJivIklNGw
	 Zgde0vDLGeGpQYJQLwh8eouEPVlb1W9L48UZbQmAjMga+Le7g8GRZmUK1T5ZHUjLWT
	 cvFb0YvM5wML4LBvgZpXOJgksExHhd8tI7/3aFH5Xbq6sIC301Q+recaO6FKeZf139
	 PTiCHz8zQe7LY4nD8tvVMLk6sYmw1YaCV8VJhM0A+kYkN+PXbhjrTO0Jk2u2Bldaik
	 Im40EneAu+0w9FcQmf4Szgxl52PzqRKzATfJG9i+r4mTiEAO2bgKDLn/z5cR6hZhA0
	 r+VuZAia1tf/A==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 7F3BE1ACB974; Thu, 11 Dec 2025 09:06:31 +0000 (GMT)
Date: Thu, 11 Dec 2025 18:06:31 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
Message-ID: <aTqJl-z-Ec_GTu-b@sirena.co.uk>
References: <20251210072948.125620687@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LICihMyHVeUvwfiW"
Content-Disposition: inline
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
X-Cookie: It's clever, but is it art?


--LICihMyHVeUvwfiW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2025 at 04:29:30PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--LICihMyHVeUvwfiW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmk6iZYACgkQJNaLcl1U
h9ASgQf7BtBe0q+u1q5F20YYddcRG7GwrJbfp2jvAfUru/2Goaz+y0r/HX5r8GB7
xS3LNwwllWaNvNd5VCWSH2hsdwimvniUteyd6G9PXK8g0xfbcDm45SNQtuHD8Ct0
Muewd0+ivo0DWkg91RSkU/56DrbbZ/gRRbV9F25K8zXwxd4erv8c6+iZI6lWIX5K
K9MNKi00MHF6ZoQmupD4DPiqGCesvlaNsAiVeSNNwFFgdoPLO7soLzqWJPCMd2Yr
oitMSfITEwyRUj7hVbE+J6JhIt8JNSJA5EheXgFrefpnEwE8b1b8QjDpTMc0lHyA
1vUz5tdL9PYvS1ZKjVP7qakZj36wSQ==
=Mhxw
-----END PGP SIGNATURE-----

--LICihMyHVeUvwfiW--
