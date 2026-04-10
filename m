Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6146377561
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 21:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775858309; cv=none; b=k//43ZyOo2L5Ev7Brr0ySbuR2C4YJyR5TpTFEZ6jdR38e/Ahb4Z5FOTkAEkYXhve9kRXkhvo5IdzBUzdzZ48AJFPh9pL9hngkzpLoXdJGeJ30PFaLqX/xS/yd/wOV3yKpqdUzfe2RouLHKSl5OBPiON4KAxY9jTRbswBFNoS9XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775858309; c=relaxed/simple;
	bh=aw8TOKkE+5QyIGiF5qlPUgilCcZuHeODVen8Sg+YsJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CbJA5Dphi1qy1pE9Bc5J4u5ryCKYC6xuhTPJnFXGzhyaBnnxVISGUZuEG3XJ7+wkf7b0VXlrs+pF6aVaPj4tnmf2EKbJ+xFWJtpDU1fosJnWRs0sdqEvBTMABZxWhJ288m244nOTpkymF/+piuV0YY7TJI/fVmXCmYq1lL+Ao/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=KhzMWRpN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YQ6DZwT8; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="KhzMWRpN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YQ6DZwT8"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 93F211D0005E;
	Fri, 10 Apr 2026 17:58:25 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Fri, 10 Apr 2026 17:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1775858305;
	 x=1775944705; bh=FmE4y9ifJWsccxbLkChS2A9WBPeo+cWUSgVE5dCIPwA=; b=
	KhzMWRpNBFbqy06ZhE7+v1VZSSYTH4plNL89QCAMsZvR9P7XGatwxVlndE6+zD9n
	K83HqAuy0H4Wt6xlouT1IWuJPhUoGx6zA1T+mOEVqIvgWzP99ItXme+jdzJOOyzw
	UhXLrKxincpkwb9REWtVOdbpUaMjE8PstMgTM6DHHcoCj3lw0NDoUV4M1C0sXRxA
	IH9TcK1cu+toppDbcFOb3PGvSfoJUGgPyflOh/nRxYW+Kg4gH1QpLtGKukVfXYnF
	6CXHWYfAKKnezOc0lyy58FwbC6wzbb5sMW9Vih5rm32jIdx7mxUg6Nq2KyB0/dFm
	7WZkVr7BgDhxbGTgsVcLsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775858305; x=
	1775944705; bh=FmE4y9ifJWsccxbLkChS2A9WBPeo+cWUSgVE5dCIPwA=; b=Y
	Q6DZwT8P9tYJ4LR19iFmKmw9vxhXZI+ltdUg1aGoQwl+6Lj70W0nri7twTOTCdTn
	L4395s1PirlQBU3trsEd9SCvbSb3TRHV51dnXqUZ6wSfDNkA/ky3HkP7/Yqpz6JN
	0mnbhVlS5I6fFW8UTwWMY9sh1m+a+pM9TVvX0/pXSnAoWjZQljA2koPF8fjEk6Yv
	TVFvkCXxFXb09TVK1NbbS1y1nVKvOYpV86D6cb29nR0QtspwPIb+/o94grZ+Ks8W
	58C5kVfl37JJdVz8DHF5+rJJ4u9IVe8Nl9ByQA2EnX0HBe2/fghjKes/uOUHWZDt
	C8RIWt0s02Z20NUyWnSRA==
X-ME-Sender: <xms:gHLZaaramTROBJgKKsLOLabWIdpBQnY0ATVmEgMuQnNXusSggj_XbQ>
    <xme:gHLZaUglsnxyqy6S_PCaMp_v32BEwIqNx_3VuYF9NeUOBn9H0NhzxmLEyFpq0RFNc
    vFkF_7FTTtIKhhukecqN3xQdAhmm1tztTsyDNdGno-JbZ2Zhr9_nCs>
X-ME-Received: <xmr:gHLZaat2zPxwUhCMy14aY1SdqVPJUJsJuM6y42xytH-t2DCfEfzKFHYezyz-xhi8jLmcKRvkZma8gOk4VaiXf2kdmhxXpx3L>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeftdehiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:gHLZad0Sw1jPGfXvgiPlZJRVMumuA4AEv3NAUPbWls-0WRCisBsbOg>
    <xmx:gHLZaRxPKZODoa6f5DgcqNby76i2-tW8GP1evh5nUIpuhlqhPxuNXQ>
    <xmx:gHLZaYVt1buybkqWqlwTu8pnTllzPmXtxCBLBwsZL-xGreZKM_Wptw>
    <xmx:gHLZaTBBqxAVarI8SKfgdU8da1M28Ro-uJyBHGpGP-aq2bMLMbcaPA>
    <xmx:gXLZab9iGSymeg5efbUO2q-Ppw0ufVDbmgf87MWcKcWOWgCAKacUKl7A>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Apr 2026 17:58:22 -0400 (EDT)
Message-ID: <dcc48de2-09bc-40af-9370-57b29161db4a@pobox.com>
Date: Fri, 10 Apr 2026 14:58:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175913.177092714@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/26 11:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
