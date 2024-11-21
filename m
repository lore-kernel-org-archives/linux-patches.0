Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E6D1CB334
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 09:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732179789; cv=none; b=JN+R9GV0KhPxchZmiVEgWVB7DZ6WA5R5fEN3PIRXVsFRLBTOqNBPyRO18cstCLHyxdn0aypP+L1pvyxMGYIdARyvlDZq+D1xhDDt3K55lXryRFAsr0iQuQ+2PKR11xqzqIEtJD3gxFyKUTKl0VObdo0zhWyU5eVFu6jWBwHGqVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732179789; c=relaxed/simple;
	bh=dkWaQ47ElqK/IVAD/NkPs8IzwV9bOvbZlyOJXgqc/DQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C18m0aT+HQb19nJnkS22QJrH/2rUYjONInRsRUR3vZoNsq8ykBOFlr7EOR0aYQow2KMfCHrKP1MU1kOaATckzOkmRKx7tMQGEct0V10P5IlnZYmGCWEItsXnM3+uh005ZuYESUZbk38rW9dxphxzPEdcbzL/LzQG0vBqq9jK4As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id B22031C00A8; Thu, 21 Nov 2024 10:02:57 +0100 (CET)
Date: Thu, 21 Nov 2024 10:02:57 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Message-ID: <Zz73QRGLDU8xreEa@duo.ucw.cz>
References: <20241120125809.623237564@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AtKEwY1kABgNV0nU"
Content-Disposition: inline
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>


--AtKEwY1kABgNV0nU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
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

--AtKEwY1kABgNV0nU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZz73QQAKCRAw5/Bqldv6
8q/UAKCqikcVHQSDaazAY35gv5DmUQFhwQCghXWes2GOgAjwSW1iFj1EiRAm6Q4=
=yCwM
-----END PGP SIGNATURE-----

--AtKEwY1kABgNV0nU--
