Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78BF229662
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020730; cv=none; b=mR6XAZlHsPtGk1joavH/chUmZENmHlEjmzlBTVUoSVUHinM7kdlK2tYZh7A882l0OksvNxJxvw6LKO3EKDFGoLtd6cN5mog5LRNzLzv4Tcoa+7Fi7BTaUkuir4mUCidbmTjRkBi5FI1OTGX+ZT6JJ9BrDeS88Yail34sW0gAeJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020730; c=relaxed/simple;
	bh=L29Y6Xg7+SW3iqFIHcfJPbpMAn2Hfnu4fzZzczf9ZM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TiqpKsU3EWqo95hLGqK3BRAHByzPDyrYkzNzweoP7XxubZvEh3K85R7qqvzMPJyWTYjOsfLR4pXrTcpfayYNs/rjBrhu5dn1vfGw2AL9yfpn1muacsNdvFmskWukkx1aHme5cIcZ4sBzvqzu1V935EzH84ejbVfJ34VrykHY1YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=By1oaMxr; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="By1oaMxr"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1F31810480282;
	Thu, 12 Dec 2024 17:25:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1734020724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UL8uTBDRf+pjE8QTwF3S//5BvjnWuC3aSiNNrfGvX4Y=;
	b=By1oaMxroGeFYwz6/ViZAQw5tsfbHwzYQKr5Ck1NCLWH7QEaPXHvEWijOjvSLFgdWqpayN
	4f36R1B5OpczsY/Ub2RBBNPI/XRgPGAdoX3E5yK7uJyv4IrDlcXG2Pxyi0c09ndItfmotY
	9Rebaz0ZB1i9dz6KgITb05hmlw61CnSBj7wp0dmgbqraOgDCFn7BbU3wSL1kXVnDRJ3Hzp
	D6fqg+gv0foclrLQM4e1yFwpKt3nVmbhF72jwN006/2NsTzjSJQHFLekIMwXKrX6Rd8SE5
	KWg0oIOcCT7I5tLhz6XkYpWnNpNOrLT0Kk7TCsHJBJmvrE1UWNbSWPvVV8Ve/w==
Date: Thu, 12 Dec 2024 17:25:18 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
Message-ID: <Z1sObgOdqlwd6Mk5@duo.ucw.cz>
References: <20241212144349.797589255@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+V1GPsq3OrjjUUg8"
Content-Disposition: inline
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--+V1GPsq3OrjjUUg8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

(openblock fails due to our targets being offline)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+V1GPsq3OrjjUUg8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ1sObgAKCRAw5/Bqldv6
8ipVAJ0VY80akJJnku7+ivZ7BJfM+au6/ACeO+QQ+mSKg6ZJnT/yn4dI3XEp9+o=
=z6Yt
-----END PGP SIGNATURE-----

--+V1GPsq3OrjjUUg8--
