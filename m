Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A82285C9E
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 18:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750877478; cv=none; b=jGt/YcZTXeaO5lhq2SOR2psPUPWEjUrgtp/y3jMPgG/MEWB1Fa8fNGWgV0EXdXQAHiKNLsTR1Ro2fP/YfM6Ozb6ZuaRbeC1PXFDPD/93BdOB7ZQhEhIkhD7eJNmlgH3JhHV+u9tLZv28ZL5CXWL14I8J1Vt/9FMKt7Hu6erP8l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750877478; c=relaxed/simple;
	bh=GOwMqggfWGFUJbVRAI2R5MYzIJqxWUXGv8uKyDDss6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCq4OijfII1RkOBZIRLPpi1ognNbFJks6wSgpCsxQbUG6P4mBTCx/zxYhhfg7U97WCvd6a7434yBLEj3sULYplJghw/1q6eYMIXiwcqZlNSx9F6fa0kXSfTCrVoUqtctiW+FrLY7S4nv8OlhRKOHkYZbjpOUvO1ykDETf/7x8lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=bwHWBHGe; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="bwHWBHGe"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2A9A51039BD02;
	Wed, 25 Jun 2025 20:51:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750877474; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=21Z0yMVEXCgCsmxoQSwB3wsw+cYQrZlQ2JyZVd3GU/E=;
	b=bwHWBHGeHNyJchkmK2xaFAO5P9470MnlLM8YkckhBfDWHgs1p2VRNh+w5dhMtlwLZyPOOm
	710O91ZVilg5Z+ZxyQg1teMPiPLopR2lJrn1B+I6+kmqwD7g/d7ZYf4dQDBGMyxgkMZS9e
	B65AOdOr/ogyBgypqwsOXfRvXm8FLBnsZLhVqislG2RY4UBvN9UuI0GVf1o0cN6KQS56Ye
	lVSGX8UfRAT3J+oHiccN17U8P6lroR8dO39Pq3WpN34XGm5hjKlNkKTkXpedq2Hkd0VVVX
	6+bUikzwshCzGeVyINAxrEWN5BfdvVz5X310490rCuMc7xwQpiI7HbHPVDlGNQ==
Date: Wed, 25 Jun 2025 20:51:08 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/507] 6.1.142-rc2 review
Message-ID: <aFxFHJqr4MC77gHr@duo.ucw.cz>
References: <20250624123036.124991422@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e+WKpGqP9A0PBaPG"
Content-Disposition: inline
In-Reply-To: <20250624123036.124991422@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--e+WKpGqP9A0PBaPG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.142 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--e+WKpGqP9A0PBaPG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFxFHAAKCRAw5/Bqldv6
8ozaAJ4vSo8FNlWSETNHgrvurNxZbCKunACeKzmRfHDTWzBM48XQJm97phY59pQ=
=7Cyj
-----END PGP SIGNATURE-----

--e+WKpGqP9A0PBaPG--
