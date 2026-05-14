Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE8E3B3C05
	for <patches@lists.linux.dev>; Thu, 14 May 2026 07:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778745057; cv=none; b=B8qBvvBAC4g71J0G82E8l8bYPVewdgZCslqAHHGcvjrKsUD0hEYGCOVL/ier2NyF7GwjLa8yViXAOBJG1GegqbTHyqwPQ5wTLsz++h9uIDQqB3NFVlK1bZXEqhEvjbB3oVklE68JZMza+FZkMxxJGzhc1zeEegcJVTasuYMXwr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778745057; c=relaxed/simple;
	bh=EktUoDEG6sBISk9n+bQs8jHQEuLetUZlsdH60AsIoK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dtpZCL/an8AITA6a695FQrp0jA2Ah07CADmkz37HAw5qPUdLPqe7hHT6Wsdr/2s4W7aiaKZCCZJ/kF/pNYIt9eyDa5sdZ375OotaCTMS91RhT2XumhYKY8B8uQ4fbu9znv2WlX9N7zKC/q4KQ5pRqiepvNpEHoQ6cne0Zdoy5TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=WcQKmXvy; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Exaoc7T+; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="WcQKmXvy";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Exaoc7T+"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 1AFADEC024F;
	Thu, 14 May 2026 03:50:55 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Thu, 14 May 2026 03:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1778745055;
	 x=1778831455; bh=Q1rsfNWLa+TOKJZzbSDM8/XIjS4JbnlS1UzqfH1Rgbk=; b=
	WcQKmXvyNMZt0hxHlAhM+Cn0RkJTGqVGw6kYNfDFVXDWMMDklri2HgsIPdrmMoE1
	a+vTbmlTvFeTcRyottfVMtV/6W+PGse8aNMyP+0RkrZCJnYoZ7UroOiF7JfDXeBh
	W/iHl7VzgrH9YjN5VCc6aWkxwfMFfyji/QDa7n0tu7zreQeWTLJC3OIYyL81+XfC
	+X4WO1r4DyjYm6K1hjYiuassHViDIo+KYKxL1rkDeFg2di2SSDXBlVCESmbfLNSU
	TPyWsIuRv5oXgzFq5QesRBrLU9t8hxWN/Z7X+W4TWy4NX5pxTQa97XfCS6gBIDDT
	dXKghULIPbEfDWCbSoAeKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778745055; x=
	1778831455; bh=Q1rsfNWLa+TOKJZzbSDM8/XIjS4JbnlS1UzqfH1Rgbk=; b=E
	xaoc7T+NhdWSHXzcyC50e82tFjtgC2mjnThKR4doKlqkfjAtrWZqaRkBqvh/s+TE
	UdMQyTMejLWDMP6ggxU9c6BVYJabLdeWiTT6WVUdR3eWSZQoX5MAb+upPX1t7HH/
	sSeg3DXyvMQlZ1jtgNI7PYWK7A2F6TAhVf3acQmcbBV42SqByDi/vahYECvmhL4f
	+ZgFBxvIb4oIYb/iD32HYwPhHUPatctrubr8F3aO1J3zVxD5b9Z7y9WvZIifNlkW
	gzXBm3pWlvD9f00a2c2O4YduKelGWiGzt92fqMYLT5waUfSGwi7FBIFuSgEl7lmk
	k6xu5EncRes8PwJpjm6cg==
X-ME-Sender: <xms:3H4FalAicAWAIHqrL99SvXtod9OPV4eKIrglz5VHa4GEOmggIjiVNw>
    <xme:3H4FavbKVe0EUoDm7inI_OoPxjQoSaqVX93ejJXLzqrcnMul6tLdoXL6IDCxpVWS0
    YHsufezCoSel-0u-AStLVn50PaVBry69RYix-vgdv6jGffpFWRQEkI>
X-ME-Received: <xmr:3H4FasFVvJlikn96ELq2x3yKi6Zi7E4lPf6YxcEQf9Se5BrDqLR5er0efYH2Iwd9yHaGnE9rGw1--odWzU6qo7pRAvpSM6W9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduvdeileeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:3H4FajvTmmmoVqtOQ4ng3aNUPyWVSZQ5n3MCV4kzhVt8jHKg2jcmDg>
    <xmx:3H4FaiKrgnCApTcN-zckqmQExEpJ-c8_ALECmDY_e3rvKlfsFpvZVA>
    <xmx:3H4FahMAF01_1SeItY41hOBsXG3Wm4ARcJiEDjJemPPblLc-X6gyWQ>
    <xmx:3H4FaqY7KhII3Ay-Esa1vywJIdGufoNQpb-_pw8xznUWT1H3AiKspg>
    <xmx:334FasWbgY-9Q36GxeIU0NDseJdqcXTn2UbR0tH0w1nzejGShRy_UlEz>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 May 2026 03:50:50 -0400 (EDT)
Message-ID: <7990da37-5152-4f32-bea9-d49a505d15db@pobox.com>
Date: Thu, 14 May 2026 00:50:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260513153754.934923793@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/26 9:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2026 15:37:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 different amd64 systems. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
