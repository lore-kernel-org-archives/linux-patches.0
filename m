Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA9296FB6
	for <patches@lists.linux.dev>; Mon, 12 May 2025 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078228; cv=none; b=arXC+ixKC7ieI8qMNei4STNlx6prVz974tEVaZVzvHxzu8SgOMLVsJQY9ujz3BuQD5ECv5DKkVetWB2kqX/bqgYAXjlGq3lqT4A8MgAmTuT/Uf2GRORY533lJNcRHoWXqH6aeSe6bcnptKEdpJ65GX46eDznQ+Uew51L3q/9YHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078228; c=relaxed/simple;
	bh=paYXfIsRJ7Sul52q275mJ4s+uEoOmuwd2mnJVO2BJUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uvErvvzDPKT+kiXlaZWFXA7Z+zKlD7INSpiALCc0UC1ActBvUtNUPbjd856t/euxajI4FbCZ3Ugs3f0H6x1VW5dPyT7y3phTxvdSdoEvjLiVIe2l/Pis/a9pEtYItX7ApxUw8MpEO8EuMeeprvMDTmaDa75o2EKwGTX02UGo8C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=U3stpOp6; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="U3stpOp6"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D3A32101EC1D7;
	Mon, 12 May 2025 21:30:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1747078223; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=NDTgPShNji8ZRvPZDtLoTH/JEFcOSSzkcPvde8SdxMM=;
	b=U3stpOp6o6T2sQkZUvj8K35uUvf/gVMECjsUlNqgmn0nXJTgnAmpp+Q2EsHrSwcm8eYSsv
	u3q8CThJQvxcINvK6/FTs8dlTzec+bFGOe5ZyXrHVhoW6zTraYQ9SRczgPlTsAwlWqjIg0
	c4RdA/qmf09Q5a78l6fUoXeyXGQBQa+ReArVNJ8ZyCWuUpsTRWw2ciUZyjPhNyQdc/2sdC
	UR7J1XV84x/uQtd1TFbBhp+nnkrbO/+QEtuVHwUznwY2KxlqCF1Q75oEjNOCSAn1QNHpi/
	gr4Kg9jpvmQthy5MwfK+YljKV0iUvodpxRxR193VkOA9FkDUV0j8O1E7H/ncdA==
Date: Mon, 12 May 2025 21:30:14 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
Message-ID: <aCJMRuUis0Igzdpc@duo.ucw.cz>
References: <20250512172044.326436266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rsI9LoYjxb/SMvDv"
Content-Disposition: inline
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--rsI9LoYjxb/SMvDv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.

We are getting errors here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
813568284
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/100105=
30202

arch/x86/kernel/alternative.c: In function 'its_fini_mod':
1702
arch/x86/kernel/alternative.c:174:32: error: invalid use of undefined type =
'struct module'
1703
  174 |         for (int i =3D 0; i < mod->its_num_pages; i++) {
1704
      |                                ^~
1705
arch/x86/kernel/alternative.c:175:33: error: invalid use of undefined type =
'struct module'
1706
  175 |                 void *page =3D mod->its_page_array[i];
1707
      |                                 ^~
=2E..

6.12 has same problem, likely 6.6 too.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rsI9LoYjxb/SMvDv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaCJMRgAKCRAw5/Bqldv6
8gsbAJ0S4lTB3haYVGdM8cOPy0paFPPuigCgh88vWYqUcTM6B90yJpb9lfzLx/o=
=QIrn
-----END PGP SIGNATURE-----

--rsI9LoYjxb/SMvDv--
