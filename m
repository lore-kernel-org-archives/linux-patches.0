Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36F7217704;
	Sat, 11 Oct 2025 10:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760180145; cv=none; b=c4wPgQr63cB5BHRfgNg65NIy8LLbOjtJ+mVIhptuoT8YK0NF1H2hevISnVMTf/LFKPNjpEE2JwylrJEQIRQ8zUYxs8BuuuHY0tTpb+3TX2/jZsIC8ZPqpVPNGQ3iA3rJQFgXAgncqtHjRZRMjPW05ZwErtgMpk8Wo9s5XuQc7sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760180145; c=relaxed/simple;
	bh=mKgumnN5JvK5ersxi0+Taf+9sDmVrG1lW66Pvvsl1pY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfxVAWSgirxNSd2EMkz6Nefprsly1sNx/pnqerU07HEyzrbJNY/Pw3kmVX+ZyXg/PzzI0gSeGzPucyZv+Tuh/f0yry4OzYHQWdkDAvt8wVxaLogX7JrcC0mUr0DQVupcKqdgnje+sOR1RG8zJcsGECSEk3Vja1KLNFqaxknvvCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOQRhB9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOQRhB9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE03FC4CEF4;
	Sat, 11 Oct 2025 10:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760180145;
	bh=mKgumnN5JvK5ersxi0+Taf+9sDmVrG1lW66Pvvsl1pY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GOQRhB9cygYtSyxJ/XY/dOt04fP329fWM6pr9/I+R0Zlv7SP/wo8n0pMs36tfEq2o
	 Q+1FRFIEJoecfDakx+sFjcs7kOrnyP/SAhIZg4uZKAhcvTEphIHn5PqrvNQOgQ5dwm
	 GfcT9SaTpCmOqrpCdvykE95Y6jo37cnwiW7aJpY7z3CXwAWENiG+1KoyrJR1EO5uG4
	 MCrQDZn5NT+7qFvDaoDKVd2lFngxXKzvBeoeparfMvuRjl4k8UuvD0nj4YAo+9xlNH
	 mMhiFaYKRtI93qiisBQMPd1V9jS+kWJyFumRkIKIqeB5XOBdmuL4UGkrdE3XpBgrv+
	 UiSkk8BMfo/oQ==
Date: Sat, 11 Oct 2025 11:55:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.6 00/28] 6.6.111-rc1 review
Message-ID: <aOo3rYORhhblfiP5@finisterre.sirena.org.uk>
References: <20251010131330.355311487@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dJmC80PMygARyTnE"
Content-Disposition: inline
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--dJmC80PMygARyTnE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 10, 2025 at 03:16:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.111 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dJmC80PMygARyTnE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjqN60ACgkQJNaLcl1U
h9DvtwgAgGjvov+B6hSOR55wKM00CrlvW49MNpV5772NAJ4c7b2BHh2dLb/y4Se1
MVtyO5daRBaN2GUXTfK0XIT4d6Ay2LpNDG1n0VatVNkk04RncJlc+0byP7ePZEbX
TgpGKqiySGoiaSXe78kmtfD5tdoHbjh0FE/y62gygEl4ntczmH9B3YoDN6elxkNY
YTKXlRp+uTj2knPbLEY4hz917M1ltpdaPNdhwB0XeU9KSanzhA9yVL2FOLRZeAeO
sxHmK90mWXsSZjLcc3TG3Frls7JrOclqXKSukq/MrcyOiAg+vI0rRQaw0w/1uLXu
oK/rRi1qE8dPEyedkEiTY2j5rgl0eg==
=lmfC
-----END PGP SIGNATURE-----

--dJmC80PMygARyTnE--
