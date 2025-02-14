Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23F71C84D2;
	Fri, 14 Feb 2025 00:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739491211; cv=none; b=TYJlkllDtWYXd3v8JADi8GBtJBLrQHJ6LlfgRZ2DKBWB9jhLx8ZLQ+WehLCcLpCMOWMQxDliiHcX0Gw7LZOU4QMJqfv4w1j+MrCC3pKyidRjYi7yz7rZtuQkOLREoe2Ip9uODqvi7fBXuFiQgrx4Ew5TawmL4i3xtqsKonSP2KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739491211; c=relaxed/simple;
	bh=QG6iJAnB/OTFtwIXlkN8O0GvPu9BSkoXLQuhM6EppDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQsAi0pHYNU0LDBV++bCE7lVKrq6/eZsqh2zliCTk21Jk5C6iT4X/3kGxzVNIx493EZKYURr7rD56Yg68sUJ+nts4e3RXfjglkbi7JDYJGxbuB0Ntukz6CM6a6/rX18rKa3I9+UeHb0TQxIsMzKqka/eFTLtV49eankTT6KdGBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3/9XLcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3/9XLcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64099C4CED1;
	Fri, 14 Feb 2025 00:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739491210;
	bh=QG6iJAnB/OTFtwIXlkN8O0GvPu9BSkoXLQuhM6EppDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V3/9XLcuOkWwMkaZzqCIiM1sxViTEnDwAPeEM7lprwRFYU2EmxcBTYtIblOpHgzx5
	 Y7vF0I+9APK+x5dSTd0qS0qVg2m1bEq6t02jwuvdmjuTa5/u+hgi5rcj2IChpox1Tc
	 Jakgd1TujyCWZgvUa8UMdVuuAQFV7NOgDEpk9dYt0HQqAiEdjHLhGzC6BbLUuHqvsM
	 bUDXgJAEcpxpZBs+/02WtlwSPsSNL5Ols8LqjX0xNOMQVWnJyZqVFzmhRfoTl6I4N5
	 f6kRC6cKnnLDzd3NLrhRVNL/4SfXBjfX2wXvpDRBqOA/lGIn/sBKkaE0DYutmFkRP6
	 MqfjEoVGfRDug==
Date: Fri, 14 Feb 2025 00:00:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
Message-ID: <5fe18c4a-028e-4b38-8500-99fd920c30fd@sirena.org.uk>
References: <20250213142407.354217048@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CO9GIaVpI0lWzJrl"
Content-Disposition: inline
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
X-Cookie: Take it easy, we're in a hurry.


--CO9GIaVpI0lWzJrl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2025 at 03:26:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--CO9GIaVpI0lWzJrl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeuh4IACgkQJNaLcl1U
h9C6MAf/bb9jd3Z4BJS46kN7HvgHvr72z/R1rIykIR6tgtbyJ4zEfpUvla3bgnEj
KCJHS/uRjMXAym96nAZX3vT+jyoJrqV5LNvpuZOJmYT5k+rAWzT3AnTPLjOJo7ZQ
ZM8hzn/rIy8UlzsdDkzgOVrFJIV2mP8wKdRHB/yveubVHSnZXj3YViEzkYmXDFee
RJI9Tb+3KxQzfIbTvhPTYqopFNgAepR2YkFH0BT9wTzcMOXKxn92f9MnV21zqvrg
4ty/J9UPXbc/Y3OyuVAAkPLpsb65omXmEJK6tpkOFN5cp6KiM0V/4XjhQExa8/91
nlWalFnnw8JL/7Wo7WeofFF4gkDSYA==
=lyq3
-----END PGP SIGNATURE-----

--CO9GIaVpI0lWzJrl--
