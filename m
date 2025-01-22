Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D2C215189;
	Wed, 22 Jan 2025 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737565466; cv=none; b=ankITcZcD4DbyKQ63/lJqt3j+3LMuwb3eqfD3oM346v5oAcqtyfId5lLgdes7m4X20VdxUxKifyHFD4zGcr38QQLwh/yMVrRcYo1vz2u3x3r8g6rE48v2A8niwmJZNrw5mra9jy/QOk4Jeg7DvcMguSk5aOX7bFsWpOWITmsR3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737565466; c=relaxed/simple;
	bh=T5wde4bXNHq0L8KjsnT/699D6cnkRrQIJLkoI9ZhnkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6RK7PBPjPElZzXjI4jx7fm40e6z+YFMbRIsneeg1bGAH7/BKL6VrFpbfONZLSmrgxZs46nb7+c3o8pkyg52rdSH+ZN8AYwWU9Nt1UgAbRPM4tVGNQvbvejn7HtgbAfhmLuShbuPyCJ6dhM/o4xTCSDlhEUDZzU+7QA7EqNS3WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Huih0epO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Huih0epO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C6EC4CED2;
	Wed, 22 Jan 2025 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737565465;
	bh=T5wde4bXNHq0L8KjsnT/699D6cnkRrQIJLkoI9ZhnkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Huih0epOUE4ZT2elTgpI/LI3LBtDofvDH5USe5Olp/neE2XO3tuERbJDMNBmhG2Vq
	 A+r9a0etmBk5JB+SROziOlx0mOUNJS61NLNb1l/dJ1LTjfEXbGtNkSjI+rR0VqM7aI
	 F9NEShmSv5gSVG4W0Yxsb2cg8p5TM+oakNBK9fBeYn/0HyJ2Ot4qhODJVex6CKSM0H
	 aJG5lxGvD9+IuajmFB4zGwLlXVABV5JChFVFsOIGOCZyw278v5yLsqwsLip3ghRT0L
	 qECDkRf0rlF0UfJFejQN0OorogcjqUSq2CmmADmXnmV7QWWyfS/Pulv2I3+spUghfA
	 nf4x8oELu90PQ==
Date: Wed, 22 Jan 2025 17:04:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 00/72] 6.6.74-rc1 review
Message-ID: <05ab6f46-c9b4-4aa1-8307-b605c00d653d@sirena.org.uk>
References: <20250121174523.429119852@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+rbFKgPjJlI1I94p"
Content-Disposition: inline
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
X-Cookie: Star Trek Lives!


--+rbFKgPjJlI1I94p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2025 at 06:51:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.74 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--+rbFKgPjJlI1I94p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeRJRIACgkQJNaLcl1U
h9Bg0wf8Chp/w/3XySizjbgqoCnUKGihxkB4b+rXmoDep9EzaekJWfkXfhmJ4x2u
N9f/i1a/ukqe9CNt9kDosMIGW/eswtlRbEFUh8n/SaZFE9Djwf4e1eMPd+oiqquw
5G2dBxK9nSWi09+WgfqUIrJU1zRJIIxdeQeon7jSFmzM6y71QFck5XYIZqrgkBHB
nv1gwwCP653rHNGjKD9dCxfs5QTFybfAaFxm8l6AdCKUNkjKegut6xLIhWNiqrWr
SGmU2eCJmQpLWac+sFJZo1WfXY/+imMUO139alzTuELUf3lEVY5RdDbbk2hlMcF5
5Q0NAG2yiuxj5GbaxFNMywPfgYyfhA==
=lTHB
-----END PGP SIGNATURE-----

--+rbFKgPjJlI1I94p--
