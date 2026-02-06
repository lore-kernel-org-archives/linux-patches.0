Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFE62DB78C
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 04:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770352041; cv=none; b=HfpyJk3Va23luFRf/CtRXjz1HdtxTPD0qmHFPt8C66J5+GF3VxczBNeUakkcS+sxbYsGAEYF+J/OSRgMi2tR+JJ0RA1BnjzlM2hdK9Mve2U3EEqd8jZ2jCUrQEyYQGkE0vCgo9aiG/6ydJjDKJY1KwKgZ/OQZoyOZK5H3UUImGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770352041; c=relaxed/simple;
	bh=sEBa8mX5vfmlzrVT0yYS68ZeUtwDzsPK9rCWmlQnn1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T0p7PZJewPFiQhaPQF3u8jgQHHnNC+s7gfzSzb2hz/8xxwBQmB8qf84+j1fbZ8t/NfKAiF9ffBUZj6hFz7xtGBdOq+BCA8VPbUr7/t9SParvMRShFQBv2tH73dB6zhmdLxXP0DPcgxm6eTyErBeeMWTA/K24vsMdmKqMFWsszzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=fX1N60Mn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=r1v4mUwP; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="fX1N60Mn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="r1v4mUwP"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C3DBC14000F3;
	Thu,  5 Feb 2026 23:27:20 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-05.internal (MEProxy); Thu, 05 Feb 2026 23:27:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770352040;
	 x=1770438440; bh=SchoUoPYvajCtCyPR3JwTEFcxkDnskW85s8vragJfCk=; b=
	fX1N60MnAHlEVCWqQN6f4hOVBhk8trZrDDBnBncMZkN0dCp1qDGThYtWM+/As8sr
	0j2BlPs64aXL2QqMzWqgWNzcxNHw9X677rylVVvRQO6ggYLjHhw2InHB/KCsAbgG
	qFECfvFU080OXtovrtip5bOS4dXOvuQiPeqzUYpVSp34VrSr9Ue4kQy26NRxVtpi
	cfomiXsBALx3kNbMQzQiQIC7J+rijIAe7Q187wvZTk2nEO1zalmBaTZ+DGjjA7X1
	g7jtreZE+N+dfNZc0YqjGdBHG6wazsE607qFTrc6bPC+zjsmrRV/kDDRTg/0Rx52
	36vCwhT812vRcl3cY9LOPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770352040; x=
	1770438440; bh=SchoUoPYvajCtCyPR3JwTEFcxkDnskW85s8vragJfCk=; b=r
	1v4mUwP3AYqGMfR803bR2DoQFDoriSchPxIjyWHpWKa3fzxQGoUsXAJQ0VYiI/G7
	fk9i+lThxQGoZUovnJdp9NhYBg8y4Sz0daJNAR/VcK9Udg8mTA0JwZijlRSkdAF9
	Mot/cdTTWffL5eJINsScZw5SaOELL9Omn2sC1IjTHVMzysV3px01DLxQp5b+YBvZ
	3YRFETbIl2H2IJGLqjJPy0+rtCrCS9bebaic3smlYkUASrx8mluQ+aN1S04Ect0z
	qWRorXd9FTNzNF9IeC1mLiU66Rj9YVazfOG3rS3S//+NhcY0ioBxsIKZ9t60ZlnY
	AEEM69id6tcnEszZPrHPg==
X-ME-Sender: <xms:qG2FadJPJF1M_S8HyGDXPLMriVmSuA8Z7ffHWlQv3puRsAN8jXqYNA>
    <xme:qG2FaVD3x9UkTIHoKUPmEUi7ThESd07WuL8mgNC2OczzEqRNV4BLCiMtrAQJYBmxA
    BpmroAysthQjn4FCeBiXvrn33eHNFmqhAvYcOvWYNjpAOBGTnjLAxU>
X-ME-Received: <xmr:qG2FaRMUKhV7cOvKRa85XrKNbWMfRLh7mmDnDcziyGbdc-q23DtQMkKANinbplOYCSrcDLwA1GZvzE7bGXejzmmgPYrt1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeejvdduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:qG2FaSWI6h8eVtr-2rZu6sc-odE78IJuEMu_IlfkevFI6Rus3ieA4g>
    <xmx:qG2FacTutGCc5OFpMfFN1dyM3DUq8iBX_uNOlfdxLIzAKSisbbqxCg>
    <xmx:qG2FaQ1YmZCLup27Q2fkWB5LZgop3dIfX74i0FPwPfNf1VwSQ5Fb6Q>
    <xmx:qG2FaRhNLNJp4KpEyfStca9g7Ltg0cUMa0H4kt6r6PxTWEowcHWVmA>
    <xmx:qG2FaWeurTAD1ok5RfICQLFz4O1BIeHTrJR4QyRcAxnOsp19UkiGuqw6>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 23:27:18 -0500 (EST)
Message-ID: <48d60741-783d-4216-8935-6dcf44c0c90d@pobox.com>
Date: Thu, 5 Feb 2026 20:27:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143851.857060534@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on two amd64 systems, a Lenovo ThinkPad T14 Gen 1 and a DIY home 
NAS. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
