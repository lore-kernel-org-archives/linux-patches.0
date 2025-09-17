Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06F217A2E8
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 21:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758142845; cv=none; b=YW7Lp0jkGHbazu8gSfVce6AZKMd2O6hmxl9dE+DUvVaLB7h2b3yNV3wEdZiHn2bG2rWllpGqZ/AQyv/MAT4HlCkdTW5vFrstvD1JXWJ6kAsSnMlLwZEhrX+5EWfPrTAVE5hW2neMt1tqjkCWyLnmpyAeLh2r4cyDgeD3c2EI7kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758142845; c=relaxed/simple;
	bh=p7N2etbn1GfxSuZruh21Wrm7SvkYIZ4Rfa8uhX+WrjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lBXRhkcyPmS9yl0yrvMJuLYx9Es9v8fKrpRFop+OYjEnXCGHXcTgtQh3FIijIDqeun/e8Te/jkvmfwa+y9uTHf8IUyqG0VktNDVOre+oyRWFDUEEHq2MGPuRFdMDe6GklRMAjYqv18OFzEsDgv975k7KS85zh1ylACWe4eRj2Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=sqLwPzQq; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="sqLwPzQq"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1758142273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L78d6oqIxqnYRCvb/KvTG26Utxi6ppyuct1jIDr2qVM=;
	b=sqLwPzQqmBuJt6ufOLPQKgLhDF+e3vtlf6V1ITFlh2eJO8RPUFKZZ5XJ0QvX2b/Xl+LFM3
	a0kJRFrKQfdWV1DA==
Message-ID: <8296d8e5-bc76-4ce9-847d-4eedec16b5f4@hardfalcon.net>
Date: Wed, 17 Sep 2025 22:51:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250917123351.839989757@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-09-17 14:31] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.


Hi Greg,

both vanilla 6.16.8-rc1 and 6.16.8-rc1 with the additional patch "netfilter: nft_set_pipapo: fix null deref for empty set" from the stable queue (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.16/netfilter-nft_set_pipapo-fix-null-deref-for-empty-set.patch?id=0c6237e517860496c3dece455ec705bbcc9a0d79) compile fine for x86_64 using GCC 15.2.1+r22+gc4e96a094636 and binutils 2.45+r29+g2b2e51a31ec7, and the resulting kernels booted and ran/runs without any discernible issues on various physical machines of mine (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and on a Zen 2 VM and a bunch of Kaby Lake VMs.

Regards
Pascal
