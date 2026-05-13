Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF173EF679
	for <patches@lists.linux.dev>; Wed, 13 May 2026 11:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778670755; cv=none; b=cOFCVAPzNaGvPabzZiRCT4Z0cyNxZm4P6IjH29hUsbcm/TRYIpHfVU7taoOir1MF6i/68cCjPOA7S0TGXbk9WGsPM9K/Av8746ze5wlW4Zs+do8ahXaihC9oQadDdmip3q2/FJCbM2g7BMsWH/ImewLbovvhIUsAijbtOdMY0gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778670755; c=relaxed/simple;
	bh=/ylwYKaVpVFAkZP5opJh6xBmyiAu/nn4aSiCglRwa7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZwz2n0i0a+x7/LJcL1VHFFhFxVHvc7PNRlJdTJT65z+lHRpldIIFjC3K2xfqubtT9zqSo3/kXMJrjf+r6M46tXpj9VJs8B0c7QF3uB+RqduCs74GhxHMFzVTa7nuVpHv5B5wEp8ACw6Kt5iAelKfiGcSyZ9485kzBBAYQ6F55I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=dqjF2fOt; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FEgsxbsx; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="dqjF2fOt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FEgsxbsx"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 5F1B9EC00C6;
	Wed, 13 May 2026 07:12:33 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-09.internal (MEProxy); Wed, 13 May 2026 07:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1778670753;
	 x=1778757153; bh=rGRk6nUUQ5KQI+G0pR/AAS29d0HuCabY8UYtZJX0GhI=; b=
	dqjF2fOtTVwlskJJ4OBOGamtip7K0yVfWzuVV92N7IcDdueCyhGfRv6nqjdy6Vn4
	yBIGKRnmd4/71uorrJKniG7m2iiXUwp103lLtTntBldMME0jvAojtvnraEUhj39I
	sRjzY7FKH8Say8d2nKw3gbUwxPoKWRyIYCYY04XDxtETmHl8a/HEp/0M5W+DMLn3
	WCByIg2VPoEPWYpD8xL+JRrxbnvilMzWFFhneYHWaEjQjFqqrWIsYC7N8UjKuVIM
	H5q5aJsRHaFFUZq9QIhyrUyeRrM96T2QmkcnfZZG8qwLasdAdY8Y4pjRB71FjyJS
	oglHANR53+o2nYMdrymDcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778670753; x=
	1778757153; bh=rGRk6nUUQ5KQI+G0pR/AAS29d0HuCabY8UYtZJX0GhI=; b=F
	EgsxbsxLP+l8QJoIQgu/O6vlZ3HWMvU69Dp54DeM8xDXghjcZjPQpiZF6QL3lhAC
	8hY3+HbE1RJagq598iO77JU8ElIUVod8+CAwEVRssLKJEJY93gSmC0zqAN+ejOgq
	Tmn1yAWrWKOg7Lr+cEukeM8aks0wdV2/OEjZSrTnVano9/qUD9J4Xv+WrtdJ5zhE
	V2WxtqgLllmH41W1XG4Ok80ogkN3K00adLk+u2vFdukA3a0gIoXj7lRmNJUjQUWg
	B67P/WvhOMW/eSjAXEzl3TqGzeGSLNEIoRBwu+GUYwZhFOhv/UwsJzQWW4patee6
	Ir6hOATixHpzlg3XEX1tA==
X-ME-Sender: <xms:oFwEavX0OX7I4snavgQxhU97hlrKcH3LKIjeBNP8frYSTYgF8UjiKA>
    <xme:oFwEaje5oPRofiBTpt5RaOtlhnO0sM5EOPu8ebQMXYr7kiseSWO7354fX_zJbu-if
    Zlng_6mpvcQibL6b2MqxNSLXWJvq15xDG12AgmbJ8rOX3C0bGJslw>
X-ME-Received: <xmr:oFwEam4tngjgZF8hYoAC-jiRvVfnSZ8j1d7h7CzPwOxKcN_G8-pGrPVuLEUzKNRwgUz5VoWcsFg6SfefJ88oMl7cpPpH_XB7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdegheduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:oFwEauQVBWFUS9lGDtyLiXT55Y1zkL4WSw0P9_WRHez8C52L4Pxf5w>
    <xmx:oFwEahfjcELxo4qXkjwc_zoWs0D_mSYPKHAOXwxZ67fEVlDmj2l-gQ>
    <xmx:oFwEamTxpsFYQJJ-h2BUFw4w2-jN4k97OMTQt7NqWT9JhNGaqauQMQ>
    <xmx:oFwEaiPB7rr3ehBLXKanxB7Er8xXpC90eITu6Bolttf0GMsdWg2x9Q>
    <xmx:oVwEap5qRhuZvhjsxlmSsnt6eObXBsha6GnnMRwSsTygF8zFWmbqlnlD>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 May 2026 07:12:30 -0400 (EDT)
Message-ID: <3bb9e657-449e-4eed-babf-ad881308a5df@pobox.com>
Date: Wed, 13 May 2026 04:12:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260512173932.810559588@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/26 10:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 May 2026 17:38:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my Lenovo ThinkPad T14 Gen 1. Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
