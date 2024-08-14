Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1711B1400
	for <patches@lists.linux.dev>; Wed, 14 Aug 2024 12:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723637831; cv=none; b=eFC/dJCwvevabGcT+4uKFYrlOaihNz5ZSKNj5iDaawe0Lb9giq/nA7Pnf9nOU3ssJol8OurJt3iOZ757pErrAdsPIgRir5iS5FmdDj50PYDWoFPjOXSfKjEmaTxZjrB2pCcKx9M3vbwnBbxlBM0QTIdg0FSj+pU4Zi9hYAcVTfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723637831; c=relaxed/simple;
	bh=qWnpU0FL3BYwKNeluUfXzWfBOxcccUWo4UKNvbP0U1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZ3o+ElOuGjikDfqS+xcdGO57uDqCpkSle66K+hkuJygPjjyaLGVTPU92uxWOFoe/Lwhvq3VKg6MClUEbeneHgP7juHZtRritdH/Fldiv78cDqKPcCvAwVf5l37t3kbmm7+znbobNwx/tspHvtU5mSBnXfYEowAjf+J3MvuWxjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id AF73B1C0082; Wed, 14 Aug 2024 14:17:01 +0200 (CEST)
Date: Wed, 14 Aug 2024 14:17:01 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	fujita.tomonori@gmail.com, zhengzucheng@huawei.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
Message-ID: <ZrygPRGECbPEswtL@duo.ucw.cz>
References: <20240813061957.925312455@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="03LUWFP1oONQbrQ3"
Content-Disposition: inline
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>


--03LUWFP1oONQbrQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> FUJITA Tomonori <fujita.tomonori@gmail.com>
>     PCI: Add Edimax Vendor ID to pci_ids.h

This define is unused in at least 6.1-stable and older. We don't need
this patch.

> Zheng Zucheng <zhengzucheng@huawei.com>
>     sched/cputime: Fix mul_u64_u64_div_u64() precision for cputime

Comment here says:

+        * Because mul_u64_u64_div_u64() can approximate on some
+        * achitectures; enforce the constraint that: a*b/(b+c) <=3D a.

Afaict it should say "a*b/(a+b)"?

Best regards,
	   		 	     		      		Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--03LUWFP1oONQbrQ3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZrygPQAKCRAw5/Bqldv6
8nHnAJ9Q1vb5gw6oo4aNQftcBwQECnfxtQCgwJr6Mjoi2rsJ9+3mWAz7weP5lX4=
=EgxR
-----END PGP SIGNATURE-----

--03LUWFP1oONQbrQ3--
