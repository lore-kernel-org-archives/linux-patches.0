Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6961DFD6;
	Thu, 16 May 2024 15:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715874116; cv=none; b=j4zPYO0tdpf2vDUqH7Joxked2SEQmkixO9Ir8OvO4ny3qUXSCnfjN90u4aJIF5gGIt4FbE4C2TQoLgPTV54Mqrqo0JGVA4IAD62xpjDZtagg6ZOt6EB234S3fTP6J1YH9UpIhSurglRRc+p9ujmIIEXED9LXpX25oFnPr17L3qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715874116; c=relaxed/simple;
	bh=XfWlKT52rk3dHWds0VUbx+0BhvlPaBvp8U6eFA2uQV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eX1RrfgFkJZIXFwP96txOFdcPc2XUoSQB7/LP90cTyyD4XgwQNT8WNlg4ChHltPJk1sZl0ex6gEv8bWB95ZYZXdt+dUlrRzCykOaDYpGNIieZJERH0S05jP4K+vJKJqPQlT7kAKy4RU/C1Rc3Qck8rLrP8/kSbYf1Oo0TTyiniE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ughN7Gfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ughN7Gfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1536C113CC;
	Thu, 16 May 2024 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715874115;
	bh=XfWlKT52rk3dHWds0VUbx+0BhvlPaBvp8U6eFA2uQV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ughN7Gfr3Rzd8oKxHLsehBVmwzh3m9JnfY7Hti36z804gvp/e37d7QK86KxT2Rdlj
	 nLUmplxi2ZaKYGBdt4LiLWxMJGK9UgwxfpcqTS/1WgIFlAjoh1J7UPtPNLX2I/hzKW
	 fPGKE9uYOHMkcawRcLHbnqvVrYHBs/Mruvf4NCUFH1qtbgmLU6YwDWnBZU0zbrJm5r
	 ktPAxsXHA4cQsVWHRvSaZuUrtHSgkDxq9Yv9dtaFr6l1P4aTE574Eq6+jh+YJP5cOn
	 TUogwDSoBMNLd020sP789U8WI2PgseM331QBS9tzXIQRGCONxyJ/5g/lQprUhkUXhP
	 UKC86w+ImBaoQ==
Date: Thu, 16 May 2024 16:41:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/308] 6.6.31-rc3 review
Message-ID: <533a6e6f-83fd-4f06-a7bb-78144839d34a@sirena.org.uk>
References: <20240516121335.906510573@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8UvaK5fao2dQW2NB"
Content-Disposition: inline
In-Reply-To: <20240516121335.906510573@linuxfoundation.org>
X-Cookie: I'm having a MID-WEEK CRISIS!


--8UvaK5fao2dQW2NB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 16, 2024 at 02:15:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--8UvaK5fao2dQW2NB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZGKTwACgkQJNaLcl1U
h9BS+wf+OEIch6iDjwEGoV/pGI3t9p1souA7yiUVT2tEsgQEt9xmIfk74fS8ML4w
nKwSKeWgTjSziGJ/LzKZ2gl6GPZv3FPy4EE9alUoQfj3rbqxRCi3+UWDykmqRKsU
70LwuLnktI4ISFHqoD5ChAYzrxnfmZ3PwAA21g4sV+nTLCT94JZ32AInDkM0EXzx
MH25OXiKNVJ3f8/Qsw3RA74WB2lKR+EuLmNwBtC51ZeXwZG/g23hXjD/XM6Nefqy
VCSXRCly7Mf+pRxlzVlJ14Wrxm6ZjASvTPsGmbhnIL+RYvBmmHtj6+HewKVBGA1P
E/u6NDMtFPAU2pJv7ihdVTV7Xg17jw==
=x7N8
-----END PGP SIGNATURE-----

--8UvaK5fao2dQW2NB--
