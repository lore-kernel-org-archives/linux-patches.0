Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02771EE02E
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 20:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743711782; cv=none; b=qzPbF0v6L6gtP4XYT/ydvB0Knn2hhiEIrgGckFxAZgBdCE1UU9gQGcGuiIZvCKVcg9dyOTfq7tibPgwr5Vy6tuOz3aa8Nyw5kokayfoB8rYwufxSrc5qkgEN00Mqy6bOg0X4MwuksBd3iLCsU4n4YpsTTGwx/6pAFW+fGCxpDBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743711782; c=relaxed/simple;
	bh=kv/27SbJuSIXTmhWnb+qdl98yr6+5eeCmGZTis71NNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+WgJCfnDOOE4EpVMyR4OHDM4YDWvYRHSR+YBkQQ4IrbeXb/LbJcbjToLglss++7yymIke6G02nvF62upl0DwvbsYTqHC/64wp3eOnXiqU6DxMb0+GTKDuyQk2Y/VCncUmNrIBZmRpX4dlA0q/RKdh75/zzPu6GqootZ/+JM020=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=DO7i7CQv; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="DO7i7CQv"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 950041026A6C2;
	Thu,  3 Apr 2025 22:22:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1743711777; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=1ArlMQj8XeUapHC5sD+RKab7T/b16esGJcv/bEjH5F8=;
	b=DO7i7CQv5w/dFaob6mQGKF0njph1dSN+yZiEHUgvsy11ZnsJCQ9N70DXau4xaiphIFSBcL
	RJ7YYgir3PhyVgztMYl5gkExJIdz7p9pNGjEAe2kCb1R1XdjdigRd0mriHnLDRi1o7x3hs
	miPRi6uc4mLBTzCmKBp3xl6oQi5ryk/cr6hB+RJynQVxRKLI6WV7JN1mbAWHOZKg2TALEB
	09lplowOE7v/92hcXgw71E/gl+XaKqxiuZcuh+q4c/hV5RUCfg2UbFJLZqLIBly0YfUZOh
	l/C0hj0yOXkl6+P0RAOMkYhFFyTxGktS/paOhdFiqNiEnWlr9D5OdL2VjbD4mg==
Date: Thu, 3 Apr 2025 22:22:51 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 00/23] 6.13.10-rc1 review
Message-ID: <Z+7uG8SUFmksDP8w@duo.ucw.cz>
References: <20250403151622.273788569@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PpefqU26Knk83jul"
Content-Disposition: inline
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--PpefqU26Knk83jul
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.13.10 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y

6.12 and 6.6 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PpefqU26Knk83jul
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ+7uGwAKCRAw5/Bqldv6
8nI9AJ9n3dCc30mlD5FEu+5km7wAefpR/gCcCMS6ey3eUMOtWjN4CHpCMgwPgR0=
=nTr+
-----END PGP SIGNATURE-----

--PpefqU26Knk83jul--
