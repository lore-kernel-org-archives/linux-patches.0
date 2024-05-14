Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2432B84A22
	for <patches@lists.linux.dev>; Tue, 14 May 2024 19:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715715724; cv=none; b=NABAVY+Mdqy3lCwrZ0qWjqyr8fH8WMHfK27l9dzRmBGVrzbAQk1abuYFOmfzWdF7fIk+QtfJ09aue3PNKIA4j0Ta4byigriENYPnfdT6u/7s2YZ0RLDMWNngiraDzpDm4WZKISjbR1YJFgZuCYEgbbUWTDpJ55LwASDiqR4hAic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715715724; c=relaxed/simple;
	bh=H9809BmAfI5QVtMFoQcj6jm6Ihj168kLsoBh+E/ZgPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yf/BEJKY76QZmU7XtoRIRPWQW6h2D4wdLmReskVLNBErwu3aM6P/hu8E37X1rxYhdMSC1SPvXFqhfC9GE01QCorvfcJzteTrsxwprHRuXyWuQ1GWNlycCcpTHGTUNPcMwJou2OJgrOawGbb499x5evIy9pema/g/Pz6fPS4cTDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D23AD1C0081; Tue, 14 May 2024 21:41:52 +0200 (CEST)
Date: Tue, 14 May 2024 21:41:52 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/63] 4.19.314-rc1 review
Message-ID: <ZkO+gHl+dPwXQ/1i@duo.ucw.cz>
References: <20240514100948.010148088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zgt/JtGQEFvrF5Pk"
Content-Disposition: inline
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>


--zgt/JtGQEFvrF5Pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi1

> This is the start of the stable review cycle for the 4.19.314 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--zgt/JtGQEFvrF5Pk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZkO+gAAKCRAw5/Bqldv6
8rSQAKCkxPSj6S8jHz55utuGfbHJIK6/ZACgqS4YUggMOYDAdD/0B+Eley8xqJg=
=tj6h
-----END PGP SIGNATURE-----

--zgt/JtGQEFvrF5Pk--
