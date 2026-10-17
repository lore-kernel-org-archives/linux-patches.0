Received: from mail.aaazen.com (99-33-87-210.lightspeed.sntcca.sbcglobal.net [99.33.87.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2C04CF475
	for <patches@lists.linux.dev>; Sat, 17 Oct 2026 23:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.33.87.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792279828; cv=none; b=gXBQRNjvs0e285iCsZSAeQCCd/iIUO1A5bMM33zH9WISwbISCbX9vqK5W5x9p6SeFDJldK3LBqAZbvHDKh+sOGB5+BiH+Ml2Acr1bYcb4IwnbZIdhTwlLFOQoRYCHfK1RGRbSf3HhS84UayneKjy6wlNKMLtyTzijApDRl9Vy84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792279828; c=relaxed/simple;
	bh=X3JIQx5YgoPv2jx50o5ZdHfUXAmixcgMh0Tf9hLb8VM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BNRPoZfMTKy8PvqVy1b7Gnfm0KUlOndRMu3rXm59F/JZ6jax3lSIVQT+YRLQ9YFjIC64tEsj/9/wqjx28gPpkB8NB2O/Nbc85GnaVI6fSQnwicdfmSIN5kR1+C8p1MczVy54G4Ac/9yPepT5PRXohwuPbGqhqx12tPgpBh3dxUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com; spf=pass smtp.mailfrom=aaazen.com; arc=none smtp.client-ip=99.33.87.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaazen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaazen.com
Received: from localhost (localhost [127.0.0.1])
	by thursday.test (OpenSMTPD) with ESMTP id 2073dec1;
	Sat, 17 Oct 2026 16:03:41 -0700 (PDT)
Date: Sat, 17 Oct 2026 16:03:41 -0700 (PDT)
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
Subject: Re: [PATCH 6.12 000/869] 6.12.114-rc1 review
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
Message-ID: <80638f58-feec-d741-a5ad-b865133f20b8@aaazen.com>
References: <20261017160036.979869304@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sat, 17 Oct 2026, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.12.114 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 19 Oct 2026 15:59:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.>
> -------------

Tested on AMD64 12-core and 4-core systems
and    on Intel x86-64 4-core and x86 1-core systems

Tested-by: Richard Narron <richard@aaazen.com>

