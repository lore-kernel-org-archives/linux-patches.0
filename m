Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2B931578E
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 04:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309928; cv=none; b=GAJBds0bUeFVF4tS1MK75QKldZPdtSfKRHmsU7uKH0JeVJfLjIy7kNbzlS+4dRh6QXbbJpcDsWgT7IXb+r0VOVLKcXuvrn2viVmAYBkRAPkPauuZ3WNh2YWmJkbE+3SDI6hvCecw310f44eV8Vlv2RCG4kOcvf+HNxbZs98pzzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309928; c=relaxed/simple;
	bh=FHUz+DfsrT1n6pQhuvpk/+iRp5WJ1hmoTnsQ5WemJJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7Kn+pJzMbexvoopaxYtEmij+2KY2MdqRN1xHEmGA4QttdQoEYDPqAtUJwV2+G8vMQUyGTMEnMSDpan1ymIWT/NndScvbGWRBwIjnhagbDxfl3qpAn3pRt6zgyi7ZJzcRRcpJKdlXjTB3NXts3p5riNE+3otgLhuZE8DhSFS7EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=ajdJN8Fj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bvmk9C5h; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="ajdJN8Fj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bvmk9C5h"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 21A16EC021B;
	Fri, 25 Sep 2026 00:18:46 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-11.internal (MEProxy); Fri, 25 Sep 2026 00:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790309926;
	 x=1790396326; bh=/5eEb1xerJLAbtSFCqEL4ocUKBGXXhcin+4+uz96tnA=; b=
	ajdJN8Fjh9LxR8/AOaPr8M9V07L0Yuh2B/+tHuUig9PJMegz2sJnaCDlIwXZsCT5
	RR1awYepHbZvDbDhHsrFXl29SMIIx8Yc6inx3leb3Nj9lhQFvlbTRSxUgCnt8OCV
	aAWFiyEUmVePhG+RlHH7AEf/FWbbRSLOTsiWr3UNja5tzACSU82x/ZjuEI3s5J+2
	p8HWfJt39U0MnTOYaPSjVijFjVrHOSGwI6ONhWMLVZCe/oz2lV7A4f+yumTEN8xO
	FC9Q+r1J8hB+JD9r/+DaIkr8MjR3J0Sv06GNMGMdl+T6izW9ufPHxNLr5qOCZIO7
	jbT6ZN1MAyyS5XZQIHy3lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790309926; x=
	1790396326; bh=/5eEb1xerJLAbtSFCqEL4ocUKBGXXhcin+4+uz96tnA=; b=b
	vmk9C5h4vFE/fp+2QLSzcKgpwMQmB4++Ha/eUwvx3THwReTb0/ni4U35ArJlu99C
	dhNU/TchAFWvFsZ18fjNulOvg9ZOHyzcJetj4nRarZPMDcP0gpmkkCrVOND0FX0k
	wk67klSlY3+w0JR02lh/Z0cHXUTS3ZspcZVKkpF6t32Bf3wP6iRWsFRCbnLSig50
	P8vvSRK0jm51X9xncqTIOFFksW4b9J2lkeBXPZ7RbHmYEqYhfDog5FP9aSow/GqC
	q167LJSYwV7GeKgTOmgWOr/Imwc+vzyeC8HbAPf+sBp7UEFLDEMq83J0OznkKZIn
	Cq7xU3E9xwUyHYShIhwOQ==
X-ME-Sender: <xms:Jfa1anvFEqFQ1-0fvRAVlTzTHFMBLCEJf0OTgtZxLZlCrzTtBNM79Q>
    <xme:Jfa1akXm0QUEkWRhhcRkCjyqlAy0IcQz9mprarA_T4pugk_C0lKQm1897ztTggOsf
    BGiEB1e1Ln3L4Q8PTdTwaRx-VUO5UepS3y1Jj7uXQ4etZTaFNXv7Vhe>
X-ME-Received: <xmr:Jfa1amTw8DV4ceNFo5s1W4TtQpGk4wZvKhGcuXIFFLwpPPKbmpac5k7tDHAVHMAEna_fdDBN649fWVLClrwodvXjb5maKmdS>
X-ME-Proxy-Cause: dmFkZTGsP48+WByhG+X7tNrTBmqPjV5nT4JgXqfIb6LSMkBmlZp629+BkEepAHRxOhzHt7
    lIrAPJ00gcEQfVN6cQ5Wr5qCa3eNzMHziejRc4HpApBfBNjnaqF8IPEte99jJGqiquVvl1
    TnOmEg0OjIy+MY5B3v0CzxArFjo7f0AIy8Nb1oqXnnuO2lcTRUP34/0rlO9StDO7YHgor9
    HL6RTfeUuxE9h7iZof13jcH1Slr1VlkEfvYjyscBjj5rWNSRqB+dH1lOpGOyF4mdnEXcSR
    ptz/7E+ESs5JHnykKRBqNSdGM1hNfn3r44lBqHpWY9HA2E+Ikuok5BmxR3SJBj7DHTOSqr
    nxZs1endMDolYMlcIJ2tjFlUGK5B1fySaTTJdprgtODXTRUSd/xfR+ds3HS1d+ARkVbqGX
    2pwSGw0Tm96YY6fFsCA2xLWLgRv+Xtn8oKAQmcH476nQaeM0ZYdJYwjdfAl/I8tMXwg0JW
    7KdUwtMB4ne1EKRoZcAKbQiraxGTKMBXPsf5PQbby30gY9PotinVUGIzP7NxsTpWFdad95
    atAgJ1wPiLYVQf+aazK09fYxwuZ8XzRmDuLpJ5Dr6CWOOWa0M6tBOrw7/Dzug25YxvIXma
    3qLrvBIXz43wsEWzQjJB0gLFh+4/6NGM1jTo1ZnxgcmU5L+CuQTgfPJ7VP0Q
X-ME-Proxy: <xmx:Jfa1aqIcMxfkMduHebSMCAK43iGcjIiMDeeMjr0yUCgYkEV65XFP2w>
    <xmx:Jfa1av11QCn5SiOy7QTWeKvZRNICX4ufuwk1ZD8nb5RoTfGSUyTjRg>
    <xmx:Jfa1alIhC2bBEZZb35JruvM3uF4lRU1Rok6VeR3LcIcYsP9-p4co6Q>
    <xmx:Jfa1ann9DlDu6nMWp19O8MQNeIu6v1ZvpC8FTxbLWwZUqlUR-oD5HA>
    <xmx:Jva1aiDpBzlG5zPszoxoeslEmdRenJBIO2njIMA8yLlHYBdfeVuvRUrY>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Sep 2026 00:18:43 -0400 (EDT)
Message-ID: <1272ec00-bbe6-4d70-ae0c-e1f68c5e65ee@pobox.com>
Date: Thu, 24 Sep 2026 21:18:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260923140644.756254324@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/26 7:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Sep 2026 14:05:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On 3 amd64 systems and 1 arm64 virtual machine, I tested 7.2.7 +
stable-queue as of commit b1b54c5d771a22b69e435ef44b5fe9ac1e714703
("drop 3 patches and reorder one 6.18 patch based on RC review feedback").

Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
