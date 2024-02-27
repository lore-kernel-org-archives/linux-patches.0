Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C14EB43
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709058470; cv=none; b=e/fb/Hk9n/qLKnkRDVn2CAHR7oQEzz0WqTPNen+jzE7Q1ZxH8pjBHXelv5mK/EVwPeGv1pTKCQE3MIBchjSQpc5eo1SUZ4iQ5bc2Yc3GEc/SKdQUQt37Bw6wxPe4udK5nAwn5KQr1cOF6QsvgIsXiJLztt9bYg0m49giNUFR5P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709058470; c=relaxed/simple;
	bh=FE/Yk8YLY9Ki7qu+177mOcqpLuFn9AEIfH2fHooNBFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgMKEu3PnuIDkcF7LTMWkz7tMzfoBw4rzUkIEFzyHaFZFQAXutXldbbBbb3fMRwgk0d6stcQVdm/Ga6ukjMo0bWfr1hNk8+O1MsH5UaHLd6hOJCZYhbJD5z2rBWslmfe6X7+1xcat0lBEnIoYzM2BFPKPKkOhYHOD6MuS4HARhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 01E881C0082; Tue, 27 Feb 2024 19:27:46 +0100 (CET)
Date: Tue, 27 Feb 2024 19:27:45 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/195] 6.1.80-rc1 review
Message-ID: <Zd4poRdmw4j534yW@duo.ucw.cz>
References: <20240227131610.391465389@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bkQ9v4Mryj6BexHU"
Content-Disposition: inline
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>


--bkQ9v4Mryj6BexHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.80 release.
> There are 195 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bkQ9v4Mryj6BexHU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZd4poQAKCRAw5/Bqldv6
8hAOAJ4/fpe5OVgLIfvMeUIp+o9rTngouACfcqKJcWkixOQhveXM4Ipukfi2zkw=
=dl0t
-----END PGP SIGNATURE-----

--bkQ9v4Mryj6BexHU--
