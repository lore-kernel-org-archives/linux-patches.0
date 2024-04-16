Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB19131753
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713277032; cv=none; b=EE+VdTmke7hhkVxsCbMeKtT/b8TlRrnGANPT3t2cX2vNak5lLN636xNO7ZjC2OSz0fl2sAVKMSAlYdIOsxqHvXGWWcRfdaRhgo8I/adrC7hGc9cfOSWj7iagbvCiQk8lfBoodxv57jsh2l7l2ie9vzUCcDl45GwJ9KDI2hcxPMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713277032; c=relaxed/simple;
	bh=C1MS2iUcQphnO1NqmqsnWJGp22heP/9EYZEXlNKKrag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T7e2wbGz7NA4GGt3WmSBieqXuBU4EQj/g6G4ByDp21fhB7wBAXF7yJV6tUkj4ib6nRSPzKswnqX26QUup244+2rKtN+m751LwRSFGG+MdDO3DUiAF0c3Yt0DBOA0jNt/G6C5R34ooD0kJ6j6OWf2DsUh7GK6Jl35HyMyEoauBpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=oQRTxHX5; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="oQRTxHX5"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1713277028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VFZUB1JTy+76aVFdxoNxXskZorgn9QS6Ccfd8Qm3e8o=;
	b=oQRTxHX5+lmrB71Jvb2auRcldhFoUsPk5IKK6T3YwjJP74yx+8WjHoCLrvAsz1uQyN4tN3
	gIFLZvpuEAs/8fCg==
Message-ID: <f500e826-1d12-4084-b6a1-31d8fdc72dd4@hardfalcon.net>
Date: Tue, 16 Apr 2024 16:17:06 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.6 000/122] 6.6.28-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240415141953.365222063@linuxfoundation.org>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-04-15 16:19] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.28 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Apr 2024 14:19:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.28-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, 6.6.28-rc1 is running fine on both an x86_64 Haswell VM, and on a 
Mikrotik SXTsq 5 ac (the SoC a Qualcomm Atheros IPQ4018, which has 4 
Cortex-A7 cores).

Regards
Pascal
