Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB63FEBE;
	Thu, 20 Jun 2024 11:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718883655; cv=none; b=tBY8zVyNaMuxXsNB/kCUa2wqMaU1vHE+5HDG56UsqhkGgQuZavBNfmBSSsHBQ9yyAkPTWMPkktOi3cxbn1JRwBTY28VVP9TPJ3JImj9lwlpUyDXVJk/qiJpoyPhaKhWlF13ENFd0JO+8GkXwq2u2rIjO0yLoIXUs1qQx4uHNaO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718883655; c=relaxed/simple;
	bh=eJi2p1dvVeGtMz3ZBSNeSCr6j9zLLDVKdhCkZutvACU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPF7EfIaQba8f4d2OQnLMadU+jtWzIDVB+0izrbE7NJxMj1oWDRU2xj4adnmshpDN2C+MwxiXARvKkztplr6CSj26kz6cxI/xc+lBPujtEhjKcxYCcWuTvcSwM1trek4hMPIyV72qyNiWbtE5THRZWCFW5H1FL/+Ru6Ovcxu4ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1OZkBcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1OZkBcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFDBC32781;
	Thu, 20 Jun 2024 11:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718883654;
	bh=eJi2p1dvVeGtMz3ZBSNeSCr6j9zLLDVKdhCkZutvACU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B1OZkBcN/j44euMVC/ho6HsATTrUk9K671dtTOs9RrkXNFpVraDv1XjpvkhziSntg
	 dYwXQYdDP48kJP9ddfZ6/UcHGlOJHHIj4DI98knvgR81le/TsimT4wP6zh2+rZDZzI
	 n08F9ARH6ZSyyY/yZh6ZtSMVi2doz1Au13XcxTxKTO5rcr1swGpPJd9WUNGxkVqXSq
	 yNfInfgY3LL0eYENH/A35YKwZNMpzeXsFID8bqar1flBK4onfW3HlE6FVq6Eomp3nT
	 ojtR7HrE/JFMsuBGl64b47WRaPZyVRYyDgEBpyvc8+yCERfI9hOOTlKaeUZ+a+LVaG
	 +9605Y0sjs2lw==
Date: Thu, 20 Jun 2024 12:40:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
Message-ID: <6d861a91-bbb3-4a2a-baac-910877955d48@sirena.org.uk>
References: <20240619125606.345939659@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rpEi0P50c9vbrCTr"
Content-Disposition: inline
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
X-Cookie: You're already carrying the sphere!


--rpEi0P50c9vbrCTr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2024 at 02:52:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--rpEi0P50c9vbrCTr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZ0FT8ACgkQJNaLcl1U
h9AtoQf5AaivccS2D7JAngqbNJYk6zok4XJe4/IV+0MQnS+JKcqAB5eK9EetZ0kr
hFXBhWtZQPgCI/B6vnyIYvAyvDDrORgxsJRsQL4oUWpZlWk54l6ILWwSeyvudDrh
FAww4uhn7FjFPW/QC4WIJlJfjOl6KzylwKvMnJ8nYnuv2eGh+SL2gioaJvjIiFpl
LALIAY6KXKXOo822JkTXeuNRkHDiYuwProPzcx4LuO321mf5lhTBa+wgrD33qB+0
SFSxEBV5/pP/b5KFu5512iMB0F3MWfPqhKK9N1TFo98AbFS5Hs63DUhGLEFzsIGT
csg5azyreMxYjqYvoaRd8caHDnLFWg==
=Pi9l
-----END PGP SIGNATURE-----

--rpEi0P50c9vbrCTr--
