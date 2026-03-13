Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5202D94BA
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 08:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773389112; cv=none; b=mnhhIBe8iDOK+R1M1FSxgCWIfhcW1dq5VEAuAwRkH55ZjiWVdyER82Xn2WMQHIhXnQ6wYwndVv3DUo1u/WFfOIhzvkUGjinY9qp/2eT2xuT4P2a97Jjrt7++qFb2SQqH2hUSg1901PJh1KShV0AENNhT16zX64IJbIEwuAVgxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773389112; c=relaxed/simple;
	bh=wqErozLvvgWWmkLVt6qgXKa9A3uBCc8KacAL1eRrX7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HHcznYbIYsAlNxoT5VzeyZ3um7sORCVRNR4OtE05C+c5cSkAUX4YXsmY5IO7TPENA04tLrADX6yUrWNaHHRz/TvwqGKUlL3w3iwlNGlEPkI9mmChajDhakwJDfiH4VaxROgYbzPFiXDaXMkc8/jYz3ch0t55vALWhtBd+eyFSSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=B0rHviys; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tiGHJU1Q; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="B0rHviys";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tiGHJU1Q"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 542997A01A4;
	Fri, 13 Mar 2026 04:05:09 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-08.internal (MEProxy); Fri, 13 Mar 2026 04:05:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773389109;
	 x=1773475509; bh=OhYcmieEv+FE8vEFiY/PmfbU95BqiZFGrB6FxP1Df+8=; b=
	B0rHviyszSzXKV4CqvgUk89h6QVt/Fn+x7aUfEuOA9+qtaMdb08bv9RAHY26se/O
	BYlXmiMf8fz3t+Usn7N0rp55LzLAJyPYLE2RbIE8MIMC3UF75K5x+lnhKKIGsmfq
	HZGPlPD297q6vCQHsangFsQXDf7DcqfCSdADf7C7H4dYwRDH3FZGHsh0g7tuqqb8
	itZRDMETY+Zdf8bwuuT2mMjWu77mphmrpXClEmS1RTH5hhE1o0jmez5sKRW3+f02
	s2viwgUutrK7dN04kHDShRkdW3vR0Itrsp8PEAvlgysUL/kSfeJ0pOW2wHW/E0iJ
	NTmdBVtEULYtD7JDdkwtqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773389109; x=
	1773475509; bh=OhYcmieEv+FE8vEFiY/PmfbU95BqiZFGrB6FxP1Df+8=; b=t
	iGHJU1QEl2szCuN0eGxxp9lURLNv9hMUK75g+r6sb/0Rwo9F1cqkW5GByCFx5fGp
	obZktNOBPLEf3AXyNSkvSPLm/kiV0BThSWPtPamBaD8kNGBWA+xkklmXqsFXg0ws
	wF0X090bqwqIJJtX+qGImpc0/h2p5ga7YvG2TvSl7iVxTiziBtTnZhUVvr6tFVMC
	NVOwMshEGKoJ1tfrSOOJS7BbKuPdjvSGYr4K4MNX/10pKLS7IwUyhc3FxFnB/14T
	Z+TZd2AntRKvZz4rQBd4p6c7M8DId+MSHAxJaR4b/4CjuPNbYp0EYdxLYmBy63vg
	/WxT1pXUJnhXDMoGH2Hnw==
X-ME-Sender: <xms:NMWzaQqW_zoyFzK7l4jRL6BVKyujcfygoN6WbEuXRrgNwkvxWiVUIQ>
    <xme:NMWzaXCS5obQ_uw2ECHsiqSc7VY-8i1LpOshtTsyzuWVGSCQ-WXGEpM9vSrpzIPI0
    1MmTlKgvFEsvpYnmw3XZrYJ6s3oP1-q7Xexi2Y6F8noE21HUGZI7w>
X-ME-Received: <xmr:NMWzaWUHtzXd_fm-CR69dgmfNkyoeAgI1_J-Ln29Y7rxv1EQapzcidst2n6A-rP919IToK4G-yfL51hkxNBGBIDuNcVPTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeeludefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeetkeelheeuhfegueevveefheehheehgeehveehjeehfeduheejudff
    geefueffjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegsrghrrhihnhesphhosghogidrtghomhdpnhgspghrtghpthhtohepvddupdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehrvgesfieirhiirdhnvghtpdhrtghpthhtoh
    epghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    shhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthh
    gvsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgush
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehroh
    gvtghkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:NMWzaT6VgFT0FQJ8c3EWVTyz18-yhCVO6ip3ItURlX_Wmc7nExzviw>
    <xmx:NMWzafBDLHV1QLPMoHJeWollETlMydIEx9sRxUmv3xOvUsdki8vrNw>
    <xmx:NMWzaQA13hTWEwVpn4xBj1rzJqrxWwWTz2e2eNrLWSwITG6el2WAHQ>
    <xmx:NMWzaXguYKglV8vUkl1VtpKi4Iykd3G7SwhV-pQfTiMUvVQk-9OVQQ>
    <xmx:NcWzaTf226_aVsyne-P-0tVA_ericZQxyuE8klKfKZ3XgmfeNDtpMmQ3>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Mar 2026 04:05:05 -0400 (EDT)
Message-ID: <1c54210a-e197-4eb9-88b5-2ed2589c7230@pobox.com>
Date: Fri, 13 Mar 2026 01:05:04 -0700
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
 achill@achill.org, sr@sladewatkins.com
References: <20260312201018.128816016@linuxfoundation.org>
 <b4f58774-18d4-4a32-9c85-603f9e2c98fc@pobox.com>
 <ee851013-fec8-47f8-9863-392f17e54474@pobox.com>
 <2a313336-ccfc-42b7-a14d-c116733ef64a@w6rz.net>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <2a313336-ccfc-42b7-a14d-c116733ef64a@w6rz.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 23:10, Ron Economos wrote:
> Probably those sched/fair patches.

Yes, after bisecting it turned out to be
sched-fair-fix-eevdf-entity-placement-bug-causing-sc.patch

Taking 6.12.77-rc1 and reverting both of the sched-fair patches
results in a working kernel that boots consistently (which I am
using now to send this email).

-- 
-Barry K. Nathan  <barryn@pobox.com>
