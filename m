Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BF779FD
	for <patches@lists.linux.dev>; Thu,  2 May 2024 06:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714632439; cv=none; b=KyhYQdaDpsLoQegaLUPJW/ICyh/r3tY5qzbiPAC9p9otMXxzlqXozsXjtT2hWx0tAHezXd1Cr6uuieoKif8zKfVLijD9+uPpX7KkesdOvb7felK2FdeSMmujE2L8XWhb5HOzNf3sCvkpxz6fFjNB7Z+L7cKc8sWVEMM+JrysbbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714632439; c=relaxed/simple;
	bh=MgN6WvuiUylFTNdRKNrLtXZ0I2A9tlEMneDXVaYeQDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fu20/gJW8Rsql997FQvnWFzDyTJn0Toj1a0bRnij7+Nn18OhCZWVirM+d+u+WQkAQKO9GHaHbjBKw9r4ingWV+gAEcsDhnZRAjp1ZUqLY9fPXI1Fq6Pq0ZIS6yfuYXkUVVoVXvHWcuzFxPg7UzJh9o6E4pJPfjeYSQ5Zws1KDYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=oxxgXb6P; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="oxxgXb6P"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1714632435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xsG96rRIPyvj3pi8mOZeqyiz+Dbsmx2Z77DJBrRJPHI=;
	b=oxxgXb6P/nA9lHONeXronDYvTSeEwmvK48+GtHBiMJG8+n7ZgU2bmDkjVRoWW90oC+j+Z2
	DeSPClLFaFd+2mCg==
Message-ID: <5f324947-bf9e-4c37-a87f-1ce05c0cd08c@hardfalcon.net>
Date: Thu, 2 May 2024 08:47:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.8 000/228] 6.8.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430103103.806426847@linuxfoundation.org>
Content-Language: en-US
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-04-30 12:36] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.8.9 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.

Hi, 6.8.9-rc1 is running fine on various x86_64 bare metal and virtual 
machines of mine (Haswell, Kaby Lake, Coffee Lake).

However, building the kernel documentation with docutils >= 0.21 fails 
without the patch from

https://lore.kernel.org/all/faf5fa45-2a9d-4573-9d2e-3930bdc1ed65@gmail.com/

Tested-by: Pascal Ernster <git@hardfalcon.net>

Regards
Pascal
