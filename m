Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E362E2D7DF1;
	Thu, 23 Jul 2026 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822363; cv=none; b=V74yFpBzzbL2ZOI72wwPMc1641pFXltU4jjawSgPCUGeLr2T1+7TMjwUnTl00T7MYp/aFg5hBefQhqiVnhZ9qdSyuNO4q1TnhE6YiOPJHstOLiegBaAgHUJWQ3clfqV+6ZbccBGV4w0ine+UdaAdUN8UBmR4EkH3SdiTHVGSpDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822363; c=relaxed/simple;
	bh=BmKbOywKzBDEfGl20oS+2ebgbSSkdGU3WtSmwraM9/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciTjX/8BY93YNRWzHetuYti/L1jP/U7ckxOpETQ2IliTxZvskQdml9UF12KsbNPoaTzN7K2PIPBGX4fOIeu7zqAblMWIvS4o1P6nEj5aWwiBs8kIHGj2clO7nA6QJqOOSdoUInaCn97KSkn4yNvq/dCuxsmS9+hpE3ZLlyo2ZTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AN/ttg0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AN/ttg0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421221F000E9;
	Thu, 23 Jul 2026 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784822362;
	bh=Vppiy2tdCEkZ1pd7/l8yiWfPdjFAuEkqSv1oL5I73c0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AN/ttg0W1n8ONTVMVHP9F4+FxlIRYsawwYEfGzmtvI4VeeoWnnncGRisvjxmKiFhS
	 gKLSg0KDMqa4WprSpiPmB25q630FOVqS/LaFUwLieiB4ps1AVaeUrGYM/q80FdX5em
	 EvkkZkPO4GrS6mOc9s/rraEXl/49WD3hPmM5NKk4Ylpk9pGK/BNyH0KDzbJP/qcns1
	 /8bSb5bxMMRLCrBXQ4PhR5ZuIQ2m6iEva7jtdxEAkVhxsUbwVtSuA0zn1Kwalh6oqJ
	 tIoqP8cusQBUef7j1m42hLSEV01rA6urzwGKJhmKi/Fl1gJAskE+eSqV+Hefwtmq4Z
	 44zux0FDYFj3w==
Date: Thu, 23 Jul 2026 16:59:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/812] 5.15.212-rc2 review
Message-ID: <1a13e94c-09c0-45f3-94ed-1893971fc0ef@sirena.org.uk>
References: <20260722142759.100285390@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YP4bUceyEXHVuI+d"
Content-Disposition: inline
In-Reply-To: <20260722142759.100285390@linuxfoundation.org>
X-Cookie: (null cookie


--YP4bUceyEXHVuI+d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2026 at 04:30:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.212 release.
> There are 812 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--YP4bUceyEXHVuI+d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiOlMACgkQJNaLcl1U
h9CmvQf8CG29tQPPWshVM6A9jfaZDWHXhQzgo97zblnNh5iSsGdqYideCLkkx0Zt
LxKxhWpcVHiXbRZTLURZjzXvhBP6DGsZMxRDswdU1Lxdf0tDgbrTnmOm0VJfrNbV
cGyCeW+tR4MppoL510JAKaa3Ubx2idwOLG7wtox7I24WEExIGi3QovymCgVKKTF+
Fx2ALFA1WEyJNJvlg8xhvFQU6Wbsp3mUFHkMkpU+b68OauFpww5YBy6sUscuFtSb
8LHIdcRlGgBQ3Tg9CjgCzZ0UAVWrG9GgMOsjkztHE2/0AbYLbvxsWoupvQOofqeq
WdmazNqHibSvA89mZnCX2Zk0978ATQ==
=ptmL
-----END PGP SIGNATURE-----

--YP4bUceyEXHVuI+d--
