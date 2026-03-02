Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7E337AA73
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 06:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772431517; cv=none; b=Ogm7p0oXQ2QHsHBQtcno6BVFWQVRyiV2FfLyGGQaemqCgsaGhS9OOW9A2s6VuAwWKwbStwuXc8LXgZn3GfLyA6LUF1LiMUIlfcJC41lrV9Ea01VMJ3oWx6/Ih+IQosDgplYovrvApOGDtViJRRdWxEpSyn5gIdUW/EqYWkVFW1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772431517; c=relaxed/simple;
	bh=rP9lWDSfdZj5wBrxxX3nL7MIJ89DKeDfOiHeciej4uc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=hqDJVUebGk0CTgSktFKOVEV/wMmdvcJ7wXId8/9eK2hVxvR6SNMvEUoqvj/ZyGQzvBPKI9e2EDghvP+qq/E3lPl3j1TW6VJxDkP0BtUJ3upsrKU2jmMn++mPGvYuzJlT6UTmSyo6tRgSmO0bXgvkx0iARsLjKgxy1Kf9+2VCOhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=F0RQofRI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QIzWzFfN; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="F0RQofRI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QIzWzFfN"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id 8E2F11D000FD;
	Mon,  2 Mar 2026 01:05:07 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-08.internal (MEProxy); Mon, 02 Mar 2026 01:05:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772431507;
	 x=1772517907; bh=e56Z1pTVGA5xdeStc6vn/S/ba11TEiKfhOydGP6HJVA=; b=
	F0RQofRIBjNSrGNklsbiV7spHrcO4523HCcQu5LZKTx51v0yVyNQdhm15fn9LX2p
	EtZpvYOaztsz2MgI0RQhbjQzHIsT0BHUXdBubh+GihPN79PmlouwkmPiDxtHLXlb
	1VJK6hMErgaXFW6sfkds6FQVFaFwckJ3ACzrULXCCRdqhukH0ffSEimQndBLwvM3
	MYJmnEfcKwjLtkgxBVhQBWNIYov5/4lXIXVAKCEnA5tJeqI5EF18S/RX4mYrYNma
	Xa+lOp0iUprQPArC6KGbx1cfX4ciN8F/tbPRKiUSwjXB/6Z0//cnydwwow86t6mZ
	6MWHmS22AY8DvZXqaYCIVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772431507; x=
	1772517907; bh=e56Z1pTVGA5xdeStc6vn/S/ba11TEiKfhOydGP6HJVA=; b=Q
	IzWzFfN8+r8quiJjhC/At/G3sOTASd1zrF0xBTUd+jIZnb0rJAlI+y1zQ2CmHOtF
	JEYzIKgYEUw8l+byoc0RDCizY2yDHfK1nTD+w8RJ0JgEFdPb03xZpbBXAhyGqljs
	GKQrVeJALdC1e92KFORymL31/i5jMffYX2shcgJjHrBk0Y5US8Xs6N+3JGCadRFp
	0wn1QaqYMZm1Tn6x5R0yD1UWdeQ3hifT9LRtM8nnIRYOrt5wmVYHfnkpB5WMVt/S
	ZeKPGAaCqykvKWA+7GoD719SFS+xh/gOH0NEMkSe91erVJQeDlhOdlIZIEMTVrUF
	GzxJf5xL+lyXTYdKw4W3Q==
X-ME-Sender: <xms:kiilaYnw9CIIgZED7av5VZb5__C_Tpw9FVh3QSSTpV668nea9Dzn9Q>
    <xme:kiilaQqOa_0YqIkydn55TYIqi8AsTH9zxOBkceUfSDvtZrqz4tPtMKwVIJSzDIuyb
    bE5tVPcpL7mveC4-F8DwAJFy1TuS5kUrf6ACoj8-oTzcXrDYPmtDSo>
X-ME-Received: <xmr:kiilaX8ncsP2LhAOz2-rfTW_x1r4pN7vhbH7jrHXe-GgRy2AxQ5YI7ZKZ9-6qz4piQ-XbEt_mXHUd-8wkDpPvmMw7BU5OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheeiledtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfhffuvfevfhgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeelkefgteejkeejvefgiefgheegtedufeeuvdeuvedvheejjeehvefh
    ffffgfduteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgt
    ohhmpdhnsggprhgtphhtthhopedvuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoh
    epshgrshhhrghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsthgrsghlvgesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehprghttghhvghssehlihhsthhsrd
    hlihhnuhigrdguvghvpdhrtghpthhtohepthhorhhvrghlughssehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnug
    grthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugiesrhhovggtkhdquhhsrdhnvght
    pdhrtghpthhtohepshhhuhgrhheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:kiilaZ3vWe1tgWDiZ2LgXxoUDR6uC5CshgBzwZ-nTGWHJ40hBrVhIg>
    <xmx:kiilaam7CZK8fw__onY0f3rp1aMYBlyvjfOfH2OntCD40sJZUzE3SQ>
    <xmx:kiilaW1asMCJqtUEKNHi_bWrm5FBMyfsW4ZaIIoPXnGtPkpRm7sNLQ>
    <xmx:kiilaZg1PXqiC144enFOSPepvlj41vJOiTu8Oxq8J7zyI90Ycg9vRA>
    <xmx:kyilaequ0SfVgr3LYffQsEQXe9H9dhxWQTR75rE2Rf3b6cTdFbpOCDJy>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Mar 2026 01:05:03 -0500 (EST)
Message-ID: <41b35d0e-bd7e-4bcd-a22c-cd96ee6c43d8@pobox.com>
Date: Sun, 1 Mar 2026 22:05:02 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228180001.1567994-1-sashal@kernel.org>
Content-Language: en-US
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/26 10:00, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 385 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 05:59:55 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

I just now noticed a sizable discrepancy between what's in the
stable-queue and what's in -rc1, for 5.10.y through 6.12.y. (6.18.y
and 6.19.y appear unaffected.)

To make sure this is an apples-to-apples comparison, I'll compare with
the stable-queue as of commit 2370009958172f632d48973387e7b6ae116086b1
("Drop a broken ACPI patch"); I'd expect the queue as of that commit to
match the -rc1 patches, if I'm not mistaken.


                       # of patches in         # of patches in
                       stable mailing list     stable-queue git
                       thread                  @ 237000995817

5.10.252-rc1          147                     334
5.15.202-rc1          164                     411
6.1.165-rc1           232                     533
6.6.128-rc1           283                     683
6.12.75-rc1           385                     953
6.18.16-rc1           752                     751
6.19.6-rc1            844                     843

The off-by-one difference for 6.18.y/6.19.y is expected, since
(unlike the stable-queue itself) the -rc1 patch and the mailing
list thread include a Makefile patch to update the version number.

For the other kernels, though, it looks to me like something
went wrong somewhere. Of course I could be mistaken, but that's
how it appears to me.

In any case, I figured I should bring this to your attention.

-- 
-Barry K. Nathan  <barryn@pobox.com>
