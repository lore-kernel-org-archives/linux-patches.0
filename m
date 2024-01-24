Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63BF18030;
	Wed, 24 Jan 2024 09:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706087805; cv=none; b=V8t+I7LtaTBwZZkiujgwdYXl4Bf6tPHgS5YaUvXJ/Ss+PO0SBzFv4rAPsZxb8I5s2fhl+h2jzXe1CLygpSVU7OyAZ2CvoBrrtZwMMTlL1zR/YMD9XrYI3/P/Z2K61GKn0+wnhSWUD92yU0eGdFlnYVasP3HUxwKw+qNrFxVtdmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706087805; c=relaxed/simple;
	bh=1t3q1YAsEwTV1CzwNUzePKkijTsVffVDAMKZQ5QfMBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpDVTC20lTZtE9TeUbqYZsN9haBv3a8soDG06BIjl1pkO/sdOY4y5OP+Q9TCircbeiuXMqcDm1v+dubhgOIzR0X2B8fCAbdgJI6VW0tNwao/kBJFBUBgdNWozRsYcM9loOwD5q35ehYEeIKT+l8EWqSUTndC+IwC8jGJln0TwLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPXHIdls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPXHIdls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA61C43390;
	Wed, 24 Jan 2024 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706087805;
	bh=1t3q1YAsEwTV1CzwNUzePKkijTsVffVDAMKZQ5QfMBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mPXHIdlsp8xTt92RJE+8e+Kd+ILlV5dDgvucY9/6vXnj8oldj4zdwly2ikH0xw/Y7
	 qt7P5bco0GZpde7gazhDQEo+y7BJgaiHbcQI2u6jKV1d+NBfH7jQM8k+036YGHm/+B
	 8RUzk+5u114lb6znoYYanWVqkToyRMyvI4ZnAOCZYTxKDzpiPDVIWV9osvs+oKh3GC
	 hpKv80oIg/I2BPe/sC5RpBfRYg3kcW1vNuQMNVoTYGTpmXMZOspcCAY0mY64HDfWUk
	 3YxmX2M17B9BroQmLP0wt5yhc6zYnGE6QWSRCZtYtxmPK3kIkSAgrZXAatknUZcmlo
	 rTGeH9XJQYrjA==
Date: Wed, 24 Jan 2024 09:16:39 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/580] 6.6.14-rc2 review
Message-ID: <20240124-economy-molehill-1ac70448bbdc@spud>
References: <20240123174533.427864181@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bWJ3YurqOOrmXPn9"
Content-Disposition: inline
In-Reply-To: <20240123174533.427864181@linuxfoundation.org>


--bWJ3YurqOOrmXPn9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 09:47:11AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.14 release.
> There are 580 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 25 Jan 2024 17:44:18 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.14-=
rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.6.y
> and the diffstat can be found below.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--bWJ3YurqOOrmXPn9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZbDVdwAKCRB4tDGHoIJi
0pR1AP4qZqx2xJ6cyMF4KNNuQt6yzhsGw5g3OzDZ4HVkgPT90wD+PlVsstD4qUHo
86Fo+bV+24G8ucMcEGr3/0zKfARGWQc=
=Ocla
-----END PGP SIGNATURE-----

--bWJ3YurqOOrmXPn9--
