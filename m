Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C6F3375C3
	for <patches@lists.linux.dev>; Sat, 25 Apr 2026 03:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777087645; cv=none; b=lvKRDZoAfOAaBE9J4Khorr2swb+7bjTxOBgaozneHb8QDJjwq8YF+K7LMRylkhOLVaTYUyZNj14Mv5rRntjt4+40jyxvLLHz9x0FZItNz7mhjaCgeH7PqwKFYwAMEmLYKFDU1xfVknxd41CgV/z0RdyYbXD4aN1LnpFuVh8WPwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777087645; c=relaxed/simple;
	bh=V2OnXzvd41cigBpxG7Wj4Syadzavm0xzosUMjctWV+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U6kM0tkV2K6F+81XZeSWMcMGGRHhLJ1yTx1W4InPpXYZfQNl1HQZnweMYpw9NpMaHxShLDb73W17XqfFVID+svQ2utVPYX+Dea9qSPJ1lSvWItA8GNrn/HflcbsG+UeSOLKwsEO2gHgzek35R4tLuNkATezqquSue7ayxYn1Wtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=OEEfnNV2; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AjrBP+Mx; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="OEEfnNV2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AjrBP+Mx"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9CE887A00D1;
	Fri, 24 Apr 2026 23:27:22 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-03.internal (MEProxy); Fri, 24 Apr 2026 23:27:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1777087642;
	 x=1777174042; bh=37ABmDKMz0lwNwI9b0UL8nIYlbMSYUIjpr+CMz5PGLQ=; b=
	OEEfnNV2/wv2onQeGTcKk7CuOih66JmsonNDzaggo268eWkF+oCzZyEbpVhQLz1G
	+4OJduzNwZziFv5NKbbVuKOm6zBAjC3O6AQ+7AQy5Z//gq9hIwBCAltq9N/droYS
	CblDce+62cKr8ralZabbA9WJwaG3kK1/FcnZ7lqi5ZZBGh0e8gKEqUN4z9s6B/gL
	4uy6OwJjduZHY22wnbWEPEN93wL7Hj66Wf750TJBSj3P4LWBbdP7ta5yjovnXr45
	3cL8RukAKN3Hky6O8lvdxlGpoEduUpIUe7mbrcZ7i1s1QXWhIQKl8/7RDbd4qTCK
	MnYTyGZycYZp5eAVX7Ku2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777087642; x=
	1777174042; bh=37ABmDKMz0lwNwI9b0UL8nIYlbMSYUIjpr+CMz5PGLQ=; b=A
	jrBP+Mx009PnMeQ20wHkGGHY9jphExN8THcf4Ch2kBvyRrzj14gGnsV3i0TZfHkM
	BcqURaMkbsrz+35nmFXU0Y/BnYHVT3q94rtsKDgBWoFNhO3maYHDW5COrQm5nUiO
	zdLq/csBhRuCNNHoTx36MPmuooJnmqK5aGWHmpsgD9CPDDLzCQ14fMK13U1Vpxhb
	HNnRrioEohtXJiV1ZipFyE+R1p3tg3co4jDqDe//AiaNT9gC31u4h4DoVfc11/Ju
	QciFKKRzEcOaxHthahQTHVpUN/LjyqvEW//Pu1iZyjIFBq+8BkHneIZdKV2VtRl8
	GOqwagc49Pp0yBws2+QSw==
X-ME-Sender: <xms:mTTsaeGYMYxES1BtkZjERTP7nDsr6dCTkpk_9CbV4dwCmxWKuRhxcA>
    <xme:mTTsabOM5ykZc4IUdB6p01qNAB1ZFBOuEXn4FJCaIX2i5tIKShi7Nc0V0kZRHX3SR
    ImutiNA0Q5UcQhNLxZbhRTgBrA6MNsn_r6lKRNwGDF4Bg7CwuF6JnM>
X-ME-Received: <xmr:mTTsaTqhF9jM1P_Vst9odo7FK42GI-Z4UiyvCoMmZ6Ff2nkE6q9tKWn4BiR0Al1ubEWbUI67i_SGIceq40VXtF5Oar8uxnnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejudekfecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:mTTsacCr1H0MW1cvS_yt1MJv2KoL_s5793eep6CGaMc1mt24RIj2og>
    <xmx:mTTsacNZR_Y54OuZnpgL2R9c2Fx6k59jNUqO8eo7FMehBOeTouRzvg>
    <xmx:mTTsaaAAJpGE3hqT3tZaE1h_bs07fBGVyCLENb0kUuUZgBTgQTZZJQ>
    <xmx:mTTsaa8lCE8yHpf6kYwxYKZON3566I9ODZKIHYXQdbnbuWLctgkPsQ>
    <xmx:mjTsaebJpf4p2X-NZCOavjCPjXhSVeriU7mjG3uMsXrmBj752x7KKOuY>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Apr 2026 23:27:19 -0400 (EDT)
Message-ID: <dd775dc6-b76e-486b-8b85-9b94a890fb01@pobox.com>
Date: Fri, 24 Apr 2026 20:27:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260424132411.427029259@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 06:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.84-rc1.gz
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
