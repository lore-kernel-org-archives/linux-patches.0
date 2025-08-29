Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142857404E
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 06:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756448540; cv=none; b=SLXh4lTVK7sdN0bpA6gDoCUDTA7ZTKImMR0Tnd5C2YHmRjN0Vy5z0nN2MXeeH6svwRUveQouEl7IaR9JFp5pN2MXHm2N7B/+qDQ0b5oUBL+1oTGhzo33gW3i+zE3uIuh9N7zAHh45gJuBsJWyWrNb1V4DbB1OwfdB6akSQlW5do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756448540; c=relaxed/simple;
	bh=4gCFEIfkrKrA1+mEzotv5zc6YOWP+rTyFVajfyvuIi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sd27zaRiBQnDGFZk70HHNPxb+REm40KLsbdUy9Xa4dvrTZZfVyhvhWqBra696Zn9bLbYSlPKm/rMl2V5R7iimiO1Vepg2KdFcpN2pnsQhjsFlwz7NcYUD6NGEyhdJcQPI642BNEtuuOuhkrWnk3LIF+0jZjlT93GFa3VfX+6n9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ABbewqVE; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ABbewqVE"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EE3DC1038C106;
	Fri, 29 Aug 2025 08:22:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1756448536; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=+4kbNWU3I7s5Rt2E7e4PezX57PUPBa3x3YJEDebywiY=;
	b=ABbewqVE3twDU0JiaIK/fdpx9rDf2VkSKxp54WrITS0NtPctVUXz843ijtaBhOuSDat8YX
	9dtVSsDIJ0sWVTBPYalS2JLPk3WVgVWLkzCzXaKC/Vqa/vsJsauOAZ6Kc5oX+KC1eZyWAg
	ZEr2a87/6cxixpeB0NlKNN2Ejd4k7ENoiHpOahfkK7a8drznC5YISTAioFk43VuZmEXQuu
	7gz1lywzqG2F9mxFpfbDEXRYU1cCj5WrmvxC5p7ipNn7jSQN3cDPBhC9il0DSYPjBloS42
	vX2OMzaea9o5A+Bn1lVXsIOczIPRHoT4Raen7+m7lvn+CYbP8O3LzHwlb+/aUw==
Date: Fri, 29 Aug 2025 08:22:10 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
Message-ID: <aLFHEtRqvj4vzfpz@duo.ucw.cz>
References: <20250826110937.289866482@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ITu0OCEWvQWhf7Nb"
Content-Disposition: inline
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ITu0OCEWvQWhf7Nb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.16.y

6.6, 6.15, 5.15 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ITu0OCEWvQWhf7Nb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaLFHEgAKCRAw5/Bqldv6
8onRAKCLxziG4eJ1UUFqYtKsD8eDvAIPHACeKqlrw6gWzUx3GKLmP07b0aGGoIs=
=Xb9s
-----END PGP SIGNATURE-----

--ITu0OCEWvQWhf7Nb--
