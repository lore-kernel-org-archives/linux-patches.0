Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C95218596
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 07:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750319627; cv=none; b=c3qAz/bsCZ5qBbRVTiFa0PhiQMcZPbhpemHZVoA6Z9tEu4Go9EJ+5618ebhqGYzTBS99EylrA13IiDi+BJCwfUiP23Q9DgeSyhrkLment4nAFZGI0A8+GJfYPWx1eT9zeaoHm2ZqS4teoharUDbGu3RgdmrM7G0GtEkECciQ1r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750319627; c=relaxed/simple;
	bh=o4exH4E8+qqhEgqJNfi41hAjOFkspOgxrwQT8MJJ7ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NmwmtHp2cdhNPX2wmsi/tNsjt+ieIEzfe25Twl9LllKWMAmfjuwpdJtolv9UcV3q3XMkdDToeagJRyZwYNN1PgVhG8dSJ9SuXjKJc7q28Pdz51zMNr5mVb43XcmPU9xEhsDWMyZm1qBkOPRdIjvwjDV/fcBLxX0xpIg+3gaNdBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=iML+QxZQ; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="iML+QxZQ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 06D2210244BE6;
	Thu, 19 Jun 2025 09:53:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750319623; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=z2cL7tSpa9FWCMqEbSAlMhSH8wnWreVFxWb6XHnKWUI=;
	b=iML+QxZQEHrDuPW9TgVLWJL8YxDgR31LulD2riSFCe+y2M6BGtdgb/LtfjBauQ2AySyzLJ
	rYr5I6MBwtAX8IDxzB2cSazMb00LaQaOvPhGcvdf8sbXeOA6fFyBi3n1y4bMjg5VtXgeSM
	4jVD7C+kybNB2WB8emo+xeuSQibRUtv7+3UULHoUGleIx/CbhPjYbzn9iDTFk0AQphmxN7
	n+uNAsaySc6rYOl8tdMsj9HJ8hpGaxpZUiCQfP21yCeiehQal4oh3fxxK0/TS7Pt2dYGGL
	wx0ySIrzRwkAwlliYFcivOOK9VZQYN16RlDwuG7V1dSRU52lw+XzYeoVuviggg==
Date: Thu, 19 Jun 2025 09:53:32 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
Message-ID: <aFPB/MIgbcZGzw6R@duo.ucw.cz>
References: <20250617152338.212798615@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jk/3YVTjEdKtuW4i"
Content-Disposition: inline
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Jk/3YVTjEdKtuW4i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Jk/3YVTjEdKtuW4i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFPB/AAKCRAw5/Bqldv6
8nnNAJ4hooTeyCok6rsXhIgwBxYX6UiLfwCfWTGGMuN+JxC8hRjyyKExI1C40rs=
=SDrq
-----END PGP SIGNATURE-----

--Jk/3YVTjEdKtuW4i--
