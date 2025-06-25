Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873E0263C90
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 08:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750840079; cv=none; b=NZn5PdjUE6X2uPx7y/mDyYa7Qwb/ZHsAXYuj2f/TpWqkWcn0uJC1/8XBDmq9/zb9FPDpHa027BJ7kdJGqZjJnK64LzTEOFiSbvn9/gXxwILzmvLV/wEmuqbh4CRA7+PCfCmgnhMPMN76Cd7bdId1kUKrFRD2yLtiiOK0Bmn/GF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750840079; c=relaxed/simple;
	bh=tFRL6sdurF5C0oF05Wkk5ZCUtUZzrnnHgrfd/+IUM3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzYNhIAxsKvgb3coeWVyaZC7H66xWDi9fKGF/0y12pDLtqH4RyuoAH+B/jMtokgwsqJkqbIgrU2D4ZPR5W/Yb2Yriv2/OmFJi68wye85pAfY+56OUBuZlhWxEs0ltjwEWfjLlhgoArDPfas6DjL1plUTZ9KbMYSRgfqdAZ2FrFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=Bn1zpG0d; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="Bn1zpG0d"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 13E5A14C2D3;
	Wed, 25 Jun 2025 10:27:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1750840068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M7MBda3ifyG4jp7mOkjP/Pm966Gi86mycz9M1yI2mNc=;
	b=Bn1zpG0d0TEoLqEscnCtADjX6ukY5s8GVqwl1HB4lH7+XwbHkwitjyZxBR1+2MVTIgGkI5
	a3EpquCcp8HsEEAfVmtGlEOoSfP6WQDMprf8YxNO3+aON98bMEnLTXDctDULMO4PvheqBk
	RcGP0ZrFMWNt0ll1R7x3GZbYFjaoiX7JuuEVMifoVJzdJsBcgokzNKJNGdrUKe5OMn+60c
	BIJ1rj728L+9ClIXX1wWAfujx1ydzEEhKcoaWNuUfmf6EbxKB1AEYNAoFj5Wfdol5+cJr8
	AAPzP+TWiZVLyjKJvUy2REorrm+I/fpI487Hg+ko1bogTRHQ5zVw6vcrkCOQXQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 38d76608;
	Wed, 25 Jun 2025 08:27:41 +0000 (UTC)
Date: Wed, 25 Jun 2025 17:27:26 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/352] 5.10.239-rc2 review
Message-ID: <aFuy7qm1rv3tAUka@codewreck.org>
References: <20250624121412.352317604@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250624121412.352317604@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Jun 24, 2025 at 01:28:53PM +0100:
> This is the start of the stable review cycle for the 5.10.239 release.
> There are 352 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.239-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 9dc843c66f6f ("Linux 5.10.239-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
