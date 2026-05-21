Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF298348C55;
	Thu, 21 May 2026 10:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779359779; cv=none; b=bNVq72Ex1joxijU2ctYABOzi3B89J2AAkjTbxaNhYve507ONwntn+c2hWplElPOIxxBRfLYkQtM91MJAJjtngRZVTpXIsY+/ho64aSAxisAsC0BZHGuCz70iZy2bOE4HpvAHus9CJd1g0uD6CBXswHOOoh7oKQKpW70o0tTUEpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779359779; c=relaxed/simple;
	bh=269xhMkLBl4PMp/HzwPEgiBBMPilg3IYfIjKOogIVls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7c3T8feObgFEPr7BEOh11K5F0waoUnQnEMpVragweqV7FCd1V9zD2DKGtfv3vO8Raa3xICI60sibSdkFNk6q41rDUGQUA9rg7LGnu5iUUjEqzXwnDppEVRT1ug5+7VdBIUkbj4l4Fma3DgwasPtT197O2QHXa5ZXmwJJ7bWF0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lzSh2Syy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lzSh2Syy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36551F00A3B;
	Thu, 21 May 2026 10:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779359778;
	bh=RseaKFF7m9k/zg/TetEfd8ssq1x14YapQVJTmmtAUsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lzSh2Syy45b6QKNh5L3Fi3XYkr8tRIDbxXZUHaEy17tWmiutdqNcO1Hl6f6CCMiIi
	 q63Xqj1p6LytkIVnXT3Em7idNl4G4srMk0rB316rcZ/oIX53yB/38dgWG+wSFi90T9
	 SvglD9iaegPAf1fEmAzInJzg549mL/9SVv5yZ3zuF3uPRkvXQGsc4FFiBQy7XBYg+4
	 c27jjV2zZ+DvZ6L7UUhlZSXr5muC9jxsARxfzOqOpx2nve321O0sT8b17hIr2Fj5Ri
	 aC7U4tGiM9BiPRNaHXB+qr0JCxtZv5UWM6oAjtctiAWQxXUfYuACISFhd0SipDHeuF
	 VwRtC8SDgkYFQ==
Date: Thu, 21 May 2026 11:36:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/666] 6.12.91-rc1 review
Message-ID: <df4de06c-82b4-446c-864b-182291ebec14@sirena.org.uk>
References: <20260520162111.222830634@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TbSQJpWB/mBTLO4K"
Content-Disposition: inline
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
X-Cookie: No shirt, no shoes, no service.


--TbSQJpWB/mBTLO4K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 20, 2026 at 06:13:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.91 release.
> There are 666 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--TbSQJpWB/mBTLO4K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoO4BsACgkQJNaLcl1U
h9CpRAf/XvBXeOkQ1qj3GN4l5v/olKLDjn0RHfBNjSVTxJsyIAnfdq0cEhuntTb+
nxA74y94rJC4YjHBfGA8R3Ng/XikmwKoC411823RtvAuUBVgYciKChP7K5x/QZa5
PNJ2BSrC2yaazMsMtyxOQlXGVMXh6dsF0+UxeEuniGI/NX4T4GAoWwE1KUbnHReE
nVkRKzWoabZ8mGfHiN0AWT5WM8fGPz2qVyhFhHknvz2d6X1Sh5KSbYrQgTaJ3nMs
mSH+cQ4hxjZSljqY0NedsodVPnhqEXBB8xz1Xm8pod38HZtQhEGaHelEK5f/9ZdS
+nrl9ttkOOSk6r2kC7tB9+hM3cS66Q==
=neIj
-----END PGP SIGNATURE-----

--TbSQJpWB/mBTLO4K--
