Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B1C20651A
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730914185; cv=none; b=lzKOyy5oglTDygIvv7mRL4O1khlxjXG3lpSD8LZDyCs128TAIeT2PT4a3m0Inq4VbjCcBADxroLgBsFEFgz8/ZSdBbvzIB2FWEw7f+oepF/N7oQjY4OZyKIVTl8WqQeeG4osxwRWOCFGN9DlJRMiBca/KVeojo0WsBgkEYNc9Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730914185; c=relaxed/simple;
	bh=oQMvFz0g2jLC3BDy+WkvwI0knLz3AaipYeJboXrFRjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BAmCdtJauOS3sS/EFsTFbhG+pkB0zQi0T6fmIx5qlkawtUuDBUTu0yOGSG8qtRFaov8GmB6Mja2VTek7cEcvwgyZzNVx+S2pO1zrh8AmJ0QwaJIP2fuQNogb+pIzUh55I/Ba4Tyof6S11znF5D+GSRMi+qL64Tj3QVjphOPfcPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 4CE491C00B3; Wed,  6 Nov 2024 18:29:41 +0100 (CET)
Date: Wed, 6 Nov 2024 18:29:40 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/110] 5.10.229-rc1 review
Message-ID: <ZyunhATDuKtcODFB@duo.ucw.cz>
References: <20241106120303.135636370@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Et6GL7kD1tCCkhWB"
Content-Disposition: inline
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>


--Et6GL7kD1tCCkhWB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.229 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Et6GL7kD1tCCkhWB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZyunhAAKCRAw5/Bqldv6
8s4aAJ4ipaS80oMgXshQYe/XkQT+WG4B7ACgjGhLdqglMJW/rY//IUps2iSHMb8=
=yK7P
-----END PGP SIGNATURE-----

--Et6GL7kD1tCCkhWB--
