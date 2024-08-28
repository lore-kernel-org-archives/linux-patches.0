Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3AD16132A
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 10:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724839738; cv=none; b=DYa9AUmFH47RlvQbDfVI8ZLsn+o5cn5e6W4HHDH8WgKTGZmtGP4NvLgWQxvSTN+isRxbwy7KUP9+lspSAjgASneMTpYAXAwWFBpxDeo38A2TyZiMbQkh9XCoLmbDx7YjV4ZxvOtDP8HMlbpOPsh2kSmtQHlKU0BqxO6Hyex2GQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724839738; c=relaxed/simple;
	bh=xV0P7iLUWANRkYciL//YE3bYgFBMfa6/iFXlqc1lhNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nyL+MaEn8wReGSJvBBn3a4Ta0Nt+D19Bzu2J8zdgWKADuz/m08gEmy8Dzg1YBkMxJi/o3wAibvDoAJyhIaMvzdPQQ6zbYBIUWNzWLr8hcFiTvAtHkF9O2VAbzRUOeFIuNSYpcZnqhWUwBSs9HvVfBsoni1uvJKF0/S/qBplbpm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id A65601C0082; Wed, 28 Aug 2024 12:08:52 +0200 (CEST)
Date: Wed, 28 Aug 2024 12:08:52 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Message-ID: <Zs73NFq5UiZdVxJw@duo.ucw.cz>
References: <20240827143838.192435816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRBFVEhV+Tsa0VY9"
Content-Disposition: inline
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>


--wRBFVEhV+Tsa0VY9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

6.6 and 6.10 test ok too, for us.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wRBFVEhV+Tsa0VY9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZs73NAAKCRAw5/Bqldv6
8tkNAJ9bDNAQRJYjYeVTukM2uatqjsixYwCgkOR6JE9r3HH+iZdm/W3PqnGEZCQ=
=nJmW
-----END PGP SIGNATURE-----

--wRBFVEhV+Tsa0VY9--
