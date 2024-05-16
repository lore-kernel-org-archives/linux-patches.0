Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C43F145342
	for <patches@lists.linux.dev>; Thu, 16 May 2024 10:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715856281; cv=none; b=pDiBthVdx9gyUgFvVEvQ4viMLz9aceaCjCfm/MjyQx7PIlJkEn9m+RtFjGJQg2sLy+iY9TnuaK49ire/mUMdL9XGkeDUUGnoInQhfwv36DukSq4MtdfeYMpGY80/tMt21/tIKWw+EBjGoOdcFxCYSXIGMaV5YH8V3l2as+kRcQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715856281; c=relaxed/simple;
	bh=A5AfgmEwsR5pOmCAWl/+5gLI7szoIUlGE45AaXulp3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8fs/3uUF7Fs3TBfUSTDTJpGe6db/DZLTS98whquw9UKUgcc/ohuExUIoGIoCbS3G4sOlDqUU01Y2+us2wKC6HZ7ghwWFtkMIUVLJAKVFM2a+nqOUkuc9rWJp7RDLuGu+65E/lDQfT8GyAF22Zi9C07HTmg6EIP+5tbqQH2IiiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 28B451C0081; Thu, 16 May 2024 12:44:31 +0200 (CEST)
Date: Thu, 16 May 2024 12:44:30 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
Message-ID: <ZkXjjjBEjn6bt2wB@duo.ucw.cz>
References: <20240516091232.619851361@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4dnc35YGozj3ZmnB"
Content-Disposition: inline
In-Reply-To: <20240516091232.619851361@linuxfoundation.org>


--4dnc35YGozj3ZmnB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.91 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4dnc35YGozj3ZmnB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZkXjjgAKCRAw5/Bqldv6
8jabAJ4+RXLU8B01r2SCh571DRUnmnMbpACgmKhmZIOWE+Lu4vV+KmWcmSqR9Ns=
=rcPn
-----END PGP SIGNATURE-----

--4dnc35YGozj3ZmnB--
