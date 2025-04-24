Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB311F4E39;
	Thu, 24 Apr 2025 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745495746; cv=none; b=t2WI6A52i05/k2FYRhXfBNIjXtuU2KGWsAbIRa3iTq+L/IyZguxRnP5ljfqh9dzFK++4jQ2IvG+6VQvHuL5YU7xKe7R4WuCAuMgEZYlwn4w6VE0QJIX6LyAsCCRtUKWIAEaY8PqB9nEsR2GAlt/Vq1k61Xg2BIPgQUpHCDLH3jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745495746; c=relaxed/simple;
	bh=xEo2z9Oy8u2/n0wj6Siyz43F+03XChWvMACW+lMGt3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amo15dDk4Tm/WbRD0Oyyj+yz5SB1b+rKZEZAIvsy5fStkaKgl/1OWqY12hdcqYtr7dBHu7gqFYtB8Z17NxuIr5Bsg7N5rit6KPjIQcAYNeU1YEtkOu5IKm7/GzLSSQLegD8JFYyMS9rrGVo1qybw2THGRRHFxME/uo0MUZLvxV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RC3CSvz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RC3CSvz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6313C4CEE3;
	Thu, 24 Apr 2025 11:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745495746;
	bh=xEo2z9Oy8u2/n0wj6Siyz43F+03XChWvMACW+lMGt3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RC3CSvz4f3nxUo6NsZIYgYfLKsktjVbLhwKGNO7wS97s6vQCIVIpOD6U9N1jFbW1b
	 3QwwjEJ010V0FAv8vlj2QTB1v5PqcZwvfetnG042B/2HNe1Y3s9dBEiTaeJtCAdK1j
	 tZE3tLU2rRSqLL96gRthUwyh8OptoRnxV5q3LAz0eqCBgncz1qU5QmNlBCNraq80k7
	 wID1lCm30TwNBCBa+y7NvcnmvWMlZliKl7D3tmAAbCi8pnYgHB+hlZXSTTm79TSyuv
	 ZvA1JR9HW9t2UswvcPLNRCaTr1BPcmbC+a2DP/v0DpjMiGyriOtgsC4W6kkFFxd4Jh
	 r8Art1GD1UDWA==
Date: Thu, 24 Apr 2025 12:55:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/393] 6.6.88-rc1 review
Message-ID: <4209ae91-015f-456a-a10c-f91a06abe78b@sirena.org.uk>
References: <20250423142643.246005366@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dFzJ3R53Jr0oxaq2"
Content-Disposition: inline
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
X-Cookie: Star Trek Lives!


--dFzJ3R53Jr0oxaq2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2025 at 04:38:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.88 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dFzJ3R53Jr0oxaq2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgKJrsACgkQJNaLcl1U
h9B+OAgAg7ypbqVyFXGnw9vKpkr+Zc/XUEQcWNsG4oLyZIUIfKxE8jOsR/DY+l63
En1PeutK7W3ZGohrPqcMIpX6pg/f1KSeZg6W/Xb8k0NbtlabVnychb2LL43mNAV+
gwmaRnT4foCJ0UwkB45MwY/cSzW5iFLD5Iqdl77THKEBDEOeNtXDGslJd2jKLlj3
xh0IgRHvGUO3axaDy1hQiR5bzgAa4XntiRhxi7XF/9/Zx+Z/AoRXWBE5pK2UtHlr
4uZ8IPKcK7Vc6hCR0Hi67VzUGYzVgO61pTH8ZrF4PP/yiSk7chzFfSEoKVAi4u68
86v7/wYag5VQyoZQe1TlgJttdGsdEw==
=9dr1
-----END PGP SIGNATURE-----

--dFzJ3R53Jr0oxaq2--
