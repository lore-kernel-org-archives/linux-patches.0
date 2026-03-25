Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A989392806
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 08:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774426918; cv=none; b=dteRDDUDFyJcSTSzlj54B8Z5IW5R/P6k8ba5vApD+etNl7jkky2EEuqtuXDzKurwUNdrX4a/4a0aeyyVf6cXDSa+fOUV9qI5xw4s4o6hwF/WGk06Iyv1KSl/75ZHHetAUWxKl+qaZn3TvpUtt3/f4hTOannFiZ2ctIgb6rusHgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774426918; c=relaxed/simple;
	bh=Zvw1qRbateDHyKzKm6QsL7VfDuW6wippK/WYr8Y45eM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJ7LWiDQRwmS2/+TtJNSRuctXGKu8mKwlOLZwEJRq3BLLhgM0MO4/rs1739/mlE5g3rLzcIdHqMPjivXB4Caa3Yy/hQTIduCHIyrg6jlxB8kmG6LLtWaVJKauBfIMdaCdEeGB40DHEUA9qBsMMGVApbwahC1KkARW0m8P1ZMArk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=B3BV6jNJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=X8//uCnn; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="B3BV6jNJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X8//uCnn"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 7F725EC0246;
	Wed, 25 Mar 2026 04:21:56 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Wed, 25 Mar 2026 04:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1774426916;
	 x=1774513316; bh=cewjqX885STHHbi3UzSHd+a/ej7GidnM25HLHmE3rUk=; b=
	B3BV6jNJ3Vjap4zJog8o8u/r/oBMU2wROUxxAT5P1kYEaXcautAplAzeSGQwC6Gb
	NAcr7/sjwLRra2bGi1fb4iR32sO7giH6L/ou8CH/xGjpAxgoFAvsbtNzA7ZPSM5A
	sP6BpLt//tfuq2wu4zbTlTWBV/to29LmvrlsVqhXtl16Pdc7y6JI9LQgpYwVvJYJ
	j3645BYa5FFxblz8+JbTHF4dyk+QxRCBlN8AaIYYetRu/97MNNBB/q+MClfkCMuZ
	hhWoOdpihDdU+XapEHUr2YueW9gwmJtkzBS7XpdqCDqio8sd0PoZdpayFnt2JsOV
	2emS4dPI3BZcJE6jE4MJAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774426916; x=
	1774513316; bh=cewjqX885STHHbi3UzSHd+a/ej7GidnM25HLHmE3rUk=; b=X
	8//uCnnbNshJQBPRDBTDwtwyXmBP2fYp6PTjs3DXZdCD49Qmzxot6vkUuefjkWiZ
	oFLioXRBly/q5TtsjLQQjjj+mdKm+kJjak5pOsgdqyTHgDSozAfOCZ2QZOwfhq2I
	Vu6FEEW4fTWgYIXEysZYuHHMOTV35Z6UWDWRGtRSo9mL1secFlYjB53Vo/dipEXn
	zxFnppyysmWonrFOK1SH9PdKxx30S3gzEeQyhC6exfaC266Dl35E2t78xG9293QG
	O/bZmkn+t76DWejw+NCL84zOeRu/YP4uD0ql6PvcBYCjoZWvoD0UVWcDISNn7MLH
	1s7ejRxlEWI+nLGqH1N2w==
X-ME-Sender: <xms:JJvDadT7eKb_jEYfJpXq7hlWJC8k32KlnRgUH9ywNGtsQ3K_JKDidg>
    <xme:JJvDaUeYR5w-So-Hd_M3zeUyvdMc9eZZXyl6VstVRwqbJ6enb2O1DN0LLQok9ETgh
    IvgMTHvMMioNOjbgJ4KjdH8PibdnPPod9AmPgr9HXgue_fjXNN7UbE>
X-ME-Received: <xmr:JJvDaUmKMiQFJNWByQiDLq-gy3iYfzSwTZUGh5T4ez8Hn-L4O1YnSBOMtNNMthBd_xfxs_5Wmw1FdAs-V6vt28k5efPN_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdefleeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:JJvDaRgwehbCn4mX5ZQZY2cH-DquiWd5mJpWZxx1Qa9Cqtq1kh-g8w>
    <xmx:JJvDadGgtz-HHehtu3yv9smFjXUeiz4GgbFQkqYrv95skugQLGi8Eg>
    <xmx:JJvDaYxgIaSXW3uHp7Ey0JAPdbxWWA8L17oD0AIMi68k1w0nYHimPA>
    <xmx:JJvDacqXEhJw8PD6Qem-JfykGcJ3EV534nXgpxieznTov3XqGLS-5Q>
    <xmx:JJvDaYYcMgMpR2tAi0lz0yhNPZ2yEM4bi8EwP9YHIohZnMw8o9i2FFBI>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Mar 2026 04:21:54 -0400 (EDT)
Message-ID: <f68260ca-6a62-4d11-a579-9fdad8f05815@pobox.com>
Date: Wed, 25 Mar 2026 01:21:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134504.575022936@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.10-rc1.gz
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
