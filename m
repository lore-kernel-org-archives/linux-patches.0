Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD88212566
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 00:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126562; cv=none; b=moU5LSCiuoXZhZruJvG627hc4lPUj5IrhvgLGnqRSsxahergRZ3n60nh/kYF2S17p9aTei8TKuQbTTH4Vl2L5UoL0Dcq2Igb/IjHc41EdwXKVQz1dj0MG44fB40A/WnH6Z2gchn/TBOO0SMBvwPgDcoNK0JXixjITVd4TEVsG6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126562; c=relaxed/simple;
	bh=ilqCm2IWieRAYcDMszPK68i8mdhs9B/KZHu227ICfVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LzwjvubB4JwawBQv9EhpI7Aw+7EqMCXk832h0U3rnraiJUwGDaGRTnElaJPcA1KIVONvjyOtQ8rYRMTbABZCPzT5JGA4YUwYQleHlXxc+k2V5sbHZNxJ/aF+sOZ5ZfHXGpPvrXNDk6LyMwS8XfLNWzfLy/0qbnpc2mMxkI06jDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=0yGxp9TE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fz905O3t; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="0yGxp9TE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fz905O3t"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 912187A0273;
	Mon, 13 Apr 2026 20:29:18 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-02.internal (MEProxy); Mon, 13 Apr 2026 20:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776126558;
	 x=1776212958; bh=OzjsKwz9LC30RD2gFYtEDz+hf33m8pEgJ7FdOVeuBoQ=; b=
	0yGxp9TE4eZ4a23Wb5d4u+EWNY3ztpzpnn1iXjgfodcazbvMSfR6DnYi0NyWV6eP
	H1o23LzBQm1xcAIsai//pUgP25cUO9FnUHp4aiCBvOzNglKXA0NfAT6fbouKutEX
	2YEGxb4ulTHMLx4f34FpbJCBmaDWXUHmqV3VkjzXbGyYVdw65ngO6lbxrAMHc4bH
	COsmtIGWwiyvjVAXPltkJE6kd334vY9ZkhamCKOnM2dphSbDk7xJqkh4tv52xzz2
	yQScYGltt0XySLcMkj0jmCrKonsdK8R1lVv1xcEQVLrZpg5E8910//ZxQK4EETQH
	lsQl8klTfj6fBYrmV44NsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776126558; x=
	1776212958; bh=OzjsKwz9LC30RD2gFYtEDz+hf33m8pEgJ7FdOVeuBoQ=; b=f
	z905O3tDx3yBlkwyL2T2ryJIict9xe0lyViREzPXy4XPLOfmrcRvRKQdelPMVU4X
	YRE1GunBMcbpEx5TPHAsw4JKYHI5eg0GKFtYKZMgFAlPqRCwKH2dYd77WbIBWUzW
	H07dbiA5o0HBql/5dGPhZEBIVe1mkRxowLHIpmAANQjEqZve6qF16qWXx8U8QEwR
	E6n98AtDQWpJEQNt3hneYekh/yQ4WAKzLHm0s0F6D+M5N5xeQTvWicXwHnuey9Ps
	IYaZxNhmmT+zhPENMr8ui97mvLL4QG/+YBIZnDpp6EH2gi/IwfOxLteHdL/sSr0l
	VkdIUim86D4Cr+ofDXQAg==
X-ME-Sender: <xms:XYrdaT3i3XWmvIeCIoeCnrl7Q084W2yMfgt74VFs3KUk9M82wGJ-PA>
    <xme:XYrdafwIDAi2o4Qe9Hm2Pm4ayyOWy6M9L0tMIgdDvMOGbufY1Ph8oDgdNygHVJSDi
    qUslgFJPipLZN6np-RIHgBEIakIggyObiV4kjBWrMur_37OB9SyF-8>
X-ME-Received: <xmr:XYrdaVol9WADlabLvKC-biZ3pQTkmCARO5a2gNlnhIH5MrgN6FeeR3EBg07eKmRfQA9v7EXx-4zDWNy2UjIL03CPLCMsRgjs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefleeikecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepfdeurghrrhih
    ucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesphhosghogidrtghomheqnecuggftrf
    grthhtvghrnhepfeelheekheelkeejlefffefhvdeljeetheeltdeiudffveetffelteeg
    gfefhfejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsrghrrhihnhesphhosghogidrtgho
    mhdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    hgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehs
    thgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvg
    hssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhorhhvrghlughsse
    hlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugiesrhhovg
    gtkhdquhhsrdhnvghtpdhrtghpthhtohepshhhuhgrhheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepphgrthgthhgvsheskhgvrhhnvghltghirdhorhhg
X-ME-Proxy: <xmx:XYrdaVV8U37fkado1GMw1xKY9OSmh2tCYdFlhxTHNFFWwMN0-UdDvw>
    <xmx:XYrdacrk99_ASoh9LzH4cf_2_3qg_GljW17K2hQMS10A-2BkakHDHw>
    <xmx:XYrdaZEHHDSflAkQ3IuMRHcilD1bg3Ofjxt2WrY_2NodCSlrz8Dyhw>
    <xmx:XYrdaesyduA-33hKh6EnDk24q5PD9h0RlDwR2LGEouHkNdd_-iboPA>
    <xmx:XordaQSLWHo0wYfzY6pxqSktO0m6xNjtRnobJ1LIpAZXMjCUa0PIOoJV>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Apr 2026 20:29:15 -0400 (EDT)
Message-ID: <5ea3d90e-9983-43a5-bbe8-e3999abb9e42@pobox.com>
Date: Mon, 13 Apr 2026 17:29:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155728.181580293@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
