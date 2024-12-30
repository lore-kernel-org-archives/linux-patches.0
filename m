Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A97F191F88
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 19:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735586976; cv=none; b=IucS1G+gINXbw/qBsJPQH252aRmKm0zDmICi1zIdw0osD6AhW9R+9+tGkxfiIsFTbtAH0I1eEtFO6kIBwlCLcikjFODAvyQ4DR0J5QnHSt7nYGSjCu5DfTqh94mzH5QLqFpKbxKZFwxKpz5Xe4ACaR0btZOCIOsQWdHhoLzSSMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735586976; c=relaxed/simple;
	bh=RBV7AVCmtT/t1t0VhW6vLY6hFofVcUSbLA2tcG3dZLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gp1oEaBGwINHmzqFUPMLBTr1Y54GmTcgfz2cwcxrQ+Y2XKGi0+fpNjsFB7yzF3xPvUJ4SdZIx0ddgnEo0DKnhBEIQKin32IQ6h0XN3p3cSAnoLO4jBPEFg2/KRczTo2tsT1OyDm66Ww2wxZI/UZKF61XGgKMret5MsYcmuqJsMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=DQJ48z07; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="DQJ48z07"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3163B10485582;
	Mon, 30 Dec 2024 20:29:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1735586971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PPBKm9op2Ao6jtgaEMtViH/5jsI/m27bLxA5CXn+6ic=;
	b=DQJ48z07SsUEtddAIEzAXPv3nbBstcB2w6NiAWVn6XJSmCoNwvpTnH4trGZOASAfz20WOO
	Z/U4z0NMVEUbLIdx/jzT8uBIrehQxGax6/+3U3RZq8tbDYN4AWafHCxAG9oxvc+OqFlly+
	IWQ4Yo1/EszJh1/5WBjJvH0TnVoX7ozLU/1V1KalQ9SDBqGEPQ79HZpaZb+L+untrsNoZM
	1UL8pR2CouCowYOeMtS8nV848pXzwZtGZHnCxGkW5oUmQj5jt3Uc5GpFDo6zZNnv/Lm81h
	AH9YKfE2YVFxMaurHFpDwmtcSE0jUgNfRvpkzDmfrU4CWwp+OvT0Sl3L5c4tNg==
Date: Mon, 30 Dec 2024 20:29:28 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/114] 6.12.8-rc1 review
Message-ID: <Z3L0mE70QZ6V5uCB@duo.ucw.cz>
References: <20241230154218.044787220@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qdWhiN3wsj6kMGAz"
Content-Disposition: inline
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--qdWhiN3wsj6kMGAz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.8 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here (obsvx2 target is down, as
is one of bb targets):

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

6.6 passes our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qdWhiN3wsj6kMGAz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ3L0mAAKCRAw5/Bqldv6
8l4VAKCZlq4JrnzabtPYNhCOtYTR5iabuwCfXwHuLbc6ZA2fHfUnUytOO1T/1No=
=9IbP
-----END PGP SIGNATURE-----

--qdWhiN3wsj6kMGAz--
