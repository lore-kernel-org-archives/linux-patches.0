Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856462E7162
	for <patches@lists.linux.dev>; Fri, 19 Sep 2025 08:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758270245; cv=none; b=c5hDRQEfF6SmvvjNgWG5gwIO4XsGaalEsfXMAj9eAEYCNClz9k2OeLzCYutgA0J575/JMjHVbDYmhLJ4zmAQRdwR/QJbjMxbQzX5QalHVOtiRI7sSBxm3wqWRXTF2aKtBoxxS9BwXgJDucHfgk6ofBW+482xuw9mEkeLmVtV6jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758270245; c=relaxed/simple;
	bh=4W0g0d8sehQkpcgyGuZelCdtbmRc9cMqDZxPkYTObhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=swTKnI1ZlwmWVVKzP4XZkIakLUl3j74WH+tdIIPfu64MVHO1ejEkWGL8tiJ9kVfcHj657bHuWop3Aj+eeO4eBtC2Qu8LBmWeDcWK5THa/NFmv92EtlEgpMTn4olaG9ynpQSroum6daM4wWxhJ8jVAYt9qIOLAoscm4R3Ghqedpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=pXc5EYRb; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="pXc5EYRb"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1758270232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/fzQKh4eKK9BcMpr+vn4JCd8LIXiTtFPuKXSXEWunzk=;
	b=pXc5EYRbRYW11axFrlqzYgy3rmLPm7wJiQp2uAz1ybCghCGC5x67IuLUEdBMjq7EJTJ1Zy
	aogtkvS0F+OLvSDA==
Message-ID: <a9283590-1e44-483d-9a5a-b82de8bf91c3@hardfalcon.net>
Date: Fri, 19 Sep 2025 10:23:51 +0200
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
 <8296d8e5-bc76-4ce9-847d-4eedec16b5f4@hardfalcon.net>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <8296d8e5-bc76-4ce9-847d-4eedec16b5f4@hardfalcon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-09-17 22:51] Pascal Ernster:
> Hi Greg,
> 
> both vanilla 6.16.8-rc1 and 6.16.8-rc1 with the additional patch "netfilter: nft_set_pipapo: fix null deref for empty set" from the stable queue (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.16/netfilter-nft_set_pipapo-fix-null-deref-for-empty-set.patch?id=0c6237e517860496c3dece455ec705bbcc9a0d79) compile fine for x86_64 using GCC 15.2.1+r22+gc4e96a094636 and binutils 2.45+r29+g2b2e51a31ec7, and the resulting kernels booted and ran/runs without any discernible issues on various physical machines of mine (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and on a Zen 2 VM and a bunch of Kaby Lake VMs.

Tested-by: Pascal Ernster <git@hardfalcon.net>
