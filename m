Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8355431A057
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 10:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758623333; cv=none; b=n/u89XxEIXlWoXB6FyK8D5Xko9GAAvcQEdbwBrlxVYkcMsSp8fUTI3Qawtz75pHdUPAdzix7f9EzPbQspDfApHzZMBv9+UrKMqAHVyj5h+HRj5eTjpBKSrvSPAI8kGF4i2B8sYIZX2kU/rhH801VKWiwTs5/UsSWKjKRvhhQgN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758623333; c=relaxed/simple;
	bh=b8bcRx/n1OGRt62h2Bk98ANdLaycS6HGYHRPiFKofCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m2n8RIv9/i5WFUFTqgg5kvv6YJa9XArmKwqKGH3hBKjn2pdMWn5ne6kVV4ExI2YGwSvfCNemwTnHDAsIQGiCrgT4DWfBMdfr0uGpeZfF0BLWSqBwBqtFaONXh5KvgbzoVpr62FHo/UWgXvlfOFrDWNjYVDCRlSqjPE9bDMbNXBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=NmryPoUk; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="NmryPoUk"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1758623320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A+2z8cWCQfG8IRmhTODqUr/zfTopUrOovmHV0vclgM0=;
	b=NmryPoUkW+EDPuxmcpz0h+LIrguoMTrlpez+D04mDUdKhJWjPOK+xk4aFGw8EL0PqbwXXO
	X87ST627jpUqZcBQ==
Message-ID: <d6c6182a-837d-4722-a6f6-b29f30c5f5a1@hardfalcon.net>
Date: Tue, 23 Sep 2025 12:28:38 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250922192412.885919229@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-09-22 21:28] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.


Kernel 6.16.9-rc1 compiles fine for x86_64 using GCC 15.2.1+r22+gc4e96a094636 and binutils 2.45+r29+g2b2e51a31ec7, and the resulting kernel boots and runs without any discernible issues on various physical machines of mine (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and on a Zen 2 VM and a bunch of Kaby Lake VMs.

Tested-by: Pascal Ernster <git@hardfalcon.net>
