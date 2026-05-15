Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B5030E82D
	for <patches@lists.linux.dev>; Fri, 15 May 2026 22:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883123; cv=none; b=CpU+5Knav9GgcoTgW2z/azNMoSkKuoq9GdMiCgd+7Mm0cxqX3ix/46nOB/THLNrEgP7uw/HzoBdmGer7f4ogxHabW05kgYV24VnIUwiJSQHnXcL0Dgcen/B/dyPvL1y5JFJIdvQkNHFm/oXCGYEoCrUHt93sCLFtdR6Cn9ABCP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883123; c=relaxed/simple;
	bh=+D3NT+ssstvFYi8I8biHhJZ7DId6Vf3fuWRz56CUhyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=umzwSqkLDkFZ07L4o+XXEQOLVJZ9TsLLB74TSn6nyGyorFfwUGaa0/M5OsJKFgGvnIBeflCoQ/hqL757CIHgJwEm5+rCu9iF6/zamoV9Y05pHOp4zujpvmPyZTv+VrM0KC2kOCO93y9MzOyYtwPrPv0QtpvSpdOn2LoPTSGifzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=HTFf4GAL; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="HTFf4GAL"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4B70A10EC85;
	Sat, 16 May 2026 00:11:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1778883111;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Soi4nFoXzU7w+bmtWmeh7chVgpP8wR3u8N1TdRBnDr0=;
	b=HTFf4GALBragU+uKHPs+OcILENJuctYaWeiVv9s6MDDwkPnGVhL5WPvOBuqw6TA+S6b18c
	p6YUFqC6vaHq3PDh3MzYqCwOGHJdkd4AybJ8TK/ro9lpMRRcm/KhdpONYHWI2miRxg3s/i
	Yksv8w5LixBPKQlafhC/WFJD0wr7z/eFFLcPFiJ15joqApC1Y1gT+gYdpRQ3FKsmgId4Co
	0KoJe3k+g3WTDMcSNZLGNgF5bUW+UZpdc0bDmC1MNXNTwKefwT7CI2gl/uMMIPqsdvOtSP
	bmIQqF5rEFz52pKRtGh3A9uIV9XYNE+JBrAtGz+6ej1RkledpImDJJnZ6cT1GA==
Date: Sat, 16 May 2026 00:11:44 +0200
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
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
Message-ID: <ageaIPk0kDdtSoVe@duo.ucw.cz>
References: <20260515154658.538039039@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rGZw6hQE/MGqGHAN"
Content-Disposition: inline
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--rGZw6hQE/MGqGHAN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.0.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--rGZw6hQE/MGqGHAN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCageaIAAKCRAw5/Bqldv6
8tcDAKC855Sg4S46ykZjV82mY0HPY2GPgwCgj9LZua9hgQt3kMueBWjYKEHTnus=
=VQfV
-----END PGP SIGNATURE-----

--rGZw6hQE/MGqGHAN--
