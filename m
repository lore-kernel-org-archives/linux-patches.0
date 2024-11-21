Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B497413E3F5
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 09:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732181580; cv=none; b=LY2u4BJa5PEXXT0AYcPyk6+oUxZl2JQYJveD/fpE9J2yD4WXhwhG0UDpJOUvyk9qH4goRQ+9V4odKcXY+39K3jTU3ir5pPSSQUP/9xHEFGZiW91jCq9D93J8gtZ5zTWI0dWTlwvY9RDBc1jHIbgbmTSMT2/e8YmWMTqBQwzz1K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732181580; c=relaxed/simple;
	bh=ju6w+OEV6RGqOl4StwYVV73mcfrYeHharZ90JPv9bV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJaQAhf+ctFtWicfRGLn5Ccv7/jKmLeBci/CejPXNzmEtSEhM1KINOzD7DbgJ9USAokp06edAzc+BKYukx0DSb/JVQYI7k1RUOqt2W0o/WrFbtXEnQTZugrOpVythtTlCKJuLY43tKN83OvoZarrvQC0LrpQ1sbImFQcxJ1Qc0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D36661C00A8; Thu, 21 Nov 2024 10:32:56 +0100 (CET)
Date: Thu, 21 Nov 2024 10:32:56 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/107] 6.11.10-rc1 review
Message-ID: <Zz7+SIXT9ti+g/NT@duo.ucw.cz>
References: <20241120125629.681745345@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oFNwiWPH6culmr1R"
Content-Disposition: inline
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>


--oFNwiWPH6culmr1R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.11.10 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.11.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--oFNwiWPH6culmr1R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZz7+SAAKCRAw5/Bqldv6
8lABAJwOktlr/JOLohfFWb8BgoNmzyPtdQCeLpnEiFASEFBHMY92Z3FbPWXJijo=
=2mEz
-----END PGP SIGNATURE-----

--oFNwiWPH6culmr1R--
