Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F252F6910
	for <patches@lists.linux.dev>; Thu, 16 Apr 2026 22:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776377365; cv=none; b=aDa90yb+e2TExAhRChz3amDWjdxlq9HkPBH5bWgMIed0GS6P6Q2UGjWsirOYkgaRYMLIkfd98GZ7l7zqV+BmRLbQsZfleSg0aC86YB4qNe7uB2rRNwKD+iTFc6CtISECG7Cky7txAf83s0JtazoDh1cY8ma0e7NdynmCkECK3oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776377365; c=relaxed/simple;
	bh=v4mLI+Jc/jsmLLBiyeClacJrBmyK6a/LIyeRUzroCSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lZO2GwgX85mWWGsKIo67BDJNOTt6EHthas6onCmXq2cm9MtMf5VPcdJCKRtvlzOAaxqVTd/nOKOyuQ8c0DCXwCDJQ0YtXftUT3wvcmPVVayyDf5GV22bxqymS5sRLdKINk8ybwNZwmQ21d/whiiqJiAjtVenWJbrhfE8r/+HkHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=e6HuoB8t; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rY2KduLJ; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="e6HuoB8t";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rY2KduLJ"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 633557A0254;
	Thu, 16 Apr 2026 18:09:22 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Thu, 16 Apr 2026 18:09:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776377362;
	 x=1776463762; bh=N8EByoorsMjORhHbfQz/C09Q5gBi3bvWw3JJWh5/a7U=; b=
	e6HuoB8tyVB89QnYAZEtptMJk/y6FfZRzQbMgxA+OVmRq3RxfcgdaOrrX7zv4svX
	sFCx0rVIWV9hOUrttRbgw9z3cgOHOHY7tgE0wNchHfZ6p/3L9jVRVAsS63xg2/KV
	KHKUzugjqjhEXlL8lJp3tZt8IMsloLw/M+K4M4aXhdUtNg/3qoseQX96Fznvub1/
	kyaDNDuIRW3trp+KkWjJPuf0npv/WBdM7SUh4Xo7ifel3QLOUNNzKO0dtx11ahbP
	nfhu1ep3xO9GE/5FPMzvuFKjOzwEcUVg8KvD5YGMCrNhvZou1ekWbjo4zxiC1CNn
	esg8ECEtWT9w/eZqS90F1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776377362; x=
	1776463762; bh=N8EByoorsMjORhHbfQz/C09Q5gBi3bvWw3JJWh5/a7U=; b=r
	Y2KduLJzg1zCCGShxov+wAzv7Zz3z4n2p6yUypM/hSZL2+jnf0XddaXVsW4TFPfv
	U4lCT7l7WNmAI7NX44SaPKAq1Gv5iKS9zEXNE/4KR6fKVUxEymFebFjrlXVErlIz
	ak8LavwGMJxQfYhxwDrtpQ11knhKyffkqN+1/1RKJIY/lvivS5h9hdt6pTwKD5Pu
	nfEKMv2oD6/Cbk8A8vCWqeqSK48hYb1WK5h2hNGbk9x+YT4OqxAT6+Pso8x5T3td
	yqlTgt92ri0ptPvyRgkcmJAwrxVuoqoNrVTMPJM7YhOAr8K/oAItEYufGiGVocZ6
	Z49ERK+s+k+2Lwx3t+9hw==
X-ME-Sender: <xms:EV7haZShVcMLtZf161VDRdqXRo0kJAO9VZE2eRjaeEI7orysJevg1w>
    <xme:EV7haeoSFEOJExpiLyEHSlS-m3F8_HoIlpQgTBgegpHpCWk2S7jtsGKsnLzoJC_6R
    Igyn8oGOMl3lE9UdWZpbwcr016eiftfvdwcVqAkBSvUzTx89DjqlXE>
X-ME-Received: <xmr:EV7haaUwVv2d2qltjyrvXmJ9-YQG5yUUTPRnBlMJPvyiqd6IU-aGzx5owJorQOzWK6rgF7s1x59p0If-LpqxJ3Ibei_E1rNz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegkeduiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:EV7haU_e9Y7Fwnp0ZBpRsKTL7i9_DaiPQ-TcNwPCCZvTUS9pwskvmg>
    <xmx:EV7haaZaqrIVpPj-lH5PoqbAcuogHBrmezNSvy6yli5TJjNJ8TCxXA>
    <xmx:EV7haUdTXWXYG1wYJfzvNEzIpnbUKXeb1pPA2p99rnX0l4GwjYONOw>
    <xmx:EV7hacpgzGJB0ekRHFT2Xy2u3zKHeej1mxVl6ytMWkoxfR4nHmJF_Q>
    <xmx:El7haUnJvFfNd6wAr_dvchHawlTmtM11dXjEjZZQFCpO4OoMExeMwPLU>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Apr 2026 18:09:19 -0400 (EDT)
Message-ID: <cbbfe1c3-247c-48d9-a808-addc75c30abb@pobox.com>
Date: Thu, 16 Apr 2026 15:09:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155724.820472494@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 09:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
