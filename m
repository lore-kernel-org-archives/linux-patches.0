Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7807223EA93
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 04:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351852; cv=none; b=bWVRm7ayfGoH5s6nWLKoO541nQtLPbmMKCpkZvynr8w5E6VIpQuIVvIlzdhf52NThyIv9PlAoK7ilJXNQ0PEpdOONd+Ya6x+nd653pN6D3sO9XCNA/gBEm2lwxL/q64BjDVvPJVMbtM6JJ0ANk1ekxWKYGy0KixMg++kJ+yno8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351852; c=relaxed/simple;
	bh=WGfRZc2d6BbOHdLirPkD53miOV0K2vlSBbSRkGoJ+1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NYxnmvrI0FKOywmUA41G1f2JViQK4BbwOYBppnOSOBfqrrQK+FpnNrfMvrgTz4TntX9YQGeLwWtXD7/tYbAMjUUhLAWPdYClK1P/Gx/xlSWBOWl5AOPHFJSnDTPnlm4+wf1JCYr5XYgZRz8n+gWj72kM6o97as6bJSVcsb30BbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=oTyE/ygt; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NPY18KoO; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="oTyE/ygt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NPY18KoO"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A207114001FF;
	Thu,  5 Feb 2026 23:24:11 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-05.internal (MEProxy); Thu, 05 Feb 2026 23:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770351851;
	 x=1770438251; bh=N1wzTV/WZL6Xg9Hp3hlRbBWtAfyVnxsaZovfh6WpJDc=; b=
	oTyE/ygt4zc/soUpvdUnzeTlY2gBj6537nqjH8RmNLuJKWnChk/dVz67lV/B17WP
	1CdKjd9uVWxFYkMhBGwDcedS067/Uf+ptyypsD61ZAuztQP0vKI2OwCwCjfAEgll
	5854Q7PG/pnWe0ILsLht2TZJSjuB/LCNseU8vAc+M2Bo09LNPa3UpZm1PXkm0W31
	VVfFyzkaMay+KTUJZ/0Hs6AjiO3nMOyJpXuE8UxwKf/Fy4Y+RoEheIzczIOUs8L/
	Fv0cbvNI5E1aex08izLImeEUvxkEmBlhqh0JasFmkh2lOVaYySD1+j+BMo1bXhem
	4P4TmWcVeUYbftjH+lv0wg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770351851; x=
	1770438251; bh=N1wzTV/WZL6Xg9Hp3hlRbBWtAfyVnxsaZovfh6WpJDc=; b=N
	PY18KoOwoD0jlTy7bPXBVVeJL5P3+hwwLRD8tNRHq3d19qAMiXD9CphyazuEc5aB
	vqh56PS5///P2slCxrwP4NLkCkS30YlSKImw2sK7FoW8AJTVKkLhlC/X8mMxUyLd
	uPXZFvFo+DgUNeUOL9adj1pxemmA/PBMWKxQsZBEkwiByEg0Yy56qvb8R+9eHMSq
	7xwrhc+oYbQXKN+jFoyD0FOrtAVWd4KikdM0xrAPnisukmJO8gV5i7SS0W/LTTfJ
	obFtcbLoHt7kTbTqWcnRXPbGNxE0ZM9M1ocbk7+hz2pC/Ls6hnMkCse9szcXyl2H
	2LMBYpgFQXChZuFEDSjLw==
X-ME-Sender: <xms:6myFaW2jySURGtW037zOauUZCGB32nspB1_U9UzJ4RolxDrh4V73aw>
    <xme:6myFaU_SLUoEieoXVfh_qQHmxef88k0EcNYqua8WsGvrrl6cRa4GaZJJ77KahHg6p
    nmla2IvIvo7WOD6q_R1a5Jq3vESrseSrZ5VIzV5CMFePg-XxguwHFJn>
X-ME-Received: <xmr:6myFaaZsXSz1jHWt4Ydq_NA86-zq2hRwQUdN7rh2WHWtpAaxP0uHm697PkhSw_pkOdn_EAXm0-g53oFd6o4m2pNBzF3-aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeejvddtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:6myFabxQ30NODEmM30HFBvx-mCe1jODOHHWAmGXqmRsyGKBcTvBg1g>
    <xmx:6myFaQ8BWnnZtU7DSHSCsTUbZ9tb_BG9TN5wYh-AnBmAZius32Linw>
    <xmx:6myFafyDdUTb1W9LCzU4ZrZ6BhqyHUeDBPw7oke6YjjCqBbNs8ja8Q>
    <xmx:6myFadu7t_gTFxDV-8ZV3EI1lR35VCb25VQ5v9adR3BUB9KJSZGuWQ>
    <xmx:62yFaTKLQhE4wooFUIdOv1tmdH2pa9sKhIRg-MBBW1wctRiTKa_Zhd2M>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 23:24:08 -0500 (EST)
Message-ID: <05eeb289-29f0-4ab8-b08c-c003ec307017@pobox.com>
Date: Thu, 5 Feb 2026 20:24:07 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/160] 5.10.249-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260205143430.733102763@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260205143430.733102763@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/26 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.249 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Feb 2026 14:34:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.249-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well, no 
regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
