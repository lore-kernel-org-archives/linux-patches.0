Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0323009F6
	for <patches@lists.linux.dev>; Fri,  7 Aug 2026 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786127499; cv=none; b=dhfB6eWM2rwnWGQB3G6ibd85sGPd4u91Rp3BnubaW0KcHfe//A8stXMBeeEHfAgD2PcSLA3MjJ/7N7V+jGFwfESN9myH96A0IYNK+MKPg5rLHuIRr9NDqZqeFH7n0te8DzkR444GzI2E7PNl9qt/sW0DQbA+W2C2gCu81fFsw5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786127499; c=relaxed/simple;
	bh=DVnetUNhfhWLHpKOl7+YC8X48dgOoqqNZGPGOKABHDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJrmSem89JftF/vJPHrSp9J/7LGbtBVzwPjdaQd2Vj5ISoehVPHJ1EooWF7vdpQwqS0ZZvVBQpoAMzlIR/apDpc/1nqKoldGdOtRGTbDglu/mZgG9XXm5cNSFXh3nHvvf8sQ7AYSNGkVFc17HU5AzI8OdTkTjYmAicOYOsJHsH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=ZWwI1Vjo; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="ZWwI1Vjo"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B569111B0AF;
	Fri, 07 Aug 2026 20:31:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786127484;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=QfEB8ITGCKqjjI9htOofCc7++z2S5qKrfomp9/dVKo8=;
	b=ZWwI1VjokfahvE5hveNMeg14DOhJwhjzGHVPK+LOMNbqL2cuyv1GKCoVOInQdNlusyTQiW
	yt+4zExBd+y3xBtuk9MMr0BLybIQ5gJALcg/LnS4QEuFJVf5gZOH4talUMFuxQ4ah7Z2RP
	9lv+mWOHkTkCT9YgQ+FiCk35Jj3FTK6/PWmP6fCKwOOudlOWSsgNKucRSPqrV77/ROi+JO
	PRvXilfD5JxFHBWGlAmVyNn2icDAiFzAiS5RW+6GVtJ7SWUveOlyjDR95p6fS2YXWiSDNe
	4yG7QrGheINvOmWOmBZ2fZWW4c0DVS87WT2yP4RqDA9v3qJfIZzMD8r1LnC5nA==
Date: Fri, 7 Aug 2026 20:31:19 +0200
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
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
Message-ID: <anYkdwFdB72mZM6Y@duo.ucw.cz>
References: <20260807143428.008222056@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G0u54LwNZju6LvFE"
Content-Disposition: inline
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--G0u54LwNZju6LvFE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.1.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--G0u54LwNZju6LvFE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCanYkdwAKCRAw5/Bqldv6
8novAKCoLSH01ns5xVTrHDg09AxSyoqbFQCggg7pAZ5H7sf9lL/0/alRBPMKWKk=
=L4Ku
-----END PGP SIGNATURE-----

--G0u54LwNZju6LvFE--
