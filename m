Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910A6306746;
	Sat, 22 Aug 2026 12:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787401242; cv=none; b=dXahfdA0bYIBbGXk2WKAszBeUfXWf+EcmVdZS8Gxv1m2RXOb4ga3tUTJMgbI1RGjGErwWjtK7Agx19KRYc5NXd9AeM7Y+3tpUZsjXDoF/GmqpWZiUe0Ham+xP0igAexWp+HxmJEvpXzkjYpiCmYCijCFE756pCckXDgEjGT/YKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787401242; c=relaxed/simple;
	bh=yj1Ja/cGOHmLnt1wHzDKFjC2UnKF0+cjpwOqLAdc9ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qL2fFIUXS5HFT2cQ5O2ulZUuzDhXjHXqD8w6+Qgz4TXvu9YoF0ig9oCozCXy+E0+O4zOCTjlnVjEnkW6KxL1YgOGqkyS90FTp3Be4WhbGL3lbZ1VAVLs/HpsPbz12WWf+4kYp2HQaOwg9WdnN3S3CQwBIBrXqX+sUA5pwl9+pwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6xx6JSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6xx6JSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3B31F000E9;
	Sat, 22 Aug 2026 12:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787401241;
	bh=Jzy/UkWw5tNWIGbb6eeKZdaoy2eluKy8KJ27ULnljms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f6xx6JSbntyrsOGH78b+l8jh3sQ8fR5Qql8BWMQI/WxCF+qEriz7xo+oFCgFVnrJn
	 0hZD1bpfyDS9+vgAJHzh4J0mo2gyo9tDOVFKEdfHZT/IJZFwvO+64aW5l7pVUGy2TV
	 A3I4KhgE9W6511TsydIhC59pmAqeoahmxbGxDDXnU99rQhbCh1/hWNkTeuZFDJcOIB
	 se9tXKUWpY29qajX3mUGFZ1b7YmWLGaeb3WLCmf3h+6aa+AOKttfoxSoWpSiyApuHP
	 N0A7+ME2Wr2OeRo3V0YTxEvxtZ8qEnEgfsoEe/S3t+5Frol8CNXNY3DX2lbse0/HMn
	 LYvx5LOP7cs0g==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id EBEC31AC527F; Sat, 22 Aug 2026 13:20:35 +0100 (BST)
Date: Sat, 22 Aug 2026 13:20:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
Message-ID: <aomUE6R5WuWkLJep@sirena.co.uk>
References: <20260820145237.531699751@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AxpKyHD2OahUprSE"
Content-Disposition: inline
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--AxpKyHD2OahUprSE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20, 2026 at 04:52:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.46 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--AxpKyHD2OahUprSE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqJlBMACgkQJNaLcl1U
h9Afkwf/ZAS80eTdbl78sjGcBLKAiEEpFrnGQYZt6ECaKdgFGqMy1gBsN9V1G9k8
CX0QZSpLMFWdJ4htwdk4+3LJTZrqlZKt1Yjk7N240DKzepYhgseEmjgyAiVXfxCW
iZpcqBzprC9D0KbvF0jbU5uD3PZte1rhcqnM2yI4YExnsRs1LpvjB26GYgjeSj50
/XRsg6k3VLqsn+gmb8MF4A5egPSql1VW4+gw9/8oCyOtZ/cSYoJF3mzkRLanbekt
1DP1j+enyXLkHsQbvRxSz/hS7TZDYyqCKphGLZ9qII+NYjjjv+CE3x+H3ya+rMhD
Au26P/u5JEOutGqg/MGWjQzGDJ39eQ==
=Q8hb
-----END PGP SIGNATURE-----

--AxpKyHD2OahUprSE--
