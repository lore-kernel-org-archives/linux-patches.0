Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E628B337117
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771405973; cv=none; b=ZuSJLRgzKoxKDlNAhWkzFot6J1sCvOuBXrNXf9LbxFEzhRbpxa+YTfy+amRSJk+htHuhVT/MAzyo3dtg0c3xNCAVKRbOPxUovR6frizGJvQc9qlZzKtWamOHUBErilIIZK7jqESZyw2wDGDvJ9/U5c9rNI5V/sGpFtOpebVgh94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771405973; c=relaxed/simple;
	bh=mPA19gt+Tf+N5oJoJi14kymt4rbzUoIbWxj6faSWRFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3etA3d8+31uRvt3eCFEXvDi6x6LHior17ImEVH20IvcxasmvTkNXURR4YMUzPJORCJuI+XZhxJt0Yk4Q+5Fw3oOfd2cc9+NOUakTIUoaegmed1dTVi3cj/PQX9lC+kphJxoaO2sPu/mRf5lw46mT7QjTTrWBy1/lVOsZEERYlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ZisCEtwk; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ZisCEtwk"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 630B310F3EF;
	Wed, 18 Feb 2026 10:12:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1771405968;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=zT7Hc5Ym74NKHqaOAuhnSmjH+81T0a+fV3PQz6W+PJo=;
	b=ZisCEtwkZ190MjAMcDy+khG1yFukEQbRV8nGq1lAbHWD4z3udphDj0EwyIwYDA9dDaT5cl
	H/EVFPcInjBPtU0ekUq8Hn553tn0nEUUBvgRm8twlAcHs/lqILe/6DFJbHZnFJGfCUAHHQ
	YQXPhFjeo5u02oJEDDBjVC2EABcXE1aS5AsuWPjVfPv9QFYB7d4C26nnsMc44TGsHNPEOJ
	1ipsRhjj5dV7MVU7IGMCk2uwUzSlAbYiZBDkZVCwSRH04ZcqMKDdrObt58DmsfRiOLBTgR
	IKmYpAjzSrEMXHOHvbog+A01jZ3qGG7m/2xxKYUR+NxuR2AyHV6zlJ4Q7x1Jxg==
Date: Wed, 18 Feb 2026 10:12:45 +0100
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
Subject: Re: [PATCH 5.10 00/24] 5.10.251-rc1 review
Message-ID: <aZWCjXUR3iTvoZjB@duo.ucw.cz>
References: <20260217200000.708219618@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1wSgS//cch1mM78k"
Content-Disposition: inline
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1wSgS//cch1mM78k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.251 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel
--=20
In cooperation with Nabla.

--1wSgS//cch1mM78k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaZWCjQAKCRAw5/Bqldv6
8iGNAKCDfB2GRjOocFM4v9v0uclKzlMS5wCcCg9QDzkUnRdIClEvSUT05IyMpTo=
=xwHV
-----END PGP SIGNATURE-----

--1wSgS//cch1mM78k--
