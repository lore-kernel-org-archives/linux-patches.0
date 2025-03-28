Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3C31A5BAE
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 10:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743157102; cv=none; b=YplA5Imrwqi2EaVysJoFLwGi0DVRMkDkIdozAaZjcEbPoYVh8Mz3dz7CR6w1bn+3+2VQ/3alXg7eWfnJ/TY/lciF2lKgSSXX/C8FYEA01RQIN4XFN9A7RvWtqkU2rK/eEmxnh4fdRwdUo8QC3Z8QyKYBkIUbvaabEIS0V9wTuUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743157102; c=relaxed/simple;
	bh=LuZQ/VXIC4NAiPg9MT1mlCX4GWeC1O18VNnybzVvySc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GdOrV0BO01iFBf2BsvtmeCy2aMi3dTs1O/iaqlsh/ks/jm+VtwM0Fe5As921yi3TGraXfbO3k+sCDRSU247rjsguJXNmvlvN4ORQkRMMn3Y6ShFSG+sp0bWi6dXGD21Slt2Qgf9/GHAze347yc9YaLaILlErpMundNmg2oC2ACs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Z0r5qVOR; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Z0r5qVOR"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3F0421023F59A;
	Fri, 28 Mar 2025 11:18:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1743157092; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=NmL+230093prb2NKvGUaTrcx0iU/raazJ57E3zSIxCg=;
	b=Z0r5qVOR6BaTO4LUrWVjCwI/84iGjwoYWbx2c4BAKGSdXTzPTMWgoOOKjv8Mz4nC/gd79F
	EQb7+VE7fnFQCIWEeO4Yy/CbJbC6s6BBMB8Gxqn+ZsL1VCllXzSUcSyUCaXVIqll4s1fvv
	RXJqsLud4JnN6Oop/rUC7yr4gDhXgTePAa7B7fSKCQZkOnzsBDu6zyXK9WGBEDDIr0294T
	CiyhXsmLocJ4kCD/v4cKAZ8oLCPNABIsIG7ooJ3gMG8DibJr7T9ixzNVJ1P3vyh5Mi57/L
	8dWKZXqXu3sGNHoRLy0PHxsj+AB2wXyB5acZQ22t2z9+GksCm7uoaf0fbEGzuw==
Date: Fri, 28 Mar 2025 11:18:04 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc3 review
Message-ID: <Z+Z3XMF2FPpJF9kZ@duo.ucw.cz>
References: <20250328074420.301061796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8kqYFcOiNCx97xrq"
Content-Disposition: inline
In-Reply-To: <20250328074420.301061796@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--8kqYFcOiNCx97xrq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.132 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8kqYFcOiNCx97xrq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ+Z3XAAKCRAw5/Bqldv6
8rjDAKCoJ9GVccacCduZB0htrl9iuNI7PgCeLRVgi6d8QkEIHG+MxnBhRShdjIE=
=Vcz+
-----END PGP SIGNATURE-----

--8kqYFcOiNCx97xrq--
