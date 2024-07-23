Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C463F13F456
	for <patches@lists.linux.dev>; Tue, 23 Jul 2024 19:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721764229; cv=none; b=uu1vuSlGSwO83wMFab8dXeOzhc0vPtAiT31ttavuhJG2nvV5PZjFp7lN6Xz2ASmHio7rhPk8J4wEdgHufBwKBPcSykAlefYWHyqICrm8ocJ76sRq49BYTfrMLNm52G/BOPC1yq8iwqOF1RNcNxxbSJ8H2OffDEDbtwln11q/hY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721764229; c=relaxed/simple;
	bh=ADdpkwbwR3T/L4KoLCfJzPkwbsNcv6jSTx+Pv0eDwGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITbpD3300UWDe3/xSi3e62MdTJLSRdfk0wG+V1HdusPkoTsW12rE3SAbsqA/p31pbUQsQYHOpKYTLyw81OskvorsZT7MR2nQLLZQC1j7gTF4peG8OTghBwE9UatK1DW0wjTURK+vWvaWtZOWg1sTCQd8+ChHz9pvyjBW4qLQvVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 3EC4B1C0082; Tue, 23 Jul 2024 21:50:19 +0200 (CEST)
Date: Tue, 23 Jul 2024 21:50:18 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/105] 6.1.101-rc1 review
Message-ID: <ZqAJehfxpzE5SI2S@duo.ucw.cz>
References: <20240723180402.490567226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FpvG4RfpDJ/CopU5"
Content-Disposition: inline
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>


--FpvG4RfpDJ/CopU5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.101 release.
> There are 105 patches in this series, all will be posted as a response
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

--FpvG4RfpDJ/CopU5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZqAJegAKCRAw5/Bqldv6
8tdPAJ9aztYl6oH1TOwJ5xzvFSo4EvckCACgo/vLgt6CsAjTcpgeZ21RToaqDX4=
=FrRe
-----END PGP SIGNATURE-----

--FpvG4RfpDJ/CopU5--
