Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094A12E1C63
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 20:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756240216; cv=none; b=drQP2MtPpCfGai+TWozbx3CThLmynytK4K9G+sJTp9lsoZBR9QPQcwnQP4NyG1bb6laEx99tgJlKdh+58DoO8VU9bCTpbYh/1B0UXycSS6grUGWktJSy7P0wrJJmbap669zgSnVjaCFM5bkWBZg8wqYhdkbNrWOLA95sBKHeHx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756240216; c=relaxed/simple;
	bh=nlZdL1mcoGHbOICEMRXnxk9Va3m/5vNGG+p8r+yJgeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=an8XKgi9B2llZxgBkjtuHDTPLPyLCaQfYXN/z2ioZOIEqqKvlyCPhkN2SKYFkK/cbbxK51O1UE2o1F2PY9SGdciznFXR96+YBh5CnGMALkkvgu675MpW5w2mhzAHJbzARZzKGbFMggVMoatDCh+PbwLLhzT0liSUg81JX3GCK0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=U8qaAZfo; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="U8qaAZfo"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 00608103BB5D1;
	Tue, 26 Aug 2025 22:30:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1756240212; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=naLTB6DSsMVqHB2S6vjW8+x2W05g2+U+x0kRjbxn7Zw=;
	b=U8qaAZfo/zUKTYmJby8XzhXUSQGXwRJrx0Ygk9GxJ4y1fMVaiHeAxV7Eq6zG40bKA+UsG0
	ovWiG91uTi8MPv1Huw+5YjdcG11VSL0BRbBQ1EnTGFgslr2tYQcyqlDn7iLjmRrI6+EZy1
	Or8AyoFs0RElDEqYSv3aY7di6BauOaoDCNkGnoTQfDRCD1YB6gaebnKTU06aGd2dm1KzZZ
	1TrtFjHicO4S1mnBR1ZsVC7QkKdjckclhHVEyUNQT29Ow6+U9nytKVgRHhn0yepGjQhldV
	O4soEm9jqTMb/MBygmDHnqVh7zDm0FUJVSI2lnKI0I6DLOP4kiSwFir4Ge1WiA==
Date: Tue, 26 Aug 2025 22:30:09 +0200
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
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
Message-ID: <aK4ZUcAVnKjG0NbF@duo.ucw.cz>
References: <20250826110915.169062587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wj2ZbTd3+4EepARg"
Content-Disposition: inline
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--wj2ZbTd3+4EepARg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wj2ZbTd3+4EepARg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaK4ZUQAKCRAw5/Bqldv6
8uiSAKCvpiXgwDmBFccZfDgwWnUIu6EKhgCfevOvA4b3DG2arTmPsg1hdcR3Aec=
=CoWy
-----END PGP SIGNATURE-----

--wj2ZbTd3+4EepARg--
