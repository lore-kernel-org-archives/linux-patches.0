Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6A423183F
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 22:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416899; cv=none; b=dlknk2s0YqRfEjOVCoHjsCa0dZw3gMwz8Y62tArC3eMgzw1vhRemOCQlLQyvVH3HKnQNZ0y9s3SdbWlDfqtnpn8Nt0/f+Beo11kGmM0PBcFI0xtYuVqYCV0UtbfPY8eOgANtC3H/005rEDxRt7X8LeYgaNVFadC5ueA7MNrlOFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416899; c=relaxed/simple;
	bh=F4xFscgnXxUdXXVlW7rBDOWX9G9F9afCkEYYRLdirSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A7ZASaieFVr4VVBL4KVohP+KDObey0hlCIFD89ncxJRH09/2f9e6p73OL7rujBczRAQONe3emS+5/Vh3E+1DRRxXgiUQr9wF1Xdt5XLvr19oP/Ek4puHeHCBxV2lVdTlANPnZVW9Qv/fhsb3FcPUoBwVhyuR6Ipe72Qe8CaHeaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=NevYAIZ4; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="NevYAIZ4"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AE07F10D93C;
	Fri,  6 Feb 2026 23:28:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1770416897;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=T53oAoFRDrKT/uKvG1YWBbUpNFyAUiwKPz8WujNtwwA=;
	b=NevYAIZ4W5b/m4GW4IHKkYttM0jDOi6pqFCqj6WSVzuDK/jDxCwfWtnBnxfXL7Sk+OBDur
	vxGm/Ty/PRUzZKvvQdhqCxKGiyF+xW/KtikwP7948gM9Oc8HpVFcMjKKpP37e8DeYrZPjL
	acIwKLXS9Dn2Wyqlh+Q6GCb4A7+xMxfRlH4ES5GLI3+6tJ+umTtPnBh+2n2FnLu8MnTbBe
	D8QLtH5qJ3uJ4QOs7Db3t7HdUw/QTqz3vGnMpZr4NbIpDW+RQFr+LLWIQrLxetTbET0gLL
	Q6w3CgEkQDb+dNWI0t05KrXEJL6iFixHJrHt6brjwwZ/T9ge9JBxeSPMt2tLtw==
Date: Fri, 6 Feb 2026 23:28:14 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/160] 5.10.249-rc2 review
Message-ID: <aYZq/rESBhRACquz@duo.ucw.cz>
References: <20260205143430.733102763@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NmbQ06LK354nvEAT"
Content-Disposition: inline
In-Reply-To: <20260205143430.733102763@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--NmbQ06LK354nvEAT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.249 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel
--=20
In cooperation with Nabla.

--NmbQ06LK354nvEAT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaYZq/gAKCRAw5/Bqldv6
8vGkAKDDLT+0WJHBT/UC0kUk37xr8u2DuQCeK2mZsv+lxpIIZA8R7xxOCTyYB0A=
=H0rL
-----END PGP SIGNATURE-----

--NmbQ06LK354nvEAT--
