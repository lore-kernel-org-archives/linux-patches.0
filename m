Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9022D1A76D0
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 11:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744976348; cv=none; b=ChMucXo3pbbwuMVsJYfWm7NimBA3Eim14BhuAnqqRjUZkphczcXFBHqmAwve3Hj+7Q9lN7AgTCbsfwT+CGOeDEt2J/YjYIvG/hHavG3GP/kboxS5XfWHaUq+zgK9tbqaEkzqUFFwh4NGDvO1YopjliliEK48daaQXI/ITH/hVHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744976348; c=relaxed/simple;
	bh=NVz4aOFSulhdbC3RB8oO43D3FWj2za9z71EvxbpOrbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqSGjIJWBv7o/c4EHJMqC8fETX3br6BDMlc8GnrycBzloYeagR5PsFDEnSsdW/f/c+Ng6RTfyQ/lTzMuFd6RH8EF3doQ+BsWRiU74dDIpqibdoRMdtVEIZXKOpIIsao9+ycfr87OV5C5jFcjI86XxkI08kuYQSl8Yzn4bDllnB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=hn6Tk1Zl; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="hn6Tk1Zl"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 792EA102E6336;
	Fri, 18 Apr 2025 13:38:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1744976343; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=u39K2FCNZBF/gUuyu7NDFodtageuv3eD8R/ZP2iR6d8=;
	b=hn6Tk1ZlCrS6pnZx/9P32xyyLByzbPV0atO+ZTOaqHv/1kcZ8sDi40nuJGbNUTQD/m1r+7
	BRBWpO89ckM6FMwXGAltlafnBG5AI47eh4ShJKC8u7YvlJ7MbdXnm/AaVkgJsed1L1Le7N
	ulBVLK2MIcZv9CFcPFvpA6bpgY0fDMKlLtEkES/6YOvj1n+SmrmwhFDZ5+TOzWjdk4XKWa
	v6HRew0HMqiJHOv7Ippzmn0S+0B08iodghET9dKnL/pqxPC4Wh0swnC2Skpg89bqEXy3TG
	TPyLf1iPyjKns7O7CkSoeVDK4osXrE0Ogw9wH11NYjhz3uStOXezc05FchqjWQ==
Date: Fri, 18 Apr 2025 13:38:55 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/449] 6.14.3-rc1 review
Message-ID: <aAI5z+86EOyaIlBT@duo.ucw.cz>
References: <20250417175117.964400335@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1vuas3fjj7xpuM3K"
Content-Disposition: inline
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1vuas3fjj7xpuM3K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.14.3 release.
> There are 449 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.14.y

6.12 and 6.13 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1vuas3fjj7xpuM3K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaAI5zwAKCRAw5/Bqldv6
8lWgAJ0UZgZdkP5/bD8Hu+/YcGKuWU08sgCgrvm3lyQtvFbuXmpIR3mNYI4tFuA=
=D09U
-----END PGP SIGNATURE-----

--1vuas3fjj7xpuM3K--
