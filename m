Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0D3346763
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 09:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765965137; cv=none; b=LAQdMdK/p+jTdSgbhjsatQtZe7Yq2/5uvYtyj3p4t7eDbZF8NsiYHVD3n2/J2xFc6/wqSN8hkMwrDON71+9Q+uj2EMf/LDuE3RnUleU1hAFjkWFyz0GdLQnB7Vuf2Uj/rOT0de+ZvL29PcB1aAtJvjijV4jgvUe+HkNl1oDFc+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765965137; c=relaxed/simple;
	bh=8spUcwATbrE6wqelUezzasFm99VURT/h+5zVxLWbxrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GW8AQVGX9Yc2KAhPLfbxfcGSCwECWcFNEiQbyjML5j9mFU0UkwSGLk78RnL1TWLD5kvmaCrG1kiRyHWqmYLV38o0sGjzw1Owdvr8ezaBD9bu9A09znABi7lfgg6RKi4h/Vgo8lHsPbXzKciUymVHhvB4BCEB8XJdcsZrgZu9JqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=VhxBQTse; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="VhxBQTse"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1765965120; x=1766569920; i=rwarsow@gmx.de;
	bh=BIpqjyAdub9BMjW1IU0iOc+IM5Hue82KL+03xpLDOfw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VhxBQTseQ3M1SG+Wdw0/uBMniEy1UGLU+3F8/mjmondC60alF4SMQtqidCQTxkCu
	 iwfQCowUqCEagUyZXdbU2vhEtqmG/ovglKRKlNbUrusCLOqOI0HAVOYSrI9Jsr9Xy
	 WDBtWduOY0rpyiGPs0/PYqd/54imFylEqFri8Mdjs01eiObizs3cdn7uLW67GthAY
	 6qFWPr+kVNZjK9o8xXSKl82wIf5hH0BkcjSnz/ovDMbrWYBTE9pQrtkOqA332ob++
	 Bw+PfoFWGN9XyfnZBszJ1yzl68TIHLLFkNb4XyBGerrPpOyTPvHwdTkxPsPOxcBgI
	 FWi8UBP9HiKztA7JzQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.243]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MRmfi-1vOY8221Uo-00RXC1; Wed, 17
 Dec 2025 10:52:00 +0100
