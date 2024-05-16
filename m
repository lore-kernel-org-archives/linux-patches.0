Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C9414601B
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862247; cv=none; b=SJwhQs/ZYGofKShCvPr6JBed4B11q76U09ZpGgcK01hqXr1rikhAZHNwSqhVBz5VtpEI7131d350hwyyTAAzCTEAf6NSIsSRvb8SMO4mxkNjUWVYj53PGvaQuMh41/+i0DCMsiPZIqFJvu1jooAJ4e+lKIDsefjAwRaGwegXcHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862247; c=relaxed/simple;
	bh=lf3vKB/AeKSgCdustTX9Bhzr/8FVczOduf+P/paC6BE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgnY6FadvKuN7hRPWHK0X8v8lpiWMVNKE34RRc8hH511aYLauCVxHqQxwTiAggWOKOWtlI5zaFYY0sACr9UsrU16JSdoeqSwqQQ8NdLJp5gAeV+EpKxKyDJaHGtF5aw/Z1z/JXDzIHB0VKzSitDiv0Pal5f5/SiMdNWOm8/LgfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D2F7F1C0081; Thu, 16 May 2024 14:24:02 +0200 (CEST)
Date: Thu, 16 May 2024 14:24:02 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rrameshbabu@nvidia.com,
	kuba@kernel.org, lirongqing@baidu.com, vkoul@kernel.org,
	bumyong.lee@samsung.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/63] 4.19.314-rc1 review
Message-ID: <ZkX64npLMXs0gdNY@duo.ucw.cz>
References: <20240514100948.010148088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAdfpCBGYRKXhPlf"
Content-Disposition: inline
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>


--bAdfpCBGYRKXhPlf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.314 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Rahul Rameshbabu <rrameshbabu@nvidia.com>
>     ethernet: Add helper for assigning packet type when dest address
>     does not match device address

So this went in, and has 2 below patches as a dependencies, but it is
just a cleanup we should not really need it... or the other 2 patches.

> Jakub Kicinski <kuba@kernel.org>
>     ethernet: add a helper for assigning port addresses
> Li RongQing <lirongqing@baidu.com>
>     net: slightly optimize eth_type_trans

> Vinod Koul <vkoul@kernel.org>
>     dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP st=
ate"
> Bumyong Lee <bumyong.lee@samsung.com>
>     dmaengine: pl330: issue_pending waits until WFP state

We apply patch just to revert it immediately. Rules say "- It must be
obviously correct and tested.". You do this often, should the rules be
fixed?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bAdfpCBGYRKXhPlf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZkX64gAKCRAw5/Bqldv6
8ha3AKCAHkkks45/TKqq/lp7uxCQzKtygACfesvM8AMZpJu0eXXtbM+eH2Ub8HA=
=7sOU
-----END PGP SIGNATURE-----

--bAdfpCBGYRKXhPlf--
