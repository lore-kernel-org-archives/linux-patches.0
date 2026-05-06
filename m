Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AEF279DCA
	for <patches@lists.linux.dev>; Wed,  6 May 2026 01:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778032661; cv=none; b=mwkRKndJqcj6bWtYojw5mCgg71JyT3iL0IXOK/NAgx6kTUPwp4p+BhiKgZxk+BL1y9L3WXx5fJbypkP75bVv47rsULLCdvGF6iqDGBnf5YalDzCchOKeSMJ7K3oknVddIWnLOO4eF2s1EjcnlU3ilVcG/c37CCEmRweGxz+0hao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778032661; c=relaxed/simple;
	bh=czrBXEohgq6qzPJRo14ZYvUPqkqDfVHf+UdZYrAyLpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rTcImfAvlWh+0fuW5sxDnNuTfczFadVQvfsTe24mqMx8aHyy3UDwRSb6GHnNxl/qhUplwZhDrMK/kGVdbBBg+I1Idci80GUMxzvEuGlu9ykCHLSL1hxadXZ2E42ZnIHSWKaB8ktpYvvEU9ikcoiArjz0zkY+4xziWCfU1fijsu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=qOB2qEy/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Dp7LQoDN; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="qOB2qEy/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Dp7LQoDN"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F27D27A00E9;
	Tue,  5 May 2026 21:57:37 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Tue, 05 May 2026 21:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1778032657;
	 x=1778119057; bh=X0faX22EXtGDSLbon1GnGn5rtdVLrlAusijmZwEwIeY=; b=
	qOB2qEy/laFpQye8pFeK0mGV/K+RyMtR9rihnK+f96Ef5dsh1gGiDIFV/N0mUpBQ
	2asOF3CAfWuaxVrIQ2Qqba3stB45Sn60/wUts/uGDWEL8IFB2tZomW+QH9IXUfBD
	F5eppzrr/6BMuRqrVTKUahRDfyK1njlvxWgNxOiWIAVyDkDjCmg7xf/+heuWO50r
	AxSk9Ps+v6Osm20HqoW6HFKvyn1dl3uLjWtoUDMLEyc6l2OH6CRE5yUxFI+HaUWV
	4TZ3Jb8ecklPCww3ajZMQf3sSifT8FGHap0phc6fRs7qmymWoYPPvcOPhaXsILsx
	6ZrB7xrDvA4CsmDlbFpWRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778032657; x=
	1778119057; bh=X0faX22EXtGDSLbon1GnGn5rtdVLrlAusijmZwEwIeY=; b=D
	p7LQoDNIzR8oCqrpAYLKWhXZFhAhWwaRScopN0pIkhG3y3vnsOHlmcQpUex7tpoO
	ewgmtYtP2CHSRo1fjwZAKWpUZqMimTSK8tXwJfj9ri7m8TviCnLBZWCQwqf1OCj/
	2ImXATSyWGKp+Xb5fwIVxBouXcj+YB/er87le/pg9f6hCQVAt8Lsd6rbSzwtD3kQ
	agzn2s7aJ8BJ43psjREZ9BZai1qFot598O5A4gJ1AY3E0ymqeLG3PsWsJqtJEu2r
	m/VctKQ8DfLm8lXEoTJ6l0NvDiOaW/L206k8InUHTBRZbp/SVE7hUXkf5C8MXk4w
	ZpoWHghVnY9TSO/lhdpSg==
X-ME-Sender: <xms:EKD6aQUAmqavNegalSTcG7G3z-Xzt8AkX6KMWC_SVLDYdq6z3I5Qtg>
    <xme:EKD6aQfPNYJzncAkPlMCA2hq9ilS6pQLtLIc_053Jka7jNQ1sFTaWy8AFYEp85yaO
    dLlDR3gw05wvbRpTlfKoMJLZ2QspN0kILxzlIolc3y-elAd7f0ehuA>
X-ME-Received: <xmr:EKD6af5Wcb6-U2OXpXJrCLmy8H8ZqaDtxA_bgDPKF5NEzmgTdnS_o2jaPEYEDVczGd3mRPmx2TfmY2ug3tgYUhAYEjc-VJVS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutdeffeefucetufdoteggodetrf
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
X-ME-Proxy: <xmx:EKD6aTQoBbTx5WDy15JmDaWipf5ru4qXhHFEO--6TDJ6SImFmUPIZQ>
    <xmx:EKD6aSePrOsRlsIorAxUDcbhb7tcrfyqHOMGzbox0FnxvA-DOEaexQ>
    <xmx:EKD6aTSUZevnJXLa5SMQtIDQpSabXqO6DPLs3b_DjAgAlFwcnSnwOg>
    <xmx:EKD6abPzID-_pchfRuxoDSIFc4pHw75MzeGSdDD_EQ0Qve_PwhuScw>
    <xmx:EaD6aUqNoaXWPLa9usdT28VkHuyeyPwNmB8otxIYLmbqyfBz3rHTkyyq>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 May 2026 21:57:34 -0400 (EDT)
Message-ID: <2953dbbc-12f1-47f8-be6e-096e552ca9d9@pobox.com>
Date: Tue, 5 May 2026 18:57:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/215] 6.12.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260504135130.169210693@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 6:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.86 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my Lenovo ThinkPad T14 Gen 1. Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
