Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A787450E2
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 09:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722417055; cv=none; b=LedGDBeenr+4bE44ebXwNBbL3GkdEhVen1r2o2fz70F7RQOXxCguRgaVeF4BY0YGYm3sOXAkWX7OWX2p/MVQeGA5VeIXsUwbkdNV3AtpNXCtJ/FjoAy5tNgJ294ThR2Y2e7ruW+Tc1YYpumxJSc5jVVBEiQXlDkVT0DL36uj4iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722417055; c=relaxed/simple;
	bh=P2NFiq7iHa8wkJwoUn5xhukmSmCPpK3GkS+gpBXNgd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKoyOdhVAvzTC35O9b4HQae+Emhjt02se7RQdl6lYyvPzcLlpuvpsMU4LCFMp5bGYD0BLf2Ko40M4A0+rZpfHey+UtTkNRHTUZ4sZJuWu7wbVPvDNMabps84FXVnk2vnGDWyYO/bZ8lVFx3V8huOpytyUF2NCUjU6AXT0TrDnoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id B9F5D1C0082; Wed, 31 Jul 2024 11:10:50 +0200 (CEST)
Date: Wed, 31 Jul 2024 11:10:50 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc2 review
Message-ID: <Zqn/mmF1HF1AEsi7@duo.ucw.cz>
References: <20240731073248.306752137@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRF42W1E5LprBaNv"
Content-Disposition: inline
In-Reply-To: <20240731073248.306752137@linuxfoundation.org>


--QRF42W1E5LprBaNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see build problems:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
394947350

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/747008=
4220

drivers/net/virtio_net.c: In function 'virtnet_poll_cleantx':
4494
drivers/net/virtio_net.c:2334:1: error: invalid use of void expression
4495
 2334 | +                       free_old_xmit(sq, !!budget);
4496
      | ^
4497

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QRF42W1E5LprBaNv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqn/mgAKCRAw5/Bqldv6
8hIsAKC+VtdMN/yhTVytR9XP8mwy8u2cgACfVMaeTHJCEm3q2GDiR3SlGRJ4e3w=
=yhPz
-----END PGP SIGNATURE-----

--QRF42W1E5LprBaNv--
