Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2F322689C
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 00:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771461907; cv=none; b=f5VmmOVG52ulYnx9Dto/iDPumsI0hiGDvBardmFGffQTLqq/pLNUL48am+l0ZPBEO/u0+aSAY8VPtTBRQ5K2F+siJE3AnhvhPyYxvtzOcFqu5fppy87muSHnAms+qTcv2kHvrxPquefdaw0WlLmbRvMRDKNba0GkhPqE2RUBjO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771461907; c=relaxed/simple;
	bh=4F6D5q5t0eR3f8e4daoJkgpNxNBVvsbdzPN/y3yODPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4SFAMsDGUMhJBdqHGS0ygTofl52QmZVnXuMysWZ5weUjVJWcQ4idQC2+MpH4PMhbKCon7Gx/2rfzK+WwTVEmn3+aVh8o6KeAOpOce129opU1pR86JZSuTHylyqGWMVgZDvCFStqJHzITDopRAtQxFexSJGYPBbFpumX5Avoa+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=UvT69xTL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DmTwHuPd; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="UvT69xTL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DmTwHuPd"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A913E1400112;
	Wed, 18 Feb 2026 19:45:03 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Wed, 18 Feb 2026 19:45:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1771461903;
	 x=1771548303; bh=Cg+oRaPUxxZvl5EfVfOgfi4D6uVgnNwvOgcl/pvhzC0=; b=
	UvT69xTLK15w8ewcolbGRDg9yr/zJF3F2+XhdHBRlhfGe7rXL+TM3z6nNBnmrwEk
	6OvpsUEg40Uyf4pmPyAAMw3jDKVhf3J5TCsz+MTITad+zZ4rfn9TtUE1h/aAIY2i
	ZVId3RSbG4EbciHYXEF2liFOfTP80KuC6r91lMZ9pfBJx4CUHS0qi3PLCCQEabM7
	eA73gixjkfDIeFxYW9vkZyKhtYcsRbhuR9X348eSvLS3c99s/cxRhv7SpoYIzshr
	A1Ljrvwju09yoJzNEL9B0r9O8LgSZblt/gR7904hiAZwnYRJqaGZANnFNcDwbfQC
	8K4Y2FaH7C4y3y2F8DOfvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771461903; x=
	1771548303; bh=Cg+oRaPUxxZvl5EfVfOgfi4D6uVgnNwvOgcl/pvhzC0=; b=D
	mTwHuPdBHih36Jt9Zdkq9iWePVhvBfyulVlVwJyoJm2GKoAN6ELfv+uILJSfoEKV
	yfQrY7OUjeFIpvk2WWjLybgCeqYu1STg3+g1bljOL9xl3lYP6g8Y5L+30rGIbTUK
	SgTYQ1K5Gcy+PtEvq/yp/UfWRKN9WXhQPKUwoGoayy2Xg6vCmWMxzT3zxKCC8NK6
	0efFdPu4GGf4gfM3MnWbnyRpcGr/wH3E6YqluwZLj1kWyWnO4OF6QnczrzfdLabU
	AlrP1kegs6v75CvXFrs40L3dYyccSbISd9Ub3fLcZbdpAq2quAvCWEpZGNCiWE35
	6oXyIxUCgBUMP0DkT1dJA==
X-ME-Sender: <xms:Dl2WaRTiIH1yMgNQwqKHqY6CeMj_HmvvrkboWkX--2lx-Lof0l9SOQ>
    <xme:Dl2WaYchop1MzQQ6IGdUyqfZiCMU7nbwKn2A4qzmDcm5P0-dDoVubJ8yQSajkkWD_
    j8UELSBVVTfi3Jd0nD2yj0MBh9pqkz61Hn3w4zwO9dotJ_w-8sdBA>
X-ME-Received: <xmr:Dl2WaYl6DhZwwe_CVge6NhUT4Ru5cIAfd9vfofF4Ia5K0-Frk05WjNOpgypnlk2n_d_RMyQoI2RzQsUr51Ws_TiggRd8NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdegudduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:Dl2WaVj7-KWoey9OYoP_ql60vBG5KTnhU_lA81F5HEG7CxHp19FwNA>
    <xmx:Dl2WaRGrTyIwZWRVOYjT9Twwgowavei5q5jmKWCsVZ8smm985uRDlw>
    <xmx:Dl2Wacw9E6upn9uE3Eqh3dXVj-OZYl8QnPPolYx-eSGzmqlgfWeP7g>
    <xmx:Dl2WaQpM1cpYIg6uWrAUTvbS788qbhuZEvnPKUuUoJ6VebfBw3O5fw>
    <xmx:D12WacZZ-e3s_lUArt-f7zKj5Gg4ob18UlK-OsMXEqwxDK1QhsFH_ANH>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Feb 2026 19:45:00 -0500 (EST)
Message-ID: <2cc3ccee-6934-4aee-b48b-79f9594b33bc@pobox.com>
Date: Wed, 18 Feb 2026 16:44:58 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/24] 5.10.251-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200000.708219618@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.251 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz
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
