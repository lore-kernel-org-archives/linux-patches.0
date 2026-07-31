Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9191F3D56;
	Fri, 31 Jul 2026 22:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785537610; cv=none; b=EfJ8usGyESqooWQ/nrGwNjoQSCZJZFUVenf6lXjCwqTtb0tPrfNm9dzD6McdIJtLsRLbNPygQYm8Q28fnT1+SohWi6bIXsQCot25VDohZyV/LyUewvJiNro588c5tlanChHJI/a98k6JZf2Iz+Mi3PdxhXK7RwcIdGitSfx+RGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785537610; c=relaxed/simple;
	bh=l5kFCuXcGOxY17wu41u+zlwEM64Ne2ahlAbp4I+MaLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zj8MaTOUKG+q0L3YnyitJOdNZCJd1dxPaSUa+B/9IrjgC6aG3Dpp7KPm6nr5z0GK5xw3CKD++fMmNRl1HU9tKtSIr2bEPBzusrDirgccSQoZpvKRbJPxlAim0hjWyVT8eXC7QBqiqoUnH0U1jQdnsaUSbvnRsdnDimPJNGnEbno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3WVQZSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3WVQZSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABB21F00AC4;
	Fri, 31 Jul 2026 22:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785537609;
	bh=MgqTRuV4dsdTKUYh98FusOMputOUXHysdGtTpdzVGWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d3WVQZSlHb8obW/G1QRdt8I8pSN80u0/J230asHiR17q3w1iR5yWF0CEnIwXFFSDY
	 PW3SkbwaK8BpC/4tdTE/NHS+oayiwul/QTTqYx4E7Wh8bm97vsYMSwbFhI3rHMFRC4
	 VC2gNzWuMarQZ+GHsJ9+zSmw95Pio58o1KNu/FGehPRUwCSIOyAzFfqsZVa3E5SDJn
	 YkMrjchhlnOn2MtggtHSuVPFPY6/fg2PiGGVClrxlB9xEG8N+on7Lm6i5ty8c2zZF7
	 aVeUXQIqL0H4Aa67ulOrA1ArarH2v239mldOWLTknBcWXIN9ktzMe+Lf/GrSsmtl46
	 2hHleNnIH18SQ==
Date: Fri, 31 Jul 2026 23:40:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
Message-ID: <9933a44a-7fb4-4d0a-aced-02292dde4bf4@sirena.org.uk>
References: <20260730141444.267951807@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="46oxxTb0gSWsCyRi"
Content-Disposition: inline
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
X-Cookie: No shirt, no shoes, no service.


--46oxxTb0gSWsCyRi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 30, 2026 at 04:04:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--46oxxTb0gSWsCyRi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmptJEIACgkQJNaLcl1U
h9D+3wf/XcEXc/mMGzuh8tsdrAsEqXUIBBH0Uyu0zupPkK0YIVKc7Xsd9ZseBLg1
v6T1tqqgThU7WNiHCsWihFtPK/ZbngHRpX7RyLfrG0+3pBj6gMWAkHLZyqDCcnHm
fg01jY5PbPapUNSnuL/p+WKt8AZc8RCO1ytw2i82oAxuplrAdbb7DlulMmFeIf9y
omruCrsPD69WCZ6bYySgVTBUKr1aAUJbZubaNysE/x1FBG177pJcypPX9+igaY32
B9OfjP6Ih7UwVAqt8kpdjTKvo9N5pLl9OoqlKfiRyLxQBPE6WcGcQCfT9P+spHqY
nFbmBz8QSwJb25L1bsyXJ9vyHKPU6A==
=0Vsq
-----END PGP SIGNATURE-----

--46oxxTb0gSWsCyRi--
