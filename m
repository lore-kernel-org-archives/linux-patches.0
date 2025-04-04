Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBABE1DACB8
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 11:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743766384; cv=none; b=dRxbpHy/w5VRMExSH+DyBlHupHw2sL2LQhTYLBa8COTe5NrLmHVi5JTgoMe9DeZtQx99z/idYkg9+qtyQVVrxxyOdHUoDT2a/PLztYePShqBMSv0gJdFfKB1ewI/dcX7E4RvLCnirnxX+DS7mDO6MVMqxKCSNCGUqoIr6j5wraU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743766384; c=relaxed/simple;
	bh=RXAzAyUymUEGdjhF70f2rxVJquHJ+jHFiR1TdWzgpM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8rClOrPLW5R5VN77LitPy6Sgv8vZ+7kShbR2iYnnvPKAQ8l58s/fmOxvYYhPxUbdcHZxt+xV5F4+U6H09fxu1miCt6yFMesp9LL+vqOdXZILuf5JUWA4TqMC5dxLirn0wJ9JRVjxgmLkObZyP3fA3IkAvK4t7jzclQsJq6tNFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=UO62+kEA; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="UO62+kEA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1743766379; x=1744371179; i=christian@heusel.eu;
	bh=1Xvnr5xTHj5ffS6/z//aYoy8Zas4UgwcMAg/MTUZApk=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=UO62+kEAOgrnnVHbOWW5QCuVe6o1YZi3C/uFXpSecdRskVTG0OMjhMk4GByOKgtN
	 XW+FNm6E5XAZm3SbEakEDYVlDV9od65/mE4wRjaAmSAWbvA/mhXYKvx0kbzo47yxL
	 LGk3+l07tt6+jDIm1ss566hWMUZwuAvM7ur5eFsbCTUYNcHuhPWBOjLk1uYak1mzO
	 oo5DngC9qU/dtoCFqXdXTwA0j9jocBIW9bWljp7RfMVZKmjgvDIsbyZn/oPGFk/jX
	 OWe2PK6tObnTrnVfwyKVBizAqwnu22ErVvdI+9+pCK+IUUQlDdVMWzHbE1OC1deUj
	 nqRfD1QORC9h5ZSePA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.113.55]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mnac9-1tH6V30reX-00edDE; Fri, 04 Apr 2025 12:38:56 +0200
