Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792429056;
	b=NLwe9Sq4jsbAYyRdnULZEPnD+PifPuZ/x4lU9iSnFzyh5CtqHlvgXM8c2lRZtqijVm3i
	 S4sp3zBghoR4/MSEuulA2NYVOlG+HY/XBf+afHjlDsZlbg8cKEVCGLG/zskK4ObAltmWS
	 kTqzdgvrAcHoqYe3bVO5mG6Bk0FNhcyktM2n+pxA7rFy3q0DTStIlzcwbz11DX0r040u7
	 FvCRAlwd7exBDJ5qAw1CnTAt4CWJFQr41oMBfMcIvZvhDTGIqjuub9SeHanhiOqn7OyRh
	 IXEJYdmQT69272/gBPnxRmM85mtmuAioFmtAdVrPZ0ilJtZys24Jml5DU7BUKiKK20w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792429056;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=n07V4RXaD9gcY6BbcIzGb3Xl/LJA0vZ/F6/698BCjZQ=;
	b=CtUzSguEVOFfFnXjmpkZdr+d9LTJGizzE6zVdE+f+vcs53vCp6OM4IXIi8UmgLp+OvEm
	 nktP6E6msRG0ZBvpzc1V1w41f8/Z8tqMGx4W42sS7D0prgPYmeoLeaeRKOviafvQPpHZO
	 7GmNDcQpyHxFWZmeDdXuvDxXCSVURNghlic/nmZUZeYbBm/wvaNCvkdQ+1qyKmKLdsKeD
	 bxVhhP81jONCVfw6seaQ4KEasAxRtdtFZcLhS0ecztC7qP2NIv6i5eH/BBPHj3xjil6t3
	 3sc1R6aTJ/PfMyU1G9/h1byep5ehmOhsB+EkcQ9lQarwlcuN5PWMTqGbYjaBvIbvM8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=YrFLmgOm;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869B2606A326
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 869B2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=YrFLmgOm
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C5B0D1070E0;
	Mon, 19 Oct 2026 18:57:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1792429048;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=n07V4RXaD9gcY6BbcIzGb3Xl/LJA0vZ/F6/698BCjZQ=;
	b=YrFLmgOm2ashYSnjXCLyDjf/18uwSRIMcc5SXYj6K5gNKy4SqRBvBcuz+hUwdqtRudRDCn
	NmGtYQqjASCPWVi4MEK+zx+YEyyu6aXiGrZ0ngfI8AueTnBffM2qAY8p+LAjXlp1G/6bBL
	MldrQdam6/0e14ARRKrNo4cLn2TVoUQM6QKfvHJTrJYO+FlQljvtkOkB7gaWDlSkUqJTzy
	V3biUCdTu2nHm31E1vWvnzn+W+on0rkbZiMkUgWpIQP010JTIpRhVj305x0qYzYdfztgy8
	6L7mxBlqjjFA8lwWEIB5WR51/RwZ2Skl+mpLgNjoJ+2tS05xO3yM7VfXHUS5sA==
Date: Mon, 19 Oct 2026 18:57:26 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
Message-ID: <atZL9nzsPwjnnflN@duo.ucw.cz>
References: <20261017155104.830766652@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6wHddwa2G7Jey172"
Content-Disposition: inline
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--6wHddwa2G7Jey172
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--6wHddwa2G7Jey172
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCatZL9gAKCRAw5/Bqldv6
8mNMAJ4i+dWOlgEYwCzmeKcW3ce1eF90LACeNZAvH1naKc2QbbcRJHFoFK4RStk=
=kFEo
-----END PGP SIGNATURE-----

--6wHddwa2G7Jey172--
