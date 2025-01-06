Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE502CA8
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736187897; cv=none; b=OzZUtnTUjJnpcw+GH0F2xt5Z3Rp6FewepWNrNT0XWfq1jejb8hFOl1x/e4vha16GVr5iCWM/FwCUInfjF9BubsHVNdG9Kkzwr3HYUd5BsQvXeCMXMnqpIPTntEwx1GrhNpE26dngNzwEYQzl3zFFcyB2tXZxEg9qOCekG8PJl7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736187897; c=relaxed/simple;
	bh=j6TVC5Ezrn0Sm2iAKf9rba6dusqYLtDhN4Vy8vbWOzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGfW5BxqU6N8TsBRuBa7WehDdNTJATpMHSl0XhmlobUSkIrCQvO3flvvHf3jjyp0RlFPdAqgjyljV5LqchwMIUVnGTMSxIlNBzgHSqn9580d4ML2UozEICC8rSGkF9e/j1mEgjx9xFh6NlUEmIcK5LwGeSLEJElsySEJgK8ZH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Eq4zWaVd; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Eq4zWaVd"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0A6AF101EC1EC;
	Mon,  6 Jan 2025 19:24:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1736187892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HGgGXAQuJnsKrNAi89TbiyR3gYZ3HT6bRG0K0+hTBWo=;
	b=Eq4zWaVdFaGxR+RUbS0q2Ep5cM2UzXiPfMGpWP3NLQBI5Fg+eUk6L2daB2Y3a95zMWiLxd
	WK06RYkgMQnaP68FQJdSqp458nb6g8S2WXu4wf0gGogshF2G0Eig63e+skxIoums9LiQGn
	P/phH3mICXR7hTnCEyLq7NGiv/7rFdE0XfaRUgKTxgjZU60/stmoePis2Cyu/L6Gs9vJFJ
	OENgIoqRykV5cou1m81GPMuq1UECNB5/9smQa8FgBjrpYTX11vDzsr1krkPBH88wauoqQh
	0e34ihrXpAR7Uo3s2gbggWTWAJ0SZkOAqz5sLXb9kxhkAibQroLp/CeE6Rpkjw==
Date: Mon, 6 Jan 2025 19:24:49 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
Message-ID: <Z3wf8auGox9woav0@duo.ucw.cz>
References: <20250106151141.738050441@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L9p7JwpDuveKz4Sn"
Content-Disposition: inline
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--L9p7JwpDuveKz4Sn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here: (obsvx2 target is down)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

6.6, 5.15, 5.4 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--L9p7JwpDuveKz4Sn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ3wf8QAKCRAw5/Bqldv6
8qruAJiDOAbVUcMSLq1NIfhCBVmnqD6hAKCNCJ5I3fwRMMoVt9r1HRdc8fcUlQ==
=bZrp
-----END PGP SIGNATURE-----

--L9p7JwpDuveKz4Sn--
