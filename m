Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E7B2E3EB
	for <patches@lists.linux.dev>; Fri, 24 May 2024 11:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716549709; cv=none; b=W0JNVBPqZ2gFGwcC3XVzIU/GG1KhwAUrW2LHAN//Iu5rQi2qQ19dHxFGLKAmVv8PPdkpUvMPgZ5W9GWLD4yl9sLXD4SZ3HyoyFBS+ppsnoD3+jjR++FQmzRCeRxB/23AzpBhAST3KDoHNjIby5faU72zB+tgxl70zsLGZCGj6YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716549709; c=relaxed/simple;
	bh=iNaLU3x3F9DnZTL/G2EVoXtFqgEqnENgimI7Dtu8GWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6Xps23iAQwtE5cB8+kcwEbjXtrKsCHTx6dDlSxjh2Q8kEpaRAUtWEKlL+c8zV9C1sK9WejOWoGXF6UXwUFjtLM//nnfEQximp3HYHgRd6+bqgF0eykcBY06le9QzjOKtVGFjMZ1mbTMb7T8fSvmOKF16eqHV0zi8yyCnfMae9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 9F3A61C0094; Fri, 24 May 2024 13:21:37 +0200 (CEST)
Date: Fri, 24 May 2024 13:21:37 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
Message-ID: <ZlB4Qcryqo6YNWPh@duo.ucw.cz>
References: <20240523130332.496202557@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+7R2Yu/myQgOF7UR"
Content-Disposition: inline
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>


--+7R2Yu/myQgOF7UR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
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

--+7R2Yu/myQgOF7UR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZlB4QQAKCRAw5/Bqldv6
8qldAKC5ifYgfrZheQqCFYE2JH1FgjRl9gCfRM0TRwKmzBg+6UCu8hv02q0Dtxs=
=iYhs
-----END PGP SIGNATURE-----

--+7R2Yu/myQgOF7UR--
