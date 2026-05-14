Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972A63D75C8
	for <patches@lists.linux.dev>; Thu, 14 May 2026 07:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778743241; cv=none; b=eq+4aMpWlrYNcZhCnkyJQikQFsVXGRu5EYaAJnxQXOCBiohra8P1jnIPnx3ESh4sDL1oRo1rhESG4ErtLc4HfppzId+VXe9aRACQwKEkbgqlxoWMqorekmP6A19f3GyjtAFEd4Ls5pwF/rTTnhm5m4d20sgzq4MgpWIueWKjLGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778743241; c=relaxed/simple;
	bh=8WY+VhXELNqA8GatSJ2GoRi5xcz2CiM19tQeAE35TFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZfXdmarZZifXQJqySxYCVvSTdEOa/2V/C5Ez39+KycdNqZvUJthM3TF9z32yNnJ1gh8sHhf0U5bc4brbLDjpdaTNf8np/xDTJFYNFFPi+TeHK1CIR7syRtLUAlqKl4n4P3JyLuSxGcdnAWjMVMkmE32hB5vmLBCPW7C0FrJymdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=fPMmjkji; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=a4/y6P7h; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="fPMmjkji";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="a4/y6P7h"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id BD5FCEC01AE;
	Thu, 14 May 2026 03:20:38 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-09.internal (MEProxy); Thu, 14 May 2026 03:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1778743238;
	 x=1778829638; bh=KkIdAgnajw/tbFniIrybanCO46LwJjeQG7lpqpdrIzQ=; b=
	fPMmjkjinWt1qMDUiG+iHO9Gl443F2iDzjxOJMnL7w/PM63uRhjkf+BHj1lP4OAq
	eqTqlwBDkKob7J1hhdr8BHmThbf7HSC4muJiCcKi0DfEDnclhR9Ieke42U1p22mX
	0guHGxsO/EcQ5UE0qUTgCA/7cUqV3log4b2lRn2giOO67vIBNfTQiPutjWUJy4Js
	4Qoc8goIXynv1xp/QGTTNp7XlcbHNw5HQAKJgwhDhjWYXWGEe1PD+UYizG/B4zAe
	A9i5Bp2TqBvepwciRJCDlZkJ4r03e85iQqVDhqVrgDxS9ySt6mKGB5uhLMjHIDYr
	g6FwkZeyG6iFWVXh0F+PzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778743238; x=
	1778829638; bh=KkIdAgnajw/tbFniIrybanCO46LwJjeQG7lpqpdrIzQ=; b=a
	4/y6P7hkHqJzjCNmXs30l5i6eXIYq9zJBNwo1OGikQH6KnkYgsLJAcgnZ6zGC6xo
	YsFdznqgqQC0SLhipIbUmJHNIreyutJ+/QlQdnk0YBNu7woM5W3XcD7Qr89At2SD
	puQ/IoHBINsy76junJJFSxxvMFIS5vcIrogDGxtzQgS8JqvThn58ir9b04KVhHZr
	9eKSbdHpWSUzcDz+1qaPguBQFcljpPWjEb6BEbPtryaV57gZwtsdSmxoRNJFmWqu
	FbsIfpluVE/vNMboE7QIUljlS8GjY9x128LlKFm/MjJW8JXWFr6m5EbVTP7icqrn
	w7ejJ8h9SLQZ5s8gHfd4g==
X-ME-Sender: <xms:xXcFavpLx1QbwldO6UR73OnZz3kttx4bL0QO4W3_i6x2TZXsyetojQ>
    <xme:xXcFalhEmdmVxj81CS50dk10LfZSHm4yGnEX9zDLlnS6IMSD3SIgsl5hKLYyHFUHA
    deMxCHFDIISAQK4IWqEbrO6gs2Wy81hYBId5cQ10iD7_D2wqwCWAw>
X-ME-Received: <xmr:xXcFansQ3bPNphC8onWekRHohHDL2yVg9jvrrDZ2WN8JadXmgu4Sd_UI6SfJe_tgJN62MHZ2HPlJABmfX_ABYUW3dg6ITeV3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdeiledtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeefleehkeehleekjeelffefhfdvleejteehledtieduffevteffleet
    gefgfefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgt
    ohhmpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoh
    epghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    shhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthh
    gvsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgush
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehroh
    gvtghkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehprghttghhvghssehkvghrnhgvlhgtihdrohhrgh
X-ME-Proxy: <xmx:xXcFam1wxWBlF8QSxStlmJwyWNpcJG3p4I-e7niog3pPCvy4v0_02w>
    <xmx:xXcFamyF-jxbL5UYJ_A5y5LDAdFjJ1V3gQj08vsu0PzmhRowxF8agA>
    <xmx:xXcFapVtdXL-9AUkL5wnRIwfqPFqLN02xQOmI_IgTlW3SwWlUdHXAg>
    <xmx:xXcFagComYHZmUlNPC_l4rXOCcb4FWeHyPGVHo1NgpJxNkZYW9qtqQ>
    <xmx:xncFag9xsAu-4VmOc8RRqec3XPleN_Q9468iPQMZfJzmNoj3tFsu72_z>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 May 2026 03:20:35 -0400 (EDT)
Message-ID: <bb244a2f-898f-451c-8a05-9350ac2a3f9c@pobox.com>
Date: Thu, 14 May 2026 00:20:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/268] 6.18.30-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260513153744.746440810@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260513153744.746440810@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/26 9:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.30 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2026 15:37:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.30-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 different amd64 laptops. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
