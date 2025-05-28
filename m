Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C003242D98
	for <patches@lists.linux.dev>; Wed, 28 May 2025 06:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748415020; cv=none; b=rWxN9tWiQyHToXU964Rt082Mf0AldFgF76L9oWCNy3LsL4zjot1AGr0OFU25a9f0B9AFp930HfKcpLgUDvAp+l7lkCIL58NUxv15dHUG47SxZ2qih4N8SkNP+LE3lP6bpf7wixehzHo7CFG7Ppau3/+rCAIFNEmJZuYJ557Inkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748415020; c=relaxed/simple;
	bh=1gdDLxbDe2Ht/h7iA3Hx1dveQII8jJ9qcqr0cmha0Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfjVXquEvhbvQ0aTD5FmNwPyqEoJC8Mjnd+Og5xivvZW7jMoXdMuF1L5avRWsMFTgjxpqO3WiOmTLuZV06NUZR4nxAzRBNQgDjVWkr7M3HtMPWDlTy/7SF0ehQKgVJnLmvwiaf31umoXMSQpK68SIyiFqiHJh+kJDgTeeNaKRU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=YVrC4w25; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="YVrC4w25"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C64C21039728C;
	Wed, 28 May 2025 08:50:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748415015; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=9+/FxJGf/fg6nDfJfXIkd4wxGzuaejuHfG9+LqI/sYk=;
	b=YVrC4w25G9rslNhMzj7Vt7KMYXQk0Nu4WeLwl9cUbFPR8Z4ZAhpa0TwhBfjMwG3jPclt3T
	mlXre/KSPspvV2qDbACjlrPXBTSaGHVlFWPiCom6c4jDVVgKix03l+QFQrsuRm99/yOdHH
	K+yxNMZ1Gj8H7l594V3KNvjRt5sRAx3yglYWBBvQtC13AlY7/ozdFwwfP6lsDXzWRV5lx5
	EetuxWhp1kfUabmJ+46nl/3F/aB1pfPyavOUdv0d740rRdTGsEdIemXlsAZboUS83godtu
	Ug+2e7uSSksYUZCz78UXgxWxmrDOHiL7zrC29mr0Os1MM35+G6NHL7rT2+mK8A==
Date: Wed, 28 May 2025 08:50:07 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
Message-ID: <aDayH15C6g9rjght@duo.ucw.cz>
References: <20250527162513.035720581@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XjXPnOCKr9jfoKGD"
Content-Disposition: inline
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--XjXPnOCKr9jfoKGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.14.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XjXPnOCKr9jfoKGD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDayHwAKCRAw5/Bqldv6
8k70AJ4vrjPHhwAnSWi4ynStElOuD7WK5wCgteCjXcxbnPOI2ENeIxp0k90VE2o=
=94kv
-----END PGP SIGNATURE-----

--XjXPnOCKr9jfoKGD--
