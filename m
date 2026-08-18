Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAB63659FB
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 05:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787031528; cv=none; b=jUDOo++VWb0UfMW8dr9EjaTTvxTna1wDPcUfuKvvMSOMQopd+u0adAJ0hxJpSAMjfr4R0/JRFNHk+UBmm9Me6j+pFHajb3UNCtZ7arXdEqmgYftKjEQ/0YsQYt58EoKX3+Ww1ppBGHFMPE8jX5UkjFTiUJkAF2kWo9yZhpJGyXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787031528; c=relaxed/simple;
	bh=mcWFfh8wV8ycRWjFP2CJ0Invr3bPeIynf1T9KCcJiDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2mhyUb6cyWB1Ur+2Rp/d0vpftaopgjmWK+RL9JelIaoATq/Ak+H2QcOXLfPph3FoxG9AqPGQD3meMZ1Hv6w9mH+SqazA0GCO5Px2Q3wmuQufjP4E8FzTGldF4tKn0JD6Jew48JfEVgec3a0vO2fsMNuD+BBEZOi83JUOuHrDss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=DKIIbUbr; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="DKIIbUbr"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id DB77414C2D6;
	Tue, 18 Aug 2026 07:38:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1787031516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IC0PduZyth+zapCBXBkEHi7YPpQZTEHKlI0IiV6l/Kc=;
	b=DKIIbUbruhSpKQb3D6HH0j+8ML4+oSCNQZVAEyMEteiju2YeRVZKpvEuCIsW5pe1BUCicE
	mNFh68uxGI/St4ZqYTK1Hd1jWH+TF1p44u8WDj3fj304jjzpfRb9cOZ+jU8dVmcFhkQSBr
	3TSdcbb0p7gGFLRBEfbyzOvo4X5UG9WAjxKge0vADM16m7pzaNxRpIFkBQ4TWdSJryc6DI
	sMyXO5Wzi2hncZ7pFKXweYruVreZJwgYfck4TQH497VTr2IX6Op4hq39iBg/EOlIQbs68V
	RbegLmvz+XSi/EUF+kgHl02hvMLUbi8It7jBKPRh518ampfNNxENiN11dVG6oA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 87ed9f91;
	Tue, 18 Aug 2026 05:38:29 +0000 (UTC)
Date: Tue, 18 Aug 2026 14:38:14 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/389] 5.10.265-rc1 review
Message-ID: <aoPvxs2gbXtb7-i6@codewreck.org>
References: <20260817132538.796021292@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Aug 17, 2026 at 03:27:19PM +0200:
> This is the start of the stable review cycle for the 5.10.265 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.265-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested d2f1aa5b909d ("Linux 5.10.265-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
