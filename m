Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF333B42F2
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787686549; cv=none; b=IfF5NwzRf7rh1j00X1PXKhiUGs2erqwNBWTw6QS7vBR/fWOd9wl7E+rSvvhwT86TZf+9QKj0xfcS1VQC/f5y6LpOet2rzE3KPZgBHmcIM4xIUrfVKqXvuP/pQtdrq7rMaL7ENeokbMbwLD26Ax2F/XJ26vrb6MrO0KPsnlEtrjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787686549; c=relaxed/simple;
	bh=yJNkKIssTK6bpd6TQZHx5wUYU8k+hiyQwo2Ws8BgDBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XkyOnMBBZ86mNlz+FzL1X1jL3zA2GjV4vXv9LzH9L0Aeth1zahHnDxypUIYDZe/J+HEHkDCVPFgcza5+rwUqFGqnpRUlZma6qn4ziD9DIXQ5xTmki5H2E/YKUXfBcQsi4Ujjv6KfApyZnBrYvVB7R/QRq+/nqs4Lia133QYB+zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cu47UWBf; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cu47UWBf"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4307A11CD62;
	Tue, 25 Aug 2026 21:35:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787686533;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=6EZyt6mUJarS31NPv67W3F31sBMrKX26j9vS5VHAZqw=;
	b=cu47UWBfJAYqh8eZqayl9xkztQKyJlczqhlJaqlayz9r9RBlumWnW8zhzTq9PWyWQ+YPiH
	AUslrxgTnRsp74KDPYtS8ibgekRgsfpf2YfHWu6ptwPp8lOOnH69hlWCFSAPiQTHxDcMqM
	dOiG+7X9JcxDl9/X8arqC59gp8eY35lAR5qjeypyYfzUrvIdW28GliFIvaUvuXIZy/zRgo
	4UwwMARtiUbK1O9RIYvi3UYHRBbogzlKTOj8Ll5DQuoTh5dnZy7h2Y85SpSiINMSPtBOIY
	TAN7rz2fpGjjzGsa4AW9UbJtOX5dtjH5iCdPykE2Mpjn+xJru0FlE6HDX0lpOw==
Date: Tue, 25 Aug 2026 21:35:30 +0200
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
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
Message-ID: <ao3ugql15ECXoDVP@duo.ucw.cz>
References: <20260825132541.986300899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QEDt5550zlpS9pO2"
Content-Disposition: inline
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--QEDt5550zlpS9pO2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--QEDt5550zlpS9pO2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCao3uggAKCRAw5/Bqldv6
8klyAJ0c3QKJ1BUymRqZQ5KrpkhnWLRoHACeMZLZbLXwFRK28UZZK2tsBuhaEY0=
=YtKQ
-----END PGP SIGNATURE-----

--QEDt5550zlpS9pO2--
