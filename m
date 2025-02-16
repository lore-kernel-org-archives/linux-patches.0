Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C756418D64B
	for <patches@lists.linux.dev>; Sun, 16 Feb 2025 11:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739706059; cv=none; b=DK5sj8z43CnmIYKr4rChC73g1ZQ7OfFKwDYHEgnKWJvDrGWc8o/k0XBSKeru4tT+5acD6gzYJYZzlo13TL2qmPlMYd80EL7SycI2mGrOTHZUZ//jF9pdhL7DGFEpI5AC8nQdqJ6ceNfsgZgTd6uoarrQApAvDR3sbgr+BLGgHyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739706059; c=relaxed/simple;
	bh=+a8QeNJVrconBBC5xsOeKGFPL3XIp0tN5RSpFq6TTuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqdiBp/+9WjyxMNORh9IgyLu05gWmB5uUtDg4mUV5HCpiOttIs6MuzjqmlOaEmY8YIx9NmSmB2iMokPhNRyl4LvnlN1s8wYv7DVD/MnTvdrkdQFkGPCIETL7QbK5U7G25aieJToqQLzN3hQxdksHqbQju1NpoZ9cG3NYDSFeiK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=QUFAn28O; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="QUFAn28O"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id CAF69103718DB;
	Sun, 16 Feb 2025 12:40:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1739706048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MMWLfdM6ZIONrekrLLgd74r1U/YchF2b1CqEH42jQXU=;
	b=QUFAn28OFgkqWj2W2GLQIDBWc+B6ly0Fy81e5QJgzz2ml64RvWRpts4qSltVsgIBSGyxTo
	mpJqL2mn6mzkwSj5wpmaCrx0DJs5cnZ+0dF6/X6u/YEaD3x8M+inKNf+X5p0WF7BcA+8ZW
	MSD/wUtCzXl7gUrse45E4yTzNDsKectXsjBsnxe7k5F3yrw/5lY04ewZEgKBt0gc/l8MSJ
	HhLMOmeaXzOx/LQDPEw5RISrnjvte2r2IYEcolfLJljDHUQJJUOFwPEOQzJrfQOVlHeOLA
	3bit/w6Vwr2gKNdr6i/9rdnwawjQUyJjis2EYdt7RJIU+bKlPHVZ2FWm8qPIkQ==
Date: Sun, 16 Feb 2025 12:40:40 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
Message-ID: <Z7HOuImndJzQx0vX@duo.ucw.cz>
References: <20250215075925.888236411@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qvWishOJmXJLIi6u"
Content-Disposition: inline
In-Reply-To: <20250215075925.888236411@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--qvWishOJmXJLIi6u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.13.3 release.
> There are 442 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y

6.12 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qvWishOJmXJLIi6u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ7HOuAAKCRAw5/Bqldv6
8jZnAJ9NaL2UtffVRy4XIi4KBw8d5WGO+wCfToEtBdd2VRCZYRL41PydNgZ2G7I=
=DRb1
-----END PGP SIGNATURE-----

--qvWishOJmXJLIi6u--
