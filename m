Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAA52848A8
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 04:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781668861; cv=none; b=V1TyLrRTVacWoh3qe3xKIb7XPqXB/YXAyVXpaLbzzE2F2jAFzZnUYEBCtOhpdtaV26sNtrawTCssd6jcRTgtg9hjs5qIM271SVyn/dWZ45LHoBc6DalHW09kjm3FqVpzsx5hWZsYZR3yHE8F/xUaWxxxkJtRm3k8rR+yTzVrRt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781668861; c=relaxed/simple;
	bh=cxOCUZbDOT8G/Kngv8/WvXt1UV84M48Tv7s6i+vxOI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmKY3ydsXeYEw0b8xkuj1/gdyQILpXnLs0HN94wvYFciH4UBAjLX1CIRS5mUOZy6XvFBKcgadCK1CxrRXUXlw0wVasaBuOza7E0kCouDFePqKvnEk2u7fnAcbYrWKX7rpjyt6Pna46Hzje5zuUMiG1ec7CK7Oz29cJuPGI4OkZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=Y41uKrsk; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="Y41uKrsk"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id F2B0D14C2DE;
	Wed, 17 Jun 2026 06:00:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1781668857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5R6ymwqWGgy12UDCyHqBtmTyEn6aeMRHMhJPffZ+ADM=;
	b=Y41uKrskjWxJuo6/+HNWm8dk92SfAHhpw39Qtjj4OFEENsroV/z3I+j/tptWDCdFh4X6Iv
	5j4CM2cIJWCO8mZjTi4HgkBzKbLInotbjx78hJwajkMlAyGp96o5gJG8O5AjRv4q0qkQYb
	cAr2kVt0DVIyT6Pw5KU3P6IMbPUkADjq89vS/yWpk8HuPpHd52WlLUw6XAREqWGeShILe4
	2sj806NQTSlrfQ/n6mj1DGg3QQ721Tc8OQvAnbkcOSNW31SFzllxSrJt+ktutUWWyG01F5
	FvmI5iAMCUUfErKHSnFV4jYKiH6rJMLOpbYal0w9Qr1HiLy8oxML4b7V6sjnxw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 79a3f5aa;
	Wed, 17 Jun 2026 04:00:50 +0000 (UTC)
Date: Wed, 17 Jun 2026 13:00:35 +0900
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
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
Message-ID: <ajIb4_3IdTM8VA2I@codewreck.org>
References: <20260616145044.869532709@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Jun 16, 2026 at 08:27:18PM +0530:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 32a7ec09e340 ("Linux 6.12.94-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
