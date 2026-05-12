Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61553C1978
	for <patches@lists.linux.dev>; Tue, 12 May 2026 21:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778619836; cv=none; b=sc8NiWI7FeQEPhYHppdQcHeza/WPm/+QIE63/XD8QvlLtfqvmizDWspE5YGpq5AIdI3e7ebDNfUI4erJwDY4BSSNLXlq8sX43F2zdbb2E3DeO1maG42q/67BfS1bnYhEwrgMxZmXSvuVtcHVLiDQcfg1zU2m68xkumvrQWvDA+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778619836; c=relaxed/simple;
	bh=dWAKedENUjBFun1WIb7DHwMLiAhrJg8SChlbpM0VUJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NthpK9koAec3lS405CbhtQJzTpDL0snBFiizTmb0MnFPT+5vPg7OzwokBdTVhrnnBdhtNAlOHwUYjUafz9fUiLo2u8dX9qGTLBmPDo9EKAWWIrEd2A+kRTDDKzz5e6sC2amgxwfq7t3CybGb9t5qsHCaCGOy0gxO8xVFSSD32YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=e46UNZEk; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="e46UNZEk"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F340411589F;
	Tue, 12 May 2026 23:03:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1778619831;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=QHYwIj1w1BWmuOfKcol3ilAqiCSxXsIvIAcqkkXHFVA=;
	b=e46UNZEk+6/3PYQioSCd+LWuDHXk3FUmV6acKVvUgwHeSt5GKG1CvgtzCwa3ExHZ3b3aiJ
	nUPY9OsPBYSlidE+EyGsxKjGJcbQqCD3pG6AO3YvlTYKypE++shXh03dNtRAhELi6oLL8v
	TQ3Upr0IIdGlwPV7WdlLy8L7ya98N3IB0VAhiBDqtCxN70fmpQDyutpivqt3PDV5H9IpFm
	2aLDDLjfO1+aZ8X5uGUERzZWRvFwDg8M49aRz74wioQUSV1W8kNdGqj7D3HC365lo2eCG5
	Uc1lbA6kSSA323Mv+py0vALWzX5GEklDNu3tth82fOG8fwukyvgDBdrpd8dz5g==
Date: Tue, 12 May 2026 23:03:49 +0200
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
Subject: Re: [PATCH 6.18 000/270] 6.18.30-rc1 review
Message-ID: <agOVtULWiYpSUZfY@duo.ucw.cz>
References: <20260512173938.452574370@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QBe3oGtwdR1t5qzl"
Content-Disposition: inline
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--QBe3oGtwdR1t5qzl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.30 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--QBe3oGtwdR1t5qzl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCagOVtQAKCRAw5/Bqldv6
8pB/AKCRz1xzOUsyszyBnMTAK+al0ch2OgCfbRihEV5r3do0jP8o2ZvZytCvSWo=
=JjS7
-----END PGP SIGNATURE-----

--QBe3oGtwdR1t5qzl--
