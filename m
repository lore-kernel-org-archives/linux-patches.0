Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BD2247DE1
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 15:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776178871; cv=none; b=R2thEyR8J9zlJPrtxA1c7nuKxj6uNN5TUoLZcT/ZgLWVubs/o1N5YBUcy9X1zLg7Te/5SUop5NUIkUXu1IIGkjddzQdXy/GfyE9mKYiz6b1gJA/FPxNBl8/WjUoowCIGOygcCDKKexo6fvTNQBQDgr+MTwRCagMmtpLYVqLwrNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776178871; c=relaxed/simple;
	bh=oC8kp4HEOJDiZQ1SXyOv4MljxUBKcl2v6FTYpSmmLrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q3syaaRYkSdoo1ks28bwHOtbc3+HaIe64mNYg1vzKmOtR+lzYlDuTRCzfIWBWLavDgI7DA2J+lKTA2U6/CY4hFttwk+5c9Rh7Ev+t564ZYvO/vT7C3VilAj1JFIcp82p0VwHIIjQrIrivrhwncdrdB1jsPhuCU2ETKgz5ukNsU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=rAlBPcEf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gTTxlyPg; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="rAlBPcEf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gTTxlyPg"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7E1E77A02B3;
	Tue, 14 Apr 2026 11:01:07 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-10.internal (MEProxy); Tue, 14 Apr 2026 11:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776178867;
	 x=1776265267; bh=MO0TcXTuzfDHSdv6o5fdNwYcQkAamLu4y8ZHaInjdEI=; b=
	rAlBPcEfBbo2iJsanIptgoTThltJKEUtzoIsbGGUlfXJK1BtgjgpBLFRx616NTNw
	gHVJFFmChj1yB/tKVLKePQaoyG216MMr6vkk38z18IbZY/hAERz1aQYGZ2TQxIgU
	VFEeLu25PucAwKv2dkCox7nzuEynScJr9ou6/sMqCx7aeNLXduH9SgRMmqtgW+c7
	9SrIeSYpduscnIiwy3DrbBcsyeG7YXiFIKNTazEbfWO24Ua4Q4+EPgsoiAVDFHxg
	kQktSAOgueudGVhKODvVtMo9bhYdXcUMWMVcd92R81Kvv/qAy+rBLlRCwl8Dq1ya
	4Bctfu0UMW6+HXfDc6xBPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776178867; x=
	1776265267; bh=MO0TcXTuzfDHSdv6o5fdNwYcQkAamLu4y8ZHaInjdEI=; b=g
	TTxlyPgS4eRIUvXm1pfyDI9mmrwufpJoX1lYNjaDYcuRLxDY0d88EeTy6yw1VJ1t
	IDZE8mqwPXOsXxlRbQns3/8J8rpvW5ZXQOWO8n16T2RhmWtWtDStB7AIvzBmlnwf
	Eqi8yM66TQ0n51McNhjZ832rRPcErF5SPsPfv2TY204eEUlnfpqSMNUPY/ITQGuy
	K+RJSjSP1A4euURNIlu5RPDcWU3XfWEgXTj6qe5+J3A0qnrXp7fNleVPews8SJSz
	5F6rfrJHjBEsRAwSIlnwHMXUphtRV3KYJkhEF0WXWXaQqUc5+fC5tP+utdCnoTRl
	BAAt7Fgwhvuj0aX3o4KIA==
X-ME-Sender: <xms:slbeaTtxlivtEgmKzUtlH7AnBeG8TsE60-tlMr8awv4mOiNXL7W1fQ>
    <xme:slbeaQWHMCF70P3TKO9PlZ1EhnezRicbU2HjFSkbaqFTa_heIneBZjQinEOushiMo
    3pqALr9DibYFBMj1xP-YwfIftRayqDIRbL_CFjvL2dnQtfMrwZZwd4>
X-ME-Received: <xmr:slbeaSTip5Kp2eYBtNddsmwy7aLuJrBLHyQT1X9YAkxnIrMpQoIru9aS0YDgQEZiDceJ1mqmmg4SDDoTf9yHDyBhksIw1vNf>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudegiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:slbeaWKLSkvE_bbS9ECLYjlRowLlkPo4ynOnvw7jtxIlmiH8JYHfAw>
    <xmx:slbeab0du_0F3mBE9mc1qJfUruHVETEDrD9SUqCp5xVipnC_JsE-5Q>
    <xmx:slbeaRIO-zXXP6HktPZVd0XWZmhSImmlnR6Dy12KkuqINZW4WEzB7Q>
    <xmx:slbeaTlL6yggogK60XpTfKE0bjWOsCC3KjwgW6LzzjRaYnLXE8FQrg>
    <xmx:s1beaeCwekOjelwl6Cgv_vHWKFBW0HZ7gHwNrBnNJgKfRYPFS2MvRqdt>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 11:01:04 -0400 (EDT)
Message-ID: <2b218a72-341b-46f7-8006-0944e42bd91a@pobox.com>
Date: Tue, 14 Apr 2026 08:01:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155724.497323914@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 09:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.135-rc1.gz
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
