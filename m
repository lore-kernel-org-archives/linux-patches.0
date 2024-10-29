Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627FC192D9E
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730233682; cv=none; b=ONb6oORMSulmjAznDidYIegqMQ++t0037UeKu2dWWz/RdowU+pSHffS/ChfGbG09TtOTbvtpBZARulIWkw4LIPd/RBeO/RCvZWaUgPx/zRGj752/WKDXfcdDHhOpikxGXmcO6pQ8b24BYIt/qS/GcMKtSbO1Z3yZ4yfhkIgIA/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730233682; c=relaxed/simple;
	bh=SXWtJP2PgIsBxqhD+emQuFuW1aVJeXNT7zfwxXsQsKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srRPyq/iB0gmLMo0SZZdm5L1hifca2mz8YBg+U1kyLsO1KfFlkhrfsPJcgRux/F/vaUfyUvsP3dF7pKfQWDfyOS6QFq/uR7KWc3AGeCdES99O4dQDj1SuIy73sfrOBt7XSi6Oh0HNJ2AsWWYs39c/KcQ0CemRGQm5KpwbozZR7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0AFFA1C00CF; Tue, 29 Oct 2024 21:27:53 +0100 (CET)
Date: Tue, 29 Oct 2024 21:27:52 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/137] 6.1.115-rc1 review
Message-ID: <ZyFFSIx0/qHJBXtI@duo.ucw.cz>
References: <20241028062258.708872330@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WxycoBxuZtFtLqyY"
Content-Disposition: inline
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>


--WxycoBxuZtFtLqyY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.115 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.1.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WxycoBxuZtFtLqyY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZyFFSAAKCRAw5/Bqldv6
8rE0AJoDWhBu7A4uyFudfXGSUc0INudhlgCfZf3PAZX9yEFbW8NMzBy2xSa5e8U=
=up6c
-----END PGP SIGNATURE-----

--WxycoBxuZtFtLqyY--
