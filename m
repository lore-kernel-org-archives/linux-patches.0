Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEF52DCC1F;
	Wed, 18 Feb 2026 11:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771414821; cv=none; b=u3fWptq4SuteP8cbj2IZOKefF8XhZG7h2Vj8+jXp8R8b6MzCe9Xy06dQ1cgo7O1FZJcAvwoh4Xmpsl8pNhW0psIuzTABJ2qwLELvj0FUOayhdQ2BKgIdeFR4neloQIjv2CzYupOf7BXMeMI4aSvVGr1tMICF71y4MTgIs1+vjvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771414821; c=relaxed/simple;
	bh=BQgQ5qLcYRi5LRHIlERVsxvN/FlZDTYpWB9Pj5yLa4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EDP35ZVcn0kpT7km2THM/oUuO3XvzVCzGKya1+JdunCnZmQp7fPJ3HjqPm7LXXuiB7FxcGTw294+w6FBqnXtLrksm8HhMIR9Xtx+fav0rXQriqObgJdQto6CEGM1wxngUIvxy/ppCh0Iy6wmYDrJNSlTKAXyvsYL75U0rIjLgxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZXmMOnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZXmMOnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546E8C19421;
	Wed, 18 Feb 2026 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771414820;
	bh=BQgQ5qLcYRi5LRHIlERVsxvN/FlZDTYpWB9Pj5yLa4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WZXmMOnhGmQY3yxEabwFwAx/y3CLnodIIK6t+RhjndlM0qulzYz8rLa/ZCV4S+GRT
	 7/E8suac3OysjGAaFSV/g4JcBqai4rD9OCL78E7BnozONmWR2owdso7ToEaJ5uGhXY
	 zgKVWN+bYLOKjKqEpCm8K9kc5QwxgmLercgCjQ9S49ZbNCOAAvRxbZH4Q/4TZyjkiH
	 S+w0Eo+8MdFvwtbw/AQkZmwKfm0wK8YVeWaGnj2l+duC+GDwf1X3U+Nb8zJSSkTQK9
	 mfotRNaf5lqxDrAvzQfaeT5QnbxIbtsFrU4MpFDb5l7SCeHsMHSzeVv1v5BCjJtqxo
	 fkwyGNTsbQ5Qg==
Date: Wed, 18 Feb 2026 11:40:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
Message-ID: <c63f4882-1853-4e10-9f9f-129d60d61421@sirena.org.uk>
References: <20260217200002.683975158@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZrLDxUzRS/7FZ8MR"
Content-Disposition: inline
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
X-Cookie: They just buzzed and buzzed...buzzed.


--ZrLDxUzRS/7FZ8MR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 17, 2026 at 09:31:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ZrLDxUzRS/7FZ8MR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmVpR0ACgkQJNaLcl1U
h9C/bgf9Em/GAa+esLQ7xI7YQ+7ntKkq0zwaFARFLiUFtMqIZ6x6jApe2P74U5Ib
3KCnydfZSPyTzO/yw4bxZomaIms2S+cfFQ8TnMaOCfmD7JdxIsS+siiIt8Jow8HV
RzQ6kdpdDT7cGZoOBiDSiyxo9GpKerjpp54xMl0M2vm0TNE9JDxqextMD2EWdYnk
CHoy6jhRXrSXkHld3XWzSwpzCekDUXtPZ4eibmqeM96ZJjXGatNcG59L58KrilQG
bWyIDpzBUjbZCU5nwshy/fBaal+e+P5zFfa092Mj6q8+3IJqJUUK1My0iYMVVRVj
gSwcGtIVfpBK2A6gLoZlln/Pq1wWpQ==
=qtDy
-----END PGP SIGNATURE-----

--ZrLDxUzRS/7FZ8MR--
