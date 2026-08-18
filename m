Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8985372EFF
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 05:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787031560; cv=none; b=RbjUIwv+6BpRDbXtO5L4kPXWrX3IzTLUVU8Ho7gj7gH4/HqUqi0OQA6k6IBfdSnUo7INctJDASXhnTb8ILudRoc+PcIghfMrk9EQcYOZcVSBo6D6KaUKo3LC50cR3TOj9F6XLO6VAH20droWZBBpmhk8+tDEGt/LrXmJb46+KEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787031560; c=relaxed/simple;
	bh=w9AWz/L+Ay7WDJYVxm2VgEb4lYJ+CaXIz+Z/2pB6scU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjK1TcrCZDKyzGtE8sSTow9BseUd/difszTDITcW1LFlULi+yEybxvA/Qj1i/mWcQXWdPnQNsCcd0q+HC3vVf/M2XObXn+jJo529oVJnMpUM8qn0+yhRWJiB0g+WvP+RHGGPfNdsW3o7GsKy93hV/b6ttHWN8pr+kw+oULd513g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=CNvDPITe; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="CNvDPITe"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 5695F14C2D6;
	Tue, 18 Aug 2026 07:39:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1787031556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyZnop0TClizu1fxSfZ3shV5T2YvL0K5VlfvhM1iwso=;
	b=CNvDPITeRbo0gMbgcNmZx4Zug50ZBsj5qi/Mjj2c3NgSKpCXdg6FiAE/Jke22t1wOW5DKC
	oHiwzKRQzpImNckcqlH2vyMjM8ZtvqWv0fcribt0/S2FgQDoeGOE0ltGn/qh6TXn83kGFv
	TXJ2pWV/LeGJBRIeqMP9I55Da39QVU4mcDRVBXtoSevEZCJkaLsW3slOK+QLRtrypFFQ9o
	IXtKU6IBrhAeLg3vB9APQ6e88HtrVBtY10ATpy7CwEOh3tS2htEsmbzKdOg7ZN8mRM9Ng0
	e+mONDNbNTvChL3fgeyqEzLyqSk9uUVnM9tYuMp5jxzlL8qe4CLW/D0m0/5qiA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id f487bb2f;
	Tue, 18 Aug 2026 05:39:09 +0000 (UTC)
Date: Tue, 18 Aug 2026 14:38:54 +0900
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
Subject: Re: [PATCH 6.12 000/181] 6.12.104-rc1 review
Message-ID: <aoPv7m5lnm9gO4c0@codewreck.org>
References: <20260817132535.394764707@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Aug 17, 2026 at 03:31:34PM +0200:
> This is the start of the stable review cycle for the 6.12.104 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 98c5a5b9f23e ("Linux 6.12.104-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
