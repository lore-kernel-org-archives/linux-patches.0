Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39811494A3
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749405244; cv=none; b=YLYRwWKd+EkDPB98JL1ixeIVdTDqnfGeVfeOEMD160ayd2xoKqwzvngZOaP/jd3F/WqetAvu26QzFpyC/92AoI5OhZ3YsTaShMdpumGlLKtrCfGIPRLGyaPszoZcG6kJYA+NtKPq8yLLex2tuvM7U121aTxS78ULNlt+8oEK6bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749405244; c=relaxed/simple;
	bh=DYNGyy54dIQZ+yASfRD28QurH5y9Icczf3Z8e976bAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZaFW9ZojYhgtRtD3PdWCaCj0whO9jeLJm97KfVJ0ru4g9U5m3Sk9XAM0wCc1XrGq6oyzcwOlcvtcnTIthpyhVFYWrvsEDRw+t8z+B91yd0ty0jxjiVNw2JsYj/jiVtDgez8nI+43RgNF9F43VwyjOPPvdzVod/mZWi+TwKxO/u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=gWDKBh3l; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="gWDKBh3l"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A08A110397298;
	Sun,  8 Jun 2025 19:53:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1749405239; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=6SR1HHxqpvhPr125Ug92SYZ6Kv0xs3/+dZrKaa/IaIQ=;
	b=gWDKBh3lWNK9SJ7+d+8ZDw4+M1LT+hCR4bIabV4ivMxw1m3ZL7bzjlVi3rCx1ItalLNteS
	vTePSsxICxRBDLr+R1kcsT4xwMejqI3gw9yQvDKIGZmZ03/P61iuSo91nBacCxwRSbTygJ
	fs628Rm7J6FM7qFhqGBIDymRnmOhwqFDzW2mGOGZfe919oC8R9DAGhONc+KImwlmriVgs0
	moUWcHbx4CScDIXNcm5hjcHixfrClAqinlILF6B/ZcBQwfTm1XSgrTAU8kBuCTN4yOWjS1
	I9PaoKco1Fr6zjTjhc+0tAvb/wdgmldkznR+Spr1lMQrJdrPqNx/ubUHTWM65w==
Date: Sun, 8 Jun 2025 19:53:51 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 00/24] 6.12.33-rc1 review
Message-ID: <aEXOL7+Ywuln9wS8@duo.ucw.cz>
References: <20250607100717.910797456@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Asto3FxhM0duGw7"
Content-Disposition: inline
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--+Asto3FxhM0duGw7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.33 release.
> There are 24 patches in this series, all will be posted as a response
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

--+Asto3FxhM0duGw7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaEXOLwAKCRAw5/Bqldv6
8sUgAKCw6yIwimENhy6etWedi4GeCjdlHACcDOOH5u1w9mjoa+ezBPROBgi8E/A=
=eY7X
-----END PGP SIGNATURE-----

--+Asto3FxhM0duGw7--
