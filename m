Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645D23D75B6
	for <patches@lists.linux.dev>; Thu, 21 May 2026 18:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779388038; cv=none; b=NwP+clILp+atepDtqtcKf6ppDIq4yWHqLOZieqkfJlBF6qgDaypwvshk6uPQqspowT7fFsMFWwe9fTtuwnf/nEhnmBEAhU+N9dZ7slB7Zrga8fuzJzUEvxI6iABStD05MZGEuUOoqe0c7eEaukOCpJQPRxldLRBmwJuQ1aPvF/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779388038; c=relaxed/simple;
	bh=Sxjr57PvmNFfkdHeIwXO6aYqmVGOPvXe8mxTpH+x5MI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RI6yC1eQM4+fZollHThyNe+ny3emORYNeYVHNZOzmieMob4wqZplwnm8fs20vlUSQ/K9C5ZsxnqswpLeXxE8Ri5521W4pOtw8REiFAasrTeDqIFeYmYO3y6QVs2tbQWXz9TW6+jg01XJGqxOEx9xFzKkfIleSgtpPLnM0A3Y16k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=sq9wz81k; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=S5hxqFAj; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="sq9wz81k";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="S5hxqFAj"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id DB0701D00098;
	Thu, 21 May 2026 14:27:07 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Thu, 21 May 2026 14:27:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1779388027;
	 x=1779474427; bh=mzyLGcVhcu2dlxdERmYIfqFqiG9/MQtLwQSA7A95N9k=; b=
	sq9wz81kZ2gSFksn+ogbA+YuGRozlZtCmu/bToy0ZQLfUaIW2UazfbXowQCqZOdC
	pgEyIaInaL1D9zogFGB8JjezkIZEgSEq4sxE4V3yfwhZ5VWzC632QipiBePLzPBO
	rls6reWw25EY0/FuE1hQ1lEWYGOayBXzMgaYOGfvgup7tg/1cA1VgPK3F8mQ7O3H
	yfnj4w2CAsbK9HrJpBCuSLhlYtzFhk8eCG5qJt3TH3CAd5cHQ9vJ0rRfm6qVxoRa
	heUelSh+2jSSpgMPcpah73R1ARuoP7m4CqmtzkdJ7WyF+fP5HZq2+VsaC5THDMnj
	vft8IRSm/6Rqpv0+a5myeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779388027; x=
	1779474427; bh=mzyLGcVhcu2dlxdERmYIfqFqiG9/MQtLwQSA7A95N9k=; b=S
	5hxqFAjeuyJvSRsFojS/9rwzGiwlnA/4oq9AvQJiYBnOsPYid7vS4Tr8E8InXKO5
	WrtGY2Utb9caStjQvRfhD43++D/FfHu4hMRrhlVAxraYkRsGkXq1lfMk8RhupwvL
	90y1nLzv1l1+HWTFwjjhwYfJssj6GvvkhTUksnRoY2fjcm4wQKGGdYixBH0cwEyF
	0wH8FnfE5r9A/C0Q15IknL0Eidu9yalL6Ltvme6cgxQN3nQJan1lA1RBnewTloTw
	nFuFUfYt3uYGdbRo8tO2HzOYuhbUhWr4gDf2IGikxc+LfiaPfvmfvXMuF1e0ca4D
	ZdHnFjXlaVjBrY0gEL4vg==
X-ME-Sender: <xms:ek4PamdyhJEIAWVRU24kxgj0BY00nW0g-NWYFRGJ2sSwTCWFGxlQcw>
    <xme:ek4PasGOJJmUON9Z9b_35JvahwekmXLT_n3Op5rNQZ1JyZJRoVqKk82oTa6eTue6X
    GuIl1ZjIev9XydF3O_-fn92NczdcOAXyOoDbcsyX6lqgdM9LxLoVw>
X-ME-Received: <xmr:ek4PajAV0g1MkBfFwlIsCttxtPgeyBfwh-IKDJUzGWNV_vtLMtGRRyHfVVaU2PYc86IIW8usvHPcjLrvBrGvAvmIr0S2lfxG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeekvdefucetufdoteggodetrf
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
X-ME-Proxy: <xmx:ek4Pan4PLx16F2chish1vS0fx9gmL1Dg8Y-Nc8aHK_5GxRS9l6HsiQ>
    <xmx:ek4PaqmFiLxLR3inkf55gz0fzPWqmzqSjBgjn7GNEpqiKbZwUEsp1w>
    <xmx:ek4Pao5VXnTOPTdmvxUMGt4W503SpzUh9_CkNI8SGhK4Gb58-4FZ-A>
    <xmx:ek4PagUjulkkFH9uOQ8Gb09Gh_XdJC46iVHOyY7vg2Z7X3q5TYpTmA>
    <xmx:e04PasjZdRvfMZ1RuPEYPLhkEQWaUEETQDQSCUzc5Sfte8Ch_zvBy5wm>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 May 2026 14:27:04 -0400 (EDT)
Message-ID: <dacac49d-8b47-43a7-87ca-24c256545049@pobox.com>
Date: Thu, 21 May 2026 11:27:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260520162148.390695140@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/26 9:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.10 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.10-rc1.gz
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
