Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [151.80.165.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B6D13D503
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 11:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.165.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728041677; cv=none; b=etngrmNlrYVtj972P3+3fs53/iNEN2eYOnoob8Hp6Uq4muHr3QsSqupeCDzQPCB7PZ3EOsWaFBDUeLTrDD3xDmZgMZRBkxSQLoLHcclF72eUtXro8fIZ+78eL2+lCtOwC482wJ1KCsevK7XdqWhuB3eQ2j9e++V0Zl6y0w/JCRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728041677; c=relaxed/simple;
	bh=r3byHRX1DD/b6lnSg+ZhhlLMhZNxtPG3BhwsndUIWZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FL28LWNZLPd1niAFbtw1ElBGvyVXgS55sQQNQVQnAlFiz1nvdUuN33GuRoaR+jDDYudu5ByEmJf8nB+i6PoPqh8tkx+gy6zJZblP+KoauUg9FLg/osy3oURPbXy8HOUpN1IlHcwZOuchqAkThy5UwKVH0hK4nk6Pm2hxeiQhhkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=cmDPgSDJ; arc=none smtp.client-ip=151.80.165.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="cmDPgSDJ"
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay2.mymailcheap.com (Postfix) with ESMTPS id 0B91C3E8B0;
	Fri,  4 Oct 2024 13:34:34 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id 9D46B40092;
	Fri,  4 Oct 2024 11:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1728041673; bh=r3byHRX1DD/b6lnSg+ZhhlLMhZNxtPG3BhwsndUIWZI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cmDPgSDJDUGFZl5Pwl3sgFi+WFko/fSHOhTIhB4YzO9jNCFQp4ogSAbfakUEYLtDp
	 C3oijIKzugW2x2C8jTUMrsUxFyO7/ufIDfFzaeidwz5zHWXc/GVo8COZ9r61JgiEkd
	 PkkLTKVdcwLAkrf1nJWB9cWx5P5uZVEqmC5F7Yto=
Received: from [198.18.0.1] (unknown [58.32.43.121])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 8078B405DE;
	Fri,  4 Oct 2024 11:34:29 +0000 (UTC)
Message-ID: <e71a5888-306f-4047-aa01-6df301297dd6@aosc.io>
Date: Fri, 4 Oct 2024 19:34:27 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 6.10 000/634] 6.10.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241002125811.070689334@linuxfoundation.org>
Content-Language: en-US
From: Kexy Biscuit <kexybiscuit@aosc.io>
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9D46B40092
X-Rspamd-Server: nf1.mymailcheap.com
X-Spamd-Result: default: False [1.29 / 10.00];
	SUSPICIOUS_RECIPS(1.50)[];
	BAYES_HAM(-0.12)[66.67%];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	RCVD_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,nvidia.com,gmail.com,sladewatkins.net,gmx.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 10/2/2024 8:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.13 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Building passed on amd64, arm64, loongarch64, ppc64el, and riscv64. 
Smoke testing passed on 9 amd64 and 1 arm64 test systems.

Tested-by: Kexy Biscuit <kexybiscuit@aosc.io>

https://github.com/AOSC-Dev/aosc-os-abbs/pull/8157

-- 
Best Regards,
Kexy Biscuit
