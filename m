Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=99.33.87.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795071889;
	b=oVeVMm5uO+XbNwXGFTqxs0YKLopbDMMGj95O3/Ika1VKTppvO3yHxPI1z0NKBLD6yWnK
	 2IwXWXy0F5UOT+o5zo2GTqi/Np/xLIB8Iv5M7NjUv9OKyelbo/rAWj8CMoHS617Pq3T5z
	 lTkuSgrXc8zfTST5LlZs5nU4z1xkYda851Pyh6SZ8CDgUYA0mgVZkClh6dQ7N9hqW1xsv
	 Mq7M4ZxXkJnUQS2fTUQRSjILF+T8p4v+M5Bt1/39z/f/2NKDGP4SJrLYiYBHYnw8wKTSB
	 wOKkGOdKfKEZTmofQ6IhuV8Ycmt7dFHmESvgT8EXW0Amqo+xzzVmW1lw6SysSm2accg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071889;
	h=DMARC-Filter:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=IhKF2tu8U5qG2X6/GsxiXoCGQXeMll+XF9WD/DEYzR0=;
	b=xsEqnGYRvUADi88jSKdddymR9+fw8kQJM4mLUAps/hHH5TSjd+U667/REPDx6h448Cjv
	 0w1umnZDh8bURMKWhBrubivvBYkDKd+GCVbgM2lC8Ul75x16evzfkOd/bDtcHYG8dpLoE
	 g3NPmj9TmZczWNBlbIi0G+6Xqbf94avoh3OPqdH2bX+HBmKGF//H/V5h3/fs0O2/eA+/0
	 pxHXAZg6+T972OwznczPFO/gUs36Oae7sC/CeA3aIHBuebhbZB+5XpYcGvMKL582EDagV
	 8YNDKVYz2MrbUZtbOumkKAuubMyydeoM+nOa8+RJE/t0Pj1A4g+QBJuWvj1G/nMGxXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aaazen.com;
	spf=pass smtp.mailfrom=aaazen.com;
	arc=none smtp.remote-ip=99.33.87.210
Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47549606A325
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:04:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47549606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id ade6a587;
	Wed, 18 Nov 2026 23:04:37 -0800 (PST)
Date: Wed, 18 Nov 2026 23:04:37 -0800 (PST)
From: Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Linux stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
    Linux kernel <linux-kernel@vger.kernel.org>, 
    Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
    linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
    lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, 
    f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, 
    conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
    achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
Message-ID: <4aac8d24-e992-4ea1-366b-3bda73462762@aaazen.com>
References: <20261118150009.797899913@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 18 Nov 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>

Tested on AMD   amd64 12-core and 4-core and x86 1-core systems
and    on Intel x86-64 4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

