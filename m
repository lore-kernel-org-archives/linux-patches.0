Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6094733ADAF;
	Fri, 16 Jan 2026 19:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768591306; cv=none; b=Nq3jjtvXuMqLfaToeZrvhIwaRTNPMP8s9S1ORtKXJo5ikYt3O49zbCfLNXigUsUfZMJRs24melsJm0i1lDsWN7wHt3qgdJV8ufnfWhxDmnGU4532KZsGPDDZ8TfgNOiPwe5FCPyk5F1vdWA5+ml+L8z5tVO8AB6Lt82EGxsN6pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768591306; c=relaxed/simple;
	bh=4PIsjwQmwhoozVwiwWVwspQ/eaQb6SpAAh0UmNLPefg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OObus1Nz9RF0LU3udf1Udv2qZBOlg1cucykmNTJsONbQHsqe29NWQt7JstTxXA+1tccDc5BgnyejHhnJZ9bdSmV79f0GP9l0XAo9ee8uz6NOrPaCVUnNJABQYCNQj0vloQJ1h42jYqkBjNVglv8Ylf5II9RKG/81iHuXovWPJls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qPgQxKK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qPgQxKK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960CFC116C6;
	Fri, 16 Jan 2026 19:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768591306;
	bh=4PIsjwQmwhoozVwiwWVwspQ/eaQb6SpAAh0UmNLPefg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qPgQxKK5nhLP5hkvb2RjhbpEWs3tdlOAyKlM5jP73zaX18JuX3FxsdyzEmgvn351H
	 bRMP+BUnDIEJjnR/u85O9YxpbB9myTOylNwSHDjl9TfrJ37aWRa5VWk+Nk/jjO71br
	 f+qqfXIB+hA4mUqRpz9FzJTFd0R5hJ7JKYmMP9Y6yowKrs+Bbsa5TXoiyuZdsqfhia
	 Jl3uYurLQm1L+k0q3DHe7a49XgUloSdxukbFZk5aGtzIT/GvKT/tA4Bjcf8+yLw1Xj
	 doU9dNk7U55qJB0+Y2a+Na3mB9ALitr0uOXHc6QrHq/3TXwp9yKEmTbsns3Br4xDcB
	 neZUfFSoM1K/w==
Date: Fri, 16 Jan 2026 19:21:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/551] 5.15.198-rc2 review
Message-ID: <d389d07f-c53c-4bdf-ab15-c9ad78ad9fd1@sirena.org.uk>
References: <20260116111040.672107150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5vFRQIppgczMos7L"
Content-Disposition: inline
In-Reply-To: <20260116111040.672107150@linuxfoundation.org>
X-Cookie: I've only got 12 cards.


--5vFRQIppgczMos7L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2026 at 12:13:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.198 release.
> There are 551 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--5vFRQIppgczMos7L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlqj8MACgkQJNaLcl1U
h9C0zwf/eQ/iCg61SMG2P56FeK46C9LwwCdtp5jZGK5dCxioci7JKIfldXd+x3/i
nzS8ewg/F/VXj2OZRVgbMXBRBafoY0p86+k66RDsPPo2GBbkjrB/hYvOI6dPdxPC
4C+pv7YAX4brlpwglmGbml7E46bBWI9u5Q4maitcDTyf9Z0qnzX5CamEKEFJAdVr
Yj0tzMHeV2tC6DeufGOJuZgTwhPdhdaNQPLOIizVfK41UQi8TDNzo15+nwJICR2b
OeyqBDhMN4Mn1gD3MBLyYToHHLEmdw1GhWOguVAiLif6tyWPQeE6ZV4qM8CsnPK+
FzsuuNzRPZ33btlKs3uxnYzrLzatDQ==
=Xccc
-----END PGP SIGNATURE-----

--5vFRQIppgczMos7L--
