Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BC11AAE2E;
	Thu, 20 Jun 2024 11:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718883859; cv=none; b=FSEUDM9BGkFHOxPuLzZ0Tk/Tw+VXlLKxL5g7tcjWO32oJXT8ivo94KpfPvc6aRnpKGrTVuQRaz4gPt/cEvVdVWEGl3ojmZG0z9+11ZyqII/l2A21P/8/52/1fI72mCe1YAhvN20Ql0SdtpZNgolLR+J5W+WabXgUwmjIJ7mPxQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718883859; c=relaxed/simple;
	bh=fCzCVYmwVLtjDfxVSvewcoKsD/2i9tBOf7Yfa94ng3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crj31QlKoZGUXCckAksk16zFhU4/9uCMHeUthVprGe8CYLJz5nDhCy2gP+jpN7k38BjsjEf+TpNQK1VTLcFjzwoRQsI8E1nqLGTM6AIU07ZebtOwCn2dSb8jdWFlsnOxbJDOrTChaSr5rDVMs21DhjkOrhO6Wfwuv8liiFNA90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O36NP9Wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O36NP9Wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2EDC2BD10;
	Thu, 20 Jun 2024 11:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718883858;
	bh=fCzCVYmwVLtjDfxVSvewcoKsD/2i9tBOf7Yfa94ng3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O36NP9WreWnFZ/6iWNUkEdTDNFg/xOwUer0meKixNWHn4+oU9K0+jaq9BBW4Gy7As
	 iGzfWAM+BM9rvxj1BaKCnWyDMil1XGplYZN/6lj8tnuT/QdwbUWJRId45MWPTInZ52
	 t/S20JWpMDoy+e7ZEZi+HqSLfl1G2Vj6OPl6NCzygEB0Yf/emQuZKlRnQdPAUPJWHP
	 mKn+x0AbfkAA7eBC8IvadkMTkK80wPPrHH7dsn1jSHdudb/medEZ9Ew0OKz23ECy4x
	 zorm1yuH+6XbnUurjdxv3/vvCcyIu0ReWH1FG5Z2uW10m3XOuG+LjBjynfIpHV9cjZ
	 iLQvSWl3fFalA==
Date: Thu, 20 Jun 2024 12:44:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/281] 6.9.6-rc1 review
Message-ID: <26921936-9a73-405a-b315-cb9f474fedac@sirena.org.uk>
References: <20240619125609.836313103@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m+iZN+hwwN1Uq4kI"
Content-Disposition: inline
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
X-Cookie: You're already carrying the sphere!


--m+iZN+hwwN1Uq4kI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2024 at 02:52:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.6 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--m+iZN+hwwN1Uq4kI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZ0FgsACgkQJNaLcl1U
h9D7XAf/cqGbZVEr7K9YkgOZOvbSucce5boQ+Sqh3jxe0/nbaTY7h4AMEDMhBXEI
o53U2B/i358QpQpxXz8sv+koGCoJXH3ut/W3GA279+o+5oAHqsaMxEdwyXGxcVtF
HogIT3GvqRksw8hUSefTAX0L12IyNyU/6vViljJEVkQBsbJbT7kryF/AcKvXVXx4
DNaWXsikIIrSXbVJiC0qdH71Ag8Lhv8i9srZ/AoAaPN+KAGd/C5VSUJ2SzUFWzQl
7WFVesSD0AY+nUhm1n/JODCXXiFOytLZAhuxh/MXeyEd/MqAbWbwgZQ3H5WDcYiM
IOc5rda/OZjMgcF0nN3p0O+fY6ir7w==
=jAM4
-----END PGP SIGNATURE-----

--m+iZN+hwwN1Uq4kI--
