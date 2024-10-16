Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC0204F88
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729070811; cv=none; b=qM3sImRVvJWgegXXmRxAcJ+pb6dV7yrTa2O1pfBhU/Lq/1Nn4HrZ0ojjsRx6uY9YwKnt4HW46KjD4Us8FdlzyZTIfCAvoWWwShacIWhXkKnTMojoi41voadqKftqNYTO3drKIeef2Dfq3qJX4t53Ov5M40Z+c776mfD5KY7gjcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729070811; c=relaxed/simple;
	bh=YGHWvoxG2pyqDKH0UP9LsHzP6LnWgKsjsLK4toqWR3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YiAOECV+JKqm8vGILsKoQ5NUREZwI0JTtFt0IfsG7MdzMOKh0wunk3EOfzJIQ3hnYh/2oCa1RcRl46da64G0pHfiCcAk6yh9HbtSFdr1Q3CfyHOvLlo3j54jN26J9IFZfSJ0pNB9ygyg/et1lUUmTtB2sr6YpDYky4ae5VoHkHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 74C7B1C00A2; Wed, 16 Oct 2024 11:26:48 +0200 (CEST)
Date: Wed, 16 Oct 2024 11:26:48 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/211] 6.6.57-rc2 review
Message-ID: <Zw+G2Exqt3JTfT/b@duo.ucw.cz>
References: <20241015112327.341300635@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GSN7by6hg8L43Dy/"
Content-Disposition: inline
In-Reply-To: <20241015112327.341300635@linuxfoundation.org>


--GSN7by6hg8L43Dy/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.6.57 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

There's regression inherited from mainline according to our testing.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
497863007

6.11 is affected too, lets discuss it there.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--GSN7by6hg8L43Dy/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZw+G2AAKCRAw5/Bqldv6
8pfHAKCMA9iYu6r9N1feJxGjzr+7dOFfPACfcjQUlGvp3S754zmDDfOcNEyQoQE=
=44Yn
-----END PGP SIGNATURE-----

--GSN7by6hg8L43Dy/--
