Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D778457E52
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.33.87.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790893491; cv=none; b=oq6RowxUUG0M75rxd7tvR6yd/FHQ6khqtzipPIiKjLyLvat10BnODvv9qUJ2VHl8M4RixCz0THyOY7jRcRnm9Dzhut98NwcFN61xxA15EjY4ZSvhKpq9hZloDasmHt7aXfgDk87TyHcxSWa5ShMvyaDqZYs/8MKxoIP7QywZ+tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790893491; c=relaxed/simple;
	bh=XuWqwOZJ1Rn38ZLj6yyLF6ciQimXXyQRg0cgzcOvnpA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NAC3XC8EfFUm7ONfoZwNrFBq3mgMqTPsi9oODkLw1+5nlCCEMbYp3y1hgM4waDSVkIbL+/QkYnmGaKz9Z/eYduvmiJcs5FKuJtE1vAbHf6hKm0xpS4pCMq9Wkxw1LSRympN1sFNW8gPKkhHFAI6lsXpo9pPUkV1Fq37Rz+fpp78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com; spf=pass smtp.mailfrom=aaazen.com; arc=none smtp.client-ip=99.33.87.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id 77a7436c;
	Thu, 1 Oct 2026 15:24:38 -0700 (PDT)
Date: Thu, 1 Oct 2026 15:24:38 -0700 (PDT)
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
Subject: Re: [PATCH 6.12 000/877] 6.12.112-rc1 review
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
Message-ID: <b2d084a8-fa5b-9ac4-9d0-80a42072be15@aaazen.com>
References: <20260930152414.738996857@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 30 Sep 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.12.112 release.
> There are 877 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.112-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Tested on AMD64 12-core and 4-core systems
and    on Intel x86-64 4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>
