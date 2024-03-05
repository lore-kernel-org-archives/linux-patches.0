Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0040556758
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 11:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638554; cv=none; b=kiQjKjXdPBSyUxRBxPIE1tLguUg1fSyqRQNFqYdtnoAz2VSEO4ftKilst+bvrw+aaQh2VcJt9iIeUkjUajacFWuFaQYMnU5YeTSH9kM1V+nhy4tSJfEwRU0AQpgAFvDtUl6crgfE2Hq4vReAMkXetkdaF4dm5rzawbKpXu+PhcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638554; c=relaxed/simple;
	bh=TngYMjVWl9Cl4wrJKTHWb8MWFISlBPfOR47LTtdqSX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMasbiVy4kOlPjClb3LQrCQEkRUkB7EeDnXrCw5TG3JBJf25liHOvUShZsls0z1aYGBeZbwa2gtiXDI3RTg2qvHYMRf5XL/iKCttg0E4jkMOTqBZmHluDTB8MgaGJP3FTppyFOzy7xvw1Cmw9F5Zh8SWI4W1sAYei7ww98oR520=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 2C5B81C006B; Tue,  5 Mar 2024 12:35:50 +0100 (CET)
Date: Tue, 5 Mar 2024 12:35:49 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 4.19 00/16] 4.19.309-rc1 review
Message-ID: <ZecDleIBcoBl8yYf@duo.ucw.cz>
References: <20240304211534.328737119@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z9efAzuOvkTkGS8g"
Content-Disposition: inline
In-Reply-To: <20240304211534.328737119@linuxfoundation.org>


--Z9efAzuOvkTkGS8g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.309 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here. But note we don't test
risc-v on this version.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Z9efAzuOvkTkGS8g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZecDlQAKCRAw5/Bqldv6
8kiIAJsGsV4zalheZWQqVCns4If64WlAwgCfTVP+MHM5XdS1rex5NoLGpoEYeaQ=
=uaVH
-----END PGP SIGNATURE-----

--Z9efAzuOvkTkGS8g--
