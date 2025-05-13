Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA8239082;
	Tue, 13 May 2025 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747129527; cv=none; b=Z1OfdlM2ZaQ0CyobrdvYDa5ow1PoricPhBQG7u9BXRn1rP4G+uweoDj8xbETDgxaAjBf2r9vgIzJKJk2W5IGH8U7n2tO4vVWwqNXa2+wrqiPXLibwRDNrKvV95r9owachGjxvxQkU/gmYNa77Fh/asdkGahkzIlEHtuNkM751sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747129527; c=relaxed/simple;
	bh=Ezz6CBB4De4wtgxr3QyY/fhmRFOc5ncE16VS/q6uz9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NyZJL9VQe+8Sw3UDyJeSK8UPLfmNP+TuTOdyLER7Hc8JD/dkn7USC+RUCR6Rdr+Uh8H0TT54+EoKk/fPC/PZnGF8UynXcGgaqLfJSIG0+8CnpvqwcLY7s4S/CQtteKKpDO+rVaVytZL4r3nJZTDgsJusYbtD++ees3oNuwETS00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNnApBwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNnApBwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5CFC4CEE4;
	Tue, 13 May 2025 09:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747129527;
	bh=Ezz6CBB4De4wtgxr3QyY/fhmRFOc5ncE16VS/q6uz9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KNnApBwgDSCzTS8/geIkkJg95I26irn5p2ACdID+w6e9Ybo4aMR3IvO2NstDuRTNL
	 q5fFr6zKQgiL7bcQY2eeFzBObrDRRgLQ5ivtRBEZ1fDsVAeA9jdjGHteRt3SMWpHYO
	 CFIt28QxOcXOa1q0acTkFHDNdD18S5zEmvfxSqrJdJ8dqdHyU2DWCHodLo0gJulvMq
	 Ah8zMhr9/LSRWbSunSjfvP2JiHtLYZ3BFBoXWJtGieUCob2uMFGXcXsTVFBRgOjoQJ
	 WP3iPwOAVPsxRgt1gyFsDOQh9s6XDSjwK7xjRt1oBuqO5PkLRi/AIJAvZ+vX2nJp3s
	 IUGSn2wI24mEw==
Date: Tue, 13 May 2025 11:45:12 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
Message-ID: <aCMUqHgsK6q2r6fr@finisterre.sirena.org.uk>
References: <20250512172044.326436266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yXCp+fXNPsSWMpYX"
Content-Disposition: inline
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
X-Cookie: Well begun is half done.


--yXCp+fXNPsSWMpYX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 12, 2025 at 07:37:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--yXCp+fXNPsSWMpYX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgjFKgACgkQJNaLcl1U
h9A1RAf/YKRbsn5ZrXF483QRTU6aNoicC9jIgKr2zkM4CH0vtRC4cBjsnXxkjyKT
sn3MHpdW0YmFX97mMxvD60WQ37C9eAdX3sAlrqcuVwHlT7mpvhlLIt5FGmncJVAa
Dgcf1/UwlW3J2GS9YKuMDOxvp0cga7ObcXfsrmVsvUinaY7znOCp0YoQEPA68OLP
Vaz6LxSfr+0NhCiXT10LpPcfS1xviH5Wb5mmS8d57i+r/6dVpB2OxZvMf7eHuPwU
UnFZRE64ejbkLRXZPGmqKGVbNwlJWybIbue0XFwuRqwRjXdjqv4s+raFG35CvJz9
RaP/2h2/RoHHJj8cmnFMaS9djz04mA==
=nW7A
-----END PGP SIGNATURE-----

--yXCp+fXNPsSWMpYX--
