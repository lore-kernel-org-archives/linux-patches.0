Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7602FAC0E
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 01:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772588026; cv=none; b=roz4Ne0StUQ1I0neW0cmE1XMDcOJRvwip4NiRr36xQSTbsYkwbekT+Vj+Sg1t0lJiwxP3SJgtoDX2Mdj/WHVBZqWhrEGC39D7r4IEzwzsdUxfwaKyl0r8bkKYVNDdKzoRfMFj9CNHqkNsC5+MsLXySVGqbCjpk/ME0ZXYYRRB0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772588026; c=relaxed/simple;
	bh=94An5Pc4MmV6LID9PS2G4FVjaczcMi1NiosVkEuRqTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c7fcDpzNNbHcUQ09l9wmqv8fyrmeG7lFHzAhGs8QzBuR3PkTGdAwGmbq6nws5phbtXaKJ36kMYeQpik26Q3xnGpS+YD9/E13ozGB0WoQBRLOp27NComhvzxtTtmO4Q61Yq4+WPS8za3XfH/4XWBzeM7MOJikxShDvbXafTadu3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=bXG9XhHK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NFfd1LNJ; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="bXG9XhHK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NFfd1LNJ"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id ABDF81400176;
	Tue,  3 Mar 2026 20:33:43 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Tue, 03 Mar 2026 20:33:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772588023;
	 x=1772674423; bh=2n4bEZxk5O9U3TjfegCzVAWPxxni/Gg9gpkJIeUKL34=; b=
	bXG9XhHKlLfM6FmdYCbj7g6NKw5du9N3FF2MDmAecLiDR1/CM2itiP+VvXBOJlXf
	pA5dvOt2BLlhscqA6S2lhxHDpISE815d4V8QkUltrxybejqc9RVHjH+wiNNUlQNK
	36Pk34uOVwv0wsf96uxeXfq/cNP+bACxzDm1bqjQp39hvkRifZojgC5zWrdq7qFe
	jc0NbPS8n7uBw2E/+TAR3hD4fPvzwtFpDOykhOf7k/c7FhqCemcrNmjrx8CIZSvz
	VQvFR+/7Hj8dRnYQd9yjG5Drb4zjOjIp+DKYD5hr8sYeGr2021zwvuxXB2oV/f2R
	IkQ5+E7Y3eRnTJaM6mIdvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772588023; x=
	1772674423; bh=2n4bEZxk5O9U3TjfegCzVAWPxxni/Gg9gpkJIeUKL34=; b=N
	Ffd1LNJACbvOWVsTSHCtZYez4diSu5DowLZo5YI3mgtf42c8pxg6+Gx8LQZKLpRJ
	FOlNMDUxa2JlxVlkwVPztrglJENnkzhCJnfeqWfRGTgt905GFjxIN2bfVrZQbeMY
	5KpHEiaXCbeoohKp2/HzndzTc4R8ZbdGqoOgNseLecfrF25Hn2IZ1TNLsavBBv4f
	cmBpB693Cr1yX2ehpdFCRFMw0CNqfsVFSIMiwE3sxHOjR7q+AECCImZnN0c8pysE
	RLRgFOco0X+2HFh8OLZ5GHLGW6ApOPk2ZTs/lqSM4duPVSuPt8T88xfPhRMMvumh
	6ItquDY4faCD+Xm8MC5kw==
X-ME-Sender: <xms:9ounafacdNbbfgIPXSqhhm1agM6EB4hwuE34avlQAV-49HOibWx6eA>
    <xme:9ounaeyMguV5Hb7AmLAefzl4gcx5Lu6Bsp7jBHeqaPSHQmCf715C8uX2ImdnqfvKD
    U26duf0GcylW7ThG1t3Gg8XnNs7eZSMZG4jFxZ76DD2Kz8Kw7NbEjE>
X-ME-Received: <xmr:9ounaTEWfBN5ANueUnhemCWczJjqM3f3MGS4avAOSs6pXwplXP26unKuQBk22_KEx3q-RjI16YVigmW2zgR_FJW8sOVX5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddviedvudeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:9ounaRoqw1h-acUw1IBj_0tsKqHWlC3P2JyTsE_CssRtLI76Sq5r2w>
    <xmx:9ounaZxNExrAVSiALzSfD5o9lNxQtfFLKj-rXuhNfi5UH_ylKkuU_g>
    <xmx:9ounaTzbffDwxdZGp-R3iCEwfoxaY3FWVCph-TZzWidnOYongg8fAg>
    <xmx:9ounaQTeA-IePSYNYRlZUaH2wfyReztITIiZV4LNP5r44wQF0WxeaA>
    <xmx:94unadSSM1mr_h8XL60GmygasXcL2NcduR3iHZGqHcsA4VGZvkxfUDS1>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Mar 2026 20:33:40 -0500 (EST)
Message-ID: <4a9cf3f9-2853-48bf-9614-71262c4e5678@pobox.com>
Date: Tue, 3 Mar 2026 17:33:39 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/334] 5.10.252-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302161007.2523181-1-sashal@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260302161007.2523181-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 08:10, Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.10.252 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:10:05 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.251
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
