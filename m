Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54C8265CD9
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 03:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780285005; cv=none; b=Q7Zu4lHufEf6e0WjugwWSLAeTLOyBkRVX+NZaaK81GKAkyngPdx8bgAqxqlf3RuOPRyBukwomYXV7zoJJsRAPG5rkSeAMveMZaYlAae72xHjNsqS3rDKYgXfHVRHbh6pJJ2tCu7F7xUrE/CmRVAgg5UhHIJBY8vm6Rg+IDjmv3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780285005; c=relaxed/simple;
	bh=BI9tI918GfzIZSRsUdqAB8+iapy2l9qK0mRkNsU+fhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/Wi+jQMrrcp/cOoK/eHdxAC/0oKUUDSs9QZsJXUDaqIPB9e6ughxlVPZ5H7y90AewxRSu4CxWsW3TOtMwKlV/RlE1kIkPAVlVJOSP0cEciYxFZyhLOnNGErGyIczuOigZVWuV8lBrQTaCfLkaLaTEbyFzbgW5qhQux4Woc8Ego=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=hHDQyNG/; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="hHDQyNG/"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 2367014C2D6;
	Mon,  1 Jun 2026 05:36:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1780284995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LISSrtzA05F3JkeZ9vD+SSIOhByZOvSq9XHTmt/ltr4=;
	b=hHDQyNG/VsAkALfCA0zGrp2tsbaqZ3UMedgfpXTevkzIe5vKVyTbBOQmca8ErFtDn2+d1Z
	iC93JejHHn8WvJmEnYfxPkclLv8+4jzNHbXMaHW4+zs6sJH+OMCVyS885nXX5CjTiy+0eR
	/S8wyurUy8cmKqvgqGXg354J4hOsbvwdsHjd8ydDcyeE1CvKKOcggE5wau6uxv9s6dJF6i
	HyUHwJz1w0jcgHQUBLOzoc/Jy0ZoC39zdnudlBmS4Ie69DPwmrvn//8GvHlPz/3SgBw3/t
	Z3hbx4brSBhqxB0Du4Xdxqv8HSCn0j0sjMOB0Jl0llX3vSin+n/yfc/jakfDkA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 90bf2db0;
	Mon, 1 Jun 2026 03:36:28 +0000 (UTC)
Date: Mon, 1 Jun 2026 12:36:13 +0900
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
Subject: Re: [PATCH 5.10 000/589] 5.10.258-rc1 review
Message-ID: <ahz-LRETxhw5zg_V@codewreck.org>
References: <20260530160224.570625122@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>

Greg Kroah-Hartman wrote on Sat, May 30, 2026 at 05:58:01PM +0200:
> This is the start of the stable review cycle for the 5.10.258 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 01 Jun 2026 16:01:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.258-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 01c1356f563d ("Linux 5.10.258-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
