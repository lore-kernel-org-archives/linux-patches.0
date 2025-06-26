Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE772EAD18;
	Thu, 26 Jun 2025 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750948704; cv=none; b=sWM/L4cBGLv4DIeX+3VnYW2z0drovt2bYMsOZ9hfJIsOcn6myIktN+Thi1wb3DW0pG34bdhcdsMZqb2jbuUDesNSpK8ONhcdgKH4D//jlQUp/cAw8pQXypM+DNlBqBnFjhGG/U5ldYBT1xgNDki98/44tDIuJjuzSXhL13NmPec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750948704; c=relaxed/simple;
	bh=HmlF4V5OvC+ua5Uphw2sCzRiditsU582Yu86XWrvPUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTtqTPfKJ2zDgRb3zc0QFhdOJfGqehrABa4WpZD+Gepu/8xgTmykJUxOEFGyNItPYIZ4a4OvUR8+SlwFezlwPCQT0VIo1O4jdTPd1Ey/21uhpHTaJVgz4tp7Ao2/F+SLEsexHClZMT5n3NX5TXPaW96lOcTxye9yEY+1TsVgHbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tY0KRNJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tY0KRNJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146E1C4CEEB;
	Thu, 26 Jun 2025 14:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750948703;
	bh=HmlF4V5OvC+ua5Uphw2sCzRiditsU582Yu86XWrvPUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tY0KRNJtLbs6YW+Ddp0WaoGNQnfOqhjMjDbLPFMQIpgq8ECCYZoV+5cSHVdvHd6U6
	 aQYV9WhAll0/+0DK9M7to7Y4iu2Z7zcu7eXRi0n/qmT+0zvmegPo75PkZTsjrGnULu
	 vs1ON27iEQe9zblEd+tQa4UC799pBmT1+M0GV3KhfnlpHt2rgvbafxpiMpbuiwxxzF
	 ZB9wVDtCuFqjyVFat4FvbSMYgTAQMtNHB/Nsl2yVsWysTKR/o7MOyci25Oag0YjhuI
	 71dKrEFK+xjQM4t3EoJl+ycnmKpPA4GYbns2o13poknCzcpF8LifMMbEJY243gJ8bD
	 QUGofcv6/kd1g==
Date: Thu, 26 Jun 2025 15:38:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 000/589] 6.15.4-rc3 review
Message-ID: <aF1bWxZVpHYsbm6H@finisterre.sirena.org.uk>
References: <20250626105243.160967269@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zzvonBl00PEabfAL"
Content-Disposition: inline
In-Reply-To: <20250626105243.160967269@linuxfoundation.org>
X-Cookie: Do not cut switchbacks.


--zzvonBl00PEabfAL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 26, 2025 at 11:55:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--zzvonBl00PEabfAL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhdW1MACgkQJNaLcl1U
h9DDBwf+O6v3cpbbkMA764fMCQ8m8h3T2uIn0VHcvfX41qPjq2Imj8tfcbucAw2B
9awzVZtkmAcvbtLSeCqPnNOgqD8Gd/Ossnijcs3/p/55GZ27jNXsORtvbgCxw5Vn
pp/UrVNW0lAtmJ/h+Q3v1v5slCtpWxYj/z1udGl4l/XdzVay45JinWfaSPSo6gWC
oOo9wnVhmcHZ7GqsLZy2UiI6LqoJXjVBsuBIj9n0PTeyOHBbfyBHeuKdL3957Dn3
wbxGhA5+Jxa3hhcdCYWEJA56Mb7Kpcjs07hZnzLSJmrCLN9G163hbGRSm7KEKrTl
tDs1XGbKsZVQ0+KCksUlPMRYydWhMQ==
=sM3H
-----END PGP SIGNATURE-----

--zzvonBl00PEabfAL--
