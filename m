Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FA9280324
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 20:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755030050; cv=none; b=br+RAaiLQZlJbd4fon9Dj7EW/McNyezHqkt1fZiFMaR7mSJubXNMmIiQnf6/IEPY8hDv0Zqo3E/kP/TS8yd3U/N/lERlDIrMAJLK8pc+FF7EeH5wAN6JvqVDRsoSdXsyZpZpada2yqEp8IztRUhUozbsM77ePeJSkVFuGRLOUvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755030050; c=relaxed/simple;
	bh=+tF8MQexVjrJPdLLHizEV4nsnUoIOHoqc7qC4YT//+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKOrM7lguxSl1j2IyOxzi/bYEXNUKqrozTcVCtxLwSrgyw4wWvlBMW0J7izXNrY918915tpSu5p0ZyT8FjSZV67jcPl84YD6OQAENVqzlld75cvYIFe5MA/BLCx2FKIM1/UsWjFzrEek1J1r+UHE7LhlyGyQUygYCqNClVpwTi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=GPwE0YXu; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="GPwE0YXu"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A2AFD1038C11C;
	Tue, 12 Aug 2025 22:20:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1755030039; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=H3tyxek2HzYAbWyIkDVz6bqMHyz10AfZCUT3ToRhPE4=;
	b=GPwE0YXu7Ga2Bwj/ovKlonpQebTULUgbX8okkVgFb1Cvf3FEN77iVzNyWwKVL+Lo5q+yc+
	cUvDVq/Fm58niFyvz6j8tcVm8ELDMDwmwne547AU/kP4+V4I2mpBOKCV5RaC3L0Uf0NqWl
	it9Rs8pz2dhWGFXtkfxKl3lpvo2YwdmRsP38kVwqPC2oGQVwYKyzHBGGNGZSVv/MWHoMZT
	Zy05tgSPj+EKQkqRED9j6gSuZowB2VhNM56khsPDLXRbyWdF7KLkZoHJ981WW3RQxaPg4/
	9ugsgx9UTunu5HUo4pjgGLVy4xb2O7C8ebBNg3ogJ0CO4V+lipSuD0uIkQUhdQ==
Date: Tue, 12 Aug 2025 22:20:31 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
Message-ID: <aJuiD7hke+/50/gG@duo.ucw.cz>
References: <20250812172948.675299901@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QhHZ/vbaSeeHaVxq"
Content-Disposition: inline
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--QhHZ/vbaSeeHaVxq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 14 Aug 2025 17:27:05 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QhHZ/vbaSeeHaVxq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaJuiDwAKCRAw5/Bqldv6
8jZqAJ9P4IzM7rmI9LXSqGKiNQ//lJR9mQCeJxcbMuO9PF3Wk1xsuqC60VYd0+Q=
=C9v4
-----END PGP SIGNATURE-----

--QhHZ/vbaSeeHaVxq--
