Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0517420DD5C;
	Thu,  6 Mar 2025 13:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741266913; cv=none; b=SnLSQHP6twuxGBAi6fKnun8l+Gf7nk5opLp4ojmo+YYc0L1MkaevQSx0Vkn3uoiJ5jyqbJcZejolSmp/w7KZdFRmopE29BWkPdi01L0gHilLpV010+vWVedED9TcuxeGDR80cyZ78D7LbWdjuBlfkHGEOWMUuh9AnKXgOaN0jYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741266913; c=relaxed/simple;
	bh=O9O62UlkBTOhtuGrt5efvAUz84z1X18H1McnHic9SF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnlQXlMjLI8wOf/446CIE9lZQvWH7LTu1e1PBMvZLjGZwM3kGvF3PU8gXLNFaXpn9Z+3g7HijMhS15E2wJ7fIAIiWUofTPFYOvtuU4IQRRW+a/TZcm+RFQfVyLthH7xEoXqZhdq5Brj+L5hLxNdzKcrHUr0fSQHMTgaqoTFIo3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7arWnbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7arWnbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D92C4CEE0;
	Thu,  6 Mar 2025 13:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741266912;
	bh=O9O62UlkBTOhtuGrt5efvAUz84z1X18H1McnHic9SF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q7arWnbf+mnu1DCbjy5hefMvtmGP/A8FBbFbGU9lLfNtdh0rP1jlY+sMuzOXIvC/e
	 1zv1tIIyT4u2rBTtTnxknCM7Qg7PeZnDqUMyhJxDjPe0Xw++ps0XbWOrmcrC6Jj76i
	 mkh02qruFVDTHlDKPjLScJHcfrcx+ow/kalQUYLgOYy4Re1USIRy62o+ML5Gis2ZKg
	 FBTfdUCSy6foxdunJoOIFzWQSlIhZflgCJz1uOm46+NkNDAD+Uxr9SDdZVxzKerJE8
	 tE9XP1/ctxKFloCc9LM9Se0UThUwrUAJNmKWMM2b/vi+ituo5I5zVQyCPyMDu90mEX
	 MbszTKrKZGa1Q==
Date: Thu, 6 Mar 2025 13:15:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/176] 6.1.130-rc1 review
Message-ID: <083c24a7-f5d7-4be0-a3ab-ff8fd43e4027@sirena.org.uk>
References: <20250305174505.437358097@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wCC8hkrLehm9utWs"
Content-Disposition: inline
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
X-Cookie: What!?  Me worry?


--wCC8hkrLehm9utWs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 05, 2025 at 06:46:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--wCC8hkrLehm9utWs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfJn9kACgkQJNaLcl1U
h9D1ygf/co2z08dbMwOCPd6thascuXdM3+0jP5iYz5v1QQQNmDdUVvMwSdUc5ptK
0jKWo2dQG8ZxZWLC68ZOOoCIKmHPVL5jZPNksNVBZT2Y85LOJpu7/KbKpYiDTr4N
fOtzSERJAE417b210HkgAhimlWZajl5t705dV/Qrnrl9G6lD2JytaC8zefliIoKL
b8UkstHx/Tv3pjY93L1IpTToyvVz5PsWB5+DxrJsKdVADohvKgc7IvUypB4+5anE
+Py8Om2SSSg8BLXCqmwKB+skxGvElErE9YSdZTJFH8mqCmiDJ8RO7EhyytKEUowm
3IYjoPPvN4BLDtlRQ38KXHrVklhslQ==
=RzpW
-----END PGP SIGNATURE-----

--wCC8hkrLehm9utWs--
