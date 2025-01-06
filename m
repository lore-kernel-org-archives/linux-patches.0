Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF631482F2
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 18:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736187792; cv=none; b=MMS0uqtDeJwCbZvIdNty26gWQL4X1lLGIT7LWYjfIle/C3xlqOm8Q14Iwiwrz+GG4Hnn0L0xctkBAvfsBgWyEga1oI7YML9m62pSYqnWVOUC9v+aoyfBoT0ie4rEptuFIH5HIRVjDnwOmQE3AGRpQDvNKfUE6ewQNgaXb7My2LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736187792; c=relaxed/simple;
	bh=B/KFn6EclxODbuc0j7AHbYAcQRvN6GVldP7KwRAmeD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjENjeSEyMK0lSBzgrq5YoQeE/eLt0AwfbcdAdtXMioxEkw03tRmu2k4+wTcKKTYjApHXAll0I2JMPuBuzNws4/dG0FSUW7PYovDZ++9AbykzlGv07xrSV5QaE98GHOHuvKT/q0USOikE3otaXX3yFOCtyJ0cA06u+hRkYVaz7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=bHPX2LN9; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="bHPX2LN9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id BF6A3103FEBA2;
	Mon,  6 Jan 2025 19:23:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1736187788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2gL8+k3JZ4Niu6xd6H6HIwIcw+6ddoZFhZ4lqWoxkCA=;
	b=bHPX2LN9lzg+vTxH+xgu/nvXiusd6zM8Xlztys57Mb/1dCdt0xNrAwUDq966WGwBePkyNQ
	cFuTHnOCixqrasNDQt8y7v0eCYH2fnQl0Qr8SsI8IbiWOrzKBLAHHUQHfJgNU5WKRcbNFi
	aDoOVeANKp9vGT9OSs+tAdt8YCnfRfMDTOVB9kqqpXjaGpjhIOoHGqhB9kT0nlyJDUfNEr
	MZ8Hzl8539QiOkXHnphhV4PRDpSpJrxx9dmFIJ9Z60zzSNCB2rXcUnsjsitIm4hlSty2xR
	ApsFzEyHl++k0jCVGs0h1baRCfxf4oyMn9p9slZ3qCJoaymofD0I7Z+FzbMMmg==
Date: Mon, 6 Jan 2025 19:23:05 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/138] 5.10.233-rc1 review
Message-ID: <Z3wfiY4CmGXHHrKi@duo.ucw.cz>
References: <20250106151133.209718681@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YlK1dL3eDgI+USf2"
Content-Disposition: inline
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--YlK1dL3eDgI+USf2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.233 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here: (obsvx2 target is down)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YlK1dL3eDgI+USf2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ3wfiQAKCRAw5/Bqldv6
8uTyAJ9hs8xEjYrNZsE5a4cFvHSjtVNE+ACfQaIBs3GczdEXh/npFLBiDV3+nDw=
=kcdQ
-----END PGP SIGNATURE-----

--YlK1dL3eDgI+USf2--
