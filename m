Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDE51F1932;
	Fri, 16 Jan 2026 19:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768591144; cv=none; b=s9M67+Dx64nOK0ITq4CANaj7+WHxJQ3b3cf4GbUYbTgv3mdA5QZ0O21aqQafg6PgZ7LlQbZ3hFW7a5gzKNQsodKMU9mtmKmdQVbC5JXwWij8Lepod+CB9kusKcI4QZ/GefI94kt0wMgBRcClhjb/fW8quzhHKsqGgQiBRJKLckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768591144; c=relaxed/simple;
	bh=F7N87ljR+BaMgWtzzudQXHUi5Hxtgo050Rq8HZZ+e2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUgNJUr3ok3v+IyPoyaTT6M+bZT0SHqtPO6Q1Ggu08LnaHzxDj1JL/4HpzdI5wcqPB5gKOhP0zGtOTwKxa8y/SnEEEQJgom3Z6Z6tG7fXVW1mdrVhv9ASamBkIejpD61LtabL4cmm6hMSxV8qniSrTByhdl3sZS4TzzkabaXcAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M896uJCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M896uJCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775AFC116C6;
	Fri, 16 Jan 2026 19:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768591144;
	bh=F7N87ljR+BaMgWtzzudQXHUi5Hxtgo050Rq8HZZ+e2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M896uJCidPRckqiGfGb5yt+aLY8zWnfO2hsymiogymlWQx78el8TjbquMO0PL2Y/d
	 6YqwBcixz4TofY97+B88E4fI65Y/oPKVYQReYvvjiksemE1tVz8II5wrrQHnfsCFjS
	 8c3IGrKeK/U7BksTt7vEVKX5HYYfPHxuCVHomICRAVH3l8+KR2MqkgruV2rSPb2WH4
	 474NRO3Fozs4Qm1Vf0lTPBosWXc06dD7O6RMmJioIRkOkuMr5INZmDMUnaIHi8yg9n
	 Qk9ZmTISlzxIvIRlRIn8ZtbZoG+ldHx8KVl2ppHr1x4XQUunYbrMEvm1QZZi3JWMw6
	 srwa1RJ/GUMHA==
Date: Fri, 16 Jan 2026 19:18:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
Message-ID: <1fdca542-d72f-49da-a265-5d426f7d18a0@sirena.org.uk>
References: <20260115164151.948839306@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SNvbRH05mA1QfAiA"
Content-Disposition: inline
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
X-Cookie: I've only got 12 cards.


--SNvbRH05mA1QfAiA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2026 at 05:46:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--SNvbRH05mA1QfAiA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlqjyAACgkQJNaLcl1U
h9DuvAf9EJqzzik8pTMwQ+3M3IGIrWWQ62f4MhoKMOBDIMz/ISjS9sV8VEBMXhhB
R0crnYMZnZQPZpT3jZwVYny23B+fDjgkwb++336KBDHNxXxYW+1E77NHlba6ekaw
nNHHqEpF8/IYpHsnFp32woBCGg6G0jt1Cc3S3j0KJcZqVdjDfr9T1wsn5F8iQptI
ORddifhyQ20f/RosesPF1R/3jx8eUku0LC3KS+OSvhv1F/bQ3ZJeRd7M2i7Lbb2l
PqRld5WBRYfOJCG7g6tzz8HB6D/7SBXDJN1kDULIgJAWd1bT7Cq75SHQgBydhJ8U
dUZ2asftEZDXpPl2wtZoz7l0pYJsVw==
=xVZ5
-----END PGP SIGNATURE-----

--SNvbRH05mA1QfAiA--
