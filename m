Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F6B175D29
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 07:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725261031; cv=none; b=Jm1hBsynmFHTtj0NiJ7H3lz704ZX7bybcC069kZAc5gj8QPOmNh1kDuQ3HEItNGEv2SycKOHI5lzlCdEdfaUDw5n4uK8eU+/DEvDPxKfwd2FHLO5q4zjJezKYLCpvWpsC3SaiYDfhEwNavxILj3ouNVCTC8vvQAAFkSk01cbTjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725261031; c=relaxed/simple;
	bh=XwPJ91Ex4iQXobjf9su0VdRAu22I/cHI8v0+O4Aro3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQPGGzUZqsTfho8AnsPDlkEulwfCrGiuOIe5cQAYhkJci09luWtZSO0cZKsdy/Nsgxj2BkCOF7zWx/RgXj1/gCNAIJJxmQaeRVSikCn5Rhm7Lw0i8N1CBPuNgz3xWcJlLpZmQXfNbB9YhilyENzliK7JuxD9S0I5EwJQhyXbU74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 8A9C91C0082; Mon,  2 Sep 2024 09:10:28 +0200 (CEST)
Date: Mon, 2 Sep 2024 09:10:28 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/151] 5.10.225-rc1 review
Message-ID: <ZtVk5NOtM8oWahvg@duo.ucw.cz>
References: <20240901160814.090297276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CekmbABPPDX4qV33"
Content-Disposition: inline
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>


--CekmbABPPDX4qV33
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.225 release.
> There are 151 patches in this series, all will be posted as a response
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

--CekmbABPPDX4qV33
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtVk5AAKCRAw5/Bqldv6
8tJyAJ9Su9jMLmqjnEAIeQz5br94l89cNACfRs9NymtNMck/UGhjakCcQjzN/rY=
=dPuM
-----END PGP SIGNATURE-----

--CekmbABPPDX4qV33--
