Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9535A29408;
	Wed, 15 Apr 2026 10:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776248204; cv=none; b=kFQ5KpClno/MjkB7N6Gm4i+3tNICj1J2zyCEM8fybm4lLHRHyKYcBC9DDx+q/B3uR4hXlsKz72WMS46MUWx4QkmptmtiNIh3tmMQtlhHMLG9ZuWXQAxAabiusUO1RWNb8pP5TnZVAubjTvJFETMqTq9+Q+AUiufNuv34rUC+0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776248204; c=relaxed/simple;
	bh=SdtinQhntMuvRPSxzTe5Z68hfpujzRJOaClR3VLGMAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kgn5st3/RSq8PcYaSUSRZxAR7nbOlqRBRu67Gk0Vg0nOeAA8n+s6vjkVZPK2IK+tfz0B3nAKpdftTN6Snc8WgxNrk1/yXxWrMCyHRQJW/P6Yi1MSZNfOXC3cjRt9WUQ/t8B6ws1o2HAnC+/xHN7GbFPQXly1k6hBy/zwXztbSWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kL3kDtWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kL3kDtWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7DAC19424;
	Wed, 15 Apr 2026 10:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776248204;
	bh=SdtinQhntMuvRPSxzTe5Z68hfpujzRJOaClR3VLGMAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kL3kDtWHbm3rKWP3pQQUgfkwOAHDNy72y1/xfnyqj29oHhg4eN6u3X8pOCkeyHAAf
	 IP7TdqFoLJwReSlMOoM1mIWPpMgwKavtiSS8nzywVKpWGzOmyNyHk40fMbfiZAeqoZ
	 NiOuGOXM40hFXNe6fj5+8HtoLCAr6GfjkzFkO0iSbXsFdXnnLPegSdNzI7hdGe/tFq
	 qtbk/mA5iVf/jJCuyDcaLEhBdcFj006OlmDVG1g40lfOZsuXyaiGCG/N3wcw9i4EWv
	 ytvREIy3s9sdfGZjrhQ+BJgAjDtfMTFGxCSJ9c88mVwqbSu0KqLO/OMDB+x6wN6lW+
	 Z7Nilit56BlcA==
Date: Wed, 15 Apr 2026 11:16:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
Message-ID: <7226b550-7a93-4551-a751-d6f1de977484@sirena.org.uk>
References: <20260413155724.497323914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cFYbj4Z2TXT5n60H"
Content-Disposition: inline
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
X-Cookie: Non-sequiturs make me eat lampshades.


--cFYbj4Z2TXT5n60H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 13, 2026 at 06:00:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--cFYbj4Z2TXT5n60H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnfZYUACgkQJNaLcl1U
h9DTaAf+IXQXru9I8UY3R1a9TUKBaCevAo0Zgg81uBuzHzmgxxfi2rSiijov2YP0
l6HToW5FcOuj6xjCHs+CswDY0DOl6qIYx5Y9EAAsePPf3jI6uty1ozRlLA0DwzOo
f0Rf3J1QRRNoxIwBbCRBe+/U3Le0ujeS2RdnfzmhyAfksi9uqKh7x9JUeJkQMccw
m3WxhQTqpRcisLaJVEvmERX/131T7actgSEBJ78A9YhkEzViyOW2vf7/4dCCsgjM
W+7JQcgmJkTJkfTUZnRPyeAiwAZ3KiW/PkuqUrwpUofD8nA3TVtc+bLgq4981r8q
1NDQpXInoLNn20jgb8dDOMj1pUapRA==
=6BrX
-----END PGP SIGNATURE-----

--cFYbj4Z2TXT5n60H--
