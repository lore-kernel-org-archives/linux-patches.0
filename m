Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE5A4A32;
	Thu,  4 Dec 2025 23:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764891724; cv=none; b=AOj+yIh58c9FgGegL7UwAvx29FxVD8qgb1wkVdMZdAO019+5DyEl9q+nbQM8EhFhx13lTZ2Zevo4rC3uSwKGBj6wUvY0hrMD1tW2XLVM9LM3e6utVGTEdNfTG4XwCRGUNyCs8geukQCW90BJ5D7cIueOCrfhZHW2loSWxTg+IRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764891724; c=relaxed/simple;
	bh=1tj5TMAu/Z1pj6JL9qkMj5UNJP9nmp7beo1672G81d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+ZxDgidqBoKQI/FGer55+5EWpbGVkr16SL8LfFWe/Fdzan0IVdrWvX8+DbBQdVIDJAJ1Q8Hb4hiMZ30Cz0qYqXxuEUXhphMW/kgP1dQOfirV9npaJNLeugUjdFNeHcfEsW9eaxferljvYl5SyegbNt0FnndQwQ03B7s8fnX8l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jCOCuCJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jCOCuCJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C296FC4CEFB;
	Thu,  4 Dec 2025 23:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764891723;
	bh=1tj5TMAu/Z1pj6JL9qkMj5UNJP9nmp7beo1672G81d0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jCOCuCJ8oBYvx/nR4nxQYgGDyM95IwDe5/6b5syVXIWY3169ZXgs0VH5ZB6PNwarz
	 4jcMjj0AXU1O7tv3ERuJqJRPaq+P1/EF/SBZHXHsh6bV59/rxYrzgG9qtV2nUyE8WJ
	 mem0zStxmV8wYiWMRz10i+6Ht9yunw6xxr9awTrx02LNOh0Y0Fqa71NGvKw0n6aspd
	 PJ73zA4fxIVL5ijpKioaiuT730Il2SZgU88zmFT36QuGrng2f6vZN5yPAEvR0HcCRh
	 EKTujwc0IBiIKA34s/tKU0MP0RxoAxiwCRazkzxgpcEgWOABVSEFRP2IPKd8jpBRdV
	 wq+ZoT8lqX7bg==
Date: Thu, 4 Dec 2025 23:41:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/567] 6.1.159-rc2 review
Message-ID: <da6969c8-a5c3-4273-923a-8614a30d44b2@sirena.org.uk>
References: <20251204163841.693429967@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Z1fX+mvVd5DkMjTJ"
Content-Disposition: inline
In-Reply-To: <20251204163841.693429967@linuxfoundation.org>
X-Cookie: volcano, n.:


--Z1fX+mvVd5DkMjTJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2025 at 05:44:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Z1fX+mvVd5DkMjTJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkyHEQACgkQJNaLcl1U
h9AKgwf/QkJJAGzBjAOQXtNYXq+/qbgHt9ygGfwbQRxSw3hRNNUwEk78q90HeE3v
AqtVrx1DFhOYzVAsbHbADkQWQYkj3OjrlvbtLnLXk8PiB6CL8UzHWrz7Ze9RBH86
HhON8lJZSjF/OAvcRhnul0ZG+2ImxcGFTtrTfOkEEYsL2fwq3zChUL35wSmLV4sn
CKNIsJ1u7+3ddAABFrzZRfs7T2MHr8otCQlFDBUIU1I/ry03CJW7xZEs8+XtLLeV
2zJVSU5T8+sQeHqjyeEfx9cpOUcUb9pBrKo/G8oamcq1tWc0b8H+28gWFmY7eaRP
OL4qgzF876PirtneH31DPRWCg3bzSQ==
=Wzrn
-----END PGP SIGNATURE-----

--Z1fX+mvVd5DkMjTJ--
