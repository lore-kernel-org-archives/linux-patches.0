Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE31327BF8
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 22:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765923570; cv=none; b=hbKQSmuELLQi/CPWMLyr1a9Odic8mdvJK3xpUnbTWFnFQ4pI/8uZiQWZKPsBr91XN2pFjCKlqkkyjiWx6fBpxVX6uMDxQPKes9337XkmlCVfWEFiD8WpOA8ZSKiF87UFZOFSAPw1+tkARQbGkajjJWKtCw46neZR7kfKpc7+TS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765923570; c=relaxed/simple;
	bh=onE6oEYwRp1XIDNnKwrmZ3KBDvY66p9IfbO7ZaxAa/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyYyM+m3BmjXVOgX+y4u7bO7mJC1gCaZeQK/fNoEk7LjBHOK2SIW4SFQvkiJ2INd4VapCaUC2dsFgwrVzhB0KUIVkKfPb4HBfiZWIaOtqEvp2WkAFUe0dIbBambEwTZ5jondwtWjUUjTRTimjtdEomM6EiNDHozJVpoMXIRjcJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=CTVztaVS; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="CTVztaVS"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1C8671007D74A;
	Tue, 16 Dec 2025 23:19:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1765923555; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=mcHyZCRFbtk6J5Yz1SQnm6tsrl3EcpVS61mGlWerz10=;
	b=CTVztaVSvusmDmU3n6UI0bNwUHii/jRpnuUv+yk7zBEd8v5OGxWhopofe/E5YYwl9cZ6yT
	cFwjnpcL/4Bcyfo/vGzvM64uaaV8G+jkPeZtPSBJQlOCdUuAa9H/vl4BMFY6EnjNKEuIOE
	2z9zUOjPXrbXEtKXYqPUHay9pfh4nzZnLFmFpY7YxUh/yO49jIRrlS0BXQ3JjNguHET2E4
	F6zg/1mwRLZRiNHDdAzr1h0YWOKsXKrPPtFVe+f6Ys0AxAA97SS+PYPpHGP9Ilm9MJ9mOi
	TL+1FuMuYCHa/Fss2TpK/lspu1sZkrgMmSMe/PxXzD0O2rjuTpYrsHyJ7YAYIA==
Date: Tue, 16 Dec 2025 23:19:09 +0100
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
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
Message-ID: <aUHa3VJic7o42AeS@duo.ucw.cz>
References: <20251216111320.896758933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKbLbaIJ2eJNk4Hg"
Content-Disposition: inline
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--gKbLbaIJ2eJNk4Hg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--gKbLbaIJ2eJNk4Hg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaUHa3QAKCRAw5/Bqldv6
8nDHAKCAetxWN6ZVAJIT1FvxSI4kBzOb+gCeO4GOEwCi701ydp0+zY+7jreeLb0=
=fo9r
-----END PGP SIGNATURE-----

--gKbLbaIJ2eJNk4Hg--
