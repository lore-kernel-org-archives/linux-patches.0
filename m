Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740EF389E08
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 10:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039936; cv=none; b=YQAfSyyjpUnInlrJmV3u5xBo0itOEorEXMZrzE9sxL/Rz4IQlvkrwjYvwJhSIetvZztP1RDRkGBy5KWs5rDc4wBeM4hyjqq053+NXd1CWpIgCP8/j87qIWlQsX4QJ9Y7JKVvy19Z/CweOMEugNooqieCsIRhd3X/EwiwPMCTO5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039936; c=relaxed/simple;
	bh=mhwMvKasTg+skjO7gevQHXHOXkB3X/xwHL+u96axFLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cNGvEeQcQO1vwBqP9a5A65mDvrgSHBt/lKowKeVY4r6te7hvau/wrEIyLYQxSp/f4AED4UmFYwZrWBi3zbcxIfUJJAWyDiicnFvKoQiJ96pF+QqeUy+xZVF5yXNuXsS79ItwdXALYwh9L5lx4fJtFOc/gCuBnu+CvqR94xdF5wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=iAJaIaFc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eo97AN8g; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="iAJaIaFc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eo97AN8g"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B004314002B3;
	Wed,  1 Apr 2026 06:38:54 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-12.internal (MEProxy); Wed, 01 Apr 2026 06:38:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1775039934;
	 x=1775126334; bh=btQIcyAqCRHPWJTQCsjbBLdEFD3xmU2yuGS1JIsrrvk=; b=
	iAJaIaFcxBkfImYmEEnzySSu07iIqEusF9qjTr0Vg5rPNmPSD7JBOdHFtYiFHvlR
	a80AUVNpODBKY9AAvVKwFAo8ewhYXyzjv991JwuNUcDymONp8DFH8ppsEVCh0Mc3
	zVnoosyGJgq95qvU83lERcRubMlriLvyvr0fX61wGfzKC1rO5NluOtUSknFUXLk7
	qad10A4uwM6pd8HkoXFvKIXagQGhr1yI/StncY0F0jM4T3IVknOEsp5qHdZ9YOIP
	EtU0l9MlzevkG5+Kiv3tiKF/mh2i3bgq/whKm0gYQ5BTZ7JO1q57bvhrFuW02qad
	ONy/8Z5UDyDwPsxVWEtWYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775039934; x=
	1775126334; bh=btQIcyAqCRHPWJTQCsjbBLdEFD3xmU2yuGS1JIsrrvk=; b=e
	o97AN8gbS475Og8OD4leG5FPjRWW0rN0o222ZfaZP73E/Nyo+V1BTANMPOw25Lf/
	mM14ZF5tfKW4CskJ/IB0+YQL0T0F4zO3kFRpM/vxvThLy7mTpa7DWbxlc0nHUkI0
	BCPrJO238Rvd58ypUHfZ4vaO9hvqqzg745iKB02HoeupcFgcZEhfvMIQZ5EBXLlO
	779kM+kpGisgrUNt/YfBkhWb4L6NtzduZn+Si+FB5zbpebkB8UqEr0cKQy0ZbciG
	hlzzJll0pNOqlvT/J5sajAFwkIYBXfssNltsw7UKAC5R6QB9RCVndVKn2ZwAvIsp
	kmjfyT5ojq+3ZyZBcdUpA==
X-ME-Sender: <xms:vvXMadr9JXCQ-kFwlKufdr4kz_B9-3JUJZUvXoz6xAQLMy6jTx6DrA>
    <xme:vvXMabhAOs9q9EukpwDw_rdpzTK2UtHJe6Gnsu6ecyVUjm_s1IjEnYOe_S0Iwywru
    wEHxXYy4iqGCOz7FmfA4AsK8PkhEww08uPD64RJ9QVm-a-iiO9z5w>
X-ME-Received: <xmr:vvXMaVvFptRr7CecNZLnifJtTpT51HhR49L5sO3C9VnMDevZFBendC6wgtaseL7jzsrTXSO9dRGyEP6hosLtV8TPF7J8Bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhrhicu
    mfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtffrrg
    htthgvrhhnpeefleehkeehleekjeelffefhfdvleejteehledtieduffevteffleetgefg
    fefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgtohhm
    pdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepgh
    hrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepshht
    rggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgrthgthhgvsh
    eslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgv
    lhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhrvhgrlhgusheslh
    hinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhn
    uhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigsehrohgvtg
    hkqdhushdrnhgvthdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehprghttghhvghssehkvghrnhgvlhgtihdrohhrgh
X-ME-Proxy: <xmx:vvXMac2zqI2aeg2suwjTJaE9pMfAzzLgHpLmXk1fzFiHy06tgk4TUA>
    <xmx:vvXMaUx1xuQOYfhs_EU1qY12H-PMNAJP4xIBOoj5iK9EtZcv1d9hNQ>
    <xmx:vvXMafXPTYBDPSEaVzpT9VrFps-QPSh6PA_LzOM1GPvuKJ2bkGBWqg>
    <xmx:vvXMaeDKnb_3_1vpvTzlmHQ5Etwg4ltZyfAs8dQJXzu7yfPGynzRWQ>
    <xmx:vvXMaa_Q58OgM3RdFbBdPW3LWCd_i3CxGsAHPFfd-YQXSM8cfUUdWndT>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Apr 2026 06:38:52 -0400 (EDT)
Message-ID: <bbf7c88e-cb8e-4a7c-93b4-fbbf47ced40f@pobox.com>
Date: Wed, 1 Apr 2026 03:38:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161753.468533260@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 09:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 systems (2 amd64, 1 arm64). Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
