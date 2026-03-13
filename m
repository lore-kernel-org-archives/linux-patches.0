Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876A4317173
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 10:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773399228; cv=none; b=E5SlDS6dhn6+e9ApjJP921Ae7NI+X2Hea4y4R36ynXVP6J6PsvBJlnDdrdo5aj4D8g2A1qfTFK+NnvTAJrKZ7HRixEarQWsv9x9JRzHqsBLJQs57irvVbnanVwEJmA8XJ4JM50W63nzXQ0w+3/DdVDDHoS5vKqFyXFjBUY+c1hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773399228; c=relaxed/simple;
	bh=6BVL80T96vvxIovGOJ/ZnCmik/l34j/tQeHt/ruK8jA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EcIglSgPxPYv/gpXIwj6n7hWFVZ4Gqq0UChC3VHTqPCWA6u+dINxh3zNR/N2/S+li9thXfVINT8RwQD2oyzjPAIlWBkU9IMDbJbbuOIE8f2tGwRqhMybeTSVctbmU8DUlAddYDvYNpSWOrbdqHZ8gSXmvs7MQ15Y7eTCTH3FgN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=InCa6CSj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=F3GlyukC; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="InCa6CSj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="F3GlyukC"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id EF3401D00135;
	Fri, 13 Mar 2026 06:53:44 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Fri, 13 Mar 2026 06:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773399224;
	 x=1773485624; bh=mgiGAxJxstQdTBoXipQiOiOjtE37gJy7WaWoUGE71e0=; b=
	InCa6CSj3/5QRM6ZPMAKnAV5QtxcJbhCKXx88U3rZLc5zQipwTTHlqDXOpDmu2Pr
	DmR2picAZYN9B3bX3L4ffs7PHRTCCDGQG/rWI1n/kmdMXoLFHgSTG0wJaGCBWTWb
	w5WxHqGb6Oo2PdASliSM7xXQxBshSD7qAP31AkpiB2xfLlhrU2qS2jYxuybkqxXW
	C0u9Lw4rr9ye5vbdtGgOxS/DGxGgZY5/cvJ+U+IEZOSaMp83cc3JYwvUnTOn2oKn
	07FODELrVo2Q4gWpYWER1fPUojylEzQ8UTg/dYhFJUsUTaN7GKTqjvoVwGIZDcO7
	O1F1xC/12kOfm/76U3TXlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773399224; x=
	1773485624; bh=mgiGAxJxstQdTBoXipQiOiOjtE37gJy7WaWoUGE71e0=; b=F
	3GlyukCLtw0vu/PrPd/KNgLjvLav3swAEMWNWUCkTK/MCwxTBqqsxqoxd8qMlZpZ
	CkhoonWrPJZnd3rrBVUNLPbVKO6vpSgiqiS0IF8T02vs85AEc29OaRZTK1AaSp2q
	E+Ams/1XwyBVpd7SbHpgC3jXahmblk4vk9Nd46Na2nzl1BqIzH2U5TmD5BHa2X6h
	TYgrglv/NQ1Uh3wnMJvRGrefuMntI1vB5ZeH8IfvNbug6yKS5fx5kXELbAmscoAD
	7XP2bs3arLcNzp4nKNjKPpPBm2WOoweo+apm/kuGugipPSN85HEenk3X8NmFPuSu
	gGmEcGv9OhjaWRzbt4yaw==
X-ME-Sender: <xms:t-yzaeRBilKihNg8kygVBAybSw39Ldb4FYPZEkmxej6xqizmeQu21Q>
    <xme:t-yzaaEp_6aHSMesgTRbaK8SxiIrFgD3PYwukYQ_JSdHwegVjLnhrJhc7P89pg7_r
    _G0t7FJIEmFp-MUapgP-3Ul672kfSu2XTa4PbB74gZxB1Ix2yhlwg>
