Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CA11F4FA8
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 11:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730978786; cv=none; b=PckmaCO0u7bNxwbADf1tdlgXaCSQ4AKBRmT+ZC8LQgHT9piytHjY4KEDdmfk2Wm8ISDXhM96pr8vy66cq/i5sa3lURVVXh/vqP7JbeiGZMzkz0HC02joSi24pIqHFftxTmZbQfZBA2nyihT68tU4VcljBtHeM4Nwvqsvd2JVVmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730978786; c=relaxed/simple;
	bh=AP1r37wh364kl0yFfqEBPH7GMuovIDo94kuiuFkNLT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OClrlxtYfDiPbJKiZkhguHFmCIUvXB7F5u3yZrYxtswv3KtkICqSAg+q5h82kYpf7OH0pjFL9c+I+RfJdC9apP16l/xlekKq5MzyaxqnwJzJKn0JDbtX0lzqC5DX4i+O3KNsX4E9v1wWQm7hjQdH7NkksqcMzUNxRnx8FBKzT+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 4F05A1C00A0; Thu,  7 Nov 2024 12:26:22 +0100 (CET)
Date: Thu, 7 Nov 2024 12:26:21 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
Message-ID: <Zyyj3ehH8w1zPWlw@duo.ucw.cz>
References: <20241107063342.964868073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9glvebqAqshtow0q"
Content-Disposition: inline
In-Reply-To: <20241107063342.964868073@linuxfoundation.org>


--9glvebqAqshtow0q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.323 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9glvebqAqshtow0q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZyyj3QAKCRAw5/Bqldv6
8mkiAJ4/cuaKxQtZCIQeJ/fGFaZOIMr5wQCfVa0sFZyPUL7+JqNVgmn2/YREMeo=
=hsRZ
-----END PGP SIGNATURE-----

--9glvebqAqshtow0q--
