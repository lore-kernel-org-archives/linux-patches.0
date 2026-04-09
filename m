Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D781A9B46;
	Thu,  9 Apr 2026 13:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740966; cv=none; b=jzPN6T6R3OExHFzJQmGOX5sywaIRzZzxMNYyT+linvZ/TXLsQarKTw5yCnNN/pLoQvk9YcLQw40fnt5KKm3FH/Tqvves08LVxIYOBXoduhjtVHzWZQtbuvNHW2CS+fWYBJau70MYGH5mua64bGhymtbax9/YYn8hUfux0IJb+qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740966; c=relaxed/simple;
	bh=WYsYkc1QDEZTVAvPkUEFw1gnVZ3mMob6ibujT1cYN5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PduHlzVe8clEcs1KiGeqVjauahtqidXPBmJrjxLV9Unh0bQ46dGzwSlJkcUuYCuZvXCCM+TP4UHSGtvqnbx+w1ee0NHxkppkOx41uP4uokPD69SDebLcY2tEKXz7/trkcGf3bK7KtlK17vjWsyuRL+kHCKgHFVaZtiexiN4Q7Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SrDxTJFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrDxTJFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7AFC4CEF7;
	Thu,  9 Apr 2026 13:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740966;
	bh=WYsYkc1QDEZTVAvPkUEFw1gnVZ3mMob6ibujT1cYN5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SrDxTJFVQxB0Qy+GfDRyiJx1GBwUjDz+/Kg+pqf+r8GR4+HTlCSPfMimpaAN3XtZF
	 K1v7X15yeHg4fpE2owAYzvWrP9AQxL0+bt5ONiiiXGBJ2chLgtQLtzd/TC8eUqyX5+
	 D3rLhqIq8j/EO+LrqFNtJQXV9bAmh89J2VXT+r7xa7nYuBE78FWdBGyxkg6Unhg2g1
	 8fh1kmwsa4SUksC2+LRgxjRQwc/Z2xuJNwm1j52CMnvQJ+V18DAUX+GkRw+wp2xXqd
	 pxtwOJWMMk/13VUWEkMb54VP4EyXQYqGXLJs31HMGG6fKZzZb/21EaKsb9LcwTBBRm
	 7crK3w0OFellA==
Date: Thu, 9 Apr 2026 14:22:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc2 review
Message-ID: <aef9f91f-44dc-4b85-aab0-02c312d874a6@sirena.org.uk>
References: <20260409091742.514769762@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IQdZuid8ULEKa0DA"
Content-Disposition: inline
In-Reply-To: <20260409091742.514769762@linuxfoundation.org>
X-Cookie: Hailing frequencies open, Captain.


--IQdZuid8ULEKa0DA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 09, 2026 at 11:25:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--IQdZuid8ULEKa0DA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnXqB8ACgkQJNaLcl1U
h9ACBwf/TiQE5Qov+CzOZ2r2Y1AVIYCP/l8dbWV/Eo9l2IzW79FtsMKMWNXWi1Dr
xfRyhIqZR9w0AcCkb7QEF/+p+MXJ0pwVbxR6k290R6EdesIJsCHJ14YJAGzttPW3
fLJ13hW0vhTiyiu+aWzHbyJyz9NBz4yWmd5IRcZIdCA5D1TVUkXA54uHy1UvQrSr
YjFsZOiLNF2Wl3B08CJ1IBBiMqJlH4DxzUBi288g6gD+8ioIP8fA8cMG9XJEsb1f
JJfQO+aarU88iQ6aO9S0LRYtTfLml/I74i4YFiCDlGg+JU70ibAu1Fzfe5iGHipy
M2F+W13507SDITo9Rle2LMrof7McaA==
=NBH0
-----END PGP SIGNATURE-----

--IQdZuid8ULEKa0DA--
