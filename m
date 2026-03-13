Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C1A25F994
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 13:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773409112; cv=none; b=mWYfJiUjEDlKPQshUXT2cN8Rmepxl9zHEmBVclxTEeRKeuGKSGQsc1qjxvaGNGJf3YMye1DFYTBT1zdO3MoMwn0DInNjOex3s/pMG3aIWpd4OEH8f6Zym2p8z3lr/udslD+qB2MOPuSIs8wVqYms7PuugH40S21i+lyuiux+Qz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773409112; c=relaxed/simple;
	bh=Os0JW1TzudHFksCaebelz4c2+1iPcHFn6PqI4MGgM5Q=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iiFAMaV4oU7GshywwlODuLvz3b4PXs6reB0P5skRoqDHU1H+LldOCo2CIIhMdf1LYk91U15f5HTGolsz674fITm63b7bIBBJAzfEsUkYTPE0WdHm2HjRYd7RhBgrl4RUR+Hew2QoQ32rnr3Du2lHZZuyYxiUjTje7clTzwWUiLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=L9kLYIV/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=s2MvJqWG; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="L9kLYIV/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="s2MvJqWG"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 439B1140009A;
	Fri, 13 Mar 2026 09:38:30 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-07.internal (MEProxy); Fri, 13 Mar 2026 09:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773409110;
	 x=1773495510; bh=bSYgn1HqoxMyATXnOdNvryJrUoij/9abvESvwZ1raxA=; b=
	L9kLYIV/fH5Bak/6I03N6IqKoF3wR0htpdq6QSPvt0qFGmf2XUfAqLCNXm5c0a/j
	HCuS7t+3scZrdLh7djOqr1/3Fok2HMJY25cdezxgzz2ricLrnskYyacmz0nlcjUT
	x+TJqep9BeyDXpJQ1SKCCE5wEF97YIxShQjCbqSgNvHTkCokPQ0KlyA7cOv6+F3r
	LWAzEpTAfq0tljFu9/RpZG4taJs3jpb/L+N4vFgu8dVCxMmEqacfVndOK6/9JaHu
	wUEHEykKOAyeaTNhjfYElMUmo8T5r6SEMYOmONcQsv6FEvbMZZYQDcAq2AJxQwFF
	0LF8gNFX6D/xZPsKEDzfzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773409110; x=
	1773495510; bh=bSYgn1HqoxMyATXnOdNvryJrUoij/9abvESvwZ1raxA=; b=s
	2MvJqWGKBO4uiGEi75CVuv+WusdilWK6JAbu2nAPZ8ZxLrx1Fa3WQ0+EvkxxydsL
	N/P7hTx1rUQoRm3Qlk9OnypLwddcDDIxe2pLF3Np38AMOqZ1KGYoSdpWXCIKT18m
	3AdOrUfK26hD15Sq95RcAiW54tZwQhjJj4N2p1Mj+4eUu2/uPJTGRoGoPYPTe1jE
	P5E47ySt/ZqCWbR94VfN/aBbEff+2kpbZ+aNNH9JdMnhIiD4sfjtW7q4WoH665ix
	OWR2NPH0wGL4hP94McxlAEhOrUgHRBDILGaUFIvyN8sjgHOeyvWxKBbYivxWlFKu
	QSa8Cr9bDXau545mJh5hg==
X-ME-Sender: <xms:VRO0aZXfmhmFsS7pg5m5AEOXd8rsPBlCjXc1KWwSpPCzF3rUXzQNdg>
    <xme:VRO0aaDXmXptRWnXMvNFMGrVVYYB1yJyYzFxozUMN2jcW_jpSZCBoAc0XaGYRL02c
    _QRBuSBM_QP9B7g1a-FhDI3z_sjhO7dTMSgCdz1Lr4yzBrZSjhZBpJ->