Message-ID: <7842e8f0-bfe5-48a6-8a33-dac858244872@gmx.de>
Date: Wed, 17 Dec 2025 10:51:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111401.280873349@linuxfoundation.org>
 <1056aea9-1977-440e-9ad3-8a0b8b746288@gmx.de>
 <2025121714-gory-cornhusk-eb87@gregkh>
 <b72d4821-d3e6-4b29-96c8-6acb1fc916a8@gmx.de>
 <2025121708-chunk-sasquatch-284c@gregkh>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <2025121708-chunk-sasquatch-284c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:v+0HCBzWPgewSLFKARSry5aXbZIYiNLBwW1wUeHkLaXD3DLQmpH
 4QXKVQoMcy30XDUDI0SwwbTwD7wb+aOV6lNFpZIRTp7693XIeptIMF7VJltQokl123ky6qe
 fWGKFajBBiyrsLAk3+NC9vh6ssx7j8YIDOCSZe4pTPl59SjNETiFu2e0VfZLoyeldIXVZyB
 URIl0xohkLZvexU/o70XQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:etti9qxiso4=;XS4YhZrheN4SlihmeskUxlbgG0M
 HyxDanPOAIPpJqIk0axMzuFJa0q9KisTXYb5eRk0DzcfB4xPwZYbsqp4ccxJlotAk3Pl8IISF
 AGle2VfaMxHT1/1B9X+1yEiIW8vRD6bBNOQPNJIyfo+BhUORh9XmZxuLPznSqSMA4X4Nww/C3
 hllUP1d06n3RqNph+PulrPy839+TDUHgZjEKE6bKV21LBOMqCPfqVgcukTXaxG/RLfGuh9KF+
 NNHvrMwnkEeT6Ut1BQyQtn/nu/Bn2wSQ6bciIabOFuErgcGZgYf4uwIofiu4G/vJmfhShZ0Jv
 xsP/pOfDyNVrQ7KE6ymc3YImUIeiQ1a2XlIbELL3+Yt2UNYJym0DiCKisIyFXgyi5h1kPf/Jn
 N9XDxAHdMC7XU8nL7hyH0fRuBK+ziZh+rqNpvun9S/nE4FQxlBsJTFhmKkpromayjEmcCs41z
 5Lmvv8xrNi7tWUolKq3ZyG7deD8txqVjjulDvkxMNStVLRU3qef6JqX8yYkZSXN0/w05BJDd/
 VuIAa4Rbt1Q2CFibUX+6RAUrin4NmJN1bahNOZQN7gRkvIvrCWrd1R5/ia/RIkzkTmouCZV6x
 hLcsDFt/DFqEf0z5dsYcjr1ykvyN0gFY2RFK3nw0EKUJZCh+ynor/hz9Ef15E/Wv/cMab+icn
 hVj5k2+b5kt5reqlMkief3jluX0oxRNqkUatclx38J1nNgw9F7in1lS2X/SMezU/ZIUQoLdKE
 1snElsdMfuij4fr9Uf1W4NChjwZ96A9pae5qKKTVxtQiYKFNp4AKoRDQMciZ28kIPtKNep3la
 2uFH2lehd500x1Sag/z7dLF8SgSMe/Xm4U+qPijoDJLrXPq4Xac3ieCQOxF4vG5+8A86FNvkC
 d+eJ688qI6A/HVqKgwaqr/RC2923Nfg+L/kBE50SAMcVhux/ZhR5JGg352BdRodhcOyUZPvLp
 Hjnz3GPCn0qqi1lAi0hOMJzwFZSQiNCjizqJ7ulBTFDXORRRMYWB+YtpURNO3p8yvtfGkOlFy
 dLjBzZsN+BzSN18dEbMLN3B5pfZWlxHd4vt6+YA9Jp7pGZE5B5E9lyANt4EPQz3c09nNC2Yz+
 rSaluHBCYO2HhZFbxoHBbDgGGLsk0joF0JokREhEzWbeubdpQtIvR1qVOXv8GFVUQOxY/hSX7
 rWWgLyQR15rQ1k5CRCJd62P5eGFYNe7hVnkLzhRs9o+33ZuSaCG5OIq6SqhXLR3CARKDoMaK6
 K+7Fe7/SX/XP1Ps3Xsd/zGZaU+N54/GYTouQEVDb0OpLGTbDsa7SQ4frSBdO6W7Sa9OY8WPFa
 inHqhD75CSlggJTSYQ3PiFxlzdLz/J7CkS38Biagggsu2Tr+MigjXjGUwbTBVATalKWkU5eOE
 PWfUp5WDiW5yUfmJGbi4DLh5NjBfdQiuQ3f4CysnJap8HVha/h8zoG04B41QxTBCPpvTpJ0BP
 oCOpbAEl2cv8XHzkpu6SwNMY1OwEmHa+bczrTfgoY9vlv3/DUcx/+pcO6wjZed4OB53p2e+gS
 1dI+oUF3aTNlpk7xUyg8byNHhFACUCeAANu6b+ufSdNU5MCyMW24VSR+IvPHZqFl6OFFu6rJK
 q5tyzN9EQEdUe98W++A7t6hjIBPIEfKwwk8Tyqd0m65lzGO/GskLKhTvM1EcTII1MMZXckOKm
 Jdem7+wSCg/kDhimshee8vKnJrdQJDet6Ec1jXzE09wVyj6w6ZucRB1FADSiIpJMU3hM79w+C
 xnOoFOIvDOokvJje3VoLP42TlQPzKfeKh470HoX7SCJifNvkC3I+neY3Sgi+hu1+Pr523vXme
 X1y+c/ncPfuRvBmnEQiBoHupelNWLncmD8l4VBKd+ICQ5WLBo4bvMNA0/6sF46Z6aR2uOPV3B
 lYwl+pIlNAQw5lUVOpTrfaWf19ztu0y/1kvm6z2NFo6RNt+xGeR4MH3ht1NkHjtGZhu8bHT1B
 HPusmeLRmIB806q2wfYNJj10Ce7nsB9jrKTcGkJj21SknDIG0juBY0wdt4gzFwJMWJoXcI8vQ
 JbB68tvW90SNcJX8+ZoGsTD/WPl2TItOzZU+z6yZ1yDwTDmJEVwCjw+vjDEV9AW/3pQXqkGzU
 YGBWbxMe0OcXhTrH7A0aTA6IQFXICcoirpBnMElGnpb4cx1KsSw9SlUbTrcixX0badU/TyEZl
 Nim0UQsWjxsnAgz5dusUEz0eI+UaVVc9IlB0/o0FeTJCXN7zfZ/DSpVyJUglc99mP+LQ4emD4
 S/Lx76C4iJLSkFM7lUBO/soDsP+tYX6XthiHIQBTP8cGJRCH7PQ4owvwNEdIQD2NURjlrOdWk
 38HpEgWoyFfvTKTuBdoDcBMibcg8A1B+He2jk7Ge5soOKOgv2mtC5hyREzytc0AWjJlUpjTb2
 DL7eYDRYw5z7giBsKr+XPPyH18i9xf/2yn6NG08aCqMtinjRnlMNdonfgMwjsxwhk1vR9uYxU
 5qsMz1MkeOjg6HZtYXkaA7h334O2IL2a66DjjmzzYi4hj/t/N+Rng8ceGsemuIoP4fVqRghoN
 126fBqOrHHsiFuWcO9GZUK0eeCWnPXhXox4G7PJEba/fwhVmvoWnfFygqLWCT2uuEt4/XEHbZ
 0shMaIzIS6uUyFJDzpCgWTOcyJ6wpL/W2tkumfKjaxABl5Qmssw7VbkIZcDFXrMKN70aaeJ49
 sQaXjs0MNDDSC9eqSas0cHhxEpEKm8wrRRtyAbHdtG+6oarY3liveEj+GBPKuacHNSGHGfVLv
 ZLEHF4c/3JLeCZT78V/K6R+LUj1YkvHuGcvR3YE3InuLm3uI5bgWwyfgvmvmiwSyVFk7ISPWO
 b7yyz2gUEPNScxaxUd5qhBaFJjUWLxI7LXkRDV3zFuJYXgtRerLLFRxHpIuMKOkj2p/t0ONyH
 qqr8o9XnK1YiH0y13sLxNwETAekWZ+LoYTVGfTcmMcytExVikYbbNf2yaEchUgQrprJgn+lbS
 dAUbh4+FMkWOecJQI+Xfcc2zHr4hDUESrgkifrhTc06nbOfN2mMVsZp58yzTdk+TGnogZ9hsS
 91qXrpFneHxgnGhnfjNAwnYWzWGogu7KJfnwbsM5OAYEc9XGDU3dcV1KFlRqbPxXIxBAhuIK7
 szfU7mPL06x5qhVKDFghq5+pV3P60+BeEaZmFw8OWLbOyk9KhLFcoB8Nr8FBN3mXXcGnDYnfh
 txJzpx/QOkPW/iZrBA6GnOqU6cb6tK6LIAE5G6kU0gpNWPRy/jC97covpdv1GoLB1XHOFaV6h
 9wc4nMalm8uK5VVpkF2kGOr4WNU+txnfFU3uz6/W9uKyLVV8+0bO3gE5BgoNfwYBKwP+gnt51
 gyNX/iWanCBhCPOKbf01sTyC16+5lS7qnPQUyjqCfCg9EapKFOdAU3+ootFOaUBshssIIaywb
 K9uxQMvLF8d+V6Wk9fs7PnWV5mpP6aF7+T+RSjFQHCyUF6PcLnpzEBl5kbQqN9R7CannC2RWY
 p9pGE0ZJrMoCmebKc7cdDZrBkqV/zuv9kKH9kVmN8UvLvmxtJQnCw06vFUVHh+YV+MfK2BY7S
 cjFBBqJD3AhduGbJqf8xuVfAD63RHhsRyMyGTNUryt9kP+Ak0ncZ99+ZLvf0V89DgtCv255pl
 nnfyWJ8Sskwe6CCpcpGutZe78P1oul0+sCWOvH0IAQ7zkJCetVtZGAj9cevkGQ0WWytH696PG
 IaYoHfNComa0C8ruf4wgF/vlZXxczHAlHQLRtBHk8quBOZz1yqUwkX80GFoBHBF2ydP23jMVK
 7kvWyNdeH2SvZUrPueSjSz/ViZAbf8ffAkkcUEtuq7mDZco2+6ugiUA8clw751pJVKcDPJGbh
 byERNXagmTQP9QTJNfLhdHP9Uv0A+dbVHjZog9ZOmgdPPAoZy6Ujduvdh1f7YAbtbfe/Tgr8q
 UYEooPQuivnM5vZKrv1pHj8InWbqC/KPv6WXXFi1IO9XL775tlfV5DODH3zHB5dcMuusGOMzW
 h9PH4JsZFYnlHWDi9CXB9QTt9SYi92/TXaUcE3LM70/49sSX1a4umIxWDkS1M+wg+uolh9Res
 /YjDbgV9DEuoHn96593qG8l2k3EADbMiATMgWLmCX4/MdSfhzPeJihHctkF1nq8VydiPASR+d
 5TS5xaBv2z32NSUAf2Qdt4Vm1fNA8VtFUaMY0ETTgIEQy7xg2pTuOg6U8bXC+SmwmyCkSMnv2
 dhLyiNFNP864447rOCOpGEVOY07oaBUCzu0oH/OAMKQ2d+eG91lMTwpq94XoS4Mwj7HkgxvnP
 akVzVVhv/zKt5aCQTbM13PJdiSVuhzp/NLjATjHlGXSTnY+RvtREiwcmea+oVs8h3GYn+2vAm
 cXhGRW+LkQxU+dZWCYfF+vAbmEtL5YFALqXAWZ3Y2mNUqLK0mmvlARtms0FycPECD0mUYLDAX
 Qf4A/+S5TsjLEvP3GoAlhurwXgtuJAs3GZIct555+s96kK0P1vsF87JdfAU+D2r43VX5RQZlk
 siUBzGjt2u4YRZDoNJ7WHijGU+ImqwXMcH21qfIMT4aW4BFLT1YbPw/Ypypa2o7U+YS91lV9l
 +xce07Q8J0WciZt143yj7FmM3w2Q5+wz3HphJC+C8tH5JZK5wkWtfyY9PAQrZzBzMH2HPrTcJ
 6XrVBLguudkuviMb9UGI1cNJMPoc2S8CgJYdATrwCxV0tOmDNrPei2B0hXuRvt0419pRwwV2Q
 75qO/f5KjyV/2cnuCF3lrONtKHj+IntV2+ZWO3XFC/DszWKsX7RK07Pnfzt2QuibF+3mIclHF
 pdpHqBFfpYPQNRmLIF/AL7T3Ny/yUPraF+LKLm4SKGR7TBTwK9FDHcmU3etWXsGvmXKc8TseQ
 DqIN4O/SD232fA5ZqFCkFT2WLEk64jiSUJ6EorLi9YPkuAW0jsKenLYbtAdbxwFwKv+MeQY/V
 5rAqdwkb/dDGN2cGQAbfuGujmmy5CU7NzHmD26jn6EW3EyXa4jxMhrK7bBNdgOaEF5f/bq1M7
 mrSs3PqoUr3m8AwK46KWw5BpdWpOYoY4NCVrpYO7F8+xl3VltwyN2jFL3PoMvV843I8HS/YSL
 JqVqmv9rmp5NW0qrQjE6IjVq2tk9SWsYlV21DBHwX8hJO7nk+CQKQYgPuk1dMrtLahmDd6RAM
 yON4RWABot3BL+Gxo=

