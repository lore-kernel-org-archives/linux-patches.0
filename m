Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776C53F9F26
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746174; cv=none; b=kl40MF6pp2Cling/3MZRqChCsdE4BZ+g1JQi4+HpuSbVNmJ3AwIWJFewCdWjBBxlD1Ts4EIDcMPKzSEXnB2ctnk1BfEiAZyTb7RUdt7n7OdwsJ6SIaQwctgYYaRnP4wfY/q24F4eO6Jygl4hoDbHWaEIYTsjH4kygZOtnN0UFI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746174; c=relaxed/simple;
	bh=X4Nal4dVzruiKWaSEYsGNCg4TNbqPVOO4N2xKunInrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Eg/JCL902vVLZ/HtdEonoo7Y3O2UlQbZ7qv0rwE5oRP+tExTEVjTeOOa6NdSO8dqzuO7WzC7q3GboKVgj4VKb8p8ezjnN4qe85LiQ9z5M9ET3I4OvJiXzy1MqEXw7mi9F6TnFnI+T6/uEYDok9tu/sGgnM4L0xEeoJvmoX5ZcWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=nG4OWRHL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fhytSGHf; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="nG4OWRHL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fhytSGHf"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 5BF981D00060;
	Fri, 18 Sep 2026 11:42:51 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 11:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789746171;
	 x=1789832571; bh=6hzt/ehdmet/uE6Jl1g7uhHtpkqXvD2yN4nNLwESikk=; b=
	nG4OWRHLqJg24+nBVbPIJOFmuotLG5k5pCoJp6zlpn/YwSWpfM3vBFKv7DqiG6EL
	NcT560VsCSKSIXPGpVA9m8RXE7Humzx5+s8K/0uHQAjFT1MWQx1XMPFXpQ5XG1RI
	3Vw8u5/g2f7DJPLX/SzK4hACQiag/6S2mm4I5a+CyttZztDltR9L+Dg2k+5kHqZw
	SypTqoHcFHrDr/pn2m+x8WYlMwFRLNp4xFXuPb04+tkBUPbgr29dEwSyi2/IX1kF
	wlQDUAwRTJDzw7R5on0qaw+2pwtjgZph3g/qbfa9IvSMCqJJY4DDxsaZ1JdeA9CO
	ZiXqBZWg0Lykkjm/EIrkwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789746171; x=
	1789832571; bh=6hzt/ehdmet/uE6Jl1g7uhHtpkqXvD2yN4nNLwESikk=; b=f
	hytSGHfzWMLX/IPCErKoTfQmVc2Z3hFsXPnBwi7p7kkjTwzfO9q7FowppzHzxe9G
	ih14sYnbvXBuNVvR5uN/q45r74CEy/SG3i7cgAbaKcJlX5GATmP513RrGqJX7Ozf
	oQapokY/Oys10B8QL+ooKEbPrqHyFxfch8DAsW/Mxaa+orKjbxgcI6LHuO41jqbG
	eGy78+Sa8psM6m6TWqJ4L7vYrXZDslCp5Il3tp8RuvyQXjeaR0YMXsLt+sYCI+dx
	L54NZHH5DIfGy3BlR8x1aMlW3U4U9UJOhwl9OA2N8bkhhkzVwEFkzlklFW6SzSHm
	/IihcXzcN4gabA4wdXFvQ==
X-ME-Sender: <xms:-lutatxoiA2kcTBCkET4C99jhbOQZndqoaTNBGuXC5rRJK_tE518TQ>
    <xme:-lutapKcHaBwFOymtKtAfWfWcpFKB6lLJ5_yCrTDBKAKwi2ubjeFNmAPEQEQoUP7b
    1Kzbwyy4j0Bbj8bqoExgjYM_LdfTug6R55QYFOVmqLWi_B8X98YxQ>
X-ME-Received: <xmr:-lutai298sLvhXQtBz3rNxrXoo0M_dww0CzBqZHhGXHN30VI8ZtskuGGmAcuGeTOQSj_IZNiLnnrI8g5pS7tbWqKiLX-7ASe>
X-ME-Proxy-Cause: dmFkZTFi1A0oYdbKDak8eiKur6KTMrjOFJhUId6lGXsSvv1WVZlngbMKYROlWdB9kCWkCQ
    94gk0YY+zhCtrYaPvWhtsqFiIUF94MHT/87NGOrqR3HZq5rWoDIn0YaMeZO86FCre/B94I
    CMFLnNJVdfd8o9/jmIytsAeYSxegKXwCmBiBdjKUq97jD2c9DbRuZe+n1i42D/bS8e/0Op
    tkAGzZ2P+ntwLFKlXWNXUbVRyxc8qpGfaDJg7y46XgQOyOGq3fOtBOTFMzi2OqKoE9ahDl
    yJ6ooxD4Q75YjKHqxWY5IeSA7FzGsV8RYQgQBpzrtxPty/hsAj+u90d/A6oqDjtc36aJpO
    peWHnfWALMsBV4o7CmwvJzfdBsy4m2+ouvAKyPHv57rmhWi3GUBzZZ2zBhCB4mwjwnNkeZ
    c436l/IZ4nzN5xT718H0vjov6+3C6yrONmlBPN5WZeDQ1+USjYAEDy+UgTnWrJyWEFs3KB
    LXdR3hynUfFuALqA4KafN3EDSf0r8mt+UXYjlTJxGqw1BaJUJKC2dnONbewQevjzagbh0p
    1ces62+P0o0SjnSAYVmLC8iuiMxBakh3wVNDOzCALgPsAqrvYUETgfOhpyAdneCsU/xRUC
    U+137LyqUXCWyPY0WyI2xm0uR5ra5dO38+bHhzFClTADqmE/TBdBBU8gJU0A
X-ME-Proxy: <xmx:-lutajfkP9YVa0P6yErEFSccpHuFjdqIThqt-P1-_P9HxNp_BQTPbg>
    <xmx:-lutam5OXTBRo9m1zvYOVY5CxgYh2VvV6nBO9m4n9LSUNocK7pU6uw>
    <xmx:-lutam_P9N25CIt6H_MnfgHIk4H47JxA8yI2PD8DBzfoCLymj8sCxg>
    <xmx:-lutatItuPnOKiWaav5jkikZTPxCbGQRuBCeCHjmGyxgbfY6S-u4vg>
    <xmx:-1utaikzqus5RhH0lKUPWksN73Jrn-_5Hg-rD33moTDJTiZaufSsgHty>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 11:42:47 -0400 (EDT)
Message-ID: <a6b16511-b93a-42ca-99e9-084121793bf5@pobox.com>
Date: Fri, 18 Sep 2026 08:42:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260917151350.597953846@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 8:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.7 release.
> There are 733 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Sep 2026 15:12:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
