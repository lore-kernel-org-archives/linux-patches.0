Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598DB2EA490
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 14:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760019820; cv=none; b=Drg3fVx4/yFB+lETNSlQrRFXgDrC/9NwwRN19guCCDVWub+q1Ag6MUdD4OJPZuyUtTJouvwj8+Q1UXTRF5WfwXtcY+Yf6E6bzAO0wlUGNLST2GkN7luOiHJllOCKG9MdTh5Nfj+g1cdY+LM1YxCjih7loP/2wjB9zQutl70YdzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760019820; c=relaxed/simple;
	bh=tKsf4rNNLhAUy8cx/s+Zj+MAaKVikS0yGc2U8lMqRPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOX/THvKl5kUqSXvku8yZaMid8O0Ml6KvBetY7Hyv9dVC8W5/U3jfOpojvEEfKhvsyCOlH7igsY0NIUVrs6TxLeu0O1O0Lqvk6IzCa3L/0Y9g904ouQQu5p6P2EwpOrJt1kRZbnmhOsCk0O+c5/1yE8RvOEfbLIswwDCnwo6CDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ad+sySV3; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ad+sySV3"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A8AAA101DB814;
	Thu,  9 Oct 2025 16:23:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1760019813; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=0A5K/PIrYFfczp2p7aBd8MOP+eifTgY270bvBsYk9ws=;
	b=ad+sySV3WNJRwtSW7u2Zn0uLB+SSMg4Zh+KL6VJ8fPKYLhm0CABTN3K/dOTG4k+ZHrB4F7
	ZBJYeoZRyh1LBFnneelIJHWrbpsP/p8jdgoavwEn4ux1OTx8CLsrCgSTQgiNH8mf8C8cGH
	Tz3tACg8aSPInLyXJD8GI24dPLdsVtTksQ4/MFhZS9f7AapfVASxVJXJJrPcYYmD3p/FFU
	htoV/P1+/uJleBe8Ue88S+c8NicjxUT6luGlugkX/Rg933olcImIRi1b+8LiaPddYSHW/U
	vl0nS3L/Nfw14Ptt9CqyDFdj2mZtFwUmRAr++F3+m7Em5agceOu6jqcjrPCBPw==
Date: Thu, 9 Oct 2025 16:23:28 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
Message-ID: <aOfFYDUuTPkgEqQp@duo.ucw.cz>
References: <20251003160338.463688162@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8dWd9aYyb2y9MZlB"
Content-Disposition: inline
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--8dWd9aYyb2y9MZlB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8dWd9aYyb2y9MZlB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaOfFYAAKCRAw5/Bqldv6
8pCxAJ42fMNsmC9JjCmiJtNjG84lVoY2sgCgnH0MwALItQyJ3oYlt+cMtue1vjw=
=hvkj
-----END PGP SIGNATURE-----

--8dWd9aYyb2y9MZlB--
