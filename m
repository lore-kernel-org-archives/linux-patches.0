Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B48C145A03
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 09:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727947314; cv=none; b=aOwSruRYiGVXNJNWDDKfdBfjsoB9Mf1ZnF3WTyNm3m4wt2vLU4H5vEdyXvCXursnUIK203kl/xiBU8T+gTShtQKbvy6f1ozAl8LzTRjZok3kL8vtHc971STVa66vmrxQz+IULP9jauLSIXBp3/pDtOSS8X1jfZAjxNzg/MmujSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727947314; c=relaxed/simple;
	bh=llj8V9RYHMWRFkcrF4C3E0pHpVFbaXT9r84k7zS45cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irjUs7rf+S4rtFhOhpYO0Q83VdXjXJ7YDHlWaYpgCpVXzmGmnxSCZ3ijLUhYyUoFILmUy5gMNvqZol2zb9RcC9laK6oxvtGZ7XvRP1+8miV8gYcMMKnQX3vfHsj7fjHhDpsOz0b3RpniNHfGWLFXtpIqawq69tL7SmsX1RCjjDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id AAFCA1C00B3; Thu,  3 Oct 2024 11:21:44 +0200 (CEST)
Date: Thu, 3 Oct 2024 11:21:44 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/634] 6.10.13-rc1 review
Message-ID: <Zv5iKMqDA/xQ9OS4@duo.ucw.cz>
References: <20241002125811.070689334@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mzTp8T29f85ReDen"
Content-Disposition: inline
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>


--mzTp8T29f85ReDen
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.13 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--mzTp8T29f85ReDen
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZv5iKAAKCRAw5/Bqldv6
8rLzAKCtA4rA3NhLAWLgFUuJ7hFsSGLpKwCffsqUDCqrDi05rGq8JDIqd9RTJn8=
=yOCJ
-----END PGP SIGNATURE-----

--mzTp8T29f85ReDen--
