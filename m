Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50C07173C
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721853863; cv=none; b=paABuBCNpo75+bsERX8Uy2B11Z0lx9+upv2moZMIe1Hu3GrTHe6MlQs76Z1qH0EWZU9z2+qffxXcCP8L+Teqc2r0zv64FyTtPfylf0RqL4ckQbYQM/pUF9/aGx0yuFQdxT4eXEW2p+RQdobUF6fCPicY33t6O/efvPtIIDNjbvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721853863; c=relaxed/simple;
	bh=tRFFpnNkFTCn6F9hWRoxPuhAwvFwiDH3vXBp30TlnJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEou8qNvXaVK7bTAyhx/6m861Th8UT3iOlVpBVoWyqOUEjdzE/pwCgWAUax5i8iFHmAWg5vSbVOvxNCkr2hSCy4jjqqxCH8U1K839Og4KmT+YcriG1axkgm+NejX5zdub/7kFRWV+PYbVwn9G62s54+WUjxJYIEjGbf1TCxS364=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 42A9D1C0082; Wed, 24 Jul 2024 22:44:14 +0200 (CEST)
Date: Wed, 24 Jul 2024 22:44:13 +0200
From: Pavel Machek <pavel@denx.de>
To: DAVIETTE <sevend@ecolauricella.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"allen.lkml@gmail.com" <allen.lkml@gmail.com>,
	"broonie@kernel.org" <broonie@kernel.org>,
	"conor@kernel.org" <conor@kernel.org>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"jonathanh@nvidia.com" <jonathanh@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	"patches@kernelci.org" <patches@kernelci.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"pavel@denx.de" <pavel@denx.de>, "rwarsow@gmx.de" <rwarsow@gmx.de>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"srw@sladewatkins.net" <srw@sladewatkins.net>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Message-ID: <ZqFnnVWNuouT83r+@duo.ucw.cz>
References: <BYAPR17MB20541144DDD717F5A48E5E5DD7AA2@BYAPR17MB2054.namprd17.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1FSJMhHn9SwfI8ay"
Content-Disposition: inline
In-Reply-To: <BYAPR17MB20541144DDD717F5A48E5E5DD7AA2@BYAPR17MB2054.namprd17.prod.outlook.com>


--1FSJMhHn9SwfI8ay
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2024-07-24 18:48:20, DAVIETTE wrote:
> Afternoon:
>=20
> Has any test on incorporation of muti platform data been seen using the P=
ATCH file ?
>=20
> Will the install cause support default models to reset.
>=20
> Any other information is welcomed and appreciated, Thanks.
>=20
> D.Lauricella

Has spam gotten smart with use of AI, or is this real?

Can you fix your mailer to to generate in-reply-to headers and try
again stating your question?

BR,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1FSJMhHn9SwfI8ay
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqFnnQAKCRAw5/Bqldv6
8rfJAJ0Q02nfe0QeU5bfe8BTBMXgv7bBYgCgu1HMRgTknNvji/43xUrIsFCd9tM=
=g0nH
-----END PGP SIGNATURE-----

--1FSJMhHn9SwfI8ay--
