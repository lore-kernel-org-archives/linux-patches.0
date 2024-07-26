Received: from submarine.notk.org (62-210-214-84.rev.poneytelecom.eu [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDA97F8
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 04:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721967573; cv=none; b=N/GhG/qHMhitHGslaig17I4cO+xIsL3+tZ3YBarqbrsVps+w0suLjVQLrpfS15K6d5a5bhX6iMML1CumOBQxPgSFCpSSOlRfSd0CwNMlxKb5pIy0kL4qKGa8b9EpljfS9fQazoxglHJz9yid0P8ckIj4dyE2QmY42Mo00yU8QFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721967573; c=relaxed/simple;
	bh=DO1EDwLhY63dBzoSf7MglNBD9v+FDTsivLy74L+VaXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eoRCcliftHDVfOGTjaajtAOpyyui7+Ni+DtfSo8XYlnwxOtxreTcC/p09hWz2UAYWsx1WbVFpM4qQ+KWN5F30JIqUJ6GGrC5q2zgqA9vHeO4gLezqhia8nsMn+gEDgkp0h+V4CWlPOFkane45ywiwEqtv15UFXsFla3PP0o06Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=Wi7zZicm; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="Wi7zZicm"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id EB78A14C1E1;
	Fri, 26 Jul 2024 06:19:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1721967562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UnHwluXWER7pky+J5vaSuo31e7j2mzedBLUl5ORZUdc=;
	b=Wi7zZicmrJmVShphEcyxtEv/5A3cZCeP7BvNwZsTgfD72AunpOJqaw+qATiYWKOm5SbiAa
	ibyIBeU85h8qIa7SnNcYVaHjQjrB1u0UFNjtUE+fGMphs+wEHXhWrH+D7G+pxxwFCjmkHA
	0RSMC8vB7AuBmiF2AerQUz9lB/ZeBgN5fQiJFpM+jJEegKsW1Nm6e0skbLxftTIlaqdLw1
	z3n+KRyjueHUeF3A0odolw54Ulz9nSKKv73iNttX+D1dyB63NIwvvsHx7YdsxbRE3pCQn6
	0oLXVl5PRswt2pCN6xmEyipvjBdpYFAFsO8vrJoSOlx80X7h6NC9NugV+pSmZg==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 61e0a272;
	Fri, 26 Jul 2024 04:19:15 +0000 (UTC)
Date: Fri, 26 Jul 2024 13:19:00 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 00/59] 5.10.223-rc1 review
Message-ID: <ZqMjtG5lTockv-x6@codewreck.org>
References: <20240725142733.262322603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, Jul 25, 2024 at 04:36:50PM +0200:
> This is the start of the stable review cycle for the 5.10.223 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.223-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 0f0134bb137e ("Linux 5.10.223-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
