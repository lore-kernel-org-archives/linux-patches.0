Received: from submarine.notk.org (62-210-214-84.rev.poneytelecom.eu [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEBB19007E
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 08:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718354290; cv=none; b=sqDRsT4TuIzQyK/zxTDfYGSIes/a37YWjpd1myHSmdG3xpV/tx8aQb13oarqApJx7Db3zof+/rbJh8iQbbN+QccyLxxVr9lM6cr7R4Gr6aY5OItlScY7B129fHq5fivxExzfRwWDjWBXAWiMZ4U5dzc9kRL66RftxMEED0Jxqes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718354290; c=relaxed/simple;
	bh=6QqwUINZwrYIdITWIBtpBk2qJO2319v2hxiHhZiXk5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uP9G9eSGGb82IAOvIf0Q0ryeMXHMcFPP88N5RJwKiHwut91ZqY/yY1L4EpN0HLrwl1KHuDHo6VZ046hyRgZc31K0LMA3BIMLNzAHFZqcMeT7Lcs1ugmP4GkYs0k8xb5V3pkeFmU0mFfSSsC63ebGjThKrGesFNib9CK20Rg3zLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=wqmcqBgR; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="wqmcqBgR"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 23DBC14C1E1;
	Fri, 14 Jun 2024 10:37:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1718354280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dzytT4OTAPYYW6m/eVOiV+9/isR+EfC8guGdMV3QHtQ=;
	b=wqmcqBgRPTtVLHA9EsnvT3Dc+kYnUrS17ArNJuQh9LwEh7GaogVQlE5qChrkhKmgc0FGzi
	Jy0vOuO5RCrQ+pZzm/G7ji9TYvKvQxylvKWjD5HZsKF5w1JD0oALKspX7Xvd/4kR3cjL4F
	cXF8SpBXcrBCSGG1Lqyafu7TS82pskwlxJU9aJQ8mbIxOYInXutcNhfSVTG3fXU3ybY/nc
	BwJNgWrxJukQ9x/ExTpYO7ZMnqDTEToClvCyi1YyPFo/wHgIwnxw1p/RdEAtuaQ+r8hE79
	+/GpY56BJBhO28XBndA2QAsvNVWGMNaN0VdvEqWJFlj0HBB7fkj1mJRbU6++Vw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id b9898663;
	Fri, 14 Jun 2024 08:37:50 +0000 (UTC)
Date: Fri, 14 Jun 2024 17:37:35 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/317] 5.10.219-rc1 review
Message-ID: <ZmwBTwSgfoQSlOGG@codewreck.org>
References: <20240613113247.525431100@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, Jun 13, 2024 at 01:30:18PM +0200:
> This is the start of the stable review cycle for the 5.10.219 release.
> There are 317 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.219-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

(There will likely be a rc2 for riscv/ppc, but..)

Tested 853b71b570fb ("Linux 5.10.219-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

--
Dominique Martinet | Asmadeus
