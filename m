Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA2D1F5E6;
	Thu, 23 May 2024 18:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488418; cv=none; b=NXmPOLQAb/wSMikzbMkTt60IsnXuuLMZoiav3IntK12e8Gis8ihNa2RKRFptS0fZR7hfw3L00f9aCuGTTLv9kL7HWze07PI3h6VwIav3azFyTPFI4Z5ZHjI3ZOjb3PtNDGfsFPu+WiOgqbPIRc2p/sgh0ctufO10mvz+iKO6MKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488418; c=relaxed/simple;
	bh=pj8rKcl3+w3JKaKvtXQdFhZzOPY1dNEPl3TRd144Zh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kz3iE+3jxmx5/S2j7XZErzpwGCxz0eK68uLtJyqx+t1bBGigslJFTpzyap3TSTd13+EmQ1nBhI6Pi4Yg0b/mGkeh2r9YioONxi24P6nPTIA1wwQd8Vg3NV1Ni+dg8KPfcNuP8SiGyMoKSv1tNWWUpXF/cUd3/vo7ZKHC3ZNMEwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDgeDRUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDgeDRUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D128C2BD10;
	Thu, 23 May 2024 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716488418;
	bh=pj8rKcl3+w3JKaKvtXQdFhZzOPY1dNEPl3TRd144Zh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bDgeDRUmVCqHvu++ckL+GBweLbJNB71W54BA1GUlP4WD4MgFZSwallJFDqYe0cku5
	 cKnhuWdd4MhpoIrOvMaACVwUwoXAu2XGyLXjbP+aV9TnjuOOZtrPRGUDNp1+yzxJnA
	 Fmi16Y3ZZhw58Siz+TiuB+sB1TRZfEgY0c4k5FdKfL4ye7F+3PPD10ApL4r1ayuBWF
	 XxWw7M1KEtc/wWttV2eAv2lbpPltzD28MyFI831S1DKfkTrbpEG6dFac2jvu3yHChN
	 B+TZ/b7kJR4R6WtYQSJjan56rHJbr4JFghs6m525/XW1TYFqw/9a4U2ixKGlc1x+oD
	 jaJvHrzmXnJcg==
Date: Thu, 23 May 2024 19:20:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 00/15] 5.10.218-rc1 review
Message-ID: <24e56374-14c1-426e-9796-94afb08362e0@sirena.org.uk>
References: <20240523130326.451548488@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/sILkDr99s6mg8mx"
Content-Disposition: inline
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
X-Cookie: You auto buy now.


--/sILkDr99s6mg8mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2024 at 03:12:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.218 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--/sILkDr99s6mg8mx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZPiNoACgkQJNaLcl1U
h9D31Af/T+7GUKdaEbOmOmNUd73VNbh/GvlFvnWYRDtCUEl8emFy47Np2Ur1qvId
la8TXRnytk5wNwOD8tAaj0U/2Mqp0fPmgefiOZhEbVL0FxDQIjXjtYkyW3MOXVv2
xfRZGSrIj2SfvdiJySXP2yupK1FpEEl5Mwbz6KueRka1CQOvDcRtNzBxSwjtNMnR
CXUFngnSobore9xjxBVrkdPF/pVAKsXNMEU770FlN8q8/xKJQ7iYX2HwP4HeAJZY
BlkyqaYeOlMmhkIO7TC0aCsM+OXNpPXzXTItFmCQe+BIEjrFczeB6UJL2np97xlO
vwh2UGLZyOYLP2kOxCOjxjWpdSXt+w==
=T3Yg
-----END PGP SIGNATURE-----

--/sILkDr99s6mg8mx--
