Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EAC22CBF3;
	Wed, 19 Feb 2025 23:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740006753; cv=none; b=HOBOT03wpOThCUFdzKqh2+Acjlt9ew24/prnOOXmialPKRv8YoM9Nu43jkmkH3tCX41VSLq6s9Arn0ytDsKHbvMkxlq8qLdqpnmN4yxjIVYGa8AHjCGfB8/tIBOxNrAfjR47bhMPgzIcCjvQi1w1a5LpyKaR/bn8ivxSxxqshGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740006753; c=relaxed/simple;
	bh=gQSqgQ2dE7pAJgW7MxghoZhRW8qSvUMPJTszxGKXEds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBzfM+xHGnfB2S/tuuy8wzg5nWN/H70RnDILq/KDWbUhrak1ZFyWttbjfxA5VPbxP1yFTY4Rs8Tv4J2Hcmld+uIn7l8ASW6eId0J9zbxv5uf5Nr03Qx5vK2GkNjpIK+oiXPmeDQPPSYprZ8EpNJ9YUlw7cjpHpYpKDM5e4Tw/8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdqqah3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdqqah3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E72C4CED1;
	Wed, 19 Feb 2025 23:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740006752;
	bh=gQSqgQ2dE7pAJgW7MxghoZhRW8qSvUMPJTszxGKXEds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hdqqah3qP2kQ87wiS2BDCnNG1BBTgf1ROMd3zsOMdn+hFo1GL+8vP6KlPCHFTPZFO
	 bMy0tQNG3jACytjw8bVjTfKZtjgybZwbLuQzbJChCQNwHL7bamI+e6ehcR3UTE2CsX
	 6yiReybm1GzPpGoXWIXb1O3yfbxlAVvO3i91XOz+rZuriHl1XxkwI2QPBg2WUZ0zpI
	 YlLjQW2BQri32hRNXP/rC1ZcoJ1o7nqyUaEX+hplJ6FWCW3q6FC3BZww2gJzwCF5O8
	 1YItmL4VVQc/VMn//VyGSvuQ9w383tDRazKJqgWpQvU+RgtH7/9UQKp+XGjbUAhr6A
	 asbrRV/h9fo9g==
Date: Wed, 19 Feb 2025 23:12:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/152] 6.6.79-rc1 review
Message-ID: <Z7ZlXdxiwLBOFJ5w@finisterre.sirena.org.uk>
References: <20250219082550.014812078@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VimosWQ4Y5SCbMoS"
Content-Disposition: inline
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--VimosWQ4Y5SCbMoS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2025 at 09:26:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.79 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VimosWQ4Y5SCbMoS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme2ZVwACgkQJNaLcl1U
h9D6wAf/bWg26c/bjkiNGaYdUJF0mW4MWcgAgKCd76TQ+wuxTurwahqXlgXwZ5e2
LK30hUHUsvroa5jyScKI6NCUIVoQLUy/vlOZE7+8XLrOsRUD18/TgnYEC6mXy1g7
RcswmFyJsCKDhSXSua9s/Aoyc+KMGme1PkCvoOWI2y53sLlIfqjbUW5S4tUHcUVL
EsTVJQuYsYXLh6UgXA2nv1/piDGkpkS9oppc15XEGItIapWWhKndqqce/L8fGKe/
9dWPNhh8Si21zy64OkevtseIfpBoGeNXLELOGY3WXw8ZT+oOhR52vH75kDWNClbl
xA15jleSz76XYfE5qZCMVum3udw3Kg==
=q8va
-----END PGP SIGNATURE-----

--VimosWQ4Y5SCbMoS--
