Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E283DCD82
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 09:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774343341; cv=none; b=YHyKfz6sJOzgkDqJDv3zXg25YyLrVOE/mZpY5pTfcZESbAzGH8GfxgohQRMIa4f/oy3p0b0U+WDZX8XeoE32ecPFS3TYp5ofxAWMuLiKBPk+qF5o7XpPSDuxTXIwUrbYF2t9NDpfvEb0rdIZonsM5H+lgZX5tQKjCYW5NAckj5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774343341; c=relaxed/simple;
	bh=/q08/hJS22kkdBfDNaW+au198b3yybnqZiagyp2PT1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QOyB3qfDZncuvQOdOwOj6i+fZpiuJLRMnPRVfRieYTd80TwxcDmMzoq2vdT+d9pEbfm+d197BPDA8rlXH+63tRXRyRAJOG8UXF1SfsqwROPnb+lcFFMN2Yrd877eY/1tbf1+DeorM2qS4FTubq77wlN3zjeP/SgwqvQB1+/o/uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=b4ioA8KL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=155BLQbW; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="b4ioA8KL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="155BLQbW"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D80F71400220;
	Tue, 24 Mar 2026 05:08:52 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Tue, 24 Mar 2026 05:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1774343332;
	 x=1774429732; bh=QpCnatYRzwCG2zmiscszJ/0kViuwxysZZHdRGdDEVzY=; b=
	b4ioA8KL4B+aDD0GBxeXeVlft9nI8g9u61k3WdeO5cbSuvwl+Wh6qQWzt9EyTa4W
	ufepdBlBxvQfQNDh3wkhFaWneO7/sgA+eVDC/glGGQc7xvJa9P4Gj9FJkMqkAKHp
	+ZVw2uHha1aIzwlGm6Z9s/SLhdb0ZLN4HD6RN8x1sxaYFTLQesAI0BtGjMQDhlYZ
	peJVEQslDpH17oB8o5oq5HKjo4leRCiSRCZZoHTgJMO6BdYNLlLn4VOPWTC22dDh
	ES6Ffmuh/t5bIlEFpvZAQp5AM9KwLbtW0379gzzwUgMDre7FQFyUlgQRda0tB1xd
	ZsXccxf3h4bYttDsFauqXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774343332; x=
	1774429732; bh=QpCnatYRzwCG2zmiscszJ/0kViuwxysZZHdRGdDEVzY=; b=1
	55BLQbWCubmfSpJx2r28C1iW0iNxfsByJqExyTin8dMHLA4+dN5FQ26SO6rlgmkb
	8JWapu7Msr+XbAkKIVoLx5xwLKauulR4dbHDA1lhyVpgs/aGMSgAhq9fYmvHNDjW
	sg56ODqvinfGoFtVLzKV4Kan4T7X2Wl63b1XMGhL7/PC0YJUvfeVLaJIYSdr2nmc
	aLmZJMjmjRKkwceiknT7ycOmJqIp7zorhwsMdeylbDfOW5LNY+YqL0t3DjKnMPOP
	7LMptCRUeyLs8uwDBtC38XIA82zDlqdXwTZMuipHe0MB433TG5SHiJ9X6/V+EVG6
	pGsT9sG0OEWudl11zE1Hg==
X-ME-Sender: <xms:o1TCaVmSf2Q0wMOm0U9WQ6BYSSezStKHUU0o22SZh5uZkuhvXf9A2Q>
    <xme:o1TCacuU3FuYnkA7A9yF9c6Y0rUKyRPxZD2S9QTifhTx3Wdv9bkl36Y1DOUohQyV1
    JQvMYEozl-HU5Cm51now10R0A11LPUNjbqQ1nVguHM4cXeqpWNkceM>
X-ME-Received: <xmr:o1TCaXKj0Yj4lqW3NdiFdg_14mGWzP9P89AvyYpScnazD8ATs9FAxbjeAE1O0DMsUSrlblxF3KkfjEoyffJKhDDtJN9Hrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdduudekucetufdoteggodetrf
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
X-ME-Proxy: <xmx:o1TCaZjtpXbdMN6a01OrbGgwfQLgl1CfzVeCOIBKryF43orjtj-gOg>
    <xmx:o1TCabtyqOsYwvtEd_jwgfFHGdRJhuXRBIVk2BYcf9EELkjoWIOgyA>
    <xmx:o1TCaThyjFyVI07MMI0zjAvI0TJFHKfSGxrwwovnKDhI6j6bJY2XxA>
    <xmx:o1TCaWcT1Xt7ZUt6L2P-2fgGDDe5TjL1RiClmK-Z7op7pC7zwqYYGQ>
    <xmx:pFTCaXLBpxWPcdLR-BVIU6i6NXe0CuXmkFpade-Ks0i2L7YZBeXwLiTE>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Mar 2026 05:08:49 -0400 (EDT)
Message-ID: <4bdd0b5b-520e-41c9-adf1-940b699736c6@pobox.com>
Date: Tue, 24 Mar 2026 02:08:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134533.749096647@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.130-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
