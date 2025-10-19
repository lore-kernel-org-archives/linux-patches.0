Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1821029D28A
	for <patches@lists.linux.dev>; Sun, 19 Oct 2025 10:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760870181; cv=none; b=NyfR1dJN/0ENZa0xjNQnNcTIbkIXdWcz6B9TURgjN1cL+rj36VNXJovxO0OxXA9xy5kbtRxS6CzlCzcyuNrg/qu+VMPeojwT9njHGlMRM24K8x4Ir/tfwgSu3eym4lnMsUpykPL5/20mqJL4ETte3/8EUjdCm3CduXGJUzodIE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760870181; c=relaxed/simple;
	bh=SAV7a4lt7hKEt6sivafdqNmETnmuFWWc/wWA4aTMqYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KnT6nE21vTEioTnYP8cVnmGo106oyb7IlMu1XscVJT1aSits0wUMIhRqTLV3o/sUri0JKCC81um02eVo0f2U5kuH6gSfWFaIK3Z/kEYin62+2gd+RtCFtVU+XiyxNvGREMBWQkGrhd5GgNfCVxAgIyhaBJ7xPJmGyT/o4BRIJzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=T8Vm9QFx; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="T8Vm9QFx"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1760870173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7r6VrRQUTO8EjsqgAX+Zw+vSOXi8yjJZSq92aCAMveo=;
	b=T8Vm9QFxTKYItZqDIpRI+i0VLm8VDoTIV35ZTVmko5B8ANaLKY38IkVmvxIuU/3nr4/sfr
	PKYh1zy5a+qSZbDQ==
Message-ID: <b779d8a1-f03f-4db8-878f-613162313653@hardfalcon.net>
Date: Sun, 19 Oct 2025 12:36:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145147.138822285@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-10-17 16:50] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y

I've applied all patches from the current version of stable-queue/queue-6.12 (commit id 4bcf0259110152b33991cbff98ac69113530480b) applied on top of kernel 6.12.53, and compiled the result with GCC 15.2.0 and binutils 2.45 as part of OpenWRT images for various platforms. I've booted and tested the resulting OpenWRT images on the following platforms without noticing any issues:

- x86_64: qemu microvm (Intel Haswell CPU)
- MIPS 4KEc V7.0: Netgear GS108T v3 (SoC: Realtek RTL8380M)
- MIPS 74Kc V5.0: TP-Link Archer C7 v4 (SoC: Qualcomm QCA956X)

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
