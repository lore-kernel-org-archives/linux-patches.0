Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A0827FD74;
	Fri, 24 Apr 2026 21:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067558; cv=none; b=ZrqEzGwSdOrCb8hzCXKob6kLZY5pseYghUD/JI8Nsz6kDEuWxMzDtokbBo4S3bJdX9x0TpO+pzlLuk+kVuwSLENtQt/E0Lf82CVmNwqjP1kqucPFqIb6X38F/tHvxO7DQAeABy2qnxm5GZRMKNxT1ybC6mvrL4VDi2d4Deh1Nwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067558; c=relaxed/simple;
	bh=ST06IZ20xS4Ttq7iDzC6ZhT8+wvrY4tI7A/2SqWMbuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2vKcG59WvgJYoQ4jNUSTaWzGTDYethJBbH3LKhlCmIcUoHoXOB+zGdpUCfKqL2FNvFCPf5/0Bnl2RYyRuQlrgmcXQGjzFe0P45qXNDVJWzK+EKonMoVnx8V862InSliHH8SyTVDuaBNoPWCZyC1mnLHSTCbaVsC1TieV5MQtgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pKhSjNLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pKhSjNLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34538C19425;
	Fri, 24 Apr 2026 21:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067557;
	bh=ST06IZ20xS4Ttq7iDzC6ZhT8+wvrY4tI7A/2SqWMbuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pKhSjNLlDGsv0YJYsP577h4T1zdzKUxNJbXE/g3gqX40H2dUR5eOY15q0oOr0tZcw
	 frY92C5XL2ciVyicdzPzNoOXwOP7l/C+2CAOjKgr0ieY/FvjEKeqjWLqxS9tIy5xrJ
	 GcfeW+oWxsiM/ZZ+azCHNtkQX4IbZHH+6XFNxq5e+6BaLDUsth1Z9nvgeVeM5ZZqkQ
	 zBk97tlxGDj0xCsFJbbtEmlvqXpQqwGFeVUXW+PuVXpohHWWuOrNHde4T+I0CjqMG8
	 +X8PEz4M012825Q34YyY5g5InDLzTqAJxYPVwKl5btNZH1o6/XgNQfSflhuxC8rEg3
	 qNZ5PS5NXnNog==
Date: Fri, 24 Apr 2026 22:52:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/166] 6.6.136-rc1 review
Message-ID: <07e46cfd-c55e-4f41-99a5-7780546a1016@sirena.org.uk>
References: <20260424132532.812258529@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oK0jRgtiKL7GDmO1"
Content-Disposition: inline
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
X-Cookie: 1 bulls, 3 cows.


--oK0jRgtiKL7GDmO1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 24, 2026 at 03:28:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.136 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--oK0jRgtiKL7GDmO1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnr5h4ACgkQJNaLcl1U
h9CXJgf+N+xmbDHE/OOQ2uiDdE2KmdSpFIZSICrH7hb5LLxH1f7Wl9o9AQVfyg9Q
xoCrx3Eqo/JeFP1N2RA/udUC6wuOiRubbX7MCF+awwvQ4r1O6G+mbrEgxqvpfwhf
OQBEqwk0GrYrPG1BSV4lDsnkqOVawgri+7+YxjmRrM3+RY7xfuKu8r6c9qPrzLGI
Grt7ziD+Z+JPfV+1BP25RipuKo0TgGmUhXUuuPrFRrPmooyU6hUwvrYSZu91USs5
Nap2HyyxMSRuw/ybOEt8ez/JSwAVciaxi5cNYsxXF9Ago0wHscL5BYnoHKCn6/YC
XAmh8GcsIjpvloS+YHilvdYZnCfYPA==
=uJ7R
-----END PGP SIGNATURE-----

--oK0jRgtiKL7GDmO1--
