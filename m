Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4D8213E74
	for <patches@lists.linux.dev>; Wed, 21 May 2025 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747841903; cv=none; b=u3gpS5in2kNnyjjKRqiqwJhtLgux7MLe8miy6dKMKR8LRl6iGUDvmSZdgsA2A2uN3j+w2n4GQt0JKo8JN/usehxTesFhOAIdJ2ILXqS+CmBUxHjd30M2YuIHnSlbInSBsskVROSlTsruzetuEW4XUnMhdx1ve2qx6hzXBf0qSvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747841903; c=relaxed/simple;
	bh=W5aTam4Q42FUoBqK9W6aw8wPdv/3EknoCir2LnFh+S4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZM6MwXKADkwDfLQoPYfGFovAqUYyKVxqEHIRvEdiJQVLEVGivf4eqfcBExhCrefHlgb/EflC2gMc8Vf8ALVtugjAUF4cJ8w+ztItrLKCRkSef31SDwgE8FG39SJjQyqInVEOhbcI/NB7uRI+/8u9Bm97MmlIiX/mSlYK+3VqqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=UFU3dJX4; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="UFU3dJX4"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D21341039728C;
	Wed, 21 May 2025 17:38:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1747841892; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=UWu712jGURaHEqTrrTrDvaMKmMla3qPpJ//sSfnzJuo=;
	b=UFU3dJX4pBuQMJ4dPyUjZ+fqlOy4meA2hRj6lW8ca/rq4kzCTXMlfMFs0aq8dqgtetZb5k
	HW/d4cxoXiEIU94XyeMnw8FoboiRiSLeaDGj/aZXVF3rtvq5WjZ+NsNXpn3EzTM318B7hR
	MebF8SllnzjFea/fiBmV7oI98rqKsbZZAusEzotwSjrNHanLpcWWjkTjjS9L25LR2LQyaE
	VYFmTabuBltGIpeYCjK3x+6jNRpXImH10UhfWhMtbPZ+xQc/VFq7AsMFNV+/4P0/ESmj+J
	P6nGVhD3GTYOFEDHF4WoRnsPPe4VGI6I8YGIkljeKC+ckQW7J2EG+l3TZ1vIQA==
Date: Wed, 21 May 2025 17:38:04 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
Message-ID: <aC3zXMct+7b6zg5m@duo.ucw.cz>
References: <20250520125810.036375422@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V1AslMTQLRFYDzss"
Content-Disposition: inline
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--V1AslMTQLRFYDzss
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We have now released 6.12-based cip kernel, so testing this will get
higher priority.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--V1AslMTQLRFYDzss
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaC3zXAAKCRAw5/Bqldv6
8rPlAKCP3K1/JyBnsHNzAYsPIITBSS8alQCcCRD9ahgzkHHkVtDPY8m+wfVhcVo=
=3bm4
-----END PGP SIGNATURE-----

--V1AslMTQLRFYDzss--
