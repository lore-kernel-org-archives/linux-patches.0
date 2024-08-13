Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F131DFD1
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723561298; cv=none; b=cxTIif8okwz9pmi5imxPNY+wOtTRtKqyq46zBaItrhc9ll1+JykOb12o4vMZTnPa84G7ntXYmasM/1LrWedI6KVy7YOLeURiCVZvZf97Ebpm6C3iRScCPtHcAUZlJ3VW/eVpn21H54rMXz2/5PKc4guMvBQ+E/XY+bHwn7NF5Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723561298; c=relaxed/simple;
	bh=A/AlOxlsuSdpqEDoTvL2YUZyZGDkvhb06MuY9ZUc+a8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfviZppcHfVLSV0HIVwwW8/qc52/rzvZxCtpwK92qiJwabigsozupgF2AaYD0qcxR0CmLF3QJrq+3pNa4/8XnahH2cFhsiCKTo2KZbtNCykppj3JNNlR0N3HJ1FHJErM7pyf3CKsuEXuAYcrMFVuXlT81kVjHcQCZDPVMN7kw9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 219491C008E; Tue, 13 Aug 2024 17:01:34 +0200 (CEST)
Date: Tue, 13 Aug 2024 17:01:33 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
Message-ID: <Zrt1TREbs0mmwu31@duo.ucw.cz>
References: <20240813061957.925312455@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ww8pdUQJyKOAy99S"
Content-Disposition: inline
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>


--ww8pdUQJyKOAy99S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
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

--ww8pdUQJyKOAy99S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZrt1TQAKCRAw5/Bqldv6
8vU7AKCpgPTbyi9d1inXG6I8lD2r4PhUIQCggyex+DoGYnIxvaVAAWndcQk8AHQ=
=ZcZd
-----END PGP SIGNATURE-----

--ww8pdUQJyKOAy99S--
