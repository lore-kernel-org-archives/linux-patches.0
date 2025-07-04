Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C472D63EC;
	Fri,  4 Jul 2025 12:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751631303; cv=none; b=uyXmGhzbT5hJ6iV/tMcKDPO40ZkJNx8c1XcbWVJGVuIcQj9ojsKbd/1VacZ9GZqpOHQe5BuUxvutAFa0PZgWMSITh88ICCJo59+pjQ9w7nVHHvYfKtCeRC1i/lpRXdBC9iQiRzSrieAAysu03Unvav8TIrMaMX02pzMgsXdIkpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751631303; c=relaxed/simple;
	bh=jGZAKokyBdNC7ugW5C09xqrMncHu2TlDWoIiOyFhYcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Llzzzn6qaEADa3JOkwxIBZmZu7Esm2LsbDSHfg/wy5f8fprs+gaRGlfM1826+LtU7X191DqZgpZNoUqfRqOIsn1mGMNFtdD/3iMGGSZPGLFHhWGcgmwoPOIVGZnJ1h8dqPM9PoUN73epYymwlnNBdt2tT3fEy3eB2kadMh8jbc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbUgefxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbUgefxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23134C4CEE3;
	Fri,  4 Jul 2025 12:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751631302;
	bh=jGZAKokyBdNC7ugW5C09xqrMncHu2TlDWoIiOyFhYcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GbUgefxcCb93/ARuVC/W6RytJA3R2oHbmeuY99IpbmWbRQjOKXjOt0CWqmtTIlQ7N
	 Lv881rxMcI9iTpyf1R1M+gH0OFFuQ2elWowcJHIWRETTSuSzmUzNmDWlVZWEKFE/MV
	 CVfrUDI5Q4EdfLHxBlmDc3ia5h8pILwrvUpBEKGp3gzMzaQt05/EEpP9T/DEvCgirZ
	 OEhu1vGXV6yGdsWKTg9heLf/yMvV4SfHhssFCNRAWlW4xGnV3s2Y1IE2MdAp8wuLDx
	 4IItS28hdQLwYHbNQXQYpFKs8ncHoJ0GMAg7rION15MKF6E82vpgljcRYbCKeFlkQa
	 6CRQts9ILonaQ==
Date: Fri, 4 Jul 2025 13:14:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
Message-ID: <972aef5f-422d-4f48-9b98-b42fded98841@sirena.org.uk>
References: <20250703143941.182414597@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="O4iI5+vWMFSYgVC9"
Content-Disposition: inline
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
X-Cookie: VMS must die!


--O4iI5+vWMFSYgVC9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2025 at 04:41:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.96 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--O4iI5+vWMFSYgVC9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhnxb8ACgkQJNaLcl1U
h9AaQgf/R4SAVKvRAVfVXmbByN63EXLiLgzDzoupjJAEa5BB66Dm+wrS8Zz7PJJH
mUzGH6590XCp4+W85rBkR+GtkIMi3tI6SIwp1dgDZUubI/M6lb2xsuKigaUX6iNh
PomUWu4RhIgh72p4VQ8z8jjRggSBVgikK7ri7vOyp39gAjeQXILidWv5cQyQWFx4
0MjaLy1cI76bpVK+r2+o1ztI8E+h1wpbZaCyMFvFg/dHpvkDCXyFDd2CnFcvhdXf
bFwY4U9IEjZkqbVEAafj4ZqqHiqLqao5k4YxRBQ6AsLpUalrPqvjPts/secDk1Ms
Te5Ammr/Ta12Mpcn0ZXCjrb054w1Kg==
=73ql
-----END PGP SIGNATURE-----

--O4iI5+vWMFSYgVC9--
