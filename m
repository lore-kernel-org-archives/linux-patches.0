Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621DE3F7A97;
	Wed, 17 Jun 2026 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781706553; cv=none; b=i6mQpOo7NAk+35M6b5vlfQ3LSdST1iihHgxuyXGmgLF00/AKL/OsSVTBGmMk0LzdiyKXPdHathxhvo3/ew/AJiXBE0DhqvIqy62y2rI4rxtpy8Cwjv+Iw+4IUVE76OtS7iXua1SehEmcSaXNtzWOetQ7zmmZXnBzMc7WIvcR8bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781706553; c=relaxed/simple;
	bh=/jFEeum7cabH6f5adwQKLkg8+APbV4GTNp3GLjNzae8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFAhQKbXlhRYqO1tALNu5TQwxdbl6YWIhuUXn3uhHxYJaREf5uFX8lMFXp5Gbp5QNC2u34wH0L1Yu3v+WW1eYVpTx75ek52FIQmqUOAVjWAatqq7E1jNTsaC4apnFAEF648KeujmFRTqpfMkfXEZifBVsdlu0elfCZcwqDt/G/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMG+oeOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMG+oeOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726B91F000E9;
	Wed, 17 Jun 2026 14:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781706552;
	bh=Ys5pPCaJd3TPOlqA6QLyisVRTVqI0cuhvJWAZEBiOP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MMG+oeOZlI89QiV7SJmi5c8q1U2g1/MB6brc8enq9zcuL7JR+Vu945Ki3Mca2gYkJ
	 e3FgWHbwd0KCntrImxyo2fXO3+n/9AqFyYTsWcJhylq7XxJtDxh2FsKeCvapIxE4WB
	 jD5FCkUhRaQ4mZsL5WEXHI8re9aVCeTPlJXTutleY6hvasdcbrNdjEUvcX4UYwJm9f
	 Is6VsUyHxPIvJkYK2UO0777DyjLZZBcqUprpLH0pWiRYTd+bNAVravDxItBRoefack
	 pyIwqVOaEgr0TyoZCdGJtmW1ZfTYt+2MXsyPN90gdDLu3L0H/GlAZpFkX6mpgBB/L7
	 7sLm9zPNL2/kg==
Date: Wed, 17 Jun 2026 15:29:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/410] 5.15.210-rc2 review
Message-ID: <558118d1-5d7f-47cf-b01f-7cb0340b86a0@sirena.org.uk>
References: <20260617080316.111043001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a5jOam4bzOVJg+QJ"
Content-Disposition: inline
In-Reply-To: <20260617080316.111043001@linuxfoundation.org>
X-Cookie: Absence makes the heart go wander.


--a5jOam4bzOVJg+QJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 17, 2026 at 01:33:49PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.210 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--a5jOam4bzOVJg+QJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoyrzEACgkQJNaLcl1U
h9DvVQf+MkXn9MN9aRem6/JsRJh3TooMNVfzdjvvtkR3HcK3IGiL5I+NY/KFKCFe
7vq3vylc+vJ/oHZyL2tCS7nn5g+Zvb+6RX/uQMGaMivA4KKO0QMKoYmd0zE9wA94
slzbsvmOwq7MPrDfZD78lwZVs9kWt8Pnny1HvUF/DZ6LvJ8/ClsnapF3+WEYDRpQ
hRBMvRRWb1dTOavKVwprVngYaUqIUZbyJuLnl7LDFrx/1Ggimp3mujallbQDee7/
18bNLvPK0zY2w+YaqFFjlkQ/GMC15Y/TGCHZ7FoSPmNXhxAlcSlOHkNuRNYYowXF
O8+m/i42GK4uWtn3POGlyX+J8i8EyA==
=SCuh
-----END PGP SIGNATURE-----

--a5jOam4bzOVJg+QJ--
