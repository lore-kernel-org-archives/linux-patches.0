Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A09145FEE
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712837055; cv=none; b=im18Q5Yxul722TJsAW4zOHaUuAm7H8X3LlzXBIgLXEgLwr23jbZN96zOpVyY9PlLx9vzQLymi8+xNHepKbJ8aZNQNRrst1hhLjhni/gTgJkNb7D8hJXoL65v+4RxspctlXpGYcfFDAkM2VnXg/cSakWCjrH1y0MYWBAN8QcRbk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712837055; c=relaxed/simple;
	bh=OTidSHC1PvaX9rw5g3FP+ojl1bFtEeGrm/h0RE5tgUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KfW71uXg3X4pJi3U5OvpDeM4EnoLiq+LsvbN+wsuT3FcKDFX7JgW8c1NMmjG1tgdChZswin+rVBnM2tlSvQ5bJ+w5+0zB1rb9AREVX07X3vxnUWmc3IRQ8oiBR/qfkZUWx+11anMtLcwARbKtXgoYFXgYxOmJf+vUChESjt+/1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 990A91C0083; Thu, 11 Apr 2024 14:04:12 +0200 (CEST)
Date: Thu, 11 Apr 2024 14:04:12 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/83] 6.1.86-rc1 review
Message-ID: <ZhfRvBksJitvLbgB@duo.ucw.cz>
References: <20240411095412.671665933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PcOhETxjHIz/2XeB"
Content-Disposition: inline
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>


--PcOhETxjHIz/2XeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.86 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Linux 5.15.155-rc1 (857e7024b96f), 5.4.274-rc1 (82d3ef764065),
6.6.27-rc1 (3126167a036c) and 6.8.6-rc1 (1e41d76814ed) tests are
passing, too.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PcOhETxjHIz/2XeB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZhfRvAAKCRAw5/Bqldv6
8sTtAJsEAqtKL3c4g0FdC9d5GrnXojhVkwCeMttpkuxFXpevvtWEtyxdCo8QH4g=
=i0eI
-----END PGP SIGNATURE-----

--PcOhETxjHIz/2XeB--
