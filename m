Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B41B2416BC
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736945463; cv=none; b=IOweSnUBp7Z0MhXbTLbgvn9Ai0Y1MkF80wVAVQNsrXpl+b3rwhI7A5YNJJ+t3xxB0uV+kdiI5MwIJaZqKdsj76B/wa08CVNTOIxcAjeeg4qKmeCvoqn6JgEBMzCSIEIXY10E1y+6qLyJZHvBhO1aoCmv8y+QAHfNEoZvrAtOGcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736945463; c=relaxed/simple;
	bh=zXXUUDG0UTpHJ52W1kiASnA8B06NRHcbEtlSOVYts8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZqCyQvY8thnoEoRamg3HhqCuABqwLa2x3AENaXIt2IX0s/dzLhZJYuIR0MR/YTp9/HmDrZEOoWm41Y1z1r/9ZEKvGriaNAemVvXC30rzOEHU6vngFg0jX9gg+912T5KFzB+89UuleoPwqksyjxOzhynJI/NBek8lCizOFk/454=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=BkpjX66M; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="BkpjX66M"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 074AF101D238F;
	Wed, 15 Jan 2025 13:50:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1736945451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4PDzi9sPdXQR1a2+/SFm3bkYhMWU3ndq9pxfSYV7C0=;
	b=BkpjX66MWetttKDp8Y1CTI4SNqq7hVcFxN3YfBgCPrtfjCFyIpBRUW3BFljuNi2+b71LdB
	VZujIesIcTmNAeb0/cobbBWHy7m2jezF7jb9c4VCmI+sg8IprvwQtQ/f/2banqDC/RnR/C
	BU5rwNrJZmWCEMB1kIjd7HVoR6lCdyuIjAqc66PD82IsnHHHewEhNF/Pcy/DbNLRi1YNPZ
	Tn3cDzPORSnDA0x+o8MQ406cxde1nzT1iKqagQEM+HRvPCIBy58c1ytoIKzuADuvC+7nYY
	dqQbYqUH61wcj0OdS8ADocHunQxKnmkvZBJXrfMq+j3Wf3mGBcLwTZXF+38yrA==
Date: Wed, 15 Jan 2025 13:50:45 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
Message-ID: <Z4evJUkzHauW+zOU@duo.ucw.cz>
References: <20250115103547.522503305@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bZ7vCSSHk8L6R1Dp"
Content-Disposition: inline
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--bZ7vCSSHk8L6R1Dp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.125 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Still building, but we already have failures on risc-v.

drivers/usb/core/port.c: In function 'usb_port_shutdown':
2912
drivers/usb/core/port.c:417:26: error: 'struct usb_device' has no member na=
med 'port_is_suspended'
2913
  417 |         if (udev && !udev->port_is_suspended) {
2914
      |                          ^~
2915
make[4]: *** [scripts/Makefile.build:250: drivers/usb/core/port.o] Error 1
2916
make[4]: *** Waiting for unfinished jobs....
2917
  CC      drivers/gpu/drm/radeon/radeon_test.o

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
626266073

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bZ7vCSSHk8L6R1Dp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ4evJQAKCRAw5/Bqldv6
8qwIAKCLMr6jxGOOdRFHEmJa22qfBwKV7ACfV23vPqQYWxwERagWF8WQWt8VDY0=
=oPSn
-----END PGP SIGNATURE-----

--bZ7vCSSHk8L6R1Dp--
