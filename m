Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF791E492A
	for <patches@lists.linux.dev>; Tue, 21 Oct 2025 21:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761083009; cv=none; b=Waj6HK0EAfA1xplTr7yVVxuOsTDgR7poZnItet9xlBBSZyju5wJvyihSVfNIHkKW1nM1skURq+HQwfSfAG4hZZF1F7Hp85NPtz02/GVR3FXP/0Ub5UTw6L6XHCE2H+agLFztKeSyuWSm/wGfLmeHUZDayt3tuY2sh5bCSvMvkho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761083009; c=relaxed/simple;
	bh=j8WTnb0Ims+Ex4UtwadikDtW+edGZn3EvmXU9vzalS0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kEPzqbgSb2AxaaPF9vgogeV8ByCSJJPVqSCi7IbwTyLW7QnC0l33k7uZkhODt5vKWOMAFy517dagIwd58PxdcSNHZR5D64w+X1X5KLcYFcDSOvoz8p8xfkiDONMmYm2iU8e2Q4qzjqxpplkOHzM1n/x6Iw6yWzsjEOgDAveqYoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b2e85dd.dip0.t-ipconnect.de [91.46.133.221])
	by mail.itouring.de (Postfix) with ESMTPSA id 31DBCC597;
	Tue, 21 Oct 2025 23:43:25 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id F3BF460187F04;
	Tue, 21 Oct 2025 23:43:24 +0200 (CEST)
Subject: Re: [PATCH 6.17 000/159] 6.17.5-rc1 review
To: "Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
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
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <b01cf3f0-fef4-e8f7-180d-903a84bc69a7@applied-asynchrony.com>
Date: Tue, 21 Oct 2025 23:43:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b7c17e91-cae7-46ef-bfc8-a9014d11346a@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2025-10-21 23:33, Mario Limonciello (AMD) (kernel.org) wrote:
> 
> 
> On 10/21/2025 4:30 PM, Holger Hoffstätte wrote:
>> On 2025-10-21 21:49, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.17.5 release.
>>
>> Hmm:
>>
>> *  LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
>> *  MODPOST Module.symvers
>> *ERROR: modpost: "pm_hibernation_mode_is_suspend" [drivers/gpu/drm/amd/ amdgpu/amdgpu.ko] undefined!
>>
>> Caused by drm-amd-fix-hybrid-sleep.patch
>>
>> I have CONFIG_SUSPEND enabled, exactly same config as 6.17.4.
>>
>> Looking at mainline it seems we also need parts of:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ commit/?id=495c8d35035edb66e3284113bef01f3b1b843832
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ commit/?id=bbfe987c5a2854705393ad79813074e5eadcbde6
>>
>> cheers
>> Holger
> 
> Can you please share your kconfig?
> 
> Specifically interesting are CONFIG_SUSPEND, CONFIG_HIBERNATION, CONFIG_HIBERNATE_CALLBACKS.

$grep -e CONFIG_SUSPEND -e CONFIG_HIBERNATION -e CONFIG_HIBERNATE_CALLBACKS /etc/kernels/kernel-config-x86_64-6.17.5
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
# CONFIG_HIBERNATION is not set

This is intentional as I don't use hibernation, only suspend-to-ram.

thanks,
Holger
