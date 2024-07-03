Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32D318306E
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 16:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720025301; cv=none; b=X+C70K32+pckigmc70n6+ZFXkCFmwjbxaAQ6yw4uew0p7HLo5LGZejW/xD+NS/XKRVWJ4M+5Brvl2s2IKQCCnU8qYiSx8qnhdSeRAha8QAGo+2I+VdK7cgTH4Tbiw146lWi0NlAdizMdha4gHfKac5nttwJYE6MNIU7pspvkimM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720025301; c=relaxed/simple;
	bh=0NnYJYBiYH40PHELNM9/s0Cs00ExwYrO8uFwkfgxKtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PwMwx15dh/P9gvcxDAjVd3e0VlL/d7E00MVOrv8YIhKuo8s5Lt9Xyv7jDIuG9DEUKkgTrIAlZ0TRJU7j6juYuyLnMBoecHw6iSM2rMXzufTcEpAGK4vzcnh0rGuKUEgho23eYSfGaxdOCRkuKhF0mmKVSdwlo8sHGQC7kUBoxEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 1AEC11C009A; Wed,  3 Jul 2024 18:48:11 +0200 (CEST)
Date: Wed, 3 Jul 2024 18:48:08 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/128] 6.1.97-rc1 review
Message-ID: <ZoWAyPmPDPenYzeH@duo.ucw.cz>
References: <20240702170226.231899085@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pX1+IVbrIs3YEyDr"
Content-Disposition: inline
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>


--pX1+IVbrIs3YEyDr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.97 release.
> There are 128 patches in this series, all will be posted as a response
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

--pX1+IVbrIs3YEyDr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZoWAyAAKCRAw5/Bqldv6
8v+hAJ0ZJNZYhn29SPeiwFbEDz//4QlKVACggZYu7TuHt5pEBXBkN09A3SSsZX8=
=tVDJ
-----END PGP SIGNATURE-----

--pX1+IVbrIs3YEyDr--
