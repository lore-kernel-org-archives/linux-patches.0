Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F5941C65
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 18:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723748066; cv=none; b=EWI9Jgfdbin/kZnSX4yVinFJE2zr+JfneYxmJRwuPy+/tRGBvwiNdNZzf1eAbjtBSjrJPRjHAcB1hIPqQ/Juj5vpfO50g7muOLziK4gDR07CsDZv814xqaPVuBxiFYE9DrB6oqDY28b4IR6O3z8NiNSPby6bMLqV+4FC+rdYODY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723748066; c=relaxed/simple;
	bh=t6SAs6r2/QC1fFdaxcvL4jVkqAGg7qkfNxjw5Celk/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K54IxyvZLQ51W2ZA6d8lrfriwIahMNfBYeqfnS2QvIbm0dXXlFfP2pwAL+0vtCslJkJmHlQmi8aA6uVGtN2T352+asNLrCL5W/FDbyZEk7eEQH/aPiUtokybpUufoW14RDpuYDIeGt2O2EfoanynPJVrZ5UoTUsqWmI6lXqDijs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id AD9211C009C; Thu, 15 Aug 2024 20:54:14 +0200 (CEST)
Date: Thu, 15 Aug 2024 20:54:14 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/38] 6.1.106-rc1 review
Message-ID: <Zr5O1kh1GpItTgiY@duo.ucw.cz>
References: <20240815131832.944273699@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ol5gAA6YV1QE8G+R"
Content-Disposition: inline
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>


--ol5gAA6YV1QE8G+R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.106 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ol5gAA6YV1QE8G+R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZr5O1gAKCRAw5/Bqldv6
8sL9AJ9KkJfJPbHXXUWu1Li9Ym73pFMX8wCfRjwubEllBRrxjw2x0vYDjfurG5A=
=hC9L
-----END PGP SIGNATURE-----

--ol5gAA6YV1QE8G+R--
