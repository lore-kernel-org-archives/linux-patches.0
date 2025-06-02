Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4225F1993BD
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 20:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748896657; cv=none; b=T0tvO3faC9U3TcG6T+FZ9Xu3DsUc+oW5GSSfLG+u2VuXpz64ADyQg1ifjVvfIUrnuMDj+jtjjAbQX1HezbcwjJgQnBKYaMzxECw/RzoH+65x1ezi0l4zm9JpYGBahnod5Z22zTE1p1PQ2UXNTk63e9cM9eXT21K+PinGeB68gx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748896657; c=relaxed/simple;
	bh=YWmvLBFVMy0ACFJ8Oem4MSHtt3PLkMSEDBUdGZ6sv8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdrfPNZe3S5CoJ1ay6W3I4Bojqr2dIy0i7wOc8oIXR8mGbUJ2DXQLedaDq9RPFdPquMfuDFcf47RI158g3wbctB1XhXh4TqYOM4oVnGMw8iNxCq70dSwAbA8RyunjvNdqQEC1M5aUBkyGHkzGcYWkJXiSWJj6O4k+ogLoroG4o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=TBOJoRo7; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="TBOJoRo7"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 20D8E10397298;
	Mon,  2 Jun 2025 22:37:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748896645; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=/DozroK7TXy3Omq1j6RielxQfk6GDYIyqfs7T8P6zyk=;
	b=TBOJoRo7Uijr7OgCa1ehbBLhCGlvxgp+UlPWWzSWDcfnCPjZrYEnRNgPJbVD9deGL4bCK6
	0L+aCxZQPDK5GLZBO9VxeoqL0HUueikS25/jng6slMAPyJjBHGbImDzWKlTkSVVP5jz+52
	OoTj2UqLtYG9mZnsaY7UVJwquucsDslf+IPeBY0bkajzKImaG+/fnNra5UKWzo3N3VGa7H
	kD5CsCsS8LJSiwfd9ibC7/LNCqSMPCNMg6W3nGgbJyVhMJbzXhtWUpHEA9x7XVPgiAAiQL
	vasOvIbnztkXOETQosnLzudy0FMbqHDrpeb8VRdkf1/op5LJRvQjvbikHRBQNA==
Date: Mon, 2 Jun 2025 22:37:18 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
Message-ID: <aD4LfrY/mz3hdrCw@duo.ucw.cz>
References: <20250602134307.195171844@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EtrPzPCbQ4nUtNmu"
Content-Disposition: inline
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--EtrPzPCbQ4nUtNmu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.238 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see build problem on risc-v:

drivers/clocksource/timer-riscv.c: In function 'riscv_timer_dying_cpu':
1932
drivers/clocksource/timer-riscv.c:82:2: error: implicit declaration of func=
tion 'riscv_clock_event_stop' [-Werror=3Dimplicit-function-declaration]
1933
   82 |  riscv_clock_event_stop();
1934
      |  ^~~~~~~~~~~~~~~~~~~~~~
1935
  CC      fs/namei.o
1936
  CC      net/sunrpc/rpcb_clnt.o
1937
cc1: some warnings being treated as errors
1938
make[2]: *** [scripts/Makefile.build:286: drivers/clocksource/timer-riscv.o=
] Error 1
1939
make[1]: *** [scripts/Makefile.build:503: drivers/clocksource] Error 2
1940
make[1]: *** Waiting for unfinished jobs....

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
849177067

Huh. And on arm....?

drivers/clocksource/timer-riscv.c: In function 'riscv_timer_dying_cpu':
2053
drivers/clocksource/timer-riscv.c:82:2: error: implicit declaration of func=
tion 'riscv_clock_event_stop' [-Werror=3Dimplicit-function-declaration]
2054
   82 |  riscv_clock_event_stop();
2055
      |  ^~~~~~~~~~~~~~~~~~~~~~
2056
  CC      drivers/mmc/core/slot-gpio.o
2057
  CC      drivers/crypto/virtio/virtio_crypto_core.o
2058
  CC      drivers/firmware/efi/libstub/lib-cmdline.o
2059
cc1: some warnings being treated as errors

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EtrPzPCbQ4nUtNmu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaD4LfgAKCRAw5/Bqldv6
8qA4AJ0VGGZuGng2U3zVTRMsFMfSTfLtewCgmAHdV1HXBYhcR2eDrMUNbO+MDc0=
=VyO1
-----END PGP SIGNATURE-----

--EtrPzPCbQ4nUtNmu--
