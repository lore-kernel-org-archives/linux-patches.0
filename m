Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A558B36896D
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 17:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789320101; cv=none; b=RU0eKN5BvtftGM6o1cIRwX/Hi669XBdV1dVjrDdBs6XKu91cXcrmZrraqjYkUzA1GWPT1KiioioNa8WWO0IACnCQ2dW5U+ImDFsMX18piyuIyj7GuAdPI03Bdtfwc6O+ANoYct2w94WfD5E6+WHWTf+uOoP9PQoy+lmCiWewQAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789320101; c=relaxed/simple;
	bh=9HtwBV3HnwCxn/Qf8Px3hIWck2pVOB4dC7tfkLsWUHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uuT3R5S3mc76AnvnjoP5465VBhN2cUybdUFl0u0DJjNOUV7YKC0g+Af4Bv/hanDOXC/QvmUrYFZvNliNWn6+r5k4L2/ly4ApxY019PpcNknMiPLBdIX76q3aerxIIrVnzXkeEVYkgWB+KHwNV2NvmZE7hMqREOm1wifn5n/jcjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=WmMlGfnN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=A1OkUX8n; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="WmMlGfnN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="A1OkUX8n"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 55DF51D0005A;
	Sun, 13 Sep 2026 13:21:38 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Sun, 13 Sep 2026 13:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789320098;
	 x=1789406498; bh=TO9UayksEEuo4YhH0WxyJHcYITEpfQTBzFu//ymT7fg=; b=
	WmMlGfnN0cOysNeR9OKGHhroxsqNhWLB3J8saLxfwBEU5RkZuEEWLqoif8j+Beji
	ZZIv6sq19pQjLZ7uz3hP/iv7fnnOHOgGrpbazhd8eS/valf3qaGSJSNI3F3Y6j5y
	0FlJfemx8gVdSNQC3sMsSlcSwp8QpGP0w0RuVK25/WZquwV6loDytFYRXQd07YWR
	QQf8o3SHZ39X4V6VLPyEZfUxAZHc84f2JUa4/hfVjx6tWiG4BfpilV1U1cLiBUNm
	UkRQtdXNukWqTfg1J7rcdY7aOGo4LEAvVNNgB5hzEfFZ4FdqYh86q1Wm7wCVY+Sl
	zA2Nj9NQRcOVc3CbOmdqzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789320098; x=
	1789406498; bh=TO9UayksEEuo4YhH0WxyJHcYITEpfQTBzFu//ymT7fg=; b=A
	1OkUX8nTB+fjCMmjRnQb2JX+8a3T9Jl4bvtcznUP18+mc65TNmf3wdN9ZlonNnpy
	iW65cgahoYwDjuCPczlpVNAQ+ELVcdYni+sz0/UZcRWvWyc9m7fEaybQk8luTFCW
	C3Cstw0hLvogg7rCyeo7mawD+wSFUSVJvznTFNXqObci1C9GBCN3doPW9Bj7ajq+
	+hNrmD5ao2FMe1Dr7bdqw4JnbkLtqQo7SlhwPSvilDWjqr6AR2d3quTl+9tMTRCV
	N6s15MjlNUcat6upy+XhL/kkwRo+TmhQrvEhWBTd/WFG2sdGp0RXDw2Z2i0a2Zl2
	/j5ACrtSgDBQ6OYkAqXsw==
X-ME-Sender: <xms:oNumah82HKK6w-jEsFwXiwXU7rXCnZNvIbZPB04RMiBKw1lNHVRRlg>
    <xme:oNumahk0OgFSPDUxalmzM8uO42wZKcTGmToxX0bq-1RN6cG27q2DJVRwgbYoRdd6b
    BxfiZm-oJ9EIq7yTNG3XE3qKSHkBY15ZoSmoJSuCJ3JFa4VGMsp8gtJ>
X-ME-Received: <xmr:oNumaqiLto6SSsuyO-qgb1mAV8dnQZ8kwXz5N9ebQkJaXc6HTMQR_K1TsZ7-CiKO73WOWg-6l89C7pP1NoHqRVf0Ixq-NUST>
X-ME-Proxy-Cause: dmFkZTG1P5L/qc8Ww8ObqIaRahkcjWAlSIQoDJh1N1/amAGyEVrpLILRnaS54SDZVVPZtG
    PZ/eQUJ8O3QqqdvY4u8Ex05dZie4MFfBhB3zMYb9cpq9xs5xkdHnmpoMPnrjkf3IgPG/Tl
    k49S+eDqB4X1nxpgVn2JwpX438YTl3fQS6FP8p3ExegP5KzX3s/pfZyAxC5r7ScnnmYrYz
    Q5JM56SSTMTV+d1t1zvEYSFt+99GICuRv2/Mclm5t/eR7xS7+dm7Zf2XxA3rKWNVnJs6Fp
    4lZdoblR6OJSSV/3unzZaRrqrcE0cUrqauGM37hCnKINnH1fvmGjjEXz3uNejFinS4caHp
    et3i9fdS/WjtRlWo1dcbfS+mtHcVlMOrLyAzIz/gzS8z8ujNJrY1ni3J4MGXVWJvPOtNJj
    h29Ee6qaS8WZZ9qIrv032j2GbotBeOZU9F4yVr4GbXBfZKR9AwAK9BmvzM+LACOJv2ZOjF
    8GTRsX11+1U8vI+cqW9DgpzsbDN01Vdg5DILeEf4Tb8il805B8Yzhr021xm3NteNmk97Mz
    Kv2qT4lXMD0Yvqv/eXqGjXkLLkPfqtPyF1wEOONBepEUqxX1C64LfE46W9Z1NsQN5GIbw1
    +oHHttIdAuA5D6bx0nTzNKYXOWlRLiSuUYESC2i5GfJmEEtrhQcDRS8CBl3g
X-ME-Proxy: <xmx:oNumapZQhYeAReeq1ShLbZhRVP-KtFkUHRuad1mthT-Hyo3Y0gx2cQ>
    <xmx:oNumauHM3VPJByNhHT8PruCwX9wKSrpN6xDhl6K_A66yxtB3szUKdQ>
    <xmx:oNumamb4Sblrlm0ny19aXgb5fdhgsMGWPmd7WzoiHgY3RrM3BUtqjQ>
    <xmx:oNumav2IfNXGTf8IRPANlQ7j8XggmxHPt-g8wzHFpw9-BpLt_U4Sww>
    <xmx:otumagQOY5LSn7XGZ9drH2fwHbaa3XEBadB18BA-Q0rAkejAJx1knIGJ>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Sep 2026 13:21:34 -0400 (EDT)
Message-ID: <fcd0319e-02a4-4975-996c-fa74f521814d@pobox.com>
Date: Sun, 13 Sep 2026 10:21:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1518] 6.18.52-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065623.398859879@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 11:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.52 release.
> There are 1518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 different amd64 systems and an arm64 virtual machine.

I'm seeing the same "needs updating" warnings in dmesg that Peter
Schneider reported on 6.12.110-rc1 and 6.18.52-rc1, but otherwise it's
working well and I have not observed any other regressions.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
