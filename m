Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178AF33F8BE
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761665470; cv=none; b=H/shV4vRshc8D9TRZflGX2Qga51887RSjoiiaYeMPXXWwJuhXx2R6hj0BABYHCUA636Wig7GjmRrtUC/3BmJWlXRwkYT5bBWSkJlLaZYm4jlzoGaptuoMEGtnkyh57otPexnPC0S0ZFlr2++n6CePGC6zdLoX8SuAxvYi9rn9HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761665470; c=relaxed/simple;
	bh=BscJQaQKXssg/JBKUDrSJc2ynCsUPDAqmXhamiPRdWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3hh2bom/G3aZmpW1jnbpi8WjjTaQNR0a2Bp4moz8c+e2qAbjgyFc7j9Pzo07Blz6ZBgEiGkBRH9iMfbuvQmdy7CYfx43sT0euWMUeyifjibK/Ye4/NLtVCowdYywkw8r9eLMF8NI81bdMKGAKbXXV6pavteTm0PmRxyysOvF0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=EOca+8P6; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="EOca+8P6"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3808B1038C10C;
	Tue, 28 Oct 2025 16:30:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1761665459; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=J+F9vjuMT9/ypXwAVsZImyHaZRjRZh4kFpYxW7n7apg=;
	b=EOca+8P6SOWsKiDdKnt1JeXPg4bMinLnLYfgLDN0YNUTuk9tSyJCQGOr1ThpgCiKwJjql7
	FV+KyyuANTEfPwpCSOJBOAZxeykByX8o7QStJH5LdJ0vVLaTQdaKLstKxY/fhBogrKebqv
	GfERKEpziTrs2W5RF2CwSlQqQ1CnHSAMBNgw10NVtq4+CQbGysaV55gn3hsh1bVu6sIc/U
	8g1oXun4qWuitutCL3Ernem2n84GOoC7QCrrVWVcPYxdhNGFHWa05sEgmWrzU9SfFlMWgx
	/IW6wuVXqJQJ/q0ba/JAn6nC7ZwgWxMTodWVQDdV+CJH7/OoIwzql8rQa3bLaQ==
Date: Tue, 28 Oct 2025 16:30:54 +0100
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
Subject: Re: [PATCH 5.15 000/117] 5.15.196-rc2 review
Message-ID: <aQDhrtRto7AQVVSg@duo.ucw.cz>
References: <20251028092823.507383588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dCp2ev7JzsPOZL0B"
Content-Disposition: inline
In-Reply-To: <20251028092823.507383588@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--dCp2ev7JzsPOZL0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.15.196 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Risc-v build problem seems to be fixed.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--dCp2ev7JzsPOZL0B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaQDhrgAKCRAw5/Bqldv6
8q8TAKC85rpyMHeTYbjzCxRgR2z8Kt9SCwCdFjyqzsZ9Xa9sazIQxK8CxE3GMXA=
=KDFW
-----END PGP SIGNATURE-----

--dCp2ev7JzsPOZL0B--
