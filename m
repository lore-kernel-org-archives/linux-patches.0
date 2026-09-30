Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF1152F281
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 21:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.33.87.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804272; cv=none; b=Cxy1ZR2mzsWohE80ts8N7Ndv2Y1MMoTqUYsKYRrJisVSRU0szIgWH2+Eg33AQvs8SHJlpCyrJYD5EttFDivqMXAM6xzXmAta4o18jo5pnJPTGWdKYuKfjFcZ5ZV9x9y2RpkXOGt0acPuQDvce6wEiz+klEdJTyJx+Zw08G2J/tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804272; c=relaxed/simple;
	bh=/4wrKAVpOlwTgxrgixAZVYhhfCFrT3oMrw51Fa71xSY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Jku5/rb+aijXkOS+z+8GwcfPWRuZaiy3dV1HJWgxg6pdeaS+tdBqP1R5URV0viNW2X8bx09LMhRt7CEZ9xoekdqdHx/PxYq4mrclncCKrRVylW1FBtKjKr3t2GXnT6F5pxDATwlvrwk3v8SlrY3gSKKERdbmczcs595EpacDonM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com; spf=pass smtp.mailfrom=aaazen.com; arc=none smtp.client-ip=99.33.87.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id 82c01583;
	Wed, 30 Sep 2026 13:37:45 -0700 (PDT)
Date: Wed, 30 Sep 2026 13:37:45 -0700 (PDT)
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
Subject: Re: [PATCH 5.15 000/752] 5.15.222-rc1 review
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
Message-ID: <2558e7d5-1e-50e8-8c7b-eeb089fbe8d0@aaazen.com>
References: <20260930152358.131179731@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 30 Sep 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 5.15.222 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.222-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Tested on AMD64 12-core and 4-core systems
and    on Intel x86-64 4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

---------------------------------------------------------------------
There's no real need to do housework -- after four years it doesn't get
any worse.
