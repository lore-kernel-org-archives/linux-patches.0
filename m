Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB821922C4
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778231; cv=none; b=lk1jlRcVBduVAn9RQTbr88rOcl/Ebr9M2OgTU5y8TlJ+4dDiupebArHKKwlFBi1xIrY99WB6i5Xc5FkArMZg30lN39AqYGuDMD6UY+z9PzOeKsxzVJbYdLWAKOqjL6bEcOmToDJdGl+P3uT5R9z1bxQkhAQEa4RhXHcK1HuivrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778231; c=relaxed/simple;
	bh=fG9xNuTscd+BK6XnKts4jb/KyoALWXwtTWifrKZj1nA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bKJT6gjbh3B/zQQDb7No98T7D5yP1+XKrrpYVII9a6Sjdqk8yxV7QixkI2nyd0JQ9bYJVZAxVrLlRkT0fsBWrWwvHVVNBY+jIQ4GJRO+zY7xL8aFhraCtxNu72J140qAbJS6kQdmmr5rBRREC2w+qIYwTs++qRplsheEWLROE8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=cdcY84WE; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="cdcY84WE"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 763401048CD13;
	Wed,  5 Feb 2025 18:57:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1738778226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zfMLIT8o7qIGzWCSQbfJ9DR55hKNeTQ38ODk2Ru4uzM=;
	b=cdcY84WE6yHU6kFn8W2UtBxp/GOJ6doWrNDPH3/oRwCr8Qliv9CefjmY60IJg2uyF7tH9X
	mpGfyksGA+99qIpunCr8eJTUeTEAB4SffBSGRFrGQa/sosf8U++e1vQbVS41x8vjWZ7wY5
	K2uXKv94Vj06FzCreL6v0bVwlP8m4W3bmcNvHlUR3Sxxp5a17yYVYwqRxh0thsOleTWsLd
	vT0YYNye20cXwMdvAhrlzga2aIHmv5tQWezMuloytk+XUQiXO2p0zTi0LP4pMYXIc54lIK
	F3u4cAR4Vnof9+2hTqeJ0BAmqICn0pJGUantStjOgHAhceKjqaaXYB+NRlGTfA==
Date: Wed, 5 Feb 2025 18:56:58 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
Message-ID: <Z6OmapsIAlCnZ8GW@duo.ucw.cz>
References: <20250205134456.221272033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HmVdHVe+dEdVqMgk"
Content-Disposition: inline
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--HmVdHVe+dEdVqMgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.13.2 release.
> There are 623 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here: (obsvx2 target is down)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.13.y

6.12 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

6.6 had some failures, I'm retrying.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HmVdHVe+dEdVqMgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ6OmagAKCRAw5/Bqldv6
8kv+AKCv2AEnN3toEullPx0fFaIE9VR52wCfRGZs8iUtSf15CMjg+E4AgXY/vSk=
=Bn4Z
-----END PGP SIGNATURE-----

--HmVdHVe+dEdVqMgk--
