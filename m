Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA7C175A90
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 00:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772410759; cv=none; b=XIlEUnc8qiGaUcuUKa/+4zWI17G5XrJq2NKSYGz2ftDhw9UMJSLVExXtzzU3wW4LyPtTXPWsnFxpo3OOGdu5h3sVHh+H2ZZKaEa8TXZnsz7u2Y4w1OTad37KMIY6UB83eqcFUH/dssOh8UzWrHaemP8H80ymOrRqGgxa5kNnLl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772410759; c=relaxed/simple;
	bh=UrRKZ6udpjy7FRGyNBxTpigDMu3PdozIkrb8O05QVqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M0TNWf5+w5h0XEUXkJCN3XXMb0tNaEO+/iRFth2xXe6TJqoaB1R8ejLgP2+X/XOoscLz+KYCtCOeT6MVZJnaV61o231X8kJB3VdSxzq9xIWLLc87BNMt+Ec2az8YK8a0HFxRp+rOzdcH9e7TD5WTitj22fqBfVygQuCIa+SRrJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=fcZ/ULfD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HmwzbWNy; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="fcZ/ULfD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HmwzbWNy"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 820731400031;
	Sun,  1 Mar 2026 19:19:17 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Sun, 01 Mar 2026 19:19:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772410757;
	 x=1772497157; bh=rP5iPIFV5jE9//0Ar+Id46QM7ZUghPfG/34WKULZwCY=; b=
	fcZ/ULfDb56au45QQsNU0bUBa3jBQ5a98l5O1UVh3PzCz9ZiOign0+lHDbOrpqzV
	9I7/sCM4G/TQsgO6y1GUAB4F8M2LiC27ncxzYtHTBXphofExWeenMJQfTHaxOUdy
	1vOtDk6tAXxB64RxUwv1lnDj01RAtAKUKN1K62vzJW9jQrXVfCcz52V4t8CzClMj
	e2+qXIFJ5S03qX9OpSKR/qao/trEO8VN677qp4HRSoNweNVB+5iOnQy3i3Ag8tjh
	3MDO1o4O+JN4XvPtNU38PZqJ+L3JXh2tmfBEBf7/KyovKKvqAy40w2rzeS8pTcXG
	bCYJQUSuUak57NFp5/Ccfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772410757; x=
	1772497157; bh=rP5iPIFV5jE9//0Ar+Id46QM7ZUghPfG/34WKULZwCY=; b=H
	mwzbWNybcjUpvPvzSMW/Z17Se4BJsYUlPJ+DJCguQczih6BOs3v10BwKqNtOPzY4
	NiAdSeCJLlNlM6JFVVNKOU96nHgDQJuGOfXEk08Nocpsdvh38m2grpvOaTpetWPX
	8/RS586xdWzXdNhOWZfrD+2F5EB+YUf9iR5Nv2OWD4wSJLwhIyttoSp7TpuUIOY4
	JUZmaKhZMPZDJgTPitinSmwtiJowhi7F8P4qOP4Ur4L218JJlVmHAB/2ZtReunke
	BCM2QvsDIpMrOrs0jb5deBnVs+UXFIFJANcceO3/5E4EhcCEvdhVDNWd+HsnWXn3
	U7lnwhCSKy5AoFWqSKLSg==
X-ME-Sender: <xms:hNekaVuSVTysxCL_R359lu7PHO4yMt2g_uIy_I9eSiZ819SCNAsmVA>
    <xme:hNekae3G3zGKoTarnH-booGnrS8TPNEIqpaBHzpo9kruSGzZvNgVPvP1lGaL6WaSK
    PSlCQ0kaNscRov5w2mMTF_unt4cvboMNwBafwgm8_B76VgJ0PgzgA>
X-ME-Received: <xmr:hNekaZ6uNrADgZIsV8bxc3tZMuTXxYHAb8diTUZVeMivSDTZCgGXlk25lLq4ySdaiTXMa-B3kIWSxKQ7gqP-0EH3ffSWlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheeivdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhr
    hicumfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtf
    frrghtthgvrhhnpeefleehkeehleekjeelffefhfdvleejteehledtieduffevteffleet
    gefgfefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
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
X-ME-Proxy: <xmx:hNekaYP-o8PWYXOPgRb0j1HK4GoMXb4LDT0IlXTmAroDynOoORjkvw>
    <xmx:hNekaVEUcHkiNrSy2AMdcAkwPePn1ufHb7-u_x-Auof3nuI5ygDNgw>
    <xmx:hNekaU0UYQp1BbP32NcOdmrHvRnZuRs_ulpt0Dym7KMyYYwa2OKVJQ>
    <xmx:hNekaUFwtGausI3Dj0gs0iLaXW6Sz2k6GBzyPk0I9itWkBc0XFsL8A>
    <xmx:hdekaWUTbPrPrgbuxNj55wMQhn76P0OLG8Tb9J8XkESnE9a-BrHOFVe4>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 1 Mar 2026 19:19:14 -0500 (EST)
Message-ID: <b850e316-e13f-4bc4-996b-b4112f118bd0@pobox.com>
Date: Sun, 1 Mar 2026 16:19:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/752] 6.18.16-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228174736.1542240-1-sashal@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260228174736.1542240-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/26 09:47, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 05:47:08 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Tested on 3 systems (2 amd64, 1 arm64). Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
