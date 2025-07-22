Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CF4372
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753200825; cv=none; b=pa08gdsKU/TvoIoq8nzlLrBlpEsvEepBSycewjSbZaHOjEWVf6OCrjkmC9Vl1Y6YMc3UtDWGxE3goGUZGQiHyFylszyi6IuynbQthXXq3pQhj8tzB7kFZTd6kXVKrF5hhIrzBoeOTLXzXjPgBXWONyQ/mqmXf5ILKluhyzh5tnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753200825; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MJdWRGFo/68YWNMWE5t67pzlqLtjs73dnAxkjMJvmovQbNM+LNSqtcMkxO6pGnUlkrRsf2hZQmoEOlaeg4MaTotOgFOiHPJtZTwUO+g6iFZztbFZxcz+ed4eCEaKfrHG/DImcjUo8q3ZANBh7Kb36MenxFAnGgHWmhylLtixMrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=G4gjUCP+; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="G4gjUCP+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1753200818; x=1753805618; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=G4gjUCP+0WBXgnTSmx5qI+3l/tQd326rhJYCWWaD0lh+qGxMdo/0cQ8UH9s5bW3+
	 ZRLEhq35oEbyIoW8jRS243ztMWCakTBDFd/80YSx/mgLYIJSr8o6ZX3cVNgSFdZYv
	 2/11tjznaykUGPeCZq7NSNxJl2iK4rEhhQzOozslk8yCMsaFirVMrodfC6r/Y8rq5
	 4KfCSMx9MOXU4EcKkdsKv5CbUN8tm9Z2x1z1eZLFgH/r7GNj9eISA2iFnxcy9EFXe
	 x5JT2Ws1pLPLCBav5x8s/AEcj/w+vWLYMrk5g5TqeqXo4VyVWaEnrE0cyzMf+YzsO
	 bGnO37mVIGh1KUb8Rw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.133]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MYeMj-1u8eGX1xVD-00Ko7b; Tue, 22
 Jul 2025 18:13:38 +0200
Message-ID: <1e9aa6cb-3aad-48d9-9ddc-bcdd1880ee0f@gmx.de>
Date: Tue, 22 Jul 2025 18:13:36 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134345.761035548@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RjoiAJj1xoeGplXLoo8xpqfSxz3bEn6ejTI+bEHOZ6+u1n5YXZx
 eDN3fOSctQ8PzcZVuPPcTf1P5gv0fqunTLSlV+dVnYZ96uYnGzPf6Z3jTfnLu1d9hqZm7nO
 77Hz1QzlodhYh7Ivw31JwNCzvDJfBxWQYnVUfmrgSs71yGblfyTpqQ3VMZjyL6lp1cPPT4T
 KT0UKcXeSr6WHsyc0sKFA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZdXD5vaZ29A=;iPSJOisIgKKANbE3Rr3CW1yPd9L
 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
 6v+34YsSabtHh7h97wj6bnivTV7iAV2Rw82ZxQ==

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

