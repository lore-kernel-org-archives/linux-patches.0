Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956964483A8
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786981970; cv=none; b=sNYTDLVBg7vfQfv+81KLuu2EPqCGiuxNkygksK/AL0mLjNAf2Db49RE7vD+z1AfkBq3ZDkydBrvfzH7sI+6N3OmF7/6PE8wQa2IT8pRSLCGGsHDZSm+yvTcikbe5ZVPoly1StUoUnhvXsh2q/3T36O09QREh0PvblXmPexgSwlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786981970; c=relaxed/simple;
	bh=6XbzM7U2yhfRCYJq+XhwXzE9Jl2Ou01wwoUd4ztTUgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LcQnIa/Qrm6KpqXQs5OpwVktmgkKjIPSnUGzAQUGuG6P4UEtxI0WvM3BQH46mB4oDov5Wfk5z8zMB38X1C1teVfqMI7yW+2NOZci8caA27tcF5DxV+UsTEBEtz9OcTQSNaiy1Cb7ITXJPKidj6lXsi/0t3zdLJhIi0whg5frZvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=NDBU9SVf; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="NDBU9SVf"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DF49911C29D;
	Mon, 17 Aug 2026 17:52:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786981961;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=fuObdAp1WKHkf0IoE/O3exx9E2qzD/4ccL/aHVrS10k=;
	b=NDBU9SVfu3X8DYXdFM+8ymYV45aMMxq8d2oEC6Ne0HTjeD+d9xxmun3QopspUseCgnc8Uz
	p0fLoQt43cT8d/P92aw2hOBjBS1Dnk5BYtsTA6aK252ekpiWDd+qgrQLGW+VdMMI40hnig
	qU05p99W25nZKyR4Ou5oWyHlq1p18LNS5Lma9XkzNZR+vN1unl//KnD0ACQwIbJ15z9QEy
	WJiKiH6JQKBfY4vs0nsl+BFe1n66kh8Mdn1673F7YSv7nZ22aQn8+7R4f1IuJas/JVDGgj
	wROLAXDkBv+hywU2P5j0WWzRXgnXDqFZ0RSS8yIWQZDND0dDrD9EIIjuuq+ktw==
Date: Mon, 17 Aug 2026 17:52:35 +0200
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
Subject: Re: [PATCH 5.10 000/389] 5.10.265-rc1 review
Message-ID: <aoMuQ8CEWcHXsGVD@duo.ucw.cz>
References: <20260817132538.796021292@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NgXJAiGw43SAS0zO"
Content-Disposition: inline
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--NgXJAiGw43SAS0zO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.265 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'll likely have comments about some of the patches in near future.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--NgXJAiGw43SAS0zO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaoMuQwAKCRAw5/Bqldv6
8hJtAJ905HypLxu30sdvxzOn36b1NzzkfQCfTN0XbauhtKbchhnyvsyyt1f/3Uw=
=m86T
-----END PGP SIGNATURE-----

--NgXJAiGw43SAS0zO--
