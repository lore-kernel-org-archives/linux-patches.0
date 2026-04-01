Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A67C35E92B;
	Wed,  1 Apr 2026 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065182; cv=none; b=eO4P5ID2J3N+L8QpQottT/4F7r2FGOkhdmdZzflfs/uySM2OiDC4L44CFdDmJW6thN2hE88SneleePOU1OxsvscnfNc6XrjybqW34egXNdmGkhUEsDAhjBtLjng+Z+JGuFz+aasEx+GIEcCsGsTj0ZyVjJ2SYvUdkdcaPnXBS38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065182; c=relaxed/simple;
	bh=hQ+vnC7PVgmPpxCJDWhjQgO2Dv+XHSTS8KXUr4R5dpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sszUcHogXWX1YHOLcJ0etvLhe0j9oagxJN/PvBAIMVN18IgyVt/ZvvaYffL+5UCf5QMktiZarQ00jHlsmUJuyPsp6TVFXDHCjTrstHwXB983PRy03ehp+aRGbnX6N8sxGWaXMaXRR1uqImJg6ltWSSyOFJpaBRnf2RgHAvAmTq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s4KnkhNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s4KnkhNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784CEC4CEF7;
	Wed,  1 Apr 2026 17:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775065182;
	bh=hQ+vnC7PVgmPpxCJDWhjQgO2Dv+XHSTS8KXUr4R5dpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s4KnkhNPJA7ZP7y5LAy2W4eDmbT2M3BdykXOOw7vEuG/E0cWWBfJy8nnFY1ajIeAb
	 CFcBTOHKecag3E2E5dml0jrqQRKwZZZKvlSBT38/hKEsBw1++yIaNCpvtNVRn65BgB
	 dptUXlD8iHJFjxGAP5kh/x7ChJEfnEdOJ0+UmJhHgCsQPORMktl3i7eIgNVAQZlLy6
	 NdbUNFZ0I2unr0FXDircmqqyeU1/ds0t91hYt+pKiYPNHetHEjj93abQP+FUaxpCPp
	 0Pn96D0/O62+1kjCZE0M3rCszbYERng3PGt7gw1OSMNZPNWVz2eG0gBXRFRCTHFK0h
	 ZFJHab1uGMplQ==
Date: Wed, 1 Apr 2026 18:39:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
Message-ID: <550477df-0be7-439b-ba9b-61d3e18f7d8a@sirena.org.uk>
References: <20260331161741.651718120@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qdb2LJeGpWScc9cE"
Content-Disposition: inline
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
X-Cookie: "Yo baby yo baby yo."


--qdb2LJeGpWScc9cE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 31, 2026 at 06:19:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--qdb2LJeGpWScc9cE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnNWFcACgkQJNaLcl1U
h9CEXgf/Yg0WkgewR2mwrchWTbilV6GAnKycKJx4Yxv5qU5wVEULRQkdgqsXyU9J
v5UXU3+Hl3X5i9EVWVOMrfvUogmCaK9R5O8/o8bJ20YExUXGhzS/2T+WcTCY/EdV
ERmr2tovKW3tuDuKuNQ+E1riCOwnxy1Uoiv93QJf5czKGWU9TGB0ePhzh5O2+7HP
iiXcgL7Fa9vcq3vwd3vMh7D2ydkbKrXNr0YlRjlxViakcdX6tP1WhSgYti3FIxun
0nNFZ+O3yaguNHt24M0UEI4hpA1Wcvc0yG3l406hvsNh0phlFrY7SReCWaD8Xq7X
f836JfA1xBwwC9kcX2s0nkZT1g4KaA==
=IaXX
-----END PGP SIGNATURE-----

--qdb2LJeGpWScc9cE--
