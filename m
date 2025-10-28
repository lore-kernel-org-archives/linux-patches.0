Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBAA27144A
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761639295; cv=none; b=Le3+C8c/96QNAJC4JVVO1JU2e9bMn+fXe+3OIz3PatOGteqIY2/l8zajKZTw7LaaCDjcl1pNrWs5HW8jIClEHeacOz2IDHR5Y5/kVEN4I5NNh5TRKI7sUEqDajWk+0x9xb36GsLU/sRe1hN4Rkq7OYf/M1BqqPrz19N2+xS4k4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761639295; c=relaxed/simple;
	bh=7fmqbVVoMRKd5rRb/hEQUoiCjHPfJ5btS65o8VIO+qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cfcsbEUHKIzWyJXF/1ckNi7T5ptnIW0x3yAxh1eZnpmDY060z06S6Dr0G7ZW47UJ/2nGcd+7hwMVxXOyW2xAZt6Iut1RiP4Cj/117jZCaRg4nwfHrfc58gOdyfSWXZVHRrXlvprXRZFwGA4JMx8PssJBbbfrBCndxQVbi5hAof4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=CNhQAqwA; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="CNhQAqwA"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B6D7E1038C10B;
	Tue, 28 Oct 2025 09:14:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1761639291; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=9J6GPm0KB+YmbPNCLYLirD9SAtVysCPH8yqWFXkk3qs=;
	b=CNhQAqwADoG00qcUlWsKZqMPb4Z8b0UWqQsjp6ogHOWx4O8cUeGrzGQco+ITYPpZ/ArrBz
	0h7caImJmOOFscLgpXTK9tctDRwmu6nyq0fDxj4wSYKFTItC0JRfk/j4UY7d4LYAmHbOoE
	/G/tBERG/Ru9LfX+CH/ZtZoSEZzY0Cs50CnjnResMkDwQG7CSWd2/wvaa39+hzc6ycCPrU
	RqcQUTzn1fnBz2RSMI8tplXFIRlwmIzHJjCSFAMiV7iGsrjbc6pfpoDMgrzABPP+iSKdvI
	SxkOyM2iD42nWRaVVT1EzF+EnHVs8+RdsK5Ui2YtnY4SRWp8tK5nPxp2kbUXHA==
Date: Tue, 28 Oct 2025 09:14:46 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.4 000/224] 5.4.301-rc1 review
Message-ID: <aQB7dvaiRIMsqhWS@duo.ucw.cz>
References: <20251027183508.963233542@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="re0tYzvWO2vvUyBN"
Content-Disposition: inline
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--re0tYzvWO2vvUyBN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> This is the start of the stable review cycle for the 5.4.301 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

6.6, 5.4 pass our testing, so risc-v compilation problem seems to be
5.10 and 5.15 only.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--re0tYzvWO2vvUyBN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaQB7dgAKCRAw5/Bqldv6
8pPYAJ0W7deXs5Gc72m/qcEdKoVsIQx52QCfaQBbWNgq6cx+YukY19tPYyIko2Y=
=q4FR
-----END PGP SIGNATURE-----

--re0tYzvWO2vvUyBN--
