Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A6622F01;
	Thu, 27 Aug 2026 12:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787833861; cv=none; b=Nml9Ez55rXGa+R6/hryb767hv1OTqSKuJdcigLACDXR0CfeN/DJHhZONZwmd03sBYBVcvnuMLrljvVubEhBxSpqLoZ+B/tZqe5Ex96VPChblDoG30yJdKqOKx+PKZC0OFneEVSeMDwc7b9055M2aCEJMTBsWCoHETg7f0y85on4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787833861; c=relaxed/simple;
	bh=30nqH0xfx/pL82b58Om+h4buXT1sWznDO0oERfyZoqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RICKAEOtSnAeV5yg2AxO3Gw+DWMMC4cOXweJomXrZn+Ge7cek9yz50Z9JE+I5ah4LhikYqsD9df4UQvrvyYLVuRL+ANTTe/IHcK5s2ovTsko3vXxYtvvPAXfZX3LtyrnM12NeyMMyCfNWMg9/+Vsl4uAHKm9dA1koMqKWh5CQFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gak8jBi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gak8jBi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6008E1F000E9;
	Thu, 27 Aug 2026 12:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787833860;
	bh=gwIqcKeHq4uVKSehIGykRQkrmtdMzZ68vnGijkcdRJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gak8jBi2jsFxWxbe2EcUPWUUyG9fu2DpEyAxAAJle80Pvd9pukFK6YK59NhTkoHvX
	 T8pjVAT8yqLIL3drDGo0H/5MdCzje2OPxi3ROU9oVF8KfR6lwms3WWRrQMrH5ikkcb
	 0hoaCZeITI+C3wwRtK4XINE13v851FF2Wc/arNFvpiAPNCel9RbC+bmD1tV9Gn2/z+
	 z5uIdMiATy6GLi7I0ImQVfxSd9DUqZR88FEBVZwV+WcV0GZy0dghVJCFl20+BOzXOc
	 5TW0yIANud3P1riVHxOYyi8ewI1rJphiEh3isaAlVzr885bX0PyIRddsmqBiXMEFlz
	 h/TniKyKTg0Rw==
Date: Thu, 27 Aug 2026 13:30:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
Message-ID: <0b9b158b-1059-4b58-8f10-f2ea01d934bb@sirena.org.uk>
References: <20260825132541.887883084@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dTFwD5LTmG7c9+dZ"
Content-Disposition: inline
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
X-Cookie: Alimony is the high cost of leaving.


--dTFwD5LTmG7c9+dZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 25, 2026 at 03:24:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.47 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--dTFwD5LTmG7c9+dZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqQLf0ACgkQJNaLcl1U
h9AMogf+NVjYus/hMJkKB7Y9RVt3ooikkoahGagTmMML3lSEOv7QkjSYID5dLQjt
zU6F9ST1uLXebwOpdzMwAv+DEcvqySvANnx7CpRqz/JU37FicW1qkwKiQPcsim2V
xS4cbYfj/qFmgm62+z2C6s9aGttbsJOnro+9LyCXwoOfV1sNjWydsNsnmZJAmiER
xpAHYUqO/lFJKifHG768K+iRHwQwWfRX5N2XsCGDgcnl6yUzw7RFUQ283DYfkN20
uOM6FEz4zeHvQu98WrkhB2RZxBrluuqO3xU4dV8+TLHfZph9iIB4OaH2kt30bs35
MOWKNmc3vTeBge7H3AWrfGR+nRHB3g==
=lxJZ
-----END PGP SIGNATURE-----

--dTFwD5LTmG7c9+dZ--
