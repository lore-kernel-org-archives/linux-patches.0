Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27402254850;
	Thu,  1 May 2025 20:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131229; cv=none; b=bkgg7GwZ4s6ROu5WV168IFbfvZWmTcTOYA58zNopCLlF1GlWTYB6l9Gh9xKqNs2nAzwfh2qrK9CsnYecFS/nNEVkc9eG3hxFn5I5rYJaotJwBKKida0VCPmAEIB1vQUBvHJR0CYLYVuIo/Ox++rhwf10xfum5vV8SD6TNDC96Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131229; c=relaxed/simple;
	bh=REWw8rurEMsaeDD6gHSZRJP1TmFzUwy6njAkpDeD7JY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRGBURIAKEyLkpIl5yKrbDUtnXVrCeg6v4N8r0YBdozYa062UiC+s2Lli3nYEi3IbnUkf0/MV2BgBjzf+FOgEm2kJetIG5fRMyRZhxumFngR5ESY4PNRakjQgtEPMCtqvs/Mk+AIyLTx0Yf2Ar+rmx7XFbp+3u62eLQDELpC2QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDkUSlz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDkUSlz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E08C4CEE4;
	Thu,  1 May 2025 20:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746131228;
	bh=REWw8rurEMsaeDD6gHSZRJP1TmFzUwy6njAkpDeD7JY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mDkUSlz9LjkWQ7api6g1PbTM5PK6x95JLgW0wQzgmSFLiB/DiFQmdwwUE8c6HWE3F
	 fjC0x3ZGVbMIWf2+uBfK78V+D98mbgcMQVOrUT04pYvVHmGNwYmHvqttHMGwzKhrVg
	 T9370Sr9UyciFlfHWR/1/ZX6ujdutETrjsqP1+qDi2LkU9bTbZ1mho+h/gosXTwwvA
	 1CR2uxpDrbXKzIotizXMptPSoY4+I01PbJIQ+Yb4HLFzjXKKiiV93HPWirxgt6mF21
	 u3h646fvwOuHinICV8rNqIaWgIiFSMjjCZdHlbhCYVaCZWMqgxb1l/WzYjaXw+IRJ7
	 pbLzFv/5LkFnQ==
Date: Fri, 2 May 2025 05:27:06 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/368] 5.15.181-rc2 review
Message-ID: <aBPZGiloUQxKLtju@finisterre.sirena.org.uk>
References: <20250501081459.064070563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WoUw+utTXRUOJanq"
Content-Disposition: inline
In-Reply-To: <20250501081459.064070563@linuxfoundation.org>
X-Cookie: Well begun is half done.


--WoUw+utTXRUOJanq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2025 at 10:18:10AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.181 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--WoUw+utTXRUOJanq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgT2RkACgkQJNaLcl1U
h9AEbwgAhWQ8e9vutByWEsnb+NNJabIAJn/tzyn900n6MTbogCpw3/gLqZYlwGhr
6GGfRXfCcZvhToQwXaxKmtdAl2aoK/lgbOuUUWWO26+xLrpMoLQ1QqVfXlDxIvtt
kVg6um/N3Jz1sE5IUASkPkNvGnsUMBXvZbrd216CFkpX+4Y93wUCoZEnLyHfB0Fn
CMg0hmoXrOb31R02256yPwc7hd4b/InoGtJOPzjJYRyNCeHnBv6lh48JqCIt+XYN
HOrEb96cwbltvdMZJ7iNF+y/8gEsPwqWU6gn56XlIByR7F12eVT7L/PcUuO/s18d
NXUt+JZSSVLOVOfx6gALjiL/LfTC3g==
=ySIi
-----END PGP SIGNATURE-----

--WoUw+utTXRUOJanq--
