Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1683C15A862
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 11:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720696735; cv=none; b=L6OctZojb7LPF+vo1BsQQrwALyUuBV8MtzfeZLKqRhEJLIRtkRYQjZniT3Ccp9tTXfCpYCN6F96MivEGxtW3rCyLdhyZlMACGFgOS5a44wEyJmS6YA08wI2zzLkSjctg6QxLZQPKDyU21EYZUcWXJhSfdk0i0OLgzMaAGBhn9PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720696735; c=relaxed/simple;
	bh=41sa6d87PHCO6NdQU/rVMgd/9/pRq60wBMDdkt5UOPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfbRV7OtHB4UylaMhwshzJepKFYlX/Se3XcBVn4wMH5KvJfgo8farpMjdn1z3D7V2L9MExXiquJAg95DHCuVd5pdIuozD70Y9jFFE/oSb9Ha1GqQ8JOVNzpF7v9eBNTPDk1C14QDwGPmajP0NznDW1EQhcc0Oo9U7RdKM7Dl8g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 903221C009E; Thu, 11 Jul 2024 13:18:44 +0200 (CEST)
Date: Thu, 11 Jul 2024 13:18:44 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	erick.archer@outlook.com, hkallweit1@gmail.com,
	masahiroy@kernel.org, jmeneghi@redhat.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
Message-ID: <Zo+/lEpl7mr+K4Ki@duo.ucw.cz>
References: <20240709110651.353707001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fI793X9dww+ix4O8"
Content-Disposition: inline
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>


--fI793X9dww+ix4O8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.98-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

> Erick Archer <erick.archer@outlook.com>
>     sctp: prefer struct_size over open coded arithmetic
> Erick Archer <erick.archer@outlook.com>
>     Input: ff-core - prefer struct_size over open coded arithmetic
> Heiner Kallweit <hkallweit1@gmail.com>
>     i2c: i801: Annotate apanel_addr as __ro_after_init
> Masahiro Yamada <masahiroy@kernel.org>
>     kbuild: fix short log for AS in link-vmlinux.sh

I don't believe these meet stable criteria.

> John Meneghini <jmeneghi@redhat.com>
>     scsi: qedf: Make qedf_execute_tmf() non-preemptible

We don't have realtime in 6.1, so we don't need this.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--fI793X9dww+ix4O8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZo+/lAAKCRAw5/Bqldv6
8pqFAJ9xsR9PP4JkHK53mmd3/di/Wk4bYQCdG8FqyLpzvtSnU8NNFsl1Kmttr10=
=NdXU
-----END PGP SIGNATURE-----

--fI793X9dww+ix4O8--
