Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C9B291C1F
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 19:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758223323; cv=none; b=fAsB45NG0seVvepnmYblxI/jUm2i9V2RLpelHW7M1GYnoX0YMLMcUYRJqlbZA0pQFoIGraq9GfwMhT/SIU+QZ9/AhY2iITABKygRjWbCCFk9EhFd9P8xFlP0oaPPVBCPzKYCXJ8RiShLdAcW9nUdwaiOpO6kwBGa1nvtdw/BVYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758223323; c=relaxed/simple;
	bh=/se16em7MEbgp0NbbT5daWyrol6E2zVVrMfkjzkIapQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRIyQXslpeDT3rMe9ksibfEMhE05D9r533fJGEV5DPHSuvUiRxBuN6c5mqvXhDEMFpccPonG6vegzI23aTUDkxvzkx4BON+b0OZS/eFqRx3OJki4j0RMaLmVnjxc8lWeuQr9c5xm5flUfIGQZPsXYlm6XMUNo6o2mfqZ2VpyyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=To/7T9mY; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="To/7T9mY"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0DA771038C109;
	Thu, 18 Sep 2025 21:21:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1758223318; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=iJuBXPG2Bh9NERc9QDLFVrPeqpcwJx8dyCLyIq/kXC4=;
	b=To/7T9mYv3z8GFyc5I/EjBnhiyDjPVOVY8oA9NyOSh57ljRJ+A7vpte6epIya+6We3HKlx
	dVNPjmE+7i33CIuqFrOSOOHhhu20SiBFfgFWTXFR3bVxuYud7CZjji6gh/hQxDAcZNXRnx
	OZ8gJiA01Trrv2eHS+mf16JcZE/Exu/1U+IG1B1ns2IOoMAE+m0nfRGLxetXatCOf/p6x7
	BnJngAsBRLn1Pr58TmVWj0cs3EBYJ1ilzhEXjBSyudHWEa7Te6mYgZzaSpSTvqht1S9n9f
	7o/RGojeoLSwWSZyt3BBi9PPKqhrqwT6sESEXEQ4eWwJNIlBDDVErE9fPOhy3w==
Date: Thu, 18 Sep 2025 21:21:52 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
Message-ID: <aMxb0EbmbJ9tiZdX@duo.ucw.cz>
References: <20250917123351.839989757@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FjvO7hMn5uzHW2qG"
Content-Disposition: inline
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--FjvO7hMn5uzHW2qG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.16.y

6.6 passes our testing, too.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--FjvO7hMn5uzHW2qG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaMxb0AAKCRAw5/Bqldv6
8tZpAJ9+mjG+Ve1qZtPiw25GZvCRQ3UvRACgjCRf9BQyVHXpeVJA99VNuuVpxDw=
=/rUR
-----END PGP SIGNATURE-----

--FjvO7hMn5uzHW2qG--
