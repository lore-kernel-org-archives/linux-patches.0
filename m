Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97AB157487
	for <patches@lists.linux.dev>; Wed,  6 May 2026 03:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778036747; cv=none; b=pDEDrUrGlaCelwoNPoqykfesnmZHGIIx6jzQGD8l9kpUZGk7XKqnitVgMiQxGybmy1Q0dQgybeqdh0LnCUHM7SC4WJxzwoCwYzmXfAF80tGDQmu//CZO2O4XTXEHqRUsNVSlcOBHVl9x8h3uD7aic96pxLryiCsotBggVdElaqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778036747; c=relaxed/simple;
	bh=gczScW1Azts7hoeZ8v/Inpc3/M+s8oFHXcVhBkg3h/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UU5DivcmqfbEqr9cUIS0UzSHBHFKGIRwqEsW3HFkDjfLk8nY9HnmBGZkRCGt58+eXrkNNiWPShqNeD/8wFn2UGR6gWFYwcIS8Bl8ADkBDPcBAzjbjL5pBnZParloi6XYcwe6RiYMq5ZujaVoUtSJm0aPbzmXNnry3Y0AyP0bOk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=WA2wYC1+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=msU3sk+w; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="WA2wYC1+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="msU3sk+w"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 743291D000FE;
	Tue,  5 May 2026 23:05:44 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Tue, 05 May 2026 23:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1778036744;
	 x=1778123144; bh=jvCyGJHkqt5IpuuN/pHHHIrytaJISPtch0oAVijrEsY=; b=
	WA2wYC1+HXJBs654TaVviwlPDcUza9i6H9jINsupLMZnwaozjXOA6Wu8oB8FnXW5
	qVkTZqidHqn1MVc4zPhCpHjahBC2AfvibdmJ+jXP3rg83w6/RA6ajBD3yhtUGx2f
	LG8Ny/Swd01miRkndZYPCPrf2hq39Xqfi2Z0sNyGpEIj7Qy5Ls39wuc195ZHFjsV
	dzGwxGSeXky7aK63ZqS5IMl/Ktsu5TVdhleyCO6H87Hw95bnJJu5W7gyn/cgP2Ba
	9s1RPkrprkyiJzwH1kBHdOlq+Riw+rkPo2PLyHoCMlCjg6Xdhhlnok+UN+PKMPCH
	1pcvp82tNqA91KRjnMf3UA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778036744; x=
	1778123144; bh=jvCyGJHkqt5IpuuN/pHHHIrytaJISPtch0oAVijrEsY=; b=m
	sU3sk+w3AvrHrOWSo0V+OJIZEt3xKsDoJ8MyFpknLM6DmN6Q6tqS6cN0lF58KFgz
	rqYoztAlbEvPJfxva8P9HQfHgoEBQYhyYrHQitl+TiS+FW8CCplD4MjeQSqWhqHN
	wY7LwTliTrsB3SeJ3izLyj7ij/1Zt/jt9nhTRlziDE/z9A0hjdGkif67UX00hUWu
	hFIXAT+HdToEGZh4nOMHfNrzbGPmkmBSXBBXY0pAH2S9X1dhfLkQc0hgAQvTu5Qs
	E7eItF+7m2im9V4B4gS2EeWhVoqA198d0snJOdHEwclk7oT+5rpFGQ3paIEUv0Ua
	vbekfaeTcHR9gwQ+ja5xA==
X-ME-Sender: <xms:B7D6aXSNYIaqm4Kf4eakLEmWBsPIhd2REg5xUApbLS1p2dKQsDeVgQ>
    <xme:B7D6aUrBJdEC3UNJx8EiaQIovS-VST1S9X8P8EiVZTi5beVM8UYDZoFn3lBOZUNxD
    rlq6JlHUeS_9IXM6eL9kc85q3lH4XtM7ROoW0zcL1bkz_vxQYlygg4>
X-ME-Received: <xmr:B7D6aYWvB14TEYqma22qooaK6Az0U_kL0403CGMuQ-cuzDgFcDI-Udekdv1-FK4PdUtnMSRNzETlyWp6u0mWKx9M8iCHk42F>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutdefgeejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:B7D6aa8jBmk8FOZ8VfTTvOByEbhbduw72ZTGdmBqMt6eIDjWg--UoA>
    <xmx:B7D6aYYkbF5Mka15BaCxXcFSPTILhnTjj1LsYfERcV6TLMWY-K5Cew>
    <xmx:B7D6aaeHv_woVsSvGMDK75Iru8PstC9eUMfAQry-7y6U_v0DRv6bJw>
    <xmx:B7D6aartKpthFGZVTd0IEBmL6wfnndzWBxBsPTamXGqkNZ0mbCw7IQ>
    <xmx:CLD6aSmjH7Tpszm-iFeOUBl3cGNAAXY7bDDTaXCz-PFJyYAL8tSB1Ou1>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 May 2026 23:05:41 -0400 (EDT)
Message-ID: <3835c9b4-78f4-4c26-8fad-695cbf9ee4c9@pobox.com>
Date: Tue, 5 May 2026 20:05:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260504135142.814938198@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 6:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 different amd64 systems. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
