Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167B328373
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 07:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756885435; cv=none; b=IxeywhF70i5zYK+y0UlhVPp5lXgzmjRSNybSKYGkyteVIJ/eRYhne8xtYcYhUE00zbSOQbC8qhOQKzidBi+3mYxGv0uk3U3xJLe69a0H9rBzdDX+8Sk4C9DFvFjDE/roOVrQRuvLWgI5sl7ICmWCV9JUJhBW52EHsxyKDS7+mtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756885435; c=relaxed/simple;
	bh=kZiyBw9trzWfrt8fd4znOp5+GvGcoeMBw5JHwezM5CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGAQZeNJlmxEits/9OLgbjTymQuDZSmHIq4C0fXFv72YnFYE139L05iaCJLrg+W4lUimM9F2WzST3Ucgmz8jxmx+jfTL22cr6nwG/CrDjBVlNVbccH4QB01It3uDx97OQ/gvTkhpHH9R2Vyogi0tJgIpNnWKYRJIp9ioDEnH2zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=aTb/8xP6; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="aTb/8xP6"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 418741038C103;
	Wed,  3 Sep 2025 09:43:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1756885429; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=LC7PJG+avZ4v567mVs68lQhNX+gk6zkUP7qNxcDvi0M=;
	b=aTb/8xP6+n71WZ1GyyTDtVOrEuh0n8omzlH0mcxAsey91l/jp3jP+O3zswDtcWjwIvdMZs
	IOepJHvZPRZGtUfA7Vb8CfTktDcZqHG6BG3QNa25TF66C8id3RGAIuaGxHFlozccfDExLO
	mAxkVfo7AdJWRFvmyMIYvDHpQX1LWQj2QZjoFGHhNeDO6iTVFC5fq4c5rYYWgNs1mc8nKO
	AjzaQBUUjBakaHaNUSLwoE0VD2CqhlxO14lNnGua7P43E31OcxYBmvV1pPuN3/3Pl20AlR
	YrGLSrrNsgRnFrDjV5LPoHWYzjB535Td560ivIal3dsco4nAH/2SjjUNNUaGrg==
Date: Wed, 3 Sep 2025 09:43:40 +0200
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
Subject: Re: [PATCH 6.12 00/95] 6.12.45-rc1 review
Message-ID: <aLfxrLL6Cmwcojkf@duo.ucw.cz>
References: <20250902131939.601201881@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kauf2XzKiiQwnKOa"
Content-Disposition: inline
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--kauf2XzKiiQwnKOa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.45 release.
> There are 95 patches in this series, all will be posted as a response
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

--kauf2XzKiiQwnKOa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaLfxrAAKCRAw5/Bqldv6
8u1pAKCRR3HXZrNHbbRHYI0zyeK0CiNS1gCfeKYQA74VTiutLEVf5wU8lWMVkdE=
=7lDl
-----END PGP SIGNATURE-----

--kauf2XzKiiQwnKOa--
