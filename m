Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C24341AC1
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761908771; cv=none; b=l0y/tB6zmcbef3yNzO6OtWGOLiUA5+YRG3KGyhcy27xPtq3iSU44ArkpPdbQBsOyN7d3YuYRD6r67WRZU0Nv7ynBeSZD14OTwPjlN1tAxG4mfigyXtuu7ZL2cS9U7KomI/Ezx8R+T36XGr99bFTtCBFlsvLyn5VFH90Ebjp1O5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761908771; c=relaxed/simple;
	bh=51OoLO/nAUAQVgxY+OcaFrn5prW6jF8TI0m8fe+wZ6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlBKUfGxo/gJX0yvseybkO5pA6QZS+E4CPBB6aVhg4UUAmuILfvIkMCmnZx1GEp6HJ2j24wUBzcMX1a9FXFQcDX7MX8eqfP0k9tGzXErnPyGi5/rkZYEKZsOGltzA0BgxlAT6qbmcCY71/LzDC8iZZB24coDrnqimhgjTm9mFUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=CUYJmHH3; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="CUYJmHH3"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id BC6D6101C54D8;
	Fri, 31 Oct 2025 12:05:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1761908758; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=U/Qb2akVnR5wG2bYWLpz3odKtl+4JnVv3SLjI7ywnZk=;
	b=CUYJmHH3g6+zgU+oCJnQcScOJxgri/Tc46kMjT9heUlefpjEQA/prtQolvi0MLKr1z59dc
	trqT6yTlrrlWV9Z3GPR8xrd8FVQIgKOuSeBAW5pJHUYiDEDKnMRCXBQMbIXBkUWZbJF0GX
	0xbNtC8QENePsn3jmvmxFh9jnIxf2LUxBO6uYYebu76ZwAD3koJ86HynUWV0LR3E8S5v4t
	c3Pmr8b/vAECD3fjomoprcr36BlHClk+pg7P4W9k1zrubNRcfFqQbztUAQK8T+qZAev+8h
	KWU7wcmLdOdpk2FYduHMH0xHY7a92kPCKAcrEvKBs/0F/CE9ph5myRThe48Qcg==
Date: Fri, 31 Oct 2025 12:05:52 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
Message-ID: <aQSYEGikUQGuXCGJ@duo.ucw.cz>
References: <20251027183501.227243846@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNOs1RKkaLtORZgd"
Content-Disposition: inline
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--PNOs1RKkaLtORZgd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
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

--PNOs1RKkaLtORZgd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaQSYEAAKCRAw5/Bqldv6
8h6DAKCxzucKYl7q/pSryl+NfAhQIj8/CgCeKxq/aBvMV3YI1tbuIWD0FVgiCVg=
=M+Th
-----END PGP SIGNATURE-----

--PNOs1RKkaLtORZgd--