Date: Fri, 4 Apr 2025 12:38:54 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
Message-ID: <c06931c3-c691-4acb-b3a9-9b2df8ef30bc@heusel.eu>
References: <20250403151621.130541515@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="v5wn7utr7ycxg3wj"
Content-Disposition: inline
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
X-Provags-ID: V03:K1:WLuhlQHS+PDXdBftMV8hO3bixlIHDBAynRCPn70q+P18m1hbFkk
 m2QrMhxTRsbtnHGKw64LCCDYLJlPEYLy+1SweYKrH5JgasoW37G0aG/szo/0rrQHivh5aMV
 GfYt78IsCAg9Rgl/o8FmoXxFVW7PnMk76z8YAvcmUr3HUUwtgqla1KG/NbuDPEYTBZY0d8i
 VJeItaZ467vuSsOGkkLPw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YWmoUAX5HvU=;pwnXKxBtyCrbOd/49iZc1AP0Uta
 UxSeo8rBE1T1g0bEuBnBEbI85mX4/Dcc6f/UXLfWCT++fX26jHNpaSkRnwsEe/U59p8TB28Gd
 RGn8kIVTab11Y7YA+BkbveY6W9SL82BduavriKYm1mwjCE1w/AyGIGlRpBSw5JtRrs3MyuwYF
 WVEnU35pcYOQnV6DMt3b6nwOYD2LCLulMPBU8QaB1KB8Fem69dBvio9JjVxaqVexE1dicyCpP
 XX0RgNVhcLurPT6aIAbR4x7bGRwaZMH4H3NJPbBQne2D9N10tOVhHLNFGUgyw4sgDwwtO3jEk
 ZobsIFlUrLsDy9EX3D4ikjSxFQ3u318v4wkvLudoIQqOQQVODJtV3PHNpPC81HZw7QX8Z5XLL
 kNb1m7p+Un33CLiB7woaTqQP47v2wNYhzzq5oNlGwQgVO2C3CHhtHghrz31OWBBl+3YYwkSh7
 0r+302a8afziPuNbCvHQseT5/oh706rLRynIv0h+XxclXg2McfSglm+6O4IiIcpCv2UTb0sGx
 8pQ2cm52rBw0oct6U8puCYbaS8PaJMuUML305u3UG03+84vA7/e/4PvCxly7sHLLj86A8It+1
 fmC4Qe+dE508rbbol11f6QIGL7FODcTEI1E7aQkgWdeN/ejsHyv+PMg9ElqCecTjHQUpUgD/1
 GsqUhAun5qryF9aApVCl1V53ZpBcVSnZVz4E+7OSSeRPi/NQKNwjfUVD7XTW8LK+BPF0axx17
 1tL+GWoK0VoT7B4/a7D4jqJN1mL3jRVVEWNmQQczb4Q0wbU0Rm7DMGDUmNSQ3QV6EIYopazwe
 xXTFvXcYjTdgA2NWyRywU1wi8UpkmAClHbSR+dq0M3UsppLqoW020IUymwyfHIRUbb7iTf7T3
 tRz1tzwiHIAwcbTpRDzHn4ubO+YOKVmYHpZ7abJoOEKoZbxAo1lkI4tIO/4E9nEgP14UfJaKM
 Ah7WTjPbgtB+14Hx3g3R763+z2gGa/b1CmFD3g2LjsD9HTxyvDoopu6h7o/AwoW6mZuQxZKaq
 l8rRuLDEy5q0g9+SJp4810jp/Ay0ECelz4hf1ZEgVXbwdDv19dTtMexDFKa9XblF9ZpyJ4kkV
 QgQgCYRVgKpcRi1RJ461/sedJtRsV1E1UsT5PAExmBznhXM+2zA2zsRhjHyXkoK2GCYYvyit2
 R3yi3TtmPwO/bCsb7WRwU2xdC6ohnJ1w000/HW6FGYYG37QshJJ8knZFcxix/jYVCh88n0nnC
 UPp541FTyi+mcwt9YvtntBV7frPzHhogcksJzO033eihE0zOIQV+tPBJbg6rvKrmN8/ZlLLcV
 XBdVz/piFlSrxi/nTwoGp5InivlfQAEsgvyH54rUpbY+ci9MwIdGXbsudveKzo6Kj3jGYmh+C
 wNPbT8tzLLbab0XWiXAwpFflm8ohK903VsksSef0CS9bOse3sCANYlDnEo


--v5wn7utr7ycxg3wj
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
MIME-Version: 1.0

On 25/04/03 04:20PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

While testing I have found a regression that was already present in v6.14 t=
hat I will report separately.

Cheers,
Chris

--v5wn7utr7ycxg3wj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmfvtr4ACgkQwEfU8yi1
JYXKow//U0IOkLZJ2LbkAACQbWxGZCfcjMvN+GOh5EU64ecvFc0UxOnqVnC/xyHu
up2JxT0kPJZ15zm4vgKWUlS383dUBuDlqEyvN6oEqZBuiiNivEyaEk06QgRlfAc4
G7L3pDD71+MPa+FIsoja0wPeh/MX2f5ftvtsqvRET7ZijHY7wF+oZQ7RBTkW8yfb
f0KufR/ml8ai6RLULP3BAwn8y6odAXbgdSzWy5S8tGEqCjdENdfG0/cL/xvXU69a
qqBBaDMk1BVYW6Dt4NXWqoE1Dr1uJcjAA+9ItPMq4R/EglnWEB83mKru9EqXJJuE
YgbMdRYKeRZ58IJy3+ww6yAVRMjNW6DyJ8atKpj7NLjWoF0FWFFbKh1Z4SF2zxWm
FhkQZdVXKr/iTIjFrZiF+xCJjSce1GnERIrFkUvRHQdEo1O9v35ewjq1GAi25dle
HijPdlpk9ZRxJM/UuBWSC/wR7MkObRfx6nZA250Nark5hO3nq4xpBPXezSL/WoFi
1AispsVSj5JU61I7tO9sDV/iiV7tVG8RAzJ6o62t88NiynJmy0IcK1Xz8pkqWWyZ
zzLL5rueRcRA5l7kPY45wmx+oJQIJGgPqrV62c9RYcKTOjVEpMUE2yk+UCu4tQ7G
KXftXts0LNGcM/uGAuXJ/hD0wq0Tqe66od4Ghp/TCNSZ9DfAMLA=
=DfJe
-----END PGP SIGNATURE-----

--v5wn7utr7ycxg3wj--
