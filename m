Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D491C17DFFC
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 19:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726084740; cv=none; b=pXRUlZHbxpEWmgwGMC7MVGlP4QmtpbRn+R6/fj31ZCCLvGfytXn0DbLaCDG7CKBGRQrm8beM7wb5EJVRaqt9+zbkOFzN6J2dzmnWlCCSKAAeqrs36tKzU05mRMAsHBnU+4d8cEJ+Ru0uEpCDMasFl9QyKq4TBe15FAeu8vnCeC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726084740; c=relaxed/simple;
	bh=Jx/XbIUPoBAtWeb37ct0nBB8w6KnbOkiVyDtaouvjrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3ldxo2CsS6etZASFVZDL6lmNMOHzcrGReQP76HfGFhgTq7t9/Naj8ZMSHyxC4aPS78gMIOyVjRV99SSRaSr5v20wtyNY3ajD+pZVsDquAQk6VMDyZW+27fmNuEaDSKCO+83OfMZ+osWoHYP6NjvzBX3T7dtHDL4usbLCjoPASU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 9915C1C009C; Wed, 11 Sep 2024 21:58:55 +0200 (CEST)
Date: Wed, 11 Sep 2024 21:58:55 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/185] 5.10.226-rc2 review
Message-ID: <ZuH2fxcX2CktXyKP@duo.ucw.cz>
References: <20240911130529.320360981@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yfdLI14yk+cb+n40"
Content-Disposition: inline
In-Reply-To: <20240911130529.320360981@linuxfoundation.org>


--yfdLI14yk+cb+n40
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.226 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yfdLI14yk+cb+n40
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZuH2fwAKCRAw5/Bqldv6
8jTxAJ4r7Yj/tsNyhPcyKvOdL6pkMuRvLgCfWFJw2eWqENXg0UQt8gKwYpQBf8I=
=tEwa
-----END PGP SIGNATURE-----

--yfdLI14yk+cb+n40--
