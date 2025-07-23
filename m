Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7352749E9
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 07:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753255597; cv=none; b=X5rd/7A74e4Ifsu70bppGdmhttzjY2RvtaAJfbnBot+r7Tvwr3JdwsVeg3R3s7RHVer/uIG1UV7BKDHFoQOdfF4iBY1FGvjNe/0S3HHrvE81OT6sHY+8e2XhWjVVbzKBwDRrYTTgPIpb7DlM8wvxV6guUMHUwW4It7Vsja4ArKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753255597; c=relaxed/simple;
	bh=6N4TRiRZ0oanZgXMZ6ZfXs5IPqi+1Ay79cak2ea1LWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BUg8xbP8rgLPWfaLSCQWsQieq48zIelxUMcty86SwnPpWNCqng0kg2essmNGV9jTnTb3UCeF1M7/NoBaoy+vlXgjpOBCG73RHB74jXlrtzfSDS03f2NpgPiUm7/cL26ij2CTF78ECSSFSR0vcLwbK9eZS6OTq7DjXQrJBXJ1jv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=F978N9YG; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="F978N9YG"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1753255138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qDjOlNwNb/uFhnwIO+pE6cclriwg1Jx+N91R6n4gkiY=;
	b=F978N9YGJqJMjXzp3AGuz4Tm+bpIfhiYsdEu/aveVUpYCvuT8lfqSft72R3Da8uR5gXq7Q
	vgHYjSHeHZA7WbBQ==
Message-ID: <0974b1b3-d90c-4f58-9201-989d71690d52@hardfalcon.net>
Date: Wed, 23 Jul 2025 09:18:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134345.761035548@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-07-22 15:42] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.


Compiles fine for x86_64 with GCC 15.1.1, and runs fine on various physical Intel machines (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and in a Skylake VM.

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
