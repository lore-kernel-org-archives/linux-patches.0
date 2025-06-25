Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB14F2D8DDD
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750877527; cv=none; b=bWbLamntKEeeMeY+3TbBBcpzN285FR/s8UE93d+T7K6dRf2ECFtCRfPMyp5XSP7Uq1veO/z1HJE9Aas+ojvifaWUisaPdNWhTbu4Kdk69QbQ2/lT7BF0fHSBNyqfXxpfPKLGo9sfpP4ZrBiWjUiw2htlZjswARghjYgAzKmH7ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750877527; c=relaxed/simple;
	bh=l1WnPhp8FBjcZjUDzHjYjNPwDZbBtpLH9BSz7EZHbUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N48CzjwidYt2CCT/0B6KljeBCJKQAc4qC/w+0MsntyXQxtEjApA52z2NwyrY/KcBPl3VJC4X2kSqn+ptg0PVcX3vnw49icBnAFrfV9v5BgQecfuh4BuST0FuEG2C3iJQiM2qUOnh2AbF1t/VIsGKtoUfweWbmDTJq26LuUaKEYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ZWT6BlUw; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ZWT6BlUw"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8D5691039BD02;
	Wed, 25 Jun 2025 20:52:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750877523; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=06Px9HkhOtgP+jomQjBxwqL1xEIgl63yXOhECwL92Xg=;
	b=ZWT6BlUwn6K6a7Xx+DmP+Dgt6pVsCJSu+j6MCyMOyDaJbqFYE+5UeJoqLeF2GzQgat22fe
	Ti/rk8S4eW6qQlXkzO36IlJErfZTs58+tzqUAr7cJ6sNxNQP6OfIqN0KdQIZjdwQ+QhBS0
	ABZ9Ou0ld4slhX7IGPFIZFM88/4MehVpweowrD3r/m9uEcHowXw5V3x4Ge50hIP3Q0HlpG
	11I5h9HQ7n86Gk0Qkd/2xljYT5O6vhKcUhDmjlW4b1m/YMm8RVLXAz24luRF2qoYXQRNJP
	P3cbVtMedyrG+HWcAcQJpOeIOjmXfFUXycJ9QmxkaiFIZY5WVe/qCHbFJd3pcw==
Date: Wed, 25 Jun 2025 20:51:58 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
Message-ID: <aFxFTkWyv5tl4Muo@duo.ucw.cz>
References: <20250624121426.466976226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WiDkXkM+P0npLAzv"
Content-Disposition: inline
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--WiDkXkM+P0npLAzv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
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

--WiDkXkM+P0npLAzv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFxFTgAKCRAw5/Bqldv6
8oY0AJ0WuAtTB/ChM+kaIbHuTVG8783LsgCfc9O5DH4Rdxk8kyhUKzo8JHFc5fg=
=cwri
-----END PGP SIGNATURE-----

--WiDkXkM+P0npLAzv--
