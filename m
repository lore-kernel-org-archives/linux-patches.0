Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7123E1E8843;
	Fri,  8 Nov 2024 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731080779; cv=none; b=ur5Axut7SSttIkpDdAuePqAQ0bY6GASWV3aIaQK7V3hk6r2jmqVdoT+LyKt3v4G7fAsmlTGyje6BfeBKACbY0KzR8pdJRGDgriu7NEIv6bEDPhSBhVX1X8MHVDc+F2sXJq8JRneKJ2tPDFlUuWD6XL8FfNjaxzIeZpoEW+5+E1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731080779; c=relaxed/simple;
	bh=EqPHh5El8iEEbybH1SWp2q9cOo6W+xoBOS5Q1xPL278=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jw7ELYwIHs9RnuiQhhb/UVLyfYq34w/86UtxA0zyVYaRR/R3e/SL21+B+At4YAAgNoAz3XKYr+d60ZSeU7fZArsd6JviRRIVsCigprPKWOIfxJDQgqJCb21Ub3S2xup5wKoY7lRSjhGXfB8MPo34xvxLR/RGkFHGS14VQCYQNs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EpMKJfc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpMKJfc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F9EC4CECD;
	Fri,  8 Nov 2024 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731080778;
	bh=EqPHh5El8iEEbybH1SWp2q9cOo6W+xoBOS5Q1xPL278=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EpMKJfc4pm3mHLItjn5EJ0otnR2IAI0Ot2buWjvtUfPORLMijQbFeigCQLCHtAfzi
	 6Gw52VTjTv/jfPUYXqk5RmrBHzbXNWnqZQ2pgpkaAzSy0uykeJyaDioPTWK400UWhO
	 qVx80St7H9hIALol9qNq53oEr7swuQrg25KsRQ5oxx+0OS68F47YkVCfPQwa5lqu++
	 EVxDNXSDtRQwdiZwqoQo+iYmtI8jZINskNryiKBnAUba03SsOnVSjdVNbMEDi1RTtk
	 +Q0BkalEsA5I4UCkyzT4dXNgmuHmzfaMfihbgNN/G0c0n6CMJBsX1QpWTL+ke0G1bL
	 WrIdKzsYSJHJg==
Date: Fri, 8 Nov 2024 15:46:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com
Subject: Re: [PATCH 5.15 00/73] 5.15.171-rc1 review
Message-ID: <16701efa-2f3d-4974-883f-0b07a558c79c@sirena.org.uk>
References: <20241106120259.955073160@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Lc1mA2Qq28QISx7b"
Content-Disposition: inline
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
X-Cookie: Do not overtax your powers.


--Lc1mA2Qq28QISx7b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 06, 2024 at 01:05:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.171 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Lc1mA2Qq28QISx7b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcuMkMACgkQJNaLcl1U
h9Aa1gf+OqPUyzgm0cmOizaWMPZwle8hrvhKIuRa9l8YiydSod1hsqrIg0TBWgEy
JjkggO8nMZL4cZ+Hm8rQxMb5lfb8zwfT5fST3dFtmWoQvK0qGNUwH9izbkTLEkfi
NoeX5ciWrv3lBv4rYWb6sBRhzfI6UOepGit7Ac6EQYDUHNK+ax+toxhW/SwVpqxT
YuGJpE3ctpukgK3W6iki42gJDhCCA0C1mGCr2US1fbd3m8+Qt08s+uTmwVhCPJER
IZZYuVDGzjk1BKfd0Ft/jg9fs8O8rZHvzUezFe4wiY+Cw4K7yTN+LTIl8dTVlHIW
kQoF1695rPe1UC9N9ucWGz3s0Tgv0Q==
=Yn1U
-----END PGP SIGNATURE-----

--Lc1mA2Qq28QISx7b--
