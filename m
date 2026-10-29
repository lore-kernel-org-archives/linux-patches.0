Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=99.33.87.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793317848;
	b=BIL1bmvgCa8PAMe4Tr11eLrLugMTz0u8fYo1kKt0ubPJ+k9DOzoRtpoMWC2DhdO8czTA
	 zEAWqaVfcw/npbp9rkDtwGtvUL/nbcE2YTmNAWY9cULBMHy/xMGMEaypOnysGAj5kGle8
	 om3n4yQ2Ijt4no9bWjKKhGfD/z7LgwRVbuH9dpw+LfkXYx8pwP84CQf6BS31mghCzj3kG
	 QSrlOEyQ0WnUg4/ea0PHYXECX4Rgag3cJd8Cxn94hEFaI4rH335et4k7tLSv4ZFkB2le0
	 dSZnwD4Fg/442nnOz0W8qGjLAH6LtWuFKF6LkNq+ZZInBxHHfwF7/IpvcYm/VMgAXqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793317848;
	h=DMARC-Filter:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:
	 Message-ID:References:MIME-Version:Content-Type;
	bh=1eLdkJnMzIEbO62c9IAvfj06Rwm36zqoWEIVBGBlwoU=;
	b=tVBmku9mMHSHt7HDbt4EkKQXRhKIjI8ufwBrUauy5xFNSMK7jea001j67H2TVtfHIwMh
	 dm5QlLNWCWNpfVzhC7niVdlpY2ZOdV/s4tKdMJXy7t4zeZCxdgcHD0WKgc/gct28oSYO+
	 3X0sg77zboNRbkZY3iwY8WCvt9/3WF44eJGiMeR6yfO9jSZ/T+OccueK4lMCKMiuFGEVP
	 sU0qOHJYJA7RNNYXOv2zcjjzOzZcA8Skuwe4j7p7sjyucPwpmJXdlc85gzNzLjFnm29re
	 2izRZsCb0Vkb3322LgNIZgiwtvdfVKqF7rLBZ8gsGNuOje3zaTW07eOtzhrMWjrXjNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=aaazen.com;
	spf=pass smtp.mailfrom=aaazen.com;
	arc=none smtp.remote-ip=99.33.87.210
Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F91606A338
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 23:50:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6F91606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id 14ccf7fe;
	Thu, 29 Oct 2026 16:50:41 -0700 (PDT)
Date: Thu, 29 Oct 2026 16:50:41 -0700 (PDT)
From: Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
    akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
    patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
    jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
    rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
    achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
Message-ID: <d5121766-60dc-028-f7eb-dbaafcfb7ca@aaazen.com>
References: <20261028165947.349197979@linuxfoundation.org>
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

On Wed, 28 Oct 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> -------------
Tested on AMD   amd64 12-core and 4-core systems
and    on Intel x86-64 4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

