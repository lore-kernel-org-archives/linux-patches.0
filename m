Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3E319925B
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725543833; cv=none; b=Rc1xDr1EP5QyC4syTkC1uEz1Ti63+ICO5h49ARPj3rABmjeU1c7bm547akPXLpF7QJNF8sWdqaVhU9qapRNulizM985rqXFxcEDpuJDD8bawUTrR8gign033CVWx1DFpyAlyTgu+JludpbIL9IAc67opzpcva6+qoFX/8E7ob/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725543833; c=relaxed/simple;
	bh=PkNt6kHkJvTmmkhz7Ij2z36xJivzgPBWs53QH8fsNcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rBedVoxSN3eJroOKIZxu3FEl6clsUd8km47gq24KdJuk6xygaJVDG39bNMFH1YIl7TgZWNtcyY4bjDA5PtkuS28+47yhgrgqhKlFzKrvm280T06UQQUt8SeOSrs7XV9tGKDlkcQiQZryXNBwhUFKnn5yBKFvpGF8tfRxD9q8ehE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 51F951C009D; Thu,  5 Sep 2024 15:43:43 +0200 (CEST)
Date: Thu, 5 Sep 2024 15:43:42 +0200
From: Pavel Machek <pavel@denx.de>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/184] 6.10.9-rc1 review
Message-ID: <Ztm1jiYCcv8cUEwG@duo.ucw.cz>
References: <20240905093732.239411633@linuxfoundation.org>
 <CA+G9fYsppY-GyoCFFbAu1q7PdynMLKn024J3CenbN12eefaDwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yE2BAdk9sXh2yg0j"
Content-Disposition: inline
In-Reply-To: <CA+G9fYsppY-GyoCFFbAu1q7PdynMLKn024J3CenbN12eefaDwA@mail.gmail.com>


--yE2BAdk9sXh2yg0j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 6.10.9 release.
> > There are 184 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.10.9-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> The following build errors noticed on arm64 on
> stable-rc linux.6.6.y and linux.6.10.y
>=20
> drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_advertise_quirks':
> drivers/ufs/host/ufs-qcom.c:862:32: error:
> 'UFSHCD_QUIRK_BROKEN_LSDBS_CAP' undeclared (first use in this
> function); did you mean 'UFSHCD_QUIRK_BROKEN_UIC_CMD'?
>   862 |                 hba->quirks |=3D UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
>       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                UFSHCD_QUIRK_BROKEN_UIC_CMD
>=20
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

We see that one, too, on 6.10 and 6.6. 6.1 does not seem to have this
problem.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yE2BAdk9sXh2yg0j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtm1jgAKCRAw5/Bqldv6
8l42AKCPzC7rb972sEduGGeEaN+8NDsSgQCgqev5wrwNyTkvtRKHLa1s7oHPu5s=
=OwmN
-----END PGP SIGNATURE-----

--yE2BAdk9sXh2yg0j--
