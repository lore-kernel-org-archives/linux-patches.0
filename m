Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5867314D06
	for <patches@lists.linux.dev>; Sat, 19 Sep 2026 04:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789793350; cv=none; b=k6EFuSdCYWcxPz0hVH2dBZm4vg1GMUdkzwyYutU3PtyVs7whiG4IxzMPdRlXiFVpFFYphe/B0VE4aD8XEbsrAVg6lnF5N7ozCNkLuSQe397uo5rwSBJHVrRBWbTN7VFSOynlLf5tgcstG/A4HHLZv4U+zRJ3N525sxRfFjEv9mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789793350; c=relaxed/simple;
	bh=k4r68afq6hyUxZs7ajqElMYcuJO4Q2v9bYqx1d2Wn5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o6UbpqAe+ydg6mr813AzI5P0yLSuXWGaofB99bLEBjTdTo2hL0FEN5pHBujsCgvvAdOM8n4xysibNWtO+6/ZEuTZVNlzUXtZveEK075J3d0XSEzIYfEsYYzrCZT6uAXrq1xQdnvZls1f4UDpeM/+AckRl1fOi+7/7K8g4xCLWGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=g4qjmJfh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YIRo3927; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="g4qjmJfh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YIRo3927"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id E7172EC01FF;
	Sat, 19 Sep 2026 00:49:06 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Sat, 19 Sep 2026 00:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789793346;
	 x=1789879746; bh=Cdmab0n4jYt37Kqta2KSUpk0MbgPi+pANQeQwzXiufA=; b=
	g4qjmJfhok4pGO38SPBX9Kf8qLA+uzywQ01u1C8FqCBFfYjRcSBcDCVsssX0w36F
	IhRPm6+Lpz77jzr504tc3ta7wYfTIpyYbo8CbVjguEL6rOVaGXSpX23JghjmENaf
	6XuyJccx+ecKuYILRjNNHVaJhUCzjFwkP0pq9ZmZICi4vamrKb5q5h8xBkKA2qBc
	H2CShqhGRIThE6+ulsEccLi610gbETjyVOrqYgXkcFxll05ogn/KKvBCVV5gIct+
	S3tjFEM8UOH6q096jYXLosnVAU2JlGP5njjuOp4vSUjeyDOEt9vwLzlePjvABtxw
	kuBUxlLlcSfjGQf1t1r8bA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789793346; x=
	1789879746; bh=Cdmab0n4jYt37Kqta2KSUpk0MbgPi+pANQeQwzXiufA=; b=Y
	IRo3927fviYoc9Vae/pGzRqI41aiotYg6KzqD4lx+/b9FolSOOqy+/QMTRVfTK/L
	evLnu17OVqjf1NESMOg/G33dk0tAEZnXN5Hmn5D03JzTjCT8dMEbhWpldyIyzDfY
	wch8U8i95ZQ5pReMaW0OOieYKwrbX9bmob5imnJ0yqImsARaNKYgfIUIcFEnQvkV
	e7tQk9VsKUmV5LBrarOAx5c3jKBeSc294L/qX2YkdfjsRRmYjnQPz4t+zMH2Y0ci
	Bl1hL5agQ7BBA4Y3fAJVVHPRY+C46O7aN3OXsFM2kNx5L1iYubDjeGSIShxboMPz
	GRX0vCQj4dVTp4EKwst6w==
X-ME-Sender: <xms:QhSuarlvr3JngImMbVlFO2H05pVTsJ7ZtNY6BGD1JCDPsD0Ls8SRuA>
    <xme:QhSuaqsWors7QTfOA7bQAMbt9oBrFoN01yzQnrNeX9hIHq46zjCjM7KY3peSpBOp_
    UxCXoPulwQrEbTjSaj2dfv5JyoEaRhe2BFfYl1680M3nwxjhS70fUk>
X-ME-Received: <xmr:QhSuatIvGb0Gva8cmCtXQnb12LhakwSkm-V2nfPFyR7Z1o7rbVwkHXfD5dCzirQfVW8HwhxObh_BGY874fwn0AGYVTU6BHc0>
X-ME-Proxy-Cause: dmFkZTEmPDgo12bE/rZK7Jply7ERprqgnefXmqY0zJIzCAOcmHsAXwErDtVK0xJOEWQ/+x
    oqADmOlOZOFG7OuUjtHfmCtVlQPJ9IFqB6f5Ea7TSyHMyEm1cgepgTkqf2Knt+TNNOI/MM
    tI65HZrG8jLtwxTjhcejNyfsykIePq1DZ4VcFT0QL1xiT/Zrog5racKF08XsxvjcSQN4Oa
    tI1G+g0LT/Gyyp3iMK4RWiBdjk+6Qc2v5moUTM1OGFiEZ5WWFvblctZoSg+wZVkGuLgu2m
    VmVfKb5jC7mT1NQvPrJZoOcYoOQMvV0/IaPz/7FfDCfLyMp8h9Gh8+azqgzMc1ZlTfcfst
    zSCbouR8X9g0hfdDIExXMJqG0ocUJGQ03pVA6z6MJiZQtPaSNrFUVvhdI9on2xQkGAn6UZ
    Wl0ZG3J6hbfLhvjWQ+KlyXUCch8TEsVD4GtJCmjPZSotQ5VJ8NzHihZF+qZW6c6JIYtldf
    t6szrTQDD1qB/ziS1wgrWxla+iShRPEEZjesk0u5DFBHUgtBty0tG9XMAio85TxOT+0RxT
    8w4+5BEInOE22NDg58dQdNAvlOGYJlgk2jORg4575YDRiMv4op7Vh2eOtCVrh7ZQloiVkO
    /2tf8Kld2qZPhKN0Q8crM/qHJBiqWDkyjXMI8fA2OiNlWSdOHPb4s/nDU0gw
X-ME-Proxy: <xmx:QhSuanjyuqn6nd6UwnFzIXaZ_YQmHouCK6Nj5u6IML6jpxyN9OTBBg>
    <xmx:QhSuahvGfEzOUMsi8WQpbh4RDOrSVVavyTRywOZv3LEQstN4ZZWfpw>
    <xmx:QhSuahgyXHYyaG8a8JKmPWEUsVc95yMqFWdB4_8cM1hzJ-ZZBIVDzA>
    <xmx:QhSuascFLUJBRchN1rR24SND5XSoU7dEnoFBsWWLOaWzIXMpCf_5Wg>
    <xmx:QhSuaj6KDAfpkfOpS848UpQw2nKZKyxjdwx3Tzj-MKnt-YNLp7RP0wGN>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 19 Sep 2026 00:49:03 -0400 (EDT)
Message-ID: <7fc82ef5-8daf-4f3b-b747-600231e702ab@pobox.com>
Date: Fri, 18 Sep 2026 21:49:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1250] 6.18.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260917151551.901433442@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 7:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.53 release.
> There are 1250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Sep 2026 15:13:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 different amd64 systems and an arm64 virtual machine.
Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
