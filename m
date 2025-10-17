Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B695924DCE5
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 19:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760729056; cv=none; b=W32+TdctLAHH4hvc0F5VYGlxlyx1MKA3osCKjcMGNjRDUZF0ZX3qRFVFJjr0m0w0sWFVp8GJrqHYv5mUXpCAv7PL9LKWvmDFNf7wwPPIYiBjOFCBniTQ9QcZw69r1PG7lTYzsIaHm6j6VixvPFBBrLFU5GWNHILDTQgPNfrcpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760729056; c=relaxed/simple;
	bh=zoXo2CsMiO+57OQRDICB7g3rOgCwHyLJqTzhSgWay4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2HgeY4ntRbJ0KvBJkf2OX/yvhZ7ES3xQtoKKD7CarfrZcjdzj6N++jwtcjem5uv3sm9/lJ/iSf8Vf1tifTF1YbCqKjVF+LKXtSGsUA+ZjsFWOMOO7UN2spqAtCqr8DtwZheccp61iV4D2AGntrtdx1B4X0XWR4KtOgRcUBJ0IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=OG+iKF2o; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="OG+iKF2o"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id CAD87101DB819;
	Fri, 17 Oct 2025 21:24:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1760729050; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=tYaVe4HHj/+un6U4bWnS4Cwhie2daT8nNvncpcprfjM=;
	b=OG+iKF2oGvZAQiTExVLjkZPL84fphaechffdmhTZnIIxZ7b6it35YCl8+tAs9AIisy7+/R
	k24C34+ejVUVX4ZMxPz9j0d88xbVzFF+S9BJBAKM6rg8JCEd15fpvJwMejwSMPM+s6edvs
	NdCeVUu/wqX2+b7jq22QQdPHpfoKaZqMMEd7Ei7brKrWb+R3F5CBsG02pziHyyTRO3IK/L
	6Olyx6R8SmRO4fbR7xnVvFSog7OmHDHLtKSKPrSJs8cWKaErHrdNdI742I2kXNZdcxqe7p
	jN1vGzt1bEJ/DW0nyipzexUmofpFcE/aFgCKch+ZYf5vYYviiHLOd1ViXXLYCA==
Date: Fri, 17 Oct 2025 21:24:05 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.1 000/168] 6.1.157-rc1 review
Message-ID: <aPKX1bIahbP1ojej@duo.ucw.cz>
References: <20251017145129.000176255@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uDc7UP3vOT1NxHqS"
Content-Disposition: inline
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--uDc7UP3vOT1NxHqS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.157 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uDc7UP3vOT1NxHqS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaPKX1QAKCRAw5/Bqldv6
8gwpAKCGla1ZvUBO2QbKeYkeCb9E9QovhQCfUsIA/mh72tH6j67TJarJyDYkx2E=
=dRfy
-----END PGP SIGNATURE-----

--uDc7UP3vOT1NxHqS--
