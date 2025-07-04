Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669462D0C8C;
	Fri,  4 Jul 2025 12:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751631261; cv=none; b=bCgAW/uKJ1CnaFUXZzpKR4qnDxM585qUf5p3j31IJdc5ALFRvBCjIgyiCgVxhavVhKX2hzBhdffLT2NbUfG+6hO3jeuqFUrVvc5l3bKPgauTECxbl234sNYsYL10kOuJMmxFjJb5N6BTH77IJJa8iiIF0KCXcVcXuCkpl7buoIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751631261; c=relaxed/simple;
	bh=n/ODnKyljnKDGn4KBOn9Qf4V30nE1DYmBOFGba3efY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fn9ygPraDGF26FddVFJTeBDx/1IcMx/T+ILV4OSiqQw5TwTqi/6zYNaSyPtbCASOw8xomyrEmqkax2XdlURN7dZhjgCYOp/6mbjDw7tDT0kRnAzPIEhjOZ5MLy61gMbOxgNh7wTd9Kes4sZVFWH9maENkRH+Ab//m/4+y6WKc0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KznaQtfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KznaQtfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB743C4CEE3;
	Fri,  4 Jul 2025 12:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751631261;
	bh=n/ODnKyljnKDGn4KBOn9Qf4V30nE1DYmBOFGba3efY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KznaQtfqSV4uK6+LtVr6gHVKDQQPgXnWt/hWWTW5qOWg2z/lrp57tMf65/r6knBPt
	 xSOIennAfATYFxAGx5o6FX2VHKGqWViHRzFZThnuXf1q4MExzrUWo1TsHjNKJhwLZ6
	 7hQ27sEwoDzOIWvX0iuiGXwlovlMxicV88knA8U244LJAGfj7Ogfy0oapgqfli0Ejz
	 YvNNAwvN4TnM6c4ystqFoApXvq8wpFq9winSnBVtCLDdQ812csag8gMaUz3LnIn1je
	 TTeBz7JUKXTJyhAb30mo1JvkEUHBl9GX/5PlALFnGJYjQI4Q8xPFhflUNlerEZufkO
	 8aZpLk1BzbVow==
Date: Fri, 4 Jul 2025 13:14:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
Message-ID: <ede1fedc-90a6-49b6-ae81-74b0b9642678@sirena.org.uk>
References: <20250703143955.956569535@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="v9vjFpyl0r2LErfG"
Content-Disposition: inline
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
X-Cookie: VMS must die!


--v9vjFpyl0r2LErfG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2025 at 04:39:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.36 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--v9vjFpyl0r2LErfG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhnxZYACgkQJNaLcl1U
h9DIRAf/ZQX9blQpzMUh07ibIWt+uq1yLxvmJeNsVNVx8IlJ9C0ZJ3bCSK2Ec+WQ
ZjgQH56dbrb199xydsKOAaya7eKCLSzxwNayO6K8nmmNTOe4HK+nXH4UQQFKw8OA
JpZEFjk6dqPv4xqq+flHELNcTPoGAiNb2c4BsS8PgDcroygMfJS2jO3nqczS/VrH
8e0AwE/vp/ds0RijwcCZCesP+sIH0Tpys3VboHvKrrVWUnXaR/WYYuR77TmKv4H9
LslsHoGCjrRWPi0HLuBcOPnH3FtjIe7G2j1fb4w2Qg1UlmtdbHfu9dCyQi1jAlNA
jEvxq5+DyYC3Ka7raTqVTcftDbN5Gg==
=CNcC
-----END PGP SIGNATURE-----

--v9vjFpyl0r2LErfG--
