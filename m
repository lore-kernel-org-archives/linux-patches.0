Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98DD4E9C17
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 20:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789675607; cv=none; b=rQRmaUKkwIfquPdvBbwy62rx0tKP1dHFtymXOV8Irp+R9HlKIyuShGRe084UHNQ4q4C1EF1INjWvoQ2MZ21Az+qFTF2BozS2FtxWjueuDKkqYt46YP2naxUmWKkt34jF9WEiyPpNfbRcXvZG2qVE4PTeNev8S5AHeF/aj3h1xiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789675607; c=relaxed/simple;
	bh=cMQ0OP8bNQlQvbq/DvZK0twSGp3MkIQB3Ui9Dqk4Ubg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpnIrIBuUUpjLJp+Oa+YtUAy09k2Bq5LvBRSD7GOvTZAias7pVuApV4FPrp4QAavxH2Ot6Vu5qvPa2G5xwXOI52k4AtA3m8YTP4sppqTIcXlU6PRHBCjIGbRUskzcWKcurWRgFjDJcIomLERbS5y9RtMEY0CZMYiCeABnVSgXdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=I73AnYRg; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="I73AnYRg"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9BE73104392;
	Thu, 17 Sep 2026 22:06:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1789675599;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Jk7CRDRYhqaWQIorgmt53Z1vef2DzmvCTID6Zli1PwM=;
	b=I73AnYRgzeW2/iXoD7JyqNnhGe4uM/M0m1EKAIymLLvhvyja3RlrzPOvr7wsf39NS3kT9r
	PdmtC5r8IkiWg1I9JGI8ILHTPxuZT7ndQPl/NGajgAmDvqsz1GmxD88OtV9mspZjaE3W+q
	y7Ik2IZBfWqKL7LmykxNTRcJ8BM50cLdGTZvo4DFxESZSRN6ZMY8NhR1yi/HwDP7GRXRis
	tXAz0umZmJLQLkEb75tn0kCAtPBLT+3YsamWpNaBFrqfAeU+0Rz0pSEvpc36zjNDyD/r6s
	rxrJqY1MrlFU73daHWzIwRl3+3G0ry1efwnXsf/J9UxCfrr8l/YdXGpMBAzTGw==
Date: Thu, 17 Sep 2026 22:06:37 +0200
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
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
Message-ID: <aqxITZsEiuplaSj9@duo.ucw.cz>
References: <20260917151350.597953846@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IAuoAgIQ4kbi0dbT"
Content-Disposition: inline
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--IAuoAgIQ4kbi0dbT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.2.7 release.
> There are 733 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.2.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--IAuoAgIQ4kbi0dbT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaqxITQAKCRAw5/Bqldv6
8vSJAJ9DfjpZIU45R2ZNL53wB/VHJ8nCsACfcbfkHpbXicAMOdKm7cUpMtIrad8=
=019t
-----END PGP SIGNATURE-----

--IAuoAgIQ4kbi0dbT--
