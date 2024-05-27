Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D18517E8F6
	for <patches@lists.linux.dev>; Mon, 27 May 2024 21:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716845024; cv=none; b=nt6BZM1XQ9jXkZpE36LCNrmuIBuz3u1NDr6KhJXAkkrGUrm7oGEdMtwQdyafT+2ARteatQCZhT/8DHxNLLrWZSMqUJ1dkaJLrnK2EEgvu2YITGYd1EaHYJdu4FDdXTpUBd8NGUcaFEt/WnH1RkNrqvHgm5qQ5Kn4PBLPP4CVBfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716845024; c=relaxed/simple;
	bh=EuG0n7WjdidwMNkKKCkD66ipaMdifKkclzGEPwS4AWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucWwLIgmQArdJ6Lz3zsKmGtRk0I+A67bdmXxFXNQZbFf7rhp5MqBMfWIXNWfdeGKsj9xg/9pw16V1mDZjkmNs49kPJVX9aIMZvnKbHtzQ26yRi6PXW0Qws2fZ1DrH2edlAZlGo35F1AHYMcsHdtdUa3qM36VxhB4/0T8uk7241A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 80E861C0096; Mon, 27 May 2024 23:23:32 +0200 (CEST)
Date: Mon, 27 May 2024 23:23:31 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/427] 6.9.3-rc1 review
Message-ID: <ZlT506xwTYWg72Jj@duo.ucw.cz>
References: <20240527185601.713589927@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="15VYIY5feoL7t89D"
Content-Disposition: inline
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>


--15VYIY5feoL7t89D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.3 release.
> There are 427 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

6.8 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.8.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--15VYIY5feoL7t89D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZlT50wAKCRAw5/Bqldv6
8m84AKCwNIbOu2dtCTmq4emwR03HGhNdbgCgttMkKHVcTqgMZa0ibekr1ZEe77c=
=2atT
-----END PGP SIGNATURE-----

--15VYIY5feoL7t89D--
