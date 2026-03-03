Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7843D3D14;
	Tue,  3 Mar 2026 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772563590; cv=none; b=UxmmxuVp/NKL0xnQ0VeUFJ2QOxbLRa8C/sjtfKasCXc4DRUOG1oLXMUv5IZeHbkfw04um1rwBg4fjQE3C0F390rP771oaiMRfAYHMfQ4DSLSC2uRrSOumlRm7QPMNCDZol3u5zmUmFqLZ7Ze14gdvIvsM4XXrlj9HLQOzSCH4Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772563590; c=relaxed/simple;
	bh=A7VQ47JPD0dcWakw/nXrIrJvGERHKkkoZ6q76JjQd90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZogZOgunW76wJtkRzhK/xGx5UHRNsnUtiLXPdHt99pZKvbO4RbfBIc/Pd3nA2QVb1ch0Mzlha+gQZmznzXalhNHnMslrlgPzkauF94E/JYhvOozc5QxeNny3StyAKLRyHC2YmWqeIF2h2x7HE4WOvbf9t5Ou7BC1eG0u+87BGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJWf+JK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJWf+JK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5E1C116C6;
	Tue,  3 Mar 2026 18:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772563589;
	bh=A7VQ47JPD0dcWakw/nXrIrJvGERHKkkoZ6q76JjQd90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GJWf+JK43fArZQhbAIYHmg+5w9JKiQ2JbC3dgKMVOgo/hzVHToaSN8LAJXLob7hdB
	 9DlT07sZrE0tb7GqLpxRG2HWZo/abDFI1cnjiblc0CEbTOw6DI+Q9+nAZXg90f5HuJ
	 /IqwXQtWaLOhBN227aNxhGVTBPZ9imXfl92tMm0f2EXdlvKlFtAA/tdx7s5Gkm3kYt
	 hjT2dCtsu7tMLOd2yrMrwuXKE9f/D0NRm7g4xF3H3OcmwQ9sJC6ZJqD/4GKjsWDIPE
	 bUROmJeRmMo4+2jSDeigFbcGWYAGBYDZMXqQmy+Yh/Eu2X4ErDD2caTlim1s6B0ZER
	 dkI3n6zs2LnNg==
Date: Tue, 3 Mar 2026 18:46:22 +0000
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
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Message-ID: <94d53832-c600-428c-a459-c61f1db6653b@sirena.org.uk>
References: <20260302160918.2520730-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dSU/brgqprMWfVi3"
Content-Disposition: inline
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
X-Cookie: Use the Force, Luke.


--dSU/brgqprMWfVi3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 02, 2026 at 11:09:18AM -0500, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dSU/brgqprMWfVi3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmnLH4ACgkQJNaLcl1U
h9DRCwf8DkvnpvSAnjpPJ4gasAt3U1yf4v/EDIb4x5/NVeh6Uo2uD8Q6tPNGXAG6
2ViLcxb0yZlqwBY5ovKqpfWjtSN9IYANK9MVMLTav6pIXXGzYsl4fw8Mchb7VEP6
bVP8c2r9azoA77zoMeZMm3BCvye4iaIuXfhM0xNMQDiuI4CCRh9yLqPhZPYhkKZb
DpRuG86JfEjy/m2MI27vVF9hgXo7bCWjNis6qOyePsOxQ9HZALlhmNMz5r+7y2m8
AYFWm3raO9qFcqqP9W1WOsienGrQtuWEwSb5jG0cSAYEGBn6VMWj/3bOhveTb+FV
D+BBYIHuJY70Wy87+JC6d6ausv5CLg==
=rpA3
-----END PGP SIGNATURE-----

--dSU/brgqprMWfVi3--
