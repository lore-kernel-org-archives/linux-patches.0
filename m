Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B131C6FE9
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752617800; cv=none; b=nbxz8q4ElgkBM/H+KkYI8k6+75mp7IhubysHVGfzHdlwmB/hzCBBriO2h9kdAiIc/BJIJrWNIUsr2HfomNgyG3bgE8DR8RM4c8IcAu5HhXk81BK18L/0xnYNE1nIRWCszCFCzGhkVRaadO+QVuIu5rKYhlI+jw/lRtE2qY8/3Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752617800; c=relaxed/simple;
	bh=NDKijB756KRCojBHCczogSV0ALKNJPhNjqneQFx7dB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuYZNJk6Vqo0xRLLI/6HZDOW2x2OzrjWxNdkPo6YQrZqgVh3i+CeOF/DpLXK3gP1o5K4T/fCBRUGVT7neUYZG6CkevmkIuERU6WA/e72QHPo+zp6fL1B0eo66mokIr+/BAPxSOam6fxSF8xRuadqihL4hgwgXv4N4QotpuRGkkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=ayvFkGj1; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="ayvFkGj1"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id BD92B14C2D3;
	Wed, 16 Jul 2025 00:07:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1752617226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fcicRAVTosrwNetBK/+Wxhodz+er90LBLPeuYSMkH7k=;
	b=ayvFkGj182aOJCmmvm5xRZwkgfjdvjxjt4ogIEExZHQhbDT0jouQNaCr1omtgjppIr4U0G
	A0QbUpt2Ws5KVtnMeI8YqvMCf2jIKH4j4s8IzuY9iUd4+FmoTn4AuF0BC7YtNJUHnZUeJp
	xcByGnqoOsLibsCVw9O5Q4Dv7gZ1ZNUC5g9HXIMmSiG7QOSItv5XrngxEs44sqYDK2B75K
	jPxhlmJQopoRRcY2twc3doHL9k0fmTd2sSBiRiFJ0AqPR08W+D8rP1s5da1W6w4PBgSphI
	DsiD4e3EW+BNWRWamA9/WHTzx3nKMS0YTwQf12OKq4Xz8+UbuZkkeqD8z3PidQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 140a1308;
	Tue, 15 Jul 2025 22:07:00 +0000 (UTC)
Date: Wed, 16 Jul 2025 07:06:45 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/209] 5.10.240-rc3 review
Message-ID: <aHbQ9VB2OvHcVd15@codewreck.org>
References: <20250715163613.640534312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250715163613.640534312@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Jul 15, 2025 at 06:36:46PM +0200:
> This is the start of the stable review cycle for the 5.10.240 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.240-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 2067ea3274d0 ("Linux 5.10.240-rc3") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
