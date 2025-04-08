Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83BD39ACF;
	Tue,  8 Apr 2025 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124698; cv=none; b=H4QBYEWY8OzGw/sEQhPNcgi1s4xEiJFOUtuNlv7Y+W9EeqnPT7V2qckXghQ3Hxe0plQdHRGWTbCohlzbyCJYAfvdEc+ZG+PgV+Ue9n4EXgMd8Nd76rfcQLi/SdsxeXwyphgg4PF6AxKZOcmplW+hXpnxHhu0Prnu0hsPTw3syjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124698; c=relaxed/simple;
	bh=2+2EeO/FRxguVYSwn8sg/lqPp2YHwHAXzAYVDNKOfr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8sJzpYKZW4FOMY5UCZkaN2rpeCUTH5NSpWIcHMigwBaFVIbquvSP2qQ3lclMC+jy2D7lt0T6EVhFLau3FywvfB4ioh5Ot1CMIuA4KJ+IWu4cNTkCLbd5etrVXckOyiZcj/HKlq3Kh2diKH51tyT22S0wrtwaa4HPz+tzSjO52Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPUv1iPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPUv1iPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE65FC4CEE5;
	Tue,  8 Apr 2025 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744124697;
	bh=2+2EeO/FRxguVYSwn8sg/lqPp2YHwHAXzAYVDNKOfr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CPUv1iPYQg4/vLZOL9XZvswfETybzAhiBYIV3rDwDTtdjBQifsTzSp7XJjpt0U6du
	 abZoGNeDQuYNy6No19E80HOasP/xc413LHJPE/Ga50FethVJBPlAm/I+DwMsymcGBJ
	 hInvRkmkvV5+0Hdv8xSz1mySTGm3qc1t7Bjly83smJuH3Oqn9H5e2CSyq0G30NFQxB
	 RV1zg5Z65pLsOoaS9ESmYCq5nAcpmhXZnZ5JXZm1NWdIDhuRGAU+RQRHzIbZiYeE3o
	 3UrKm87xxdGyD+goywTTwoNrSU4Jc8wSWFbDiYh8/kftySnKnaVhgNszgCdTy4AAMZ
	 LxZG4f0egyzDg==
Date: Tue, 8 Apr 2025 16:04:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/268] 6.6.87-rc1 review
Message-ID: <fff4ab4b-0a02-48a9-b49a-9ebc7dee2a0a@sirena.org.uk>
References: <20250408104828.499967190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mVYU3NcEub45wxd4"
Content-Disposition: inline
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
X-Cookie: Meester, do you vant to buy a duck?


--mVYU3NcEub45wxd4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 08, 2025 at 12:46:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--mVYU3NcEub45wxd4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf1OxEACgkQJNaLcl1U
h9D6ewf9FtZBNtnHZCDEHZ7YAmtIkETj4lVj+PfkvSui7StSJB2qIXTJyKogX9U8
iuJCit1KkSjlSWulYN2nQm8VIwPHA+n2OCoJXvsV/TQoIOvnBya0ExjRMy6DgGXR
NU+QTOums6DlPv1XLlQ9h2MOa4XuYQi69Cj1yA0DY+0zw4xTA8ytsVAad6L2v0fH
/lMWdERzdEZTkHwuw2brH69hhCA/zEb4vsaKTaQ8joUYWstNj7O+WC1xl+qsBydo
KU/hQcHl9WliRjrwHCl+lb2WVKQna/HzThHlzz7abED70gULBxEhWRmd6Y+KG2bF
q4J7DoGjqRwVYJOzI5ikkHWcp7aZyA==
=scdj
-----END PGP SIGNATURE-----

--mVYU3NcEub45wxd4--
