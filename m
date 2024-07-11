Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00BB16086C
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 11:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720696848; cv=none; b=j5yUIDyb7YwZuK8UDESJQ+0wnxh7+VleHzrKlQdo83I5Vhfd7lcRar84Ri0nAW6BXDgepcPaczS50t0e/rvhOlxL3EmLxKZ4JFb3g+dBD6t1PMcJ9AmqFvSBYWuPlR66LnRRrNv19UST6HB8wNPyjw8f6co4O0ZmhCaPbIrdjl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720696848; c=relaxed/simple;
	bh=MH9pKtHoxjxgfCXThfN3OBLOy7q/0Tp/taYKYsOuP1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QryFO0L+CnpjBTwru+F8x7esd28pDr1l6Tkdp+5EvJEwM8dYgRFem3sy0ypO2ZBIBgwsjFaUxLkaLleg4eHBPKZiIAcVlk8vktoEdUZSHxBYzpVw8CqjJfJcG5apAkc3wordzQ7dlrkyo2pb+QU4PAnz6An4PXBN3D3kUSGSWzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D05671C00A3; Thu, 11 Jul 2024 13:20:44 +0200 (CEST)
Date: Thu, 11 Jul 2024 13:20:44 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	guanrui.huang@linux.alibaba.com, hailmo@amazon.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
Message-ID: <Zo/ADAlGyoVcyj33@duo.ucw.cz>
References: <20240709110651.353707001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T/s9MeQRrk30cFja"
Content-Disposition: inline
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>


--T/s9MeQRrk30cFja
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Guanrui Huang <guanrui.huang@linux.alibaba.com>
>     irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc
> Hailey Mothershead <hailmo@amazon.com>
>     crypto: aead,cipher - zeroize key buffer after use

I don't believe these meet stable criteria.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--T/s9MeQRrk30cFja
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZo/ADAAKCRAw5/Bqldv6
8kW6AJ4nhH1m1QyznYBgEJuwSbeo+kZV0gCfQ13G83ROfJP02BZvMZMKn/fua0A=
=9jrv
-----END PGP SIGNATURE-----

--T/s9MeQRrk30cFja--
