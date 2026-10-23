Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788437;
	b=MB7HwTcu/tYwdnGN1a4oQfhK0hveT1n+xKSOnt3W4ApP98cMpM0P9vI9VFN3Pt4ulrEU
	 cfU2OmtgZWx7GTUT3t+aLYtBWKGYnce5GoP6BQqYYZmoMSO69aRvpvoJwIp4xTZGJdTDU
	 HucIuUlkVTonneVc4XPKcrtdEf/8OMnqGxyfdrEJ21ykSZmTHfuJuoFVHaifXs8ZDwNnV
	 wN2qT0ofhxlIWmCIjbyIeQN1lojt9FK2Js3b/H+ChDIjI1C0UIfh3jYZqwvLx8rq3HFsk
	 /fVGaDv/hHOBOnnUbYm9/DW1K/nh3AZ6ZAxN+ceXmd3yJ+CfGbKpfTp+1wGYHTMMEEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788437;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=Xd4GJauzXekkiN6UyS45giibY3KS5AKSeOnhjBf/I8g=;
	b=MiCsy4nDuOCwufu9NcaN1WzAz6yFdRQsefdaWLS6I36rM66Dr7MosGI3GEsI5qZfRqAe
	 k9psFVQRJQM3GGiTOz3X7d7ivWcKfsfn96+V92CY+tUowqBnJbVsRVkYj/gKRIyzcBnX6
	 K9uglhA5C7UIoH12m52Q6dmiWId701ZhzEi3qYMz4WB2Ji2MSJNblol4UiObFrkK70yvm
	 dmElDS82ooaVDMiJYtXh7RZ1zItz4F8Lj/V63keWzWpV4bwbuHSMSNcxdl58iV7WvBtE4
	 Xfr3yliUDT7KsR52dCb1m6U1nCoHXBTkmpEdTWI/JBx2S6oHzb/lzyOVx3IlHrx+EnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=XXhDGiuH;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D1B606A31A
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 20:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98D1B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=XXhDGiuH
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A9AAE10B003;
	Fri, 23 Oct 2026 22:47:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1792788430;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Xd4GJauzXekkiN6UyS45giibY3KS5AKSeOnhjBf/I8g=;
	b=XXhDGiuHDzIr4zSnd6g7VXx4ZIhZWP5NKT8BFSiHVRdMXzIe2AkqvK43DgP0dZ+mrd5W6Z
	2GBSfUcLS7Ca+aTZNkJOXfE6n68ezLyIkxIZo/0anC9cft3KgwhZq1UA8R1epDkKGvENze
	LCJaElCz6RlOQwbX1OQmFCJ6rh3KlnP32OD2oGhb6nbg/8z5AvWvQ1e6gjtmajRfiA/agy
	+t4Bclgf4XGIpCtYHlDKCpnPmdJhMBoBw8x1qaRCu9y76qR0VWipZZGYD4EudzKpYuKYL0
	Qt/3gSuo4VWdKsLrqg5szXUpi6mTYiw6vaUu5eVX+XUbUapHeHMGyB0fxpFUuA==
Date: Fri, 23 Oct 2026 22:47:08 +0200
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
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
Message-ID: <atvHzKB1sufpr95P@duo.ucw.cz>
References: <20261023163714.201276352@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JHmKaCjINuHtwyQJ"
Content-Disposition: inline
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--JHmKaCjINuHtwyQJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.59 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--JHmKaCjINuHtwyQJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCatvHzAAKCRAw5/Bqldv6
8lj4AJsEYe0zGMEYesQM4tqctvDomsgIZACgtR2KMhIScZuITdXsfGfpksFV5fc=
=ZKLp
-----END PGP SIGNATURE-----

--JHmKaCjINuHtwyQJ--
