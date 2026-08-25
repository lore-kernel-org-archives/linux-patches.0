Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300C236C5AE
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 19:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787686384; cv=none; b=KIFyIpNvdvgUp61EwaVxeX4EoQuOME8bd3xYd5L5iDc9PVSLXuTpCi4BjA1BwnqTv0DN2kK8D30zCDlfwlN2ePS1u1fHedTpO/VQxDeI+rq18W0Mnf/qEWpkmhbCHfgqrPP+bTYmXzjELfI0r/Ey6TAphsBSTOVuXd1KRycFMZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787686384; c=relaxed/simple;
	bh=Q5NdzABNFZlHFCzW27oyfxovrmxctYHCZD9P0x47IHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNEo0B7nHKJJyIGfgbiblWoLGRQZtToNBhSmLgEhFzbunJkUhyvN00O6AVHXKZyG+7t//73pf5wM4Ur3dDmQG9K7ht9mHp5Qgm9JK67BmUi/VM65nk7yhbmUt4B27eclbe9ZmDAaFFOOUciddTKljwwTGV42yava8GuDhRDPffo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=FKdmwfYC; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="FKdmwfYC"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8952011CD48;
	Tue, 25 Aug 2026 21:32:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787686376;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=4NtvRj8W1oOwlnyCE3sKP1SvPzYEjVab/DZ+yqxWCqc=;
	b=FKdmwfYCqpDu/UnLdwk7+zmd9iAkKklcD4pIekgirMle+bAAzY9A0BrIOH6YK9VBqgbXMg
	7HeuhlxKv+42azpj8STxYWLrr5XfSO4SfbYabKZL3QcNgDRT8iIrXbaTUNw7G+hrNUgbcg
	E+pjssfol8vjZwqFGK4soHkU6R1g9LSQ7HfR4l5TghXe8sgpAwNVrYBhXf0BYwecbt7SBa
	yRUviHCE7lnzoWw4em50kcBJWhLzFtT/+YxY4xZI8EgN/WIwawGjTAk1lTcFUpj6Tr/9S5
	hH5LXYOKAtZqidm4AVkXBw1TS3/kcsp/FlCJTOfzfTYA58xzX6p9x8ACxAQF4g==
Date: Tue, 25 Aug 2026 21:32:52 +0200
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
Subject: Re: [PATCH 6.6 00/87] 6.6.154-rc1 review
Message-ID: <ao3t5IEuWIpAvLu0@duo.ucw.cz>
References: <20260825132541.813800447@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qXZqWn07lcPALZgg"
Content-Disposition: inline
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--qXZqWn07lcPALZgg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.154 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This seems to have same problem as 6.1-stable.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16096629443

Best regards,
									Pavel

--qXZqWn07lcPALZgg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCao3t5AAKCRAw5/Bqldv6
8s+bAJ4ulsdOh58b2UPlx+9hcDkZ3ia5hACeKcBznE11olpqfhbQvrGpS1B0xEM=
=D1cT
-----END PGP SIGNATURE-----

--qXZqWn07lcPALZgg--
