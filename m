Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ABB1B0F1E;
	Wed, 25 Jun 2025 19:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750881391; cv=none; b=idiyXnlXqXfC/zM+zK6i7VFNdb8VoOKVdlOnGgnWSp00j0vOlw3J+Ku8kNrDiqeJAktH9iCChPusu2pitagEBHxeaPHPbGt5QkZ9NKOZd6dhDu130G6s0oD1ZfO6YgSqx662mI5YOAP58Ec/O7CUE1igzcF3gpAy/9yWu5pD0Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750881391; c=relaxed/simple;
	bh=fIKaUiwsBGCUgkstRrfVbezcD9r/69kGjCeCsdPpegc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlrAbRGq1C6yRKNwc6ynGachMOFIQmApGwXolc6oexw/3t7heHH7OP0ijsKoYkQyufVTfMUBLpyHOSPEA6GjeZ3Uwk2pAcxl7/DrqTY7z6Wxp5bn5DE27MTRPFocztKnJ1mcescFh4Z+MQIN5ta1X5C4Y2t5b349gqZDv7fwEc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rR2ynLOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rR2ynLOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5041CC4CEEA;
	Wed, 25 Jun 2025 19:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750881390;
	bh=fIKaUiwsBGCUgkstRrfVbezcD9r/69kGjCeCsdPpegc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rR2ynLOUG6AYXaYnhlw4zTPLreJz8PcV5okrxYNCL8pA9z9d1Q8AZxbAt0o2VLIyr
	 ijY3RPeUU00lSTr2jknkFu7heGYMPARcdyD6s3W5wIMGoXScMFyAwyTIRFirsA6nuB
	 KwbTX7U+Z4cxQC1eLg033eAxPK3BywY58/5fm5flNeeCKmNq+weUoffRMYbquu7ixs
	 u/OYIFgyi/LWIT38p2Ym7yFXFa/5TJGYPa6F4BcEYAh7G4Mk75viDha2Jz1QZDtoXl
	 kwY9Q+AJeZQCoKMy5Okqb93DnzKMygfaowqiBhsIqH0lNDBg2FkbXMURdVSVfNYoXb
	 KKkCBPqrv3TcQ==
Date: Wed, 25 Jun 2025 20:56:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
Message-ID: <aFxUapreQoZR1_No@finisterre.sirena.org.uk>
References: <20250624121426.466976226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AMeTe3/eu7DFM4Q0"
Content-Disposition: inline
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>
X-Cookie: Do not cut switchbacks.


--AMeTe3/eu7DFM4Q0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2025 at 01:29:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--AMeTe3/eu7DFM4Q0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhcVGQACgkQJNaLcl1U
h9CFmgf/exEllONE9c0OS+57h8baZz9o0Ye3CoN3/M5iAUf0YtTSrO2ediRBgq2e
hGJ9yK98bGamrSOJcIZpJLIeGA67ISxbNWty3ZigprqzxBxclCkYj8OJT4sFkMpX
aeTcU3Mw5UqojdrnGlVcRRgyNgzKGeWUWJ0kxxq4oTRZJfPRPsm3BYMbW0a8Ntdd
KBaJy/cy+elWT8xGAj/g8njKYzSCTq03VqE8ehBDInURf82Qgo1NJeQSVuNupIwt
7uKZ5Wcdz0PbuaUc/h0X5Jsn4CLxOesyQ0VPQgOSa7Te0O5WzxU8P7NokbqN4eSh
HGVaYdq+f06OWk5Z3GR1bdCy+BGW0A==
=r+pW
-----END PGP SIGNATURE-----

--AMeTe3/eu7DFM4Q0--
