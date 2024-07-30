Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE7238B
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 21:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722373346; cv=none; b=ag04jcOcbFtm/yFXlE3/nc6jcMUpvi1bdSwATG6KUrHcVsTonRfMqazGDQpdWU2oP1UVq3kqz8ZQQU3u1Yrbu2XZreQslhG86KnzQGWb+N0f4BS736E7UCXAEZ7bZEKCbjiX7LHBeSi8L5TLNfYwhjHNh7VJ06+XcJlqtjD/Ta4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722373346; c=relaxed/simple;
	bh=7/uf0OevkwywPkhARSogSiv4kSPEYbfvGA0Pcioqhj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wej8I19aNJSAwlavp3xCVedD0FSpGGnxvKv5Jgk9Yx7YIhkIDJRoVReQQX9/xY7jHwVn1Ar8nHDHW1F/UZ2/WubsxJ5cjoUPHXkNjWS9dw0iGWUfq7RsbFfrnOLTAcI2gG8mB1QSvYlHnpOEk5ZBNgCWB4n8Lvav+dbM9sNhNMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 7E7C71C0082; Tue, 30 Jul 2024 23:02:14 +0200 (CEST)
Date: Tue, 30 Jul 2024 23:02:13 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc1 review
Message-ID: <ZqlU1X8EVrdCLEY4@duo.ucw.cz>
References: <20240730151724.637682316@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nSoJ71Dp7WvavFwa"
Content-Disposition: inline
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>


--nSoJ71Dp7WvavFwa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.10.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nSoJ71Dp7WvavFwa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqlU1QAKCRAw5/Bqldv6
8lVxAJ9hRy3poXNWWDj8+CWwNr4Y55q7uwCfcYPEdg3iW3xUbVTajAqIKAyUB7k=
=Jx+p
-----END PGP SIGNATURE-----

--nSoJ71Dp7WvavFwa--
