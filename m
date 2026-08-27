Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C97223DE7;
	Thu, 27 Aug 2026 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787834242; cv=none; b=Z0EC4myzVz4qH6+m9vXoIJufcBFDd0nQFkxsb1KzmGf9xOjLi2QIW6edONY2hHtzM+SThOU8W8VCua0Xj7vAS5C10CLIPTLvm/WYKVQblMsE3Hfcd/zUWWGuiH24fnEYlwOFxAVsund9VC0lvtj28hOQpvrQvR0rnhgI0vOGhqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787834242; c=relaxed/simple;
	bh=aNZiP5xH1ECJ+NLOuVqzuasiCWgQYFQ3qyy5u5xDRRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQBjfSBb2RJfcpfZQ3t8G9bzhrpkHKXvLcrI8o2SHSOIrBwiwR0fOq6exH+qyrwiXVU543ou8kgv2NdT5OUsof/Ycq9c7VCl1VRA1dtLm8gyRotQnFEnBwY0GKmcQK/ikvCwGZyJxt+JIP+60qkBpIpqaYPgkTYgJw4pVlIMznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQiBY/mI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQiBY/mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458F81F000E9;
	Thu, 27 Aug 2026 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787834240;
	bh=l3QX2Vxe3WHXjr2xVJ0eZiaisLXgM2Wh+r0CEfeLFcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DQiBY/mIP6ybVviwaoThG9r9VCk99K3ilr9CVBc2I3Ww+otYZ9TWuqSubhvHFgxRK
	 0uVIypeQp1MmGbSgWJBFp+uiBPd37H1N4zE7lN8+3CSgkm8d0/6/qHkq7MbIhA594e
	 LSQy9i5WAcXUqbqGSrpq3ckXUd+S/PVXifP/wfguW1twB+/6bblvdNRDCdCprGynQH
	 RMrD8GhOFbOHSPeB+OoaKkUxlxOvAMCBieKMyENB0nw0mQ3eAwsnjeYpLaiqi9hwFn
	 5QjnDdHgYQTNZHvtr8Y50JIN/45ZzGmKESeS3K/uHopN5w7X+96DtqPlENCC8A28DB
	 Zl1nw932f/jYQ==
Date: Thu, 27 Aug 2026 13:37:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
Message-ID: <b042adcd-b807-40fd-9b08-f8303d22d4f0@sirena.org.uk>
References: <20260825132541.986300899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aH129S9hJvFgh4pU"
Content-Disposition: inline
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
X-Cookie: Alimony is the high cost of leaving.


--aH129S9hJvFgh4pU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 25, 2026 at 03:24:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--aH129S9hJvFgh4pU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqQL3kACgkQJNaLcl1U
h9DjFwf9GPDItLltOGL8uGgJOvwlloTlAxj+fnP35LFxCRSf0505UjVEWSVBuV/j
Palq4l2h3fP3SL6a3ZWyrstb+NFHM1qIBL4HWRzca6JDyzBIAYR72zIAVFRg5kna
rgo1PRTCx/ggR6Utu7bMPDOKjtZaUIl8V5/heRcx1iFuna/Egxp5+oYDXD6mRPFh
fW2S2nf3dnFOrzHeXBZUahgCfe8zrme8HN6JtKZ+gGTqwnL1+t8u932RB8/s2bNH
793Q1ttM4stEvCn7TOkdnOCVc1Hb4qee2iYLJCmFei9YaCjR4fMV8nPGe2RaVArJ
OiF7HIep+Rd4zpTcljKIc04zVxVQaQ==
=hMca
-----END PGP SIGNATURE-----

--aH129S9hJvFgh4pU--
