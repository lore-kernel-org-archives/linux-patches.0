Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF6E1922C2
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 09:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718357718; cv=none; b=QdP4ZGxvyvNPguszgKxQz4jz/AwfBRT3EW3FRv/nOgl+fjRxyfRCp/Sc9biXHcl8GUqWOxtSw34L78GP9UWO3lRy370wknw3/Dv0/yAy3FZ9tHSOq12T+7Wk/3+vUZQGb/786XwsQyc0bawavLMltVndwqhfLAfydbnKz55910I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718357718; c=relaxed/simple;
	bh=+SRN0TRxmcBxaF6CyBtFMH7/VP/6CAVDDqHQgSCDdoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TaA/f/fiCGVBpn+45uuAm9A+EizjbNGQYY4sG//AlFojjh2ghuYAaCSIHJQY+El5ZHpG9tpHIYIDfeuK4BcfXvm1sp9hUu95WyaCRuPUx8f9Vw9+sH/6cQoNfA0XKPl9ZX9k5/ZiNcOr5Iji+k7pW8NgwgW8uOscEhq8EGYBieQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 2CEEE1C0082; Fri, 14 Jun 2024 11:35:08 +0200 (CEST)
Date: Fri, 14 Jun 2024 11:35:07 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/85] 6.1.94-rc1 review
Message-ID: <ZmwOy7M+WQQweaSD@duo.ucw.cz>
References: <20240613113214.134806994@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Bb+eb7BKPYLfG0z"
Content-Disposition: inline
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>


--+Bb+eb7BKPYLfG0z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.94 release.
> There are 85 patches in this series, all will be posted as a response
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

--+Bb+eb7BKPYLfG0z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZmwOywAKCRAw5/Bqldv6
8p+8AKCMHRgKGCDAtTKWJK79aoTPmKVQ9ACfYdtDawBVEOzsLgCWqASbflOXtqI=
=5RJg
-----END PGP SIGNATURE-----

--+Bb+eb7BKPYLfG0z--
