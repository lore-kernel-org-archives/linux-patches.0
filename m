Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B9536AB6E
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773913529; cv=none; b=H8IcTKycN4r6H0mh+mRabPJwQZ+AqPZd7RcOEoRqp0mVHP17e4VO09MMNT08SHThwHb2KTPn1ULV4lAQJfIGG83Me1p1035KbYbyJ2vy2Y44GXW8Xrmc+d0YbWBzlLPNT06ltv1nKFdYCyjO11YTjtheZUgoyPoyYl2huZecT6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773913529; c=relaxed/simple;
	bh=QY70JMdiRH+xFN+LLG0Mk75g+UBu8k+n0QtDtJ2ipNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j5cJpRHbQ1kbLl58beXfu3b6cBYZp+4XcpaMpFBzVQaMBoLsI421rRHzCeg//6IHMo7Z7tHac3OmCIaNAssvXwHiPDr2ZY2J7MuXA0cdeAZO4NjtdQWGQ+8AAzVlUVLesCGoCGFNwFP57dfgkoAroVthO/gsn+XlWe9NQzjIsDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=hDmsKLBc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=e5p6hZd3; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="hDmsKLBc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="e5p6hZd3"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F102F7A0060;
	Thu, 19 Mar 2026 05:45:25 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-08.internal (MEProxy); Thu, 19 Mar 2026 05:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773913525;
	 x=1773999925; bh=rusm5Vtzetj9VyDhIDIcNPek70wYgVsKADZGoqvCulE=; b=
	hDmsKLBclbAQczdrixvUImkbNbEZHR3UHWQLGCnpqU56CuB7tdNFiGGFXYpyUMg6
	Iv6Ag5emkctkUz/U0JM3MkJeSbwJqKmdiExZXGHYHGj67ebWKVfrffn9tURpMnnA
	MpzYv7MS8dLXA+uGOMqUlzPFL3X17Q8077uUJHvS7zcqcm9ckFMxGB8k8k69Q99K
	un6SP7bTrWrZ6AdPPtQrMxtCWWBVV89g2v/yW3BlOSF0ryvCEwD7btSGdcZ7B2p8
	HaCYvXEWl5eCLweRhs0eF8YPZSU1pPKeVddhzaUu1RVl7yaZd2PjNOPgqFKEI2zg
	NXyhWkQDBKGzWNO2Ce0smw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773913525; x=
	1773999925; bh=rusm5Vtzetj9VyDhIDIcNPek70wYgVsKADZGoqvCulE=; b=e
	5p6hZd3MqI7SvfLHvgj5SxislhDdiCKecY3Jh/CURk8IgdOOz4K/kHcO93Udl10t
	RZo3JFFk0h4E38o/0fH1cewtm8T3ReEav1Cl6fycZI4zAMn8qqD+3ubZJk2K2GW1
	ysP5aB+HMWIT8JGS5gm4XEBM5e3LdIYtE9FUA3n0XKGt2Ge+iFIHnslZUynR/yDS
	dozY+GTG1UzJs89L64Jdt266UHAGyMJUOotiNtq/XhJN0ZRvz3aK0MWajSmwHAgW
	LrvAQ+9B7YBeNJ3LafQuZ8l2G67sE92zt+tfKFE+WM7QKLvuHqWhNMlJBjOXNcww
	D0mEvpAv2RwGj5EO7UByg==
X-ME-Sender: <xms:tMW7aeihBGJqoTKYQrNiuQSQM7Pen3dFJafifRwYk5Z4yzTu_386Zw>
    <xme:tMW7aa6uUjMnc5tdRWZiaP8TUueCxonxCdLjYyauU6fWI6KcGMaX3lazIBrJQqdlp
    GqxekjOth87d66EII6eIuFXHss01smpRwHD2QPxjHAxXpx9HGGQJ9aX>
X-ME-Received: <xmr:tMW7aRmboBgaT66wRO-xI9mDjcqDOkqKRhbug7ojzdPLVPeTwJphgZOYi9Q--shcRQWy4-dBavi3ScIFUiVqnriicejHGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdeiieekucetufdoteggodetrf
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
X-ME-Proxy: <xmx:tMW7abNpOcQRSdi7s82U1aaVAebYo3FeN17xeFzbt-M6tnkcMQlp5w>
    <xmx:tMW7aTqM2EffKzMgnB6xIBF0H5paVAI1wmX_67JBlZElv7Ux5tP3lA>
    <xmx:tMW7aUtnA3e2OXt86aqUwRZu7yzdH2YBhyW_ZbBwgPqnbdojxSoWOg>
    <xmx:tMW7aX5-Lgg4bvN15zy5eJJOHViGUuUmnwF096Kbhfhye9SxzI0WYg>
    <xmx:tcW7ad1wqvYFfFfc1yq7HMnE9PlY_GKx118IWSNYoS0K_WJxCTso4Vwk>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 05:45:21 -0400 (EDT)
Message-ID: <12e26873-30e9-4bd7-adac-78734bd82c53@pobox.com>
Date: Thu, 19 Mar 2026 02:45:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260318122547.233850204@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/26 05:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Mar 2026 12:24:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my amd64 DIY home NAS. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
