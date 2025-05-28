Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A62248F72
	for <patches@lists.linux.dev>; Wed, 28 May 2025 06:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748414221; cv=none; b=BCwgucbBi8y5TEQtusyQpVlL0zKoQtAOryuARzrw3vHDHV/YbXE2uXxgxSD57kAjnb8Te9hNtz3luuS1OvHkEwf9yvLGg3nllrffQDEXEJXGbRSJ8oRyVZ0Gg751A8P1AtM6EyqQY4BLfcVBqWZDOyDICZAw9VaZLACO+L2d6r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748414221; c=relaxed/simple;
	bh=11tFUM3TULXoB5cAE/S/6LaR+nrzvNKbNf05E5x2cpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHvkOj/V/dzm3Kbn6JChYbsEb9LrKAvXAN6U/X05iVrmanin7OXYtI792358ZjdUxoQikJSJ2RrBCHt/yzqSHxIZZlqiMm0ca/Va6VdH8hXaC895rAQ2nTE9Cv4lJycb3aYLz0Dc+hw9cFrcbr9+T8BBnlfChfRrNG8Guk/Z7aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=S7+RhUQH; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="S7+RhUQH"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8F3A81039728C;
	Wed, 28 May 2025 08:36:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748414216; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=SJ665PIw+zdBcBYTOJq6QfkF7vfcPN/CAeV7BEmm7b4=;
	b=S7+RhUQHOwiKrTp/1djB2GauECG924WgiQ1YCnPrYJ5Q6RizcsqOg81FpIL6VVMyLdLKGC
	56HGjkEZbW2hIBUWEiW2OJh2PKam/S+YA/rR4cWoxWq62vlS50cq8Wr382uMtd9YEoscVw
	3GVBI1OcCg2kF+q2Tljb848t0FujNuStsxE6UtYcOwZ+UWfR+CqKaXu9RJARqDTs4RqLtu
	JCRE/Hs6a9wU97TxMJhfYDaQIVY7JacYQgOOyPJvyyBywg/Wd+K7TnD6WnHEXrTbQUTav1
	jTBZyhLfMFiEe8qkp3xBxJIjJkr7LWETmhyKvOGSG/P6epFty9lsgv6xMmhygA==
Date: Wed, 28 May 2025 08:36:48 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
Message-ID: <aDavAM+eSKEycKrZ@duo.ucw.cz>
References: <20250527162445.028718347@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nx3cPtjHiT/0/nIz"
Content-Disposition: inline
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Nx3cPtjHiT/0/nIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Nx3cPtjHiT/0/nIz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDavAAAKCRAw5/Bqldv6
8t5WAJiPHT00Qk81P79QYdubi/RNLnZcAKCrda8uUhMoUPDsTZi9JvkLWiusjw==
=GP+/
-----END PGP SIGNATURE-----

--Nx3cPtjHiT/0/nIz--
