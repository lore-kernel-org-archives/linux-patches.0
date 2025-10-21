Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A01D296BB2;
	Tue, 21 Oct 2025 21:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761083067; cv=none; b=Jwgnva7ZAPGQJjxZlLfZGuDxxQoUuEIGWZfvZeysCEHQwgJeC1m7S14516x5LR9xxcjNJXGicFun8fC1REmUWchsREahEQhp2cg/fL4x5kJHPl6/9kkCT05ZbXlLgl5N6BTced/Yb0QqcZftlp4goo4UL13uHY/iu62vtZdyKV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761083067; c=relaxed/simple;
	bh=LH5PVxY5EL733clxfZZcW9q1PxHHbZTzuaiYx5J9AH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hk+m8boWbexN0iz1JPNotUwSQtuGTOVC4vo5qL43tmqjG3VU9zXPpu7KnARHgFUP3iQ+7n06iK95A4XiuXAMKvc3nR8S9w/W3noKSA5eKU5K+Ts7wVNhvPoAn0uRRMzKLa9YD3VCJtcrHmp/hQc8WtO5HrCjjTy+omHfsck4oHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hburrdRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hburrdRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE4FC4CEF1;
	Tue, 21 Oct 2025 21:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761083067;
	bh=LH5PVxY5EL733clxfZZcW9q1PxHHbZTzuaiYx5J9AH4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hburrdRRG6qRTf5+j96MsAPMyXqiCGl5cNTlx8oh0PpcD6F2R0pgsaQ3j7q9xx68/
	 Axk4AQribaYivfqXd/isTTrzui5e5FA9vr1E0kCbM5t6sSTiDhwGitrWIYkZzhJuOO
	 QHvEKRWLjoQgMXdej/EYdk4ZPrDOIkkS+H+TnF1ANwO9fTBW/Hp/4o7+lKVI6suBWd
	 sWTjVGoii5+2HtOu/qCKzQhwn0Cp1HOtyidzCNsAv/6idJSJ8DEPs1MzComYwOONkE
	 +DEDF+s+z6xUYm5NAtghSP9I0hgvY337dsaOJl5c0Kvj8+dyW5Jcxlsf35+G9EQQQ0
	 yLcp4e7IB4+JA==
Message-ID: <f5c4f35d-6305-49a5-8408-a418761c6a6a@kernel.org>
Date: Tue, 21 Oct 2025 16:44:23 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/159] 6.17.5-rc1 review
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251021195043.182511864@linuxfoundation.org>
 <fc400181-7c76-6344-c6ea-a4e48d722f55@applied-asynchrony.com>
 <b7c17e91-cae7-46ef-bfc8-a9014d11346a@kernel.org>
 <b01cf3f0-fef4-e8f7-180d-903a84bc69a7@applied-asynchrony.com>
Content-Language: en-US
From: "Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>
In-Reply-To: <b01cf3f0-fef4-e8f7-180d-903a84bc69a7@applied-asynchrony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/21/2025 4:43 PM, Holger Hoffstätte wrote:
> On 2025-10-21 23:33, Mario Limonciello (AMD) (kernel.org) wrote:
>>
>>
>> On 10/21/2025 4:30 PM, Holger Hoffstätte wrote:
>>> On 2025-10-21 21:49, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 6.17.5 release.
>>>
>>> Hmm:
>>>
>>> *  LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
>>> *  MODPOST Module.symvers
>>> *ERROR: modpost: "pm_hibernation_mode_is_suspend" [drivers/gpu/drm/ 
>>> amd/ amdgpu/amdgpu.ko] undefined!
>>>
>>> Caused by drm-amd-fix-hybrid-sleep.patch
>>>
>>> I have CONFIG_SUSPEND enabled, exactly same config as 6.17.4.
>>>
>>> Looking at mainline it seems we also need parts of:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ 
>>> commit/?id=495c8d35035edb66e3284113bef01f3b1b843832
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ 
>>> commit/?id=bbfe987c5a2854705393ad79813074e5eadcbde6
>>>
>>> cheers
>>> Holger
>>
>> Can you please share your kconfig?
>>
>> Specifically interesting are CONFIG_SUSPEND, CONFIG_HIBERNATION, 
>> CONFIG_HIBERNATE_CALLBACKS.
> 
> $grep -e CONFIG_SUSPEND -e CONFIG_HIBERNATION -e 
> CONFIG_HIBERNATE_CALLBACKS /etc/kernels/kernel-config-x86_64-6.17.5
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> # CONFIG_SUSPEND_SKIP_SYNC is not set
> # CONFIG_HIBERNATION is not set
> 
> This is intentional as I don't use hibernation, only suspend-to-ram.
> 
> thanks,
> Holger

OK I think that we need those other commits you identified brought back too.