On 17.12.25 10:36, Greg Kroah-Hartman wrote:
> On Wed, Dec 17, 2025 at 09:27:49AM +0100, Ronald Warsow wrote:
>> On 17.12.25 06:47, Greg Kroah-Hartman wrote:
>>> On Tue, Dec 16, 2025 at 05:06:56PM +0100, Ronald Warsow wrote:
>>>> Hi
...

>>>> If I did the bisect correct, bisect-log:
>>>>
>>>> # status: waiting for both good and bad commits
>>>> # good: [25442251cbda7590d87d8203a8dc1ddf2c93de61] Linux 6.18.1
>>>> git bisect good 25442251cbda7590d87d8203a8dc1ddf2c93de61
>>>> # status: waiting for bad commit, 1 good commit known
>>>> # bad: [103c79e44ce7c81882928abab98b96517a8bce88] Linux 6.18.2-rc1
>>>> git bisect bad 103c79e44ce7c81882928abab98b96517a8bce88
>>>> # bad: [d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd] drm/msm: Fix NULL p=
ointer
>>>> dereference in crashstate_get_vm_logs()
>>>> git bisect bad d32e7ccac8c6afc6a3a46fa4e7cdf0568ee919bd
>>>
>>> Is this also an issue with 6.19-rc1?  Are we missing something here?
>>>
>> 6.19-rc1 is okay here
>=20
> Odd, as you aren't even running the driver that this commit points to,
> right?  You shouldn't be building it, so why does this show up as the
> "bad" commit id?
>=20

maybe I did something wrong with bisect ?
- I'm no developer and not very experienced with it -


side note: tomorrow I'm in vacation

> totally confused,
>=20
> greg k-h

