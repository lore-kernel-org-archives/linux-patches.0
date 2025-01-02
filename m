Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15751953A1
	for <patches@lists.linux.dev>; Thu,  2 Jan 2025 10:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735814586; cv=none; b=BNoPkryAt5B1JlHPyqh61hfNlA5TAPInawSQ3Z6zIfQ7qirKN8wYvrAQ7nC2myWyCYq+gUgA7whNd9mNdjc4HObGFNn52+10aopClq3lSiD9nNyBN4sr6LYJqbL+2vow4KKWHkVlFS+tHx7smgwB7zpmbIRkiUYQyWOmWxPPb3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735814586; c=relaxed/simple;
	bh=l7UhspAr4/ASax1uqyabAdakfv+Kut0Wn5A2KiqHS1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H4w2mTNQUNh37VCcBViqzCem382yMtS9nAmjISNZvJNHb8uePOKN1+cAJYNdkGbCHnNyrJ1OrUkwzv3c62zf1BUCN8b01wtZiJAeLInQLbFrLS5ZYECJ4OYTu/RMQlOshmNo2klZEqz7UnX78/VcgJvKh2An0Bxoh+QQZsVcI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=E2Tjnvv8; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="E2Tjnvv8"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9279A103FEBA2;
	Thu,  2 Jan 2025 11:42:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1735814581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OzZ1H79fdHrmUWxtv4WKopTVw4nnZzOq4SG19I/ujVI=;
	b=E2Tjnvv85sSl869h1Xx1D4XVltFuCi4VrZPsI4Tv96rqwDuPESGBF+RcvmHCMCKti2ZHRj
	s8DMSUzf2ZL58HEmOwQqTzUeiBgAq80aG0TsMQP0Hv6nJvfD21O12TTE7ae0hyG5FGI0AB
	m35aNa2sYBwJvuz4L+tupZrjrMQa9S2fOTxNdSDUxGRfqj2G8Q71jxz9bik3muEDC5Og/m
	W1sKHph+nK/cx392kWvfLOlybvL/mqKNKGU4C3NPFbVKBZiql20wnr8E59t5QmcVqrzRwZ
	AzbtohqfQFrjUkieGtgFM+3BhNn+d1fg5Cf1qNOmtfiap5UobnvLOjaIXohPRw==
Date: Thu, 2 Jan 2025 11:42:55 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dan.carpenter@linaro.org
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/60] 6.1.123-rc1 review
Message-ID: <Z3ZtrwAGkr1XZZy7@duo.ucw.cz>
References: <20241230154207.276570972@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8O1ddBMBScpfx03q"
Content-Disposition: inline
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--8O1ddBMBScpfx03q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.123 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Dan Carpenter <dan.carpenter@linaro.org>
>     mtd: rawnand: fix double free in atmel_pmecc_create_user()

This is wrong for 6.1 and older -- we don't use devm_kzalloc there, so
it creates memory leak.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8O1ddBMBScpfx03q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ3ZtrwAKCRAw5/Bqldv6
8gKmAKCuKrtAMYXiFL2nfbSJAfDlF11XegCfZf9VKVMzN8RklZoruK8fHbFvQuw=
=oldI
-----END PGP SIGNATURE-----

--8O1ddBMBScpfx03q--
