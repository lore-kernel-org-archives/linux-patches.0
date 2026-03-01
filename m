Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353572EFD9B;
	Sun,  1 Mar 2026 12:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772367036; cv=none; b=rJH/2c8GrOF4y+d5qOAy0ZYbr3c1R1M1xCrv/9k1JAbGM7SiKTk8hjFugH902exqWHcNR7ytNkxaEyx0UHQZoOR6RCsHYexKpqgjBfWMmtax+uGiMfW0TC1DgYA2Sp3q7PQdKTrbDa8Vgw7ad+IsDElmAx+zmy5p+VRA8pbyrf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772367036; c=relaxed/simple;
	bh=rImz8/EHmMKxZQgXaq0guR5vsKBGy6/KobbLw/R9CTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9d5pZPZLeOTQOXpB5ML5vyP2eClqKi1i49esqbLvVS1toqJdLldyKbE3vmzH1MWou2FSdgfM4IZ5dAfYWvf05sAm7N1JntTYgMe61XooM3qy19BDchCA1DeE/ojUYhQvIqXNp25NiVEQ1Hyy3mkIyTE5PeM5yy0ci7G0Cz8Axg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0sjXlzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0sjXlzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD98BC116C6;
	Sun,  1 Mar 2026 12:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772367036;
	bh=rImz8/EHmMKxZQgXaq0guR5vsKBGy6/KobbLw/R9CTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J0sjXlzOtKCd6KYFTTQ2W0elIoJA0lQFqAkDpYsVEfk4B3S3I5TH/XQKQ0tyAEEr8
	 0hAiKujWQoezUfOgbUsGapE+7CUPOh7UndMUoGuGwInGbZA3md99plRwZ17TzbN7kP
	 /MdJFgsfnvjI52I7+pQKj3uesYzsOnZGqfBqX3PFtlrBm9WWQDMCts/Qo6HbpDWJdb
	 yQozFGd2vK0cuqqE1quRHt8pAPp2lT7D4YRR30ebKBGKFMxUH9XHr4mjcBuBVyzFgf
	 4sYM2VnIXbke5dIZyQpBY4CUoEqTQ9fiq6gK6m5XJbOJgIQ7e+6fQilMkVSs7mZxab
	 yQeqWKwnc+dYA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 6CAFE1AC58DA; Sun, 01 Mar 2026 12:10:32 +0000 (GMT)
Date: Sun, 1 Mar 2026 12:10:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/232] 6.1.165-rc1 review
Message-ID: <aaQsuN9Y82rBGGde@sirena.co.uk>
References: <20260228181119.1592516-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OXq18sMvjDvZRBV3"
Content-Disposition: inline
In-Reply-To: <20260228181119.1592516-1-sashal@kernel.org>
X-Cookie: Think big.  Pollute the Mississippi.


--OXq18sMvjDvZRBV3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 28, 2026 at 01:11:19PM -0500, Sasha Levin wrote:

> This is the start of the stable review cycle for the 6.1.165 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--OXq18sMvjDvZRBV3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmkLLcACgkQJNaLcl1U
h9D5SQf/YuRzJJ48xzyhTZplAZ+HRGLZ47IIDQqEl95pRlD5v01pd1ZRjYazsWN7
gyrFhxmO1g8owD2wHoMa9hIHr8JamsjpwGvwl+1HrFqZuxMkE+KvzrNWsWXnTzk5
R/3lnjDYRI0qlXbpFaNXLhBBjmeNoAcqJaZsu6H9xTih8sP9+YT6+UqCAE5SIo1/
VEPHhHaSt1n2424KFSx5RiSL2nH59ghjQtQAZXnabgPvuTvimLfGEoxq28k50dso
odhnEznzyXcigVAXUNhl4impoWdsARKPbtrpfg/nT5XjKxxptKx4SYIz7/Y805T3
GdVNl09UhcwAC62NB8+9qsvDmaiYJw==
=CS58
-----END PGP SIGNATURE-----

--OXq18sMvjDvZRBV3--
