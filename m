Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE16224B00
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 08:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739522443; cv=none; b=WFRPEO9+8SxKR+KRkPQ4tq4e6R7NWVJCkEIExlAYaxtIClPXSjnqyDUw+nDV4BfMLDG9cQoJ6Gz1te4Ws2P691t5KKV2rh6nDlq1XsTgvjOHWovV3gfs9YJVMj40laiXH6Do6015f0i72UHDlFlHcJI+8wpx3OVrFPP2EscjbzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739522443; c=relaxed/simple;
	bh=C203CqEB0a0aNvJW/xLJe4jhXrkHQ0fI8K/p06xIVr4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Qj/v1SkX05V25MenIu92Oknf9cCuZLZYxfK8jyjZQ/h8DCCeuC+PXsb3cLSZXYXkxbzwHdmVsFMtcyoa5F/C1oYLudGSWTL8AXhkn6RceZRxXfaAjDtcw5UdORs4Uq7x2Gwd3be7yz3GSqUzY15mra/GKHOnzyGe3j/K9cnwo04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5ddd71dc.dip0.t-ipconnect.de [93.221.113.220])
	by mail.itouring.de (Postfix) with ESMTPSA id 532D912566F;
	Fri, 14 Feb 2025 09:32:07 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id B241760189381;
	Fri, 14 Feb 2025 09:32:06 +0100 (CET)
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250213142440.609878115@linuxfoundation.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <e7096ec2-68db-fc3e-9c48-f20d3e80df72@applied-asynchrony.com>
Date: Fri, 14 Feb 2025 09:32:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2025-02-13 15:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds & runs fine BUT fails to suspend to RAM 99.99% of the time (basically
one success but never again). Display powers down but fans stay on.

Tested on multiple systems, all x64. I first suspected amdgpu because why not :)
but it also fails on a system without amdgpu, so that's not it.

Reverting to 6.13.2 immediately fixes everything.

Common symptom on all machines seems to be

[  +0.000134] Disabling non-boot CPUs ...
[  +0.000072] Error taking CPU15 down: -16
[  +0.000002] Non-boot CPUs are not disabled

"Error taking down CPUX" is always the highest number of CPU, i.e.
15 on my 16-core Zen2 laptop, 3 on my 4-core Sandybridge etc.

I started to revert suspects but no luck so far:
- acpi parsing order
- amdgpu backlight quirks
- timers/hrtimers

Suggestions for other suspects are welcome.

-h
