Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C01F19409A;
	Thu,  5 Sep 2024 21:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573024; cv=none; b=G2iz7eBfO+NXxOfj+PQk1b3BoTOY8Lqy7i4V6URKsFD9TlKXnIi4E9N28D1Ol7gid6kviDRPOR7+1+sLeU8u3B2NKby0RahnLfa5CwwnQsZ+xpxwC2xJIIe9+UkZtBCIqwAq93lkK9LHb5LOkwawpZVInK2TOipmgauE/RGHyYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573024; c=relaxed/simple;
	bh=3RR47xVp0SxhiBPgcoOvDSg05EDmtSLYHYjGxwQFUas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJAwIWCqd3PagSzCFPfO54pvyIpo8itULtfcAkKHkLvZ8mEbVoRmnpDUEOFqrL/blS865xWnDfmdj4L89WLjSz6jt0qNB8CzDCCLavdI9cR1jOsyPnuVetAjwc4UhFYuarezPdVnMmq2r7QKm4BBceD8PmXlW1Uwn/3LOCfn6aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4pXVi0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4pXVi0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AF1C4CEC3;
	Thu,  5 Sep 2024 21:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725573023;
	bh=3RR47xVp0SxhiBPgcoOvDSg05EDmtSLYHYjGxwQFUas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J4pXVi0OefRMNv4J3PsGL/MkTOXLjObpv1QvSTq9u3hnhj3I8pbMwl2O/hZjUs23U
	 9hgcsQxTCd/2ZadYi3vW6+ivKXtRZFs9hqBJd6wW6qjTqLmt7K4Kc623L2avlPE7Dp
	 SpHUNRxpj9bDIQbvAiyP5CfVaZ+xC1mFFi+zQVFI2esoxZ+38Q5g622xRFuk0ENj2u
	 aji07KwXAw5sn/39w7njGtF96xJNpxezYjy644R/iS8OcXzdBOpC5kJxKsewIx+Sur
	 twySO0sehlPpZ96ZmyUt+KY9860tQjgI70rkUAqRB70r/SMtXgDL7i2DwFaDs8d6sd
	 RLm+PvYu4CGHA==
Date: Thu, 5 Sep 2024 22:50:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/131] 6.6.50-rc2 review
Message-ID: <afa56186-daeb-4032-85c1-d6c8e3b036da@sirena.org.uk>
References: <20240905163540.863769972@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vGb93nstYvodguc3"
Content-Disposition: inline
In-Reply-To: <20240905163540.863769972@linuxfoundation.org>
X-Cookie: The horror... the horror!


--vGb93nstYvodguc3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2024 at 06:36:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.50 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--vGb93nstYvodguc3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbaJ5gACgkQJNaLcl1U
h9D5KAf/cpLPctWgFIYfZgojNTmZbOXZvZEvY8XjuXndXPvpwlrbBm8yyGwCezV1
TpwkMnDR003h6+GVbBnsQdl+6aXIP5B1hRl9C1m0sjn1BDF9uBkuQ840EI8Tg7/c
b7YDTGzFAVD42zzLCemsquFNSgZdVh1JK8lcIGVoMOwJx63sMfX87wyoLQpKIuPh
ACSZuFVhVhh1H1jOJVsx9WpC1X+MSsLgwa4sPwGyM5zZ4TcE5PkJ68qio0UZWL7u
rMoZx3/Bul0E8poh2JSPiRNbBpLQQbCVh40Zw3xxjZRg9PoXJdXfSUPb1SDmh71U
eUqGrP0TUxTXkpLcW0heIklJMdi4Ug==
=v+xd
-----END PGP SIGNATURE-----

--vGb93nstYvodguc3--
