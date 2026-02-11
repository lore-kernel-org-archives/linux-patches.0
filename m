Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC9032860E
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 07:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770794793; cv=none; b=moAczl193RaqvBTw/ASypOvxC34VKRvfUd0/hLE247h1a5nbhOoQElaPhYuQbOMrUJSYtrZaNdbiVnkK8tXLsOliKEITlGgwVLaRf16+EY/amJjS/PsmNEkCHMxHdnNiJfUaYPuecBkpnePGSvhWaKdwjXaL/bwNsKoFWMTolEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770794793; c=relaxed/simple;
	bh=AQY1Pch6Yo/fWoxiC1nOtd4TOdr6W4P8ILkIwlY7a3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GnoUNIMx55rcrX9oe9AUVsTl6OxYZUye4dCE9kpkZgRp53v/3RGMI5Qx9GMkD942AKwENTcKpbKIP7Ut4ZZfURmhUYujKskKwtg69roGpPx/X7QjVyCVgi+NV5ttmFsJu1Gxq9C4XXYW5a40ZHfJgHIZgLemGtx5FXUnOtJrvf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=dQ00WxJV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sSG1yyzZ; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="dQ00WxJV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sSG1yyzZ"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id E69661D001A3;
	Wed, 11 Feb 2026 02:26:30 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Wed, 11 Feb 2026 02:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770794790;
	 x=1770881190; bh=D34MrX/iYVQK1jA7+37Hm/zyrQh0fR6Ts8JMoGOGWME=; b=
	dQ00WxJVvA+oFyTpJlxZUzdrJcrkMf7ivkabSKPSC1xzt95MMoc5Zk5FyI6G8Jsx
	mlteYoQXTK+T9UOgPCYrUvbFva5vKPXMGLT5i1tJ0ZGg65xMXV2F9HLN+aVBvF+I
	TrnLWGsO41/LC/xZlRc+jl6WP91+HzRVG5ikIQwjvxEIy/oVaDHTuZBJlUlpVD7i
	SwkFxo5df21jTCPHr2yYXMEzq9TzZvbT8ZEpWlbKJBmoDqsNkSG4JbfFOhlBA84q
	wNm8BDP6djVKuhIMf9n6mPq2LLAYfL2rNxFy50L4I2IQxQkgPjgOyPihPyEYBhf3
	ctemhCkRrrtRw8RctXTzyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770794790; x=
	1770881190; bh=D34MrX/iYVQK1jA7+37Hm/zyrQh0fR6Ts8JMoGOGWME=; b=s
	SG1yyzZO/3lBmgK8JShdAolY0VmfpFFom384FQp1yvNACkbNCfP8qXMn0sk3h/3s
	sYGIb32C+9LSRjM6vkB5iQn0yltpGPyhOMzTVe2HBHN9bDy0Ne2Wx8tAXx7NESI0
	odp7obz/xhBkiz/WpezGvaSDwxJ1P6sx7+D8OBnO78pEWPOQsGp7dg+ZiW5Yih0V
	Lh9IdMQZQ++A1v6YVaGWyj2ydM+Ro039VitMfUVRpOhmOdx32b+j+nLM2va2AyYl
	+uvUno7Cl3I123lYRhm7TRkAg+eZyZdg3XKkqv4gpcZBkPRJQFLhC+OPn16VhP0M
	TPKy93g/dIxp8Ge+QfDGQ==
X-ME-Sender: <xms:JS-MaYi_afzFasMXAEksGl7L_C8P96SupQHmdpMYNd-nRc_-A7IaKg>
    <xme:JS-MaeujjgWhHlp4693Mht9JwMp2UoYmUvI3u8BdFAz1ArbCeXyxJbII0Hsc6qKkK
    0gTrPvvT5B3p52BD36Z24ec4ZsUJdKE7QRD3P4UX2Z3uE66_-cbQ4U>
X-ME-Received: <xmr:JS-MaR3XF7-u-udH5Vg4ac-iDQ1qrS2Sx4Fa5kuHnGUZ4Dmgn_7jsW8Tjssv6y02R6jVdNkNtSABPiHOJwIb0ag0lUcCRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdduleegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:JS-MaVxekri5F0FMZyblMlleCOkBrLZ0osuFRuVZxUhc770XDbbEqQ>
    <xmx:JS-MacVrRJxrS4bbxg70bloNQ1qfmhnBI_zO9YzCyRM8edORG7FFcg>
    <xmx:JS-MaXACWzucNJ_xJcSkf-oHT3ypm9YJt9RBSSr-IcZqWok_Ov2cqw>
    <xmx:JS-Mad5dPzNH--g92jB5cmf2l-dIam4soQ94msq-TclqYmTAXvKdQA>
    <xmx:Ji-MaX-EaTPtLa4GG7nNYU04SN0Ymr3T5ykj-5ON7BMeGmnYgO_UscnA>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Feb 2026 02:26:27 -0500 (EST)
Message-ID: <60ea3c47-2c65-4990-b8e1-a01b8ee8cb52@pobox.com>
Date: Tue, 10 Feb 2026 23:26:26 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/41] 5.10.250-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142256.797267956@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/9/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.250 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.250-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well, no 
regressions observed.
-- 
-Barry K. Nathan  <barryn@pobox.com>
