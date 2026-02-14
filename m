Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DA642AA9
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 23:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771113509; cv=none; b=Xwd6leJHl7SORYyqI/+myfq5BrW9Ksb7pjoXQoXz49kDMYEpJ84UW32gr3aoReSpnz2gc+IBkbyMlL4iE4W3uGS/d6/ysA288mzgKxvoKAI3u7FsQgj2yfsWHCPAu3CW7ygSLZzC/pzu8YDgsy1owddADKxpoZWmMKwvjAYhILo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771113509; c=relaxed/simple;
	bh=andy9kC169edONX4/CKW1kNzS8b14/li5qQ5UoIfzIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FzjW0ePp18Po+f4i7EzoV8f+Vq4qr33LiKso4cfRDSK8/2H7Hr4AudcK0lXLWXp4/NHN346O7tmr7OMaSONuUWArwMixShUmdNFzgAg23Teq1yPzQiF89Vrw2Opi/V4b1JNvQffopuMQ9SW2WyCrsLpHYeZejdy19kBl/ATYaNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=uC1Cn/OD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=A/SK2U5M; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="uC1Cn/OD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="A/SK2U5M"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 316501400082;
	Sat, 14 Feb 2026 18:58:26 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Sat, 14 Feb 2026 18:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1771113506;
	 x=1771199906; bh=USUL/t6anATWir8WW7h8je8BTkLziXhBoIaNtfsRqos=; b=
	uC1Cn/ODXoVOxdiLMrojxWGaPLSXXjJobnMF0f+QdCbGRfglBwVXeiYvS82StXw3
	gfEw0rD6Sx3f+RQH7A45RIxZyf/qYLnqw8MQsNYRg1O9tKPgCMqZwYuEjsy7mjPr
	DoPhZ97Gb/TW3BQnbSXiz5uucccQKWEnVUMpPemzCObnUudsTC3+6ipUt1Yd5znL
	vc6ln1H1Ef/CL6bIaCE8+WL3VlWTNWodJf3G/SVFTRaEVtebLQxKe0jEMBJyWmRv
	znMq/6KjTbscE5LxuHUNMDPpmIJB4MUvKcMXXYQp1A0qxj07JfjTHpCtAhhYyCSk
	JkSz3dZxE2kq1yChCj/oPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771113506; x=
	1771199906; bh=USUL/t6anATWir8WW7h8je8BTkLziXhBoIaNtfsRqos=; b=A
	/SK2U5M6SlF9FWrGf983lYjQ+BPqRiaiPZob6DJruV1OLpjUDFnOcVJNhRsZ8+sC
	r1WSJFNDJuyCcu49CApkz5WnJ3ZG5G7q84nlJVCyfrk87RjT6zH8Fd9XmPVSHQQ9
	ieB0P9KUlJptGouh33lrOYPYA0bXWr+KcU6II8TWVxBaMXBG49ng6VSfsnTdCCqA
	2gIDKRAfU1AQwpr6FWTEOx14uPKZobFKq1ib62wWwFSJJ/Yqt6yy1euEcgL4kcrp
	6/1AKHuyTeQgXLlrxVziKHdLxU8hNBscVKZpVOQDlZ7Ml0yvZCUvszaz75e6SiIn
	LqjHi3un5H+rFH4FpbaeQ==
X-ME-Sender: <xms:IQyRadT47SlO-gVmNoh4pPeHTkRLb_vDy2QeFwgWjkM8z10nS-XrBA>
    <xme:IQyRaSq5VL8AcZ0NlxBv9Uqoy3tkQ1oo0-yovH0K7UxphUi8kr9nHO7H8MhpKj1uD
    EpO0tgiNze1zDWQVT0sFzxAkG_8WxVvff9zxCNpchjD-Q_Tv5_JkcE>
X-ME-Received: <xmr:IQyRaeV5Or2PdR1ekBkr8G9eXbw6R0q6XEtReI7jm6oduJtXYAA9sykdiNYFGbdKqglDY5GVjsloa1gUcI3tNiTSgsTNew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvuddvgeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:IQyRaY-O-GOB8_wWqiv3T--c7BQq4N6RZraFNs_1V3FchhU0G_EpGQ>
    <xmx:IQyRaeblKMp9O4b8w65LHkddFg7PiI2S-Z4QKwYKdK7X6T54vqGv5w>
    <xmx:IQyRaYcdWvaMAeGyuiwmQ2mvyh-P0nh-5-QBwbtaUE9RQlzTHcIazA>
    <xmx:IQyRaQr-Iy8nd1BgyU6FcoVGjkeiGzSHlnMWWEqA6S_F1PkLdRGbpQ>
    <xmx:IgyRaYm0GXLV-GXKl-PKDL15mGvLw-UPcm-f0VgU5Owr-eNOeKltLr5k>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Feb 2026 18:58:23 -0500 (EST)
Message-ID: <631bd94e-9ce9-46a2-a7e0-7ae7fca2729c@pobox.com>
Date: Sat, 14 Feb 2026 15:58:22 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260213134704.728003077@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/26 05:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.72 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.72-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on two amd64 laptops, an Apple MacBook Air 2017 and a Lenovo 
ThinkPad T14 Gen 1. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>
-- 
-Barry K. Nathan  <barryn@pobox.com>
