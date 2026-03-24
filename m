Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0512039768D;
	Tue, 24 Mar 2026 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774366737; cv=none; b=hqDeZ6UwDblrVGwsg6xEE2NZxO+OBc6TffKh3bUdsO9mVeVL00oXgERH7qpgsXVcEbiXD7sFLC33Eh7+1qb0WGvbYdHOmLpVZXEtCoX0P4K6DmhFLJSvIPBROmRqRxED/Qf+SaBo0OAP4td9e7H5pIoKO5z5odbS281Z7xHgzM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774366737; c=relaxed/simple;
	bh=LmRlgfHRkXV/Z/THmHm+a0sXXS3m/D27NwNuF8QvyBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlr0sYIUf52XII4L5LzZyeoOTJxpJKiP1GBAGSPGwam4fHM4CwAZBKuo0+KliEiZaCPK4lOZnhcWaCMg2TGYo+d2j3o59Y6iY7LPbub/nRxPkk9InWLY7l1S/UYAkeOozHAOh6i9KosSKMkq/7sBVodusTKUT6K81EQZITTLvjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elURVI5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elURVI5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095BFC19424;
	Tue, 24 Mar 2026 15:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774366736;
	bh=LmRlgfHRkXV/Z/THmHm+a0sXXS3m/D27NwNuF8QvyBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=elURVI5nhhuhfvcoJH+fLF8DoLpWv9no1lqdpO+IgCqD2v7crPyepcOoE03Iqvn+m
	 DtEGvB/2uo1yJIbtUU4kT+NWL6qM8e85PfEAWicClrjku+Fga9HymnyWFmDn567gcg
	 EyX1t6sENNdtTXU1W+dmz5A7v/LyK5gDrsi7sjJTXUAFMgV4FLTU+qPMS3T/f3RRgm
	 H5zvqCzcpGRtgwR1jRNCr96WVd8aRyP98mpr2J20vmWWnNc1mwCsM9txJaSfOW0f6M
	 idp30VaAUba87484hzshuKRslc224ehUINePQz9HIf0/f+cuS/eh/q3ICRdBBIk01Y
	 1RgMiPqiboC1g==
Date: Tue, 24 Mar 2026 15:38:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
Message-ID: <7d04d749-66fb-4ef9-92be-415b3823deab@sirena.org.uk>
References: <20260323134533.749096647@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NTdnPYZJtwhYBFew"
Content-Disposition: inline
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
X-Cookie: Forest fires cause Smokey Bears.


--NTdnPYZJtwhYBFew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2026 at 02:38:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--NTdnPYZJtwhYBFew
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCsAkACgkQJNaLcl1U
h9CwNQf+Ls2oEzFfmKpaYXqN7NxqqWi7RVtRcVZ1RDPSm6LO+VQhnF2rUwZ7lgnO
QSXmQPN6IH/MbiHB+PZUAqzKbDhPTJHXOvy8AfEBWFdDpPlPuZcBFp0YbH56gfVc
TnJ0CYiDOAwuLJ668nMPTY0J+t/U7QpQtnSk8f6fCEuq7KDbFrEWtTs586aN0+KM
98QiKIvxJR5Bg7ve0Ik0epZ1TbzEBscjX9wzZJ8fOosrEkx1+btJgLgWjR2BmEt/
Tv6BN7skYiF50LZ33GhYo8HVsrC+DV/aBJqU0kzUBZwt8mfm0PAMjqztWxTg1eqH
brc1p/abH4GFBmtYShSYjtCl/CYdKQ==
=xWaB
-----END PGP SIGNATURE-----

--NTdnPYZJtwhYBFew--
