Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F0420FAB2
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 12:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984094; cv=none; b=ZOIiWKDEpUaRSJUznHaPi+cszYB5FukxcRx33L0PCSHDeHexqM1eyS7uB2WbFCQCXmBQKkka7vBKwwSR4XCidQZv3/3p9T2tR1KL2iwYv17+xggF17Xn9/22VoczEExAQSyJP/anP/q7l1Md/6P4xVLOWj1cYzAr42uu5gjNXPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984094; c=relaxed/simple;
	bh=wnh7WqRNWHKMBy8pYlw+oqHdI5pZKHsfzU9zXFAxNeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZSvEXIWYECL8p2R8MbMGtoqK0H4Boev8yGmjZnnZHsZvFF8uD2Ox0MAIfP1Iw2SfRAUXK91+JP71Pp+DmZz7qq6tX5ywnZAJS3qAkWJ9EC/qHUpXFeMLuYPdvoV98WVZTthDpWS+6M1wH/oCh4TDh05WIe0CQwhx++nNLS511Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 18A9D1C00A0; Thu,  7 Nov 2024 13:54:50 +0100 (CET)
Date: Thu, 7 Nov 2024 13:54:49 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
	chris.paterson2@renesas.com
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
Message-ID: <Zyy4mfTry2gNQBH+@duo.ucw.cz>
References: <20241107064547.006019150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="acHZ4brnx10MN/2v"
Content-Disposition: inline
In-Reply-To: <20241107064547.006019150@linuxfoundation.org>


--acHZ4brnx10MN/2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.11.7 release.
> There are 249 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing has problem with BeagleBone Black on 6.11:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.11.y

(I'm cc-ing Chris, and may be able to do further analysis).

6.6, 5.15, 5.4 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.14.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--acHZ4brnx10MN/2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZyy4mQAKCRAw5/Bqldv6
8rwbAKC/HOkY89DuqtQGStaubX8I5inAZgCfUAH/oMKx8b9yCKZg9elpk/sbwGA=
=ukZZ
-----END PGP SIGNATURE-----

--acHZ4brnx10MN/2v--
