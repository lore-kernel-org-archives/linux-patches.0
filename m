Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91EC1C32FD
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 09:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725268965; cv=none; b=GDzqovjxdXt+JK7Hl/8f8kVB1sJMpN6XreJUSYo7FjenoYJOHu9sjDA+9Q0PN353w6rspN2wxTOxrgP65fQN+03b2LHf8ZgMLBiLDrcti9uM4yZvuAeItTgG5poxAQt4w7Pmk5VIFemFSpNnbSGJEfWYI9EJ8hY7z8X4f6366RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725268965; c=relaxed/simple;
	bh=U18uxgrAwxlpsONTG3cU9Ne10ekdPt/kx4SnKlVAhJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLT6/LD3xPAGHNOtQLiwPouC8QjPlhaFRieWza0I/9yWSu62EjTywvqKrqL0JtwVR8tFtfnQaU6LXhJd2e/cx25D4aKLYI7bPN84gg1VUiWf/EhTeg7HHSzsTVhhlpqPw3wFbtrZIVW4O7cIeXmHI/bIZVibynn0OILtPh+VYlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 039961C009A; Mon,  2 Sep 2024 11:22:40 +0200 (CEST)
Date: Mon, 2 Sep 2024 11:22:39 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/149] 6.10.8-rc1 review
Message-ID: <ZtWD39hotzRekF0p@duo.ucw.cz>
References: <20240901160817.461957599@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SXAaYyJtKBc9mggX"
Content-Disposition: inline
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>


--SXAaYyJtKBc9mggX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.8 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

6.6, 5.15, 5.4 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SXAaYyJtKBc9mggX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtWD3wAKCRAw5/Bqldv6
8jlSAKCAB23dcrmkZu4i3f8DnZ74sG410wCgwCbKRf0ebObFbNE9UiosdEEFNC0=
=XQrq
-----END PGP SIGNATURE-----

--SXAaYyJtKBc9mggX--