X-ME-Received: <xmr:VRO0aa3SeMf3E7rsp7HFXHl5t6SROyVNoGoH9gF1ua5D1iIReg4LgA_5BDHVW9O1_91yO4rC8aNPcq6YYiMAqfZgN7d7FA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeelkedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffhvfevfhgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeduudekvdeiuedvuddvgeelhfeltddugfdtgffhvdekueetgedvfeej
    teekvdeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegsrghrrhihnhesphhosghogidrtghomhdpnhgspghrtghpthhtohepvddvpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehrvgesfieirhiirdhnvghtpdhrtghpthhtoh
    epghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    shhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthh
    gvsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgush
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehroh
    gvtghkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:VRO0aaR4bc8XQUBll4Ni55Viv7CMF9QWIAeyuP8h4Vs4F8H81lwjAw>
    <xmx:VRO0aXYu5xJr6iKDKpQUwYhVV7L3pJb11Aio3kUddx1wTQboCdcGVw>
    <xmx:VRO0aYDTvf7ok_mW689zkIWDtXYeBupBvYIyZDzcQhbf37ABl0jjGQ>
    <xmx:VRO0aeDymWN-yrI_S18af7QiAzQRKL5JlH1IBUvTVueuW5OkqFgC7A>
    <xmx:VhO0ad7HhYIFPvBhaJvfyXDCNDj5SBEaj8I_BjSFjuLebqAS2um01Jui>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Mar 2026 09:38:26 -0400 (EDT)
Message-ID: <71d1fa5b-e6bb-4289-bd8d-445aeddcb9d8@pobox.com>
Date: Fri, 13 Mar 2026 06:38:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: freeze during boot regression Re: [PATCH 6.12 000/265]
 6.12.77-rc1 review
From: "Barry K. Nathan" <barryn@pobox.com>
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
 <d87a1702-6906-475c-afd7-9b4b25bfd48c@pobox.com>
Content-Language: en-US
In-Reply-To: <d87a1702-6906-475c-afd7-9b4b25bfd48c@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/26 03:53, Barry K. Nathan wrote:
[snip]
> On 3/13/26 02:37, Ron Economos wrote:
>> On 3/13/26 01:05, Barry K. Nathan wrote:
>>> On 3/12/26 23:10, Ron Economos wrote:
>>>> Probably those sched/fair patches.
>>>
>>> Yes, after bisecting it turned out to be
>>> sched-fair-fix-eevdf-entity-placement-bug-causing-sc.patch
>>>
>>> Taking 6.12.77-rc1 and reverting both of the sched-fair patches
>>> results in a working kernel that boots consistently (which I am
>>> using now to send this email). 
>>
>> Confirmed on RISC-V. Reverting "sched/fair: Fix lag clamp" commit b547745a2c78fd1cc1fdc6a0d1b05c884c05cec2 and "sched/fair: Fix EEVDF entity placement bug causing scheduling lag" commit f9891a33ba67ce40e5a17023d2f3a5e2b7d72ffd resolves the issue.
> 
> After looking into it a bit more, I found two upstream commits that
> should fix this issue without reverting the two sched/fair patches
> (either of the two commits alone should fix it if I understand
> the bug and the code correctly):
> 
> 
> commit 4423af84b29794a9bd2bd07188d8e71083e54c61
> sched/fair: optimize the PLACE_LAG when se->vlag is zero
> 
> commit c70fc32f44431bb30f9025ce753ba8be25acbba3
> sched/fair: Adhere to place_entity() constraints
> 
> 
> I think c70fc32f4443 is theoretically the proper fix, while
> 4423af84b297 is a performance optimization that just happens to also
> fix the bug.
> 
> 4423af84b297 turned out to be the easier backport; the upstream patch
> applies to 6.12.77-rc1 with an offset but no fuzz or conflicts. So I
> tried 6.12.77-rc1 + 4423af84b297, and just as with reverting the two
> sched/fair patches, it eliminates the boot freeze in my testing. It's
> what I'm running now as I write and send this email.
> 
> Next, I think I'll try doing a backport of c70fc32f4443 (I think it
> should be easy enough), and I'll try testing 6.12.77-rc1 +
> c70fc32f4443 (probably both with and without 4423af84b297).
> Maybe 4423af84b297 on its own is enough though.

I originally wrote a much longer email, but I'll try to keep this concise.

I was able to backport c70fc32f4443 successfully, and the backport does
fix the reboot freezes (with or without 4423af84b297). However,
backporting that commit convinced me that it's too risky; I'm particularly
worried it could make future sched/fair backports more difficult. And once
4423af84b297 is applied, I think c70fc32f4443 ends up being a fix for a
theoretical bug.

So, even though c70fc32f4443 is the commit that was cc'd to stable@, I
believe 4423af84b297 is a better (safer, less risky) way to go.


In summary, I believe the two best ways to fix this regression are:
1. Backport 4423af84b297, or
2. Revert the two sched/fair patches.
-- 
-Barry K. Nathan  <barryn@pobox.com>

