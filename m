Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EF617C9B5
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 19:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725563556; cv=none; b=L4T919MweqD9XSyPufXWH5U9qLnhv72uONoPMhrE5Z6bXLGonlRtWH+NoHzmYw2DOfenXjt82PF6AFsITDuPjZFZ3Hn8bIrcsNzFLNndcZtw1puK0KjN0juNVjDT1RohP4T7lULlQ8wcxO90Y/V7Zy/0cRo0Ng+iY2Dd16+6IwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725563556; c=relaxed/simple;
	bh=RY+285Jvos3Lce3KrWnNw6KwCdu7/GEnZ9+YO6AgHtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fB1/UZLKir5rcemXEtvWjjgosBZn8b0WmBHlnG3guR8aE0ckNIYJU/L5S6Yz8tZnyLF9IoWEz8vtZBiq+LJl0csc38xAlYEAdRH1a33D8vDuI17JHxDKd4dbaut9PBJWFYRkljpWVUhrixp1/vxpeM/+lf8qw6VUr4Sn6mVqD6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 24AA41C009B; Thu,  5 Sep 2024 21:12:32 +0200 (CEST)
Date: Thu, 5 Sep 2024 21:12:31 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/183] 6.10.9-rc2 review
Message-ID: <ZtoCnyqAzR4U53nC@duo.ucw.cz>
References: <20240905163542.314666063@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wfZdgS/jjDdO1Cjo"
Content-Disposition: inline
In-Reply-To: <20240905163542.314666063@linuxfoundation.org>


--wfZdgS/jjDdO1Cjo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.9 release.
> There are 183 patches in this series, all will be posted as a response
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

--wfZdgS/jjDdO1Cjo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtoCnwAKCRAw5/Bqldv6
8gd7AJ4snB18i7j0boxsfoFJjnC6etZliQCZAUruRiQBj62GsWYUlIZiDlk8W0M=
=lhjw
-----END PGP SIGNATURE-----

--wfZdgS/jjDdO1Cjo--
