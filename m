Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795686952;
	b=QBWYqnqerZHVeiqvdGPbtJ0J0nZosYYE7RxXi0TYEIlnxJl0cxnE7fXmndyacAAiYIam
	 9KOBDb7RvWbUf/reW+7ne34WtubS/zKWl/3GStp1RT86vyUtxwc+O4c+E5TsX0iYlDY9T
	 anHj3OiMI31jDcOSvvbUIllG1y+AG0WCLZNjsGm/pLyJmOJy9QXHzk/orrULuuFHyQcxl
	 2mwPPtYuVxonIkvI/nS/0btYPQppsnY+a1oWB6lEu232EwjJ9PgQYIIJg5fxENeFOTchN
	 zbKVwSETw25asmuWwn6WIpTDxR+hS7hjnN7FtgU/1LaLQ3cZ51MsrAvtOEDtqJxHBTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795686952;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=zw+R973gtwQwTUGP1+JczRwZxz4UW95QN1Ei33XKlY0=;
	b=qPmxMu6cF5o42Tc1XqjhE7ixIQ3JIJEvrhTu75r0xYLtcuPpkAoMnoRKf8l99ElgBJht
	 vosu0k2ViLYpqOBON1dh+hU9OBDvPCE7sVSSTzU2UKbw9AIq3825eMFvR2Cs51X743lG0
	 mcWVIN/HU5N7NDZwzoOV1FDD+p+oJuj06JruxHBGIRC6JivyQZCjFZbi2xGRnvNnR1+gr
	 8XaOOafRAwOvwwtSMjj/Tt7duR1bWY4OJwo7oSwl29tOsKlRSAt2iJFQeLBJq1fEiAZvp
	 vfuz4/BjuYEVXcUB7W2rHlcgbia4pVKHwtMyxM+y0WpE1drTY25bS8Y7xYAtRC2dwBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Fky2KCzM;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B240606A31C
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 09:55:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B240606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=Fky2KCzM
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DF28410907E;
	Thu, 26 Nov 2026 10:55:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795686945;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=zw+R973gtwQwTUGP1+JczRwZxz4UW95QN1Ei33XKlY0=;
	b=Fky2KCzMEBINIc06BnuENEcRuoXO5cWxe0UQQrpSnF8u8+Qlcw1lFyB9FSuSLv7pNmA7O9
	yVqjESOHN6BwtBB12DaNbeB5d/5nYVUXnRqu09xmshcdODwppg0X5BX7s6qzHO5zdaS3T1
	m6/uBTuhr95JwPeSSZkytrjze14s9sXbmqicZvmGyJBmGreFbFH3iAmos+HpsEFSKpkYpm
	flIL30N6AMn/vdaO0umAhkcMEeEUJEWvAE4OmBqmmVwbTlW73NKVlZbbTOyLu5hKHuQwBk
	rP+uPV1bv0S5RiW+zT9f36PCtfnDdTyFDENC0iWyehkvCFzkdpS4jNQZxpB4IQ==
Date: Thu, 26 Nov 2026 10:55:42 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/816] 6.12.120-rc1 review
Message-ID: <awgCHqMDTNJKs0n2@duo.ucw.cz>
References: <20261125143849.205329330@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L4OTj72toGPYDGxF"
Content-Disposition: inline
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--L4OTj72toGPYDGxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.120 release.
> There are 816 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see build failures here.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3114400164
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/18365213109

fs/nfs/nfs4proc.c: In function 'nfs4_proc_unlck':
3301
15:36:38
fs/nfs/nfs4proc.c:7281:24: error: variable 'cbnl' has initializer but incomplete type
3302
15:36:38
 7281 |                 struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
3303
15:36:38
      |                        ^~~~~~~~~~~~~~~~~~~
3304
15:36:38

Best regards,
									Pavel

--L4OTj72toGPYDGxF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCawgCHgAKCRAw5/Bqldv6
8gbiAJ9V5MJIg+z4W1WGXq0dSEnUDNr6SQCfYfqu+TDyRQfP9wbVF3N+L/hcr5Q=
=ZWsX
-----END PGP SIGNATURE-----

--L4OTj72toGPYDGxF--
