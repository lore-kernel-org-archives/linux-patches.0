Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A231D63FB
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 07:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760167964; cv=none; b=EqPvyB2i5CmblEWDe0EVMsa31s3+8JOsBkOQO7kyWw2BhZxYuGF4iBg2x2lkumGqHgRxpp0gRp4+UPx7H1CAZ9El/kbnzqypfAzQtHW1bCRtg/3VjOEtFODZcTiHdYF5GccaPDwl0M7jeDL4jMUVUNtkVMJR01fubO+ommPsKZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760167964; c=relaxed/simple;
	bh=JoXdpMxN3GauHPEeg+stKWW8b5Z4gTdU/i8zy40M/Qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8Ux1VhHWK/9htzfTCRPAZzCeM7LiNemUxpRXh/JLge5Ojmce47Wd9kC8BIzoQCcK5QzkzV+dDd/V2W9ey0jlPWzzWr7TfxEgi7UGduWdHpx9L0axiq36DCeMxXJwQkokhsnw/sD1uinrc7Q46qGGfhKLuOLypaNTTEw2TFUtq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=PmOa/8+K; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="PmOa/8+K"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A81CF103ABB41;
	Sat, 11 Oct 2025 09:32:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1760167959; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=fVms1xCvK8YpTMqzPboH7jUZ4clXDKKcxCouH9xtMCU=;
	b=PmOa/8+KAAg439unnL5FDKGVTO+v7ID18JGd7necJzKQwW1pyHFdZW5ZdHXXL7nSfdpAVT
	yav3ovG6UDmYiISJsJOcglwNmILeNNMdw+9AqBXXYhXATFQBWHvFLWJzTkBMzmhu9gcwLe
	7LiiCcqm13swTFHs7Sp4HSTtaPOvwQx1RFDEcZFgL3VVEikAelcnKqwVOX7tFUcw+lfKp/
	y2b1ok4X8hPmVHNOBSPex4MmeXbhxG2WuW0BR0bXEcYhuM/X6dMEoxhydzD2zzSycUgwLc
	yRR9HGZQ8c+V9A9t9ovhHgJnVtC7Trn/rrt77bxJWEKK47xWBrNZhFZwkkTbIg==
Date: Sat, 11 Oct 2025 09:32:36 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
Message-ID: <aOoIFBsosgU2uktK@duo.ucw.cz>
References: <20251010131333.420766773@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LRE7oHYaRJnAP2sI"
Content-Disposition: inline
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--LRE7oHYaRJnAP2sI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.16.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--LRE7oHYaRJnAP2sI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaOoIFAAKCRAw5/Bqldv6
8lEDAKCEvFsmNjZ/MCF463jphODSCsgS4QCguQFNWsbXcqSVJ+frmks77pN+cA8=
=CIaj
-----END PGP SIGNATURE-----

--LRE7oHYaRJnAP2sI--
