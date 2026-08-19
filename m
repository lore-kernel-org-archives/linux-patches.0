Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909632D7393
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 01:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787104504; cv=none; b=tgA7oSO0QE6k7gLGVhZ79oQh9Vf7H22G+dUY0eDFajdHaNpdR4ppuvD1OlTvV/X2wnK16UcrTDsRiB5zlLn/fbKF0FGScXYdsbKHWZaWoF5sGQiQb6FPpE+7BRQk2mRigDo0+Tg1LI1giibntueoUX/GsggJGqx8ZBFvPaGCFt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787104504; c=relaxed/simple;
	bh=Mti3lBCAFpdUbwx/fhXIyya1Jx2nivpinlaQa8aGj7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Htt7+dWr3gPryvIwkg41WtmlOhLIsGExbnGYA1eGmjh8hzqq/P9JXOYq7V1uQA89Z5iBRNcIJ+P3bpk8J70RV38M1fCtezndPHHVhsmrfFaIUYTPKIthIelJsxP/RhsYuagGPrUpmKEViAaMGwEZhAJTZCv8qLukf5vwyfYzHWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=mjq7a5MY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DNi2lctc; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="mjq7a5MY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DNi2lctc"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 497701D000E7;
	Tue, 18 Aug 2026 21:55:01 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Tue, 18 Aug 2026 21:55:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787104501;
	 x=1787190901; bh=t/Z6bGi3UZwJnRtU69C68ollMPJLPwLewcpFYV89Uak=; b=
	mjq7a5MYEm9lVktGtEipa5jRi5QLGuWOR/na8TO4KACq2x2BJiHYmaFyFeTRi/nP
	BqkTLrO+ptvqrh4cfgtSE0wHnJr5jAi8qpJHhNB7ScysR1FyzC+gt1017GAxPsqO
	CqxrjKpsqOdD+FeVUhqXpYh3oKvdb4GGSA/ujv5VTIax3KedQL0o1W5X9J0WKWMk
	WRpz3RFMG5BEN3paKgQ7EdQ6HhWO9Ib+jCrgk/WA0Ap3xU5oOv1jVzBDjcK9MIlq
	czFoRCvO7bEfbhC2Q8XihALCBIxb/4cpCwUC0NdfbrNVoj2MQZkAOtyMK7g01uW+
	ucwnRtinSZ/mR6QwYfYEbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787104501; x=
	1787190901; bh=t/Z6bGi3UZwJnRtU69C68ollMPJLPwLewcpFYV89Uak=; b=D
	Ni2lctcD73isYBjMMygeGI4Tv3jTOFvS7lwcyr2IhVJlUWMbGJhp/iWBd8WSvVE6
	ayRKm7VEQ0ks3EJFCDN3DtvS/2bg0khq1iX923F5aAvzazV//UjWENiqDkenP42R
	a4cfEMUcy0AafGEdExCNs0SEB37mwmZj3AjmsN+F77Yb0HaXqdT9PunYJm4C8WAZ
	cymjwHHTnGRgF0KlQcP4J3l+0VLnjq8PuMJRoemBoPe+1RoVV+7xiUOBjyidb6HA
	TU9vlNfVSYD7zc+NSSOuQ36xa+w3xB6Rri9yZxePViEkjwT/Uggn1uCHHgAN47yc
	NDq81Hr7B3Y3uAggo9zmg==
X-ME-Sender: <xms:9AyFasEHwAfNHOhMy5k3v4iuouh-W7YzmxiGR_6ZhHiDCcrzznEFpw>
    <xme:9AyFahMCqjNOLAlaFBklHWcU9-KOTyS0yt2NoWSYwZZJTQUjYGkhjEZUpww2XGKB6
    CkQB-Bjduh4aKAM71weaxIKp1RlYMY9d5CqgQys4zK8um0SwbL8eg>
X-ME-Received: <xmr:9AyFahrb1ymHscTAdLjcMdrjf3os1tu-rB9VDfqEq_2Q8wtzGR5wzK4OcizMdwH1CEu_ZDxSbpWoqO0mFimj-IR-PPOZ_rv2>
X-ME-Proxy-Cause: dmFkZTFYB5/TG62xVUugBv8Eau0zNUZ/7fZoXUmfYoEuRSUdcEmRsAgUv184X5gVvu5hnp
    YLydHRIuyOYU5Y3sVdoaCl7JeAX2UPKchJ6UzLrech5CdBAJivYr/D5TJRNWZmBTwJXDhM
    6GQ1HX9FMdqXiWxyahee6wUsWhqqqoJCMt4pXvsmAPsXb8O2mBsJDcpdG1C9Wsnhl4Jm7Y
    TMbv8jbaW2HBXcyouy+61Bp4dD3TIdUVUbyuq/KUB4ezsrh7zSVlR/cmyF45GapSj9GqYP
    bAD0L0vm330iDvqMdBqVXV9IZamjTsFAYjr5Ijy2tO/hHoGPcAeLz06UavCQle8ClLZJfe
    h2+I/uTplBU3Xys0H+sTGYqht2UK7RhFoBE1fX8OpjVuQEno9Sv2njZ4oBQGVY1BHNhIxN
    9AR6jNKWHE8KhSeVPTtB+IaETNhizj6Qoja1WDtRBGWqKXf6tb+UJUqMH71onSsiM0KfXU
    mqUqHMospc0hDhPZmD1yPWL5nhEIKdWl9AYk2aR4VG+KV8/exEdBvacZqVYEtDqtm7dElO
    yLtXoixeHIuOhI4UtR09gRaZV5UwxoKqO578f8ipkcGXWuGPmTRdvHME7kUsrRPiyKJf7Y
    VmF1sBw3Ae3AuyAuCaS5oXKjd07a9qOUGzh4yuf+afbb+Go92qdoGtWnGUbw
X-ME-Proxy: <xmx:9AyFaiCQLJtEAT5jyQ9Vcukft89Uikd3UvCHE8Wp5QuWkoyryNjPIw>
    <xmx:9AyFaqPWYTTRJGoIxiC9773mx1zbA3DuGWBYAphYWF1Ko6otGSV-yQ>
    <xmx:9AyFagBsHi0zPSbAOJeyT_XvBv8DdbGNLN-J-Zn3K5dzTAEN5tlQZQ>
    <xmx:9AyFao8dxiQ07o5VTn0wrmfuAE2PLU9tZpJLhQhRKmOH0n7_HldIZg>
    <xmx:9QyFah6a0fAEhDiIrHhR2rWS5qDwkA57UlB_dS58ZSBT0X-npOJ0wAt6>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Aug 2026 21:54:58 -0400 (EDT)
Message-ID: <6da7cc7b-7212-434a-bf76-528a2491cb3c@pobox.com>
Date: Tue, 18 Aug 2026 18:54:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132536.466235697@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 6:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
