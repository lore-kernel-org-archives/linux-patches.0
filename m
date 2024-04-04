Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7C54904
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 07:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712214308; cv=none; b=YnUgjP5DBn7K1KpobRP4tSuW8yerJkbcJLFIGgU+hP1TAf+/l75P/4DqQuR2maDpNVJkbvSG0iedLjzBo9z0q5UvaO9bzO8lBI7CiogUyL890Dr3Pe7ngNboI9TVAv4tX/tX40Vhqm7kBy8D2xa1Y2bFMLt27tr3h+3n+g7uCfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712214308; c=relaxed/simple;
	bh=awCWiNIcCia22Z3aIxNnqluGlvZq9YbD2aDfCIEOP44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGQ4ZwP82P4LwQNr9AUQ3+2RJWDoPN0OEdVlt1MFhnx2FtlOxg5CX4hbXlfuyzs0+KhTOk7dFxuRXCjr1YHVkEE/y4HiuPChd7HKphhXjkstkR/O/nEE4tUE/l4yX6AFRE5yooK+y0wnCjCzU7oZob2zJK2AqhakWIOfXhZbLlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id ABEC01C007F; Thu,  4 Apr 2024 09:05:02 +0200 (CEST)
Date: Thu, 4 Apr 2024 09:05:02 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 00/11] 6.8.4-rc1 review
Message-ID: <Zg5RHvawLJK/A7Rw@duo.ucw.cz>
References: <20240403175125.754099419@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GC+Cwo/4YreXUK3V"
Content-Disposition: inline
In-Reply-To: <20240403175125.754099419@linuxfoundation.org>


--GC+Cwo/4YreXUK3V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.8.4 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Linux 6.8.4-rc1 (c4c57420c666) tested out ok:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.8.y

No problems with Linux 6.6.25-rc1 (e253a5c1b7de), either.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--GC+Cwo/4YreXUK3V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZg5RHgAKCRAw5/Bqldv6
8gC1AJ9+25DESr6JetssvHz9CyyRY0YEYQCdEquBdPlwKsY7Th28mu1pHZgw6hE=
=eHJt
-----END PGP SIGNATURE-----

--GC+Cwo/4YreXUK3V--