X-ME-Received: <xmr:t-yzaYi2r24kL8DJh0iDxnZigPTyxnzBDg999UGfcDQozKGhwdfCrez0IyeJupmB_-pjtsxMzIo1keuIAVFZBgVnVZU8AQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeelgeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeetkeelheeuhfegueevveefheehheehgeehveehjeehfeduheejudff
    geefueffjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegsrghrrhihnhesphhosghogidrtghomhdpnhgspghrtghpthhtohepvddvpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehrvgesfieirhiirdhnvghtpdhrtghpthhtoh
    epghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    shhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthh
    gvsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgush
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehroh
    gvtghkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:t-yzaYpg5iuUnD5jwSasN91qxIeWNxQWNZXSikulxgmfJSrD2SjBKA>
    <xmx:t-yzaQQe1Gxn7mKQ0rrEREas7w76elb3SMehlh7nRD2TCCXe1QRyvA>
    <xmx:t-yzaRRFunOHZ-j-CrRcqBiredqGbWGqwFdx40Z5aH33ug75WPdaTg>
    <xmx:t-yzaWUI4WxZLu4095twV3bqSjee4PTglu1aPnBnZhHuedA5z-XsaQ>
    <xmx:uOyzabvDNhWHQ8ou1K-owoL65ZNqaMHGOG6ZaFUai7-m52ShXZoht1Px>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Mar 2026 06:53:41 -0400 (EDT)
Message-ID: <d87a1702-6906-475c-afd7-9b4b25bfd48c@pobox.com>
Date: Fri, 13 Mar 2026 03:53:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: freeze during boot regression Re: [PATCH 6.12 000/265]
 6.12.77-rc1 review
To: Ron Economos <re@w6rz.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Francesco Dolcini <francesco@dolcini.it>
References: <20260312201018.128816016@linuxfoundation.org>
 <b4f58774-18d4-4a32-9c85-603f9e2c98fc@pobox.com>
 <ee851013-fec8-47f8-9863-392f17e54474@pobox.com>
 <2a313336-ccfc-42b7-a14d-c116733ef64a@w6rz.net>
 <1c54210a-e197-4eb9-88b5-2ed2589c7230@pobox.com>
 <88e4edea-f204-4f06-b898-2995237fc823@w6rz.net>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <88e4edea-f204-4f06-b898-2995237fc823@w6rz.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

(I forgot to add Francesco Dolcini as a recipient on my previous email,
so I'm doing that now.)

On 3/13/26 02:37, Ron Economos wrote:
> On 3/13/26 01:05, Barry K. Nathan wrote:
>> On 3/12/26 23:10, Ron Economos wrote:
>>> Probably those sched/fair patches.
>>
>> Yes, after bisecting it turned out to be
>> sched-fair-fix-eevdf-entity-placement-bug-causing-sc.patch
>>
>> Taking 6.12.77-rc1 and reverting both of the sched-fair patches
>> results in a working kernel that boots consistently (which I am
>> using now to send this email). 
> 
> Confirmed on RISC-V. Reverting "sched/fair: Fix lag clamp" commit b547745a2c78fd1cc1fdc6a0d1b05c884c05cec2 and "sched/fair: Fix EEVDF entity placement bug causing scheduling lag" commit f9891a33ba67ce40e5a17023d2f3a5e2b7d72ffd resolves the issue.

After looking into it a bit more, I found two upstream commits that
should fix this issue without reverting the two sched/fair patches
(either of the two commits alone should fix it if I understand
the bug and the code correctly):


commit 4423af84b29794a9bd2bd07188d8e71083e54c61
sched/fair: optimize the PLACE_LAG when se->vlag is zero

commit c70fc32f44431bb30f9025ce753ba8be25acbba3
sched/fair: Adhere to place_entity() constraints


I think c70fc32f4443 is theoretically the proper fix, while
4423af84b297 is a performance optimization that just happens to also
fix the bug.

4423af84b297 turned out to be the easier backport; the upstream patch
applies to 6.12.77-rc1 with an offset but no fuzz or conflicts. So I
tried 6.12.77-rc1 + 4423af84b297, and just as with reverting the two
sched/fair patches, it eliminates the boot freeze in my testing. It's
what I'm running now as I write and send this email.

Next, I think I'll try doing a backport of c70fc32f4443 (I think it
should be easy enough), and I'll try testing 6.12.77-rc1 +
c70fc32f4443 (probably both with and without 4423af84b297).
Maybe 4423af84b297 on its own is enough though.
-- 
-Barry K. Nathan  <barryn@pobox.com>
