Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DC92951A7;
	Wed,  1 Oct 2025 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313904; cv=none; b=us+VTUWQsaKtBekPSkXcOwlC8Sj0ZD1Mw67IJ/cZ8Ab1eq0VlTywTz9t3yQ5ENXvIQi9bDtquUU0SWNnCuQ45UPWwdooZratVDjhZreGZkyxE4AceZaw7SkZUXLWgIWMmzt+R8ncbrjjX1oNn6ep962Q1jHbftrv2GC1Crw6MQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313904; c=relaxed/simple;
	bh=r1psO/nTC1s9EQIimjDMV4YssjxG2wLTXGUyL1ayt4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gmXytiR6sQgil++2j61CbM7KDa9a0/qO15m1ZK1o3ms2FAsfxU3ns7Zxp20WZslir8l8uOp+xHENoPsv4F8ye8kCN41IzWnSMesz/L6wSqaM0mO8cuTLTyMLyK1xSgkXkRygUEHsdBACHAZcUNTorshXNhkUmOeWOXh01S+u6zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dslknEKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dslknEKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64FCC4CEF4;
	Wed,  1 Oct 2025 10:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759313904;
	bh=r1psO/nTC1s9EQIimjDMV4YssjxG2wLTXGUyL1ayt4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dslknEKd1XI6J5aM1LMWXWNGl4gcoLGK1uxg+euURm+7uk+p83iVZcU90GzJ0pU2/
	 QO7ff8+HLR/PITbWaY21BD1FcWyjxzNIghWrAE+OBOBr7X+Unark+3uPe/0pagKtvR
	 9No1/pJH5/PzXuQc8uMjMsOwkDDntDBRoxnQJ8reIjDhbqA/n9HFJNOYn1ceu8nAEk
	 sK5inac0YJX4410tDxuQLUlNiAT7WlZTQtm5qZwHcDQdb8f1UPpRsaJ14D+ePOyBy8
	 Kb71OXz0rgbV4WeUN0fQC/7/oanvVX00WfZ+bF+Ha/JeFJqd3KXdyBOqV+Y1xFlw1p
	 /vP6tf6hpDiIQ==
Date: Wed, 1 Oct 2025 11:18:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 5.15 000/151] 5.15.194-rc1 review
Message-ID: <aNz_7DLv2KWQUxts@finisterre.sirena.org.uk>
References: <20250930143827.587035735@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QFor97G36exto3Yl"
Content-Disposition: inline
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--QFor97G36exto3Yl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 30, 2025 at 04:45:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.194 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--QFor97G36exto3Yl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjc/+sACgkQJNaLcl1U
h9B5ywf9G/iZ1Rxt3rY1LbXIOBKV4Owd3EG30gYjIiJFhVnnF9DvK06GbrCwptUR
XXFnwzrmGl4QkzbM5l8xWhGq1gz3tcyh7Q/0CLAmvVF9fPjYWHojEQK47mRnDte6
rAchv2GEMzHA1XzzK+W7LOFh/3lW+SdVFelvbgTWWrc8TUu7zLR5OJ5IrKEQhX7I
6kQbb3Ntkge8MYHhuZiOBqrOM2Mj2IFoVECRbzXlOju0Q1O64tSQf1ExhUT5MjaK
Yc2M1YA73U+rKxRzp0KRMAAi1ytA8Mbh/X3y7vTuJAbKnz0Q4Fcm0pcHaZbOmzj4
lk9kVP8MftiUsIOJXhMdCJ4iL2qcXQ==
=G/J0
-----END PGP SIGNATURE-----

--QFor97G36exto3Yl--
