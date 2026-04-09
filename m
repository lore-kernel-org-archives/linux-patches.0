Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0A53D0930
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775755073; cv=none; b=Udx7z+SGdcTu2INMQRuzPi+ppqzhPE7+r3jEdev0LqJujylf4ASV2otMCVBkuWbP/2jyBzm37uCRYBg1uuRptQbApXzrOjBbFya6VL5bhUKgzTKcBEFMpDMBxhPmOMRrc9WXVyK1tfevk8qyqBD/1shj47lWNP4/kgtgXjlTjeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775755073; c=relaxed/simple;
	bh=XNSFXUdOMMNeLntGyWhwp5y3uK3cglIQvIAzR9WCEqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFhwl2GA4eGD1FS1VlbyzEIssORS7A2zCHGDegvIs83js9o57/nyQXS8hodKgKc+sK2FxJ8/s5OOiWjXXv4kcZdEZTyHg74m3Nb/uw5TquXxnxscyfY5k489UyxpVOS/dttivbJgWiSjsZEhgW1TKy+JXeXfuuqAOve0G09GzlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=eTOfZxzp; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="eTOfZxzp"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E88D41123EF;
	Thu,  9 Apr 2026 19:17:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1775755057;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=M+7dYn9NOWAyl8B1gSJpklr1v/6uumbFdxA9tcC4lF4=;
	b=eTOfZxzpEm+BnCqEVr1XkPcyKe0LexuJswcEvtM8ikk6eTMJUvewjDAb58dyjP8EJtJADr
	E7eJi6VJi/WwroXAH0NfWGwgwarva2hAdEtw+Bk/Q+TyD484uK0seiLsx9zZENstosxirR
	hNFzqUXbEMAXCQS7tAbSiDl+W9KgjGssE54NUrP6t/52ecfToj87XDlJKSvBpjebJpZS4C
	kGKXKd371jdGZBntrkRdQJt/ECNk+Y+6SUv0Iu7II3ccnCiUanxTePSY4oDacSjzPGVIzM
	HvFM/uIwsRQX+w4iVO1YIIB0/CnEBsBsr55gPVSdXbjCsBU6L5C+uvLrGBiULA==
Date: Thu, 9 Apr 2026 19:17:33 +0200
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
Subject: Re: [PATCH 6.12 000/241] 6.12.81-rc2 review
Message-ID: <adffLTWdq6J_TmhT@duo.ucw.cz>
References: <20260409091733.126574279@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yDckzbhZkNE0txpL"
Content-Disposition: inline
In-Reply-To: <20260409091733.126574279@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--yDckzbhZkNE0txpL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.81 release.

As far as I can tell, this is rc2, not a start of the review.

CIP testing did not find any problems here. 6.18 and 6.19 rc2's seem
to be okay, too.=20

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.18.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.19.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--yDckzbhZkNE0txpL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCadffLQAKCRAw5/Bqldv6
8uUyAJ4szpQRsmGav2w13by7yNMMJ16h0ACgvwrU9ZGolJz5ysSsG+Lwo7yP+5s=
=ZKLJ
-----END PGP SIGNATURE-----

--yDckzbhZkNE0txpL--
