Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899BC3B7763
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781772673; cv=none; b=p8ENkjhLhHxiMrqgAZzvRRzDZUOeD8paUIv6PVcw3M4zTcjhfehARO2xaxt8RxNYv9klKdIWkJrJbSvbl1AT4muknpJ/2N5oDBArwrFfPmuamQ/jzzRKlEGkdWBCbrLh1uGJg0wPanzHKaSMObMNKcmOVPRjTOrFNAaa2JR2dnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781772673; c=relaxed/simple;
	bh=zO3V54C5HHRae0L772OfE4dD3EmL4beK+4OIz4Un73c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAqtcN9oZnmrhptHmhjT4ieOPLujsUWLiFqCsnwGxDem7BEQiLcXK4LSmPl0gp4j6O/SyMAO/+I8YsjYha2LDmUKjuMdNbZ3WbvQcO9bh2/IBbc7m+g76ukr1UiFfNHGRxwFIJ2idDkmVChyfDEwGtveVSJHhMHY/sy3d1PYRgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=LnfTT7Ot; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="LnfTT7Ot"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6E0BA115367;
	Thu, 18 Jun 2026 10:50:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1781772663;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=LF/JZdcxFgRK0iBWPnF0l7Y1owU5r6zC4pFS1bPYe+k=;
	b=LnfTT7OtQzupS0TOAp1wDSUfO3E40mrTTOfaEDOSo7Ks1zW2Hl5+UmPXfvckGdH8NNDEC4
	Cy8EkrjWBaG3cggkBE6zvzl1YjW+mU4jXW2GRPnPQ/DZpgf+zFINGsmaU+wTQuQtrpdG1r
	TnFu0W8SvCqX1cRIaZJmFH5nyseLfJJZ9/YZe9wIF/f8wr+ADIrIqdnW35Wjb5LPCmkTWg
	a4gWI9lOQn+MDGo06J+iT9Q3L84Gu0nhfks2/1TKktxCcZQf+FciLHlsf9K3TEwJp58ntb
	q1ilIQlHus5UNQpjFFQ7/DgSpRI1/lN9xs+5wcn5D0tFlmkpAcTdQqZlacnMPg==
Date: Thu, 18 Jun 2026 10:50:53 +0200
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
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
Message-ID: <ajOxbajb7j2Wmnio@duo.ucw.cz>
References: <20260616145109.744539446@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FURrPcz5idKMhdAZ"
Content-Disposition: inline
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--FURrPcz5idKMhdAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 7.0.13 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-7.0.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--FURrPcz5idKMhdAZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCajOxbQAKCRAw5/Bqldv6
8n0VAJ47EQw1pKPmg4x6mBTUKiVoNEELIQCfXitiZO5RCm8+icmQnozeDrH5Usk=
=nk/W
-----END PGP SIGNATURE-----

--FURrPcz5idKMhdAZ--
