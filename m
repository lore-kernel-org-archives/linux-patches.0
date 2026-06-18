Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D405C3264E7
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781772912; cv=none; b=uqYP99ud5OS9fSWaRK0adxgpfPKjWvUa5xRO7tFe1hrrPBhCPgwZzGTLTgc5WTBZNuPovPct0Zt4BPg+Iz22XUr217hMiV3Lq0BMDLwuKji1G0hfqS9mTSdeNceiEdkkxqM6y3F84mTfrovqZR0q1YjHpaMlMupGxfDQ9QR2i7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781772912; c=relaxed/simple;
	bh=bHcv1lP/sbWMG6OS9TQBnfhz042PTakXTaAM/YnYgDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TM6e00/iX9bzyH7ntJt49b2ZV+mZR/9OxJTsZ9HKDekcQ82qE1DS8uiFx68tc5zxDGK6DjmpgyxGFtWAnHv9iqpi0tsqGs2vdb1peq5pg3SMn6wv9XcCcEmjUeFbCyjt6JpND7SFh0A1fxfi2vO35k21iuJumeuFy1ch/89Mb/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=GXb6L0Q6; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="GXb6L0Q6"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5FEB9115766;
	Thu, 18 Jun 2026 10:55:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1781772909;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=5mHHbSCxRhbTiPsgEHNsX6NKZxyP4pLuDQeG+2PLmaQ=;
	b=GXb6L0Q6XB2T/nuhA1kyKFAIDQZgc+HuIE0vdCV/NAxQk7N06HkQJdp+SraQhxFSSiqxDJ
	KhFFWFP2DCTo+OkCBmYjs/vEYALC6tqxBd1LPzs0GE+JuDk/pTkPbARkz3ugZvMgEUXiZF
	N8ESeApRWvu0XUGxy6hrvdkmEHyNidwZ/EXFRum8g2OQHelyyrptbkgnMzCLPoSu9h/h9F
	3H1+Qmsg7ChsLyfdKC3OK2bTQhvRr42n4dOsUy3zvKc4t4quODueAl0cJAjvfOsh2PnwOE
	YHiF0+TlgI9EviXWF7UFY7fooREa6W9KZMU+LsFt1we8nIjoyWc2YuJFJrb+Yw==
Date: Thu, 18 Jun 2026 10:55:07 +0200
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
Subject: Re: [PATCH 5.10 000/342] 5.10.259-rc1 review
Message-ID: <ajOya2lY8V3HnR_d@duo.ucw.cz>
References: <20260616145048.348037099@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sMuaL4XH5S+pL0ax"
Content-Disposition: inline
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--sMuaL4XH5S+pL0ax
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.10.259 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--sMuaL4XH5S+pL0ax
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCajOyawAKCRAw5/Bqldv6
8lKVAJ40HZ9NyMc8/aOuSBUOnJgWjCpKUQCgmN6u4rsS6Sijz/yJ8n6YrzUwzxs=
=PpX+
-----END PGP SIGNATURE-----

--sMuaL4XH5S+pL0ax--
