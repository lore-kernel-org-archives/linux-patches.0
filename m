Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DB828853A;
	Sun,  5 Oct 2025 16:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759681568; cv=none; b=igKW9WHL4VcVGJ1cUsFEQPlXsQgb/u1GnHWXUQfGUrqoFu9hfk8Llr5dcPg2Z2b8P1aII15GBViXlRR9KZUgf6qQgLjNYeOiHJguga0xcHYIckNgnTGRgHF4awzhQ4KZHDIVUV1mJeTt+x7pvxcOWRGQkQRDiLOpZWRqqE8TD/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759681568; c=relaxed/simple;
	bh=54Zp1V8+9BCWQ8BKFIdvBi40E8jKu5XFMgcrPy1Ww4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZzKikuBqQnotAltwsgWM7fvNTYgfn6g2XetKshExuSF6tQkIXLQkMq7L9B/94rKRlsz9c/g8FEpYModU6s/LFquUQztuJcaymHpswVprSGvTaWSExN6pmPGRoJWszzmfIYUlDsb8E6qCZDqtVBwNMYZ1DtFatExGlPbxRCGyHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Det24YiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Det24YiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE15C4CEF4;
	Sun,  5 Oct 2025 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759681567;
	bh=54Zp1V8+9BCWQ8BKFIdvBi40E8jKu5XFMgcrPy1Ww4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Det24YiNMueiWXFfSwtMr0M6VzeEOfcdNmgtoC1V1NIcXxJNVwhv89zsyempp9jug
	 5raqxKiKE7aSPxP74yxrvfx3bVgOLeZkb+IySsvWMJZoC88/PAJF9TE3EqCqW94biI
	 yyC6sSZ8s7m2TTYvB9lH50h/tGGMfE9FPS9Rm9ii11SHF7YzZsOMnwyuoFhqmNZv0L
	 MI5iBkKll6jOncVqmwCytjYxJa80sYhjQarWflI993oYWOhxPUlrdBTlRApc1Jw7aP
	 LpP+WlJuQHqiHZo3tHPurlbPxiViSMM47H5xr5nl92KCYvyAAipN+xYkD/2yOlsbPD
	 6/QRt46/1EWZA==
Date: Sun, 5 Oct 2025 17:26:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
Message-ID: <aOKcG8godmOiS85c@finisterre.sirena.org.uk>
References: <20251003160338.463688162@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WqHoK5HrtigY1Fb6"
Content-Disposition: inline
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--WqHoK5HrtigY1Fb6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2025 at 06:05:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--WqHoK5HrtigY1Fb6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjinBoACgkQJNaLcl1U
h9AN2Qf/T3q3XhupI3ZyQwuFtvxyVFITeh2M4rfr6DfE7a8ds/s3ikc923j8J0z1
1mhrTslz2OokCuubgPce9g0G1eXuZ2ecHWMfz+gySEnFGWDA++HCXbezRxVPJVMQ
ziEzHpCbN+GNYNUj8ui0FCGEhlPzVvs8pxLkF495GTIk8y+PccNgnXkKYZlu91c0
VfW+LHbvc5toJbkxyuLUt5aVAb0Fs5YOjdPF+cM4xuQMrD1GfEJbg2bfOw1oamWx
BfUkw5BrDTonrqj5QoSMTewHd8Kcskjyfg7XA3Hz/LPkBzaLdPgfzGYTVsWOmb9j
I7ZX1OH2g4P+bLcHSJXPp7x3ScP0kA==
=OWpA
-----END PGP SIGNATURE-----

--WqHoK5HrtigY1Fb6--
