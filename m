Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0C53793DC
	for <patches@lists.linux.dev>; Fri,  7 Aug 2026 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786127637; cv=none; b=CAsJ+TGHcFGKswZOwaHfJhHpaAYyP+8iS1Dz03oUUxKlmoSoMW6yozkPBL39+0D3XDIsP0CX21Q9CY5XoHC29HI8BTDUnLGxuHtZspRFI9BQJrBK4HY7pnu5PcoQWwb0Jg2tRQRS6HGSUUJwGiIJVqietut8QZPw+i18ZXwj3ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786127637; c=relaxed/simple;
	bh=++4PP/DxGqbE0I2hE/9zsIRgWAC9HfdPaB7Od+zhgxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoLXrjAEDA1nDX7HvazHgO5cuyJaOYmyQvPAQaJYC+0MrWSfyp3Ju7ZLXk37O0TniAtG7mXY9nG4I3kzpaLKrBkjXoBLOeiiv50IbngocaOaZuoksp/U7/rSjwma7cIpwEILuMTHguAJ+rihQxvOpxp6zl1PbCSYRKXi69Ui11U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=i7v2SKhl; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="i7v2SKhl"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9635211B0A6;
	Fri, 07 Aug 2026 20:33:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786127629;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=WcYt8c38vpq5RZ0f+lkj0MzFHLxy2/xgKstDe6GrHjc=;
	b=i7v2SKhlIkqKpqIzZZ5pNKgIxwWNIruLcj5LpDpLO5R35XaREfJqII/dFHdVHlvT7uq6vX
	nFG9BBRl0ZXUEdrQmML7KQyQ8yGTc45hyxaiWlltHrHHj9lltSkGLIreeZ9LP3h+h/ORDm
	wCve7aEOHfoKr8MZVOG58XFMYuSG807ySqx2BJUu/qREN/gR1ArDtpQ/H0tXuKs8o5RE1r
	9XtFZ2B8OW4VpM8UP0VwD0aTg7Vw4QtYBOZvECaM49PtQndponXpKMddxJCKrKq5UQqdYv
	9hD9dpb161Jc320Ei1QexybxbbgNfx/LM2INBdz/fd0lW08dc34BITu6QzvGWg==
Date: Fri, 7 Aug 2026 20:33:47 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
Message-ID: <anYlCxkwN18FaoEt@duo.ucw.cz>
References: <20260807143415.358597922@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtzc/rMXqjEbLo+B"
Content-Disposition: inline
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Wtzc/rMXqjEbLo+B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.151 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y                       =20

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--Wtzc/rMXqjEbLo+B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCanYlCwAKCRAw5/Bqldv6
8kcGAJ9Bjrv3/D6l6OPz1Aa/KDwTYbDLbQCfZO3Pd3LBrLNPZFaRmgqbACrpsrE=
=ifjv
-----END PGP SIGNATURE-----

--Wtzc/rMXqjEbLo+B--
