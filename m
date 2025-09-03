Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AE82D97BE
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 07:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756885491; cv=none; b=YVXucmXrSVpBXq55ZG4KSZMdLybbJdrpwFTHR75zKnxu53n81NJ1ya6yQBOlNN9gtpbqd5WndIGxmTVbXiQ4Xyxy9Nk9IbsRcyUAzRUft0hexkEx1DPOB81UylVEYoVZZDsJgCdk99GfD+x/ETdsfW04p9VjeHla/F8NYIFG6rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756885491; c=relaxed/simple;
	bh=hNNsj37HVnCHpgbSlN6yv4eI1AEtobfdUnxREKt1cb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjFgs7N1GFYG7AgPyOIsF8YTzXBnMZsLSnE1plblxyFC5ktrYHt7PyqK2T6zZRHJ91TU7PNLItoNeIZzivXTHSuv8Thfbz9W/iqEDS8DskNRUPmETuZM6qIFbRA/l3dx33fWkVzjHoD7QewHXoYWfb7iJkrBWYqi3KIGGcp6zn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=CHJs08+A; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="CHJs08+A"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A83FC1038C103;
	Wed,  3 Sep 2025 09:44:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1756885487; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=SWDYnH+0lZxnHtZBovEsrVgjx+57uRz4UYqUaq4WDxE=;
	b=CHJs08+A1BXIxV8lPs+nOTcT3QbynW8QFz/0QryCXcWIUWYM2mHBRZx2qmhDprWBG/kpXd
	fmJWG8ERCYIcrr2EKF9wPkr8PZeY+XT1tX6vuYpb99Mav5829QymX8bARLPYGUShCNeqsp
	J8zNSkDBIsNw73OEShVgm+y1JrqPDnuss9kdUJGMs7BAjIroCeVk5Bdi7NPYRxPg/ZE2L1
	DeeoLTf6KWKwzPik0Gp6qcAN0kx4NTY3a1Rx41JG9gZYrWSBWutrzwgKQGMxI07WK6HLMX
	nN+BJUjRsOGOOu5ss+ELpC1udBOSGYV2i3+gRFjEufIKSylM0eAqrZW3K8dgdw==
Date: Wed, 3 Sep 2025 09:44:41 +0200
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
Subject: Re: [PATCH 6.1 00/50] 6.1.150-rc1 review
Message-ID: <aLfx6XBRILdjarFi@duo.ucw.cz>
References: <20250902131930.509077918@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NNxvPmAXCVuScpcF"
Content-Disposition: inline
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--NNxvPmAXCVuScpcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.150 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NNxvPmAXCVuScpcF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaLfx6QAKCRAw5/Bqldv6
8v5RAKC0c27Zgnc6USqJ3ULfVy1Qfx6rvQCgtvhqx730MULMcpAxAO0VVCnMNWw=
=py/w
-----END PGP SIGNATURE-----

--NNxvPmAXCVuScpcF--
