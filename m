Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB419479
	for <patches@lists.linux.dev>; Sat, 25 May 2024 09:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716629844; cv=none; b=os+LVq3Vm+EbKxZOGLvwgqz/HN/B0c7k8b37x5s6JzYsutiI/rSC0KZ4vIgkuPGDcG+cAOJ1zQOKf53MVAae4daI7EUq4UCoytYxhKa2J0g5lUJ4CclYjrL8Y5bUisjsNyvagr9ZhOIxpuZgIlvwZY3bnkQ3C2QoJNtwXq3OkY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716629844; c=relaxed/simple;
	bh=M0R+1z3DK0h60G/oPIyYQDPmLrcLTvb3ohK1sQJDcFU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=LuyuIkOcYcxP4y74tnhP7jWCf4jJwvNpDyx313oih1AxGEa0sBhOaLaZqwiqnnTnDGtm5RIo+zV42CKdTHiMVH9Nh1q8yEwVSRQe73kCAXKm7+8EI0I0h5+Z+0DEx8J2kaFmjLDgtJxq+imBfJoawKr1BNmocUO/VAV50OHoHY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=z3pSQdmw; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="z3pSQdmw"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1716629839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c40YkThs28V4qKi9wSLxiEi1vDtYBwch29f9N6r9i88=;
	b=z3pSQdmwPwnQvmCvHJvKr1u+bNDr5AM1X5SoKysiyL2TuPgmPF39UbtsZg9IgU+DazklLU
	Zkg2cyiVRqQHbSCA==
Message-ID: <8a6dbd72-43ed-4541-ac7f-23bfaafde3fe@hardfalcon.net>
Date: Sat, 25 May 2024 11:37:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Pascal Ernster <git@hardfalcon.net>
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130330.386580714@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-05-23 15:12] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, 6.9.2-rc1 is running fine on various x86_64 bare metal and virtual 
machines of mine (Haswell, Kaby Lake, Coffee Lake).

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
