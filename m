Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CF32820B6
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 07:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756885645; cv=none; b=SpUv8/qoitgECBTHFPY/UCE3bwQGFCbDq7tAvtQXM/ywqDrX4CqR1G1C/uTCGn5YwWN5np1vmISK7RcUkr0nvoz7ZpZb7RV4Tn7/a0MNU0TFXO8Rt1D6H7ZnlcMa5tYxEn8MXNx0zkFVY/sPn7UXOZaTVk7CsoS5JhaO9BLMD0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756885645; c=relaxed/simple;
	bh=WB5oFhV6TPfVy/dZQzGsAR9s2F36ZuHdy490NdByYFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tp5oeoJdEJ4cj/RbTc1UpSDaV1Aft/EsNgtWY4VkfVfuMEojgPUVXEAR2JmujBs/PfSFMFnbfiJ5GgwW2X/+llvft9doz0Iij82gKRAKSugcikEZGNJbGhreCSfCXgEJkdtuc2G7GKNlz+o8WfjjGYVaeH8/A8rhb9RGfOFCLtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=PCVtINom; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="PCVtINom"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 442191038C103;
	Wed,  3 Sep 2025 09:47:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1756885641; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ZH2CuePyC+wEVG/F7e4kduUNkZgVizA9FIDuQHsGJ38=;
	b=PCVtINomO9jg+j/dhNL7C5piN4tkqzSl2kEbyosQinSCCw7WsaomDX7MhzD1LT9LE658FU
	iWt8T3DKxU9Mic68D7ZJvTbCKVGscQjks2gYYErtZY0bA1MWoNnIsAqympSgw8lBw/EsQO
	by5/K5X80XLqCz6uvekwbdmOIBawrPlglJkBn+Buo/DdTfxaR11m3HzXc1iO6PPh+SiR+L
	udFnO82ZrnUqTT9L2CMXZ9QmjApaL1+G35MubV+cZI+JUj0JeO70TUWGiMOldYTZHoZTMp
	1kQNU7y4g9ITJXQy83zYfgyNTQZyrb5g8ZzMy175TX1fhFAhib2zYotYTTmELg==
Date: Wed, 3 Sep 2025 09:47:15 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
Message-ID: <aLfygzKOMI2ALBJG@duo.ucw.cz>
References: <20250902131948.154194162@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1KYsNb01aP8n7w8a"
Content-Disposition: inline
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1KYsNb01aP8n7w8a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.16.5 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.16.y

5.15, 5.4, 6.6, 6.15, pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.15.y
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
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1KYsNb01aP8n7w8a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaLfygwAKCRAw5/Bqldv6
8hG+AKCxCOjSsbF6RvvJ3x5L1/fLwPYPMwCdGDjpcPHhkaZbJbh46DaJZHvagsI=
=wzb5
-----END PGP SIGNATURE-----

--1KYsNb01aP8n7w8a--
