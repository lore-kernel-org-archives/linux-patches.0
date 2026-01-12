Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F7329ACC5
	for <patches@lists.linux.dev>; Mon, 12 Jan 2026 10:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768213537; cv=none; b=V0yaLHAzRf1tskaot4gAY6t5tCZIeVsTbNh6v4nvG9GLspaVwYeoFmNEAEqUJ6FgrGW4BjmJEX5rJ+C7IeBaDZwlW+n8kg2qcGSeN4R7uf+dWO0G8JG3SeMoYknB4yrT8+vGAAUtw/OLhOspS71GAZiDt3/zmR4yNyQ5fdSo59M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768213537; c=relaxed/simple;
	bh=yG2kuOLN0BnF2X0bgfpPE+fNgbO0xjjbuTJ+NNOkhN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4X1Z+nAYhynX2Jfd1kLPlDwpC31K7XR1MRFW6Muc22e2RLbqLkMpGxE09s5DFBYYgnRpzgcehoA+dAVRi4elAPUcj4FpQKb67AZjs1MolmHzDKfgi783Qsi8GZ9i4bzgtvf3y9mpPli303G63GwUNxED8nDXLX0zQuCyO1Vxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=AIEHmWRn; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="AIEHmWRn"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9B54610978B;
	Mon, 12 Jan 2026 11:25:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1768213532;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=VJhALLBQG4FF5ORE+5QqD/88VM2vJuZBQAeJMOENRNM=;
	b=AIEHmWRnmcGNhNiH+w8qssDzL5Hwj3bBTCsUaFv50spK+VZ67ZYwV1GWuXK2ygCLxnr+4T
	fGWIi5Gd2cKUB6TkZXPHj5BzEMmd4tfupFWy3mZ6ai5xauHzMSQyIOKqfYWpmiUEAzSfRC
	FXz/C9um0eFxU/qfCjRTnAWLWKz4exoNYxf5WXKeUYKYUGFYy4/ua2HCjNFI+S2wbAZ/V7
	VAcwNPcwfsq7wMlI4JkdmIcg5KZTZTcY5crcNcnLtdtAXfiMlOTaqWyENHZaMfot/PgDUB
	Dr1UscH81hdBRbO9+YqQeREQhy1p43AWileJ+fFhOE7TbKm+f1fzks8fQaQ8kA==
Date: Mon, 12 Jan 2026 11:25:29 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
Message-ID: <aWTMGd1Z6y7M3pAK@duo.ucw.cz>
References: <20260109111951.415522519@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FFHVls0oKSx/BC9o"
Content-Disposition: inline
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--FFHVls0oKSx/BC9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel
--=20
In cooperation with Nabla.

--FFHVls0oKSx/BC9o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaWTMGQAKCRAw5/Bqldv6
8ggvAKC6OcbU7d/qV+Q5enMZAQ5Ium1KLwCcD3DCI+zGtNWL3dLBZJreShmTbJw=
=UNpK
-----END PGP SIGNATURE-----

--FFHVls0oKSx/BC9o--
