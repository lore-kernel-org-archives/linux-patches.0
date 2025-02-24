Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4C613C3F6
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 21:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740431358; cv=none; b=Spo9W+wE1u0DEiRK02OOatvzxH+zjpykuW280k8YLdUgAp5/P8e92MgNHsdYKOnvGa7SqoUGRhYrgQ6Zc2GBfCxlUNjIzIUR2JzcRgdvnqydgWH19/dkpngrK6EKBC5c/WQQOIjiPtK7SeAYxbgv6al333qmTZHThOA+KRwHMF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740431358; c=relaxed/simple;
	bh=guqJxAKXDfn634VndPunaNjT9uS40FqYaHe1iRQ91Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BM0t82qfibPlgaXheVEnfgV79bfcvyyrj5zZBVUFJDmuNIyc8hDer4AwZoaMRYdlFy7BywZsZzN4hMRtNe8PRfU6CH1O86ed2qFOX4X7o9K0u2ZPMKLE/kZa871FFyzbJusJ6UzmyyEuQmkz1jDSL88vJBSAd+Msuo7Ot1Q8nVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=hyHc/FsN; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="hyHc/FsN"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5709510382F1F;
	Mon, 24 Feb 2025 22:09:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1740431352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gCFTUJhvP7sYPpfnNbKkCvTj6m0PeLY9YrwPgvAE7zM=;
	b=hyHc/FsNBDdoScpDZW8ImxYryCq04KF0/aunnESBYUYsRf8HzG/idd8VmYvK71OKFNzsWP
	asY0sjWf7WDjdpkHZewqzefdNRcWVokIOKqfQ+9dO3/5vs4XhvvhlcMtSVSRymetQX0JVF
	FrcUVyjGhXP57Ld1WWT9ZLC4EN5SapHW64hyaBLPCfMIpNlbtZZ9jaJTP2ORvZG6hrAlwn
	gxK5C3AkxHN9Dq/vkBtcgJ1zTXrIW3XyMPj3iYrTJBoxFSLjRa/Qmav32v80TxBgCSov5b
	cMufO354Az5jH06mYgdJQ9vND4OR5i2TGBsvhY8yoUx15PJLKaIv+ldWX5le1Q==
Date: Mon, 24 Feb 2025 22:09:05 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
Message-ID: <Z7zf8X5UoDtpX4FS@duo.ucw.cz>
References: <20250224142604.442289573@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lwAjGOtVX5NJEWC"
Content-Disposition: inline
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--0lwAjGOtVX5NJEWC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.13.5 release.
> There are 138 patches in this series, all will be posted as a response
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

--0lwAjGOtVX5NJEWC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ7zf8QAKCRAw5/Bqldv6
8omFAJ0a8d7UT/lNuUu5714XGT1Ct36W0wCcCixYO1ePu/aQNrUyntkTrpS9e+0=
=rEnU
-----END PGP SIGNATURE-----

--0lwAjGOtVX5NJEWC--
