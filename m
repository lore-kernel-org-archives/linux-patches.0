Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1BF25F96B;
	Thu, 11 Dec 2025 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765443739; cv=none; b=kjMk5/rJ4SaHt2pNCq8DylzBm+KJBZUFSKqJxiuFxpeDKUZvdPphqaubXbSm1DzHxJpzWPqH/je4uEs5Z/OAWG8KNvBrGGsC+vg5LOeHv6tBJ4ILOWYs3oJ+4bwCrD62enKEbqCXYQekRGRcaqsFLNn93V3cA7wqQbOSTYjbmLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765443739; c=relaxed/simple;
	bh=nkq1ZXiB49UyB3y6+lIE0f7UqwJlWmJTtNCh5bPPlSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6pDqJUBGWaDLtkpbzyERHL1a0sfC0X0snGHNjRg4IrQfduurk24V2+xlPtiDuRgkVntAMx0MFPFMVP/Iz3ohRTdxeMK2hLyL61cEVe/zYeuMeanRXJ5hOuUIQlN8/qPuaGWLdKK8HGN1wA/N8XPE5+NiYJc9wyVFK3fE9TFnR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TW23bRbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TW23bRbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6762AC4CEFB;
	Thu, 11 Dec 2025 09:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765443737;
	bh=nkq1ZXiB49UyB3y6+lIE0f7UqwJlWmJTtNCh5bPPlSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TW23bRbxay5k2LC8n36ZkDcoNEfMKZklmUORF5C45+R7AAi79BpizK59UdSasTbPp
	 o1kiqtwzH1qHZNdYrkBdqrzK+n61YUmpvXsjGI2SMPBCQ5f09j1+dOS9cp6oUyPSvf
	 OK5VHNRaPXTCvfQgBQAmEiwas+q5oWo8HCQkcMa5//8qPfx8Ve74Lviull4EkyVcSP
	 Bul22WEnMd7m5UjOn3rfQgOkjGzpq8NCOeKxhIGhgE6xTTfe4xnUf853Y95A4IS0Gn
	 5i/R1dml6AT5NQUdS8JEAEbBvQGvKKsnGCSU6+qAGmCOlgvyrYfyUUMoNf/IBoatae
	 Z63mf5VUrmg0Q==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id E2B431ACB974; Thu, 11 Dec 2025 09:02:13 +0000 (GMT)
Date: Thu, 11 Dec 2025 18:02:13 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
Message-ID: <aTqIlTvqHS0rocte@sirena.co.uk>
References: <20251210072944.363788552@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UdWITBtXkyHyz5zJ"
Content-Disposition: inline
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
X-Cookie: It's clever, but is it art?


--UdWITBtXkyHyz5zJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2025 at 04:30:10PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.1 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--UdWITBtXkyHyz5zJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmk6iJIACgkQJNaLcl1U
h9DYDAf9FbVQDnsKh2WTzU0FNIVUNt3cgEarYdT+L21oKkDvb2K7q2VJr7aiswyx
U1aanSh2emBYIp5+qsFMN+d37IPJ/q2FcS6crQpx+DGdZrI+6L7876aT91dalfNE
jVT33Ll+LvMMpNiFe8Cr6iM0o0rCR0AVwGUmpVyVLse1BIMLw///Xv2O9ohJp7+8
cRBNcUs0bwXvhtriC8OJBUwBxslp1f8fQDSYV4CmUpzCI173iqsUJIMMqks+WUuV
i3kSTEvb1yx0Vs8X4OYJHmfYcwD93SSi/uzfzbmHDMlrPK2/u3yVXAWgN9ptGx4O
FxvCdSid+SJs8bngQU0moRBQkL0gtA==
=u4N3
-----END PGP SIGNATURE-----

--UdWITBtXkyHyz5zJ--
