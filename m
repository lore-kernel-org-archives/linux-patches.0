Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407B333D515
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 02:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772503435; cv=none; b=liuVWrmH4bxN3gG1JHQH2HG1yTiJHYqsj9d9cfzE9R2i60s9aiLTfAfjIr0BjmEsXgxZXTW0+zDE/cTk9gSkwCz9OgWUESkLRFY8FMvzK7bBI7DX1biv73SkMOeJodH2kyxZr0U7a516YcHv3SI5R6rLKDHh5JWjMIJ4P/XzrUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772503435; c=relaxed/simple;
	bh=l9YeKE+tSpoPHLxfoVgpuKL9el5j5bmjT/Dhn83z+JU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1ldIGemkQxgcKnSbdGtnfKjtsRD/RL/Id3qZYchg8qtlDFxthr7dRB9yB5gEeekwOD/7x+tw6x78XHOQICFGZ+fx+aalvB6HOMTte7pBpj0IILHX1q3LamXGIJVZNkwSbB7rHIXOwGPWmyCSjE/HSyQ8T6FlsBMtF/TN8pP6l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=V5ieEVKM; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="V5ieEVKM"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 0287D14C2D6;
	Tue,  3 Mar 2026 03:03:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1772503430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VIu1Aq1ylpHIfvNHfnHRw9A2irl/Pi9ELu3L01EXW0E=;
	b=V5ieEVKM0Z0Q+HEdZAZ5Ic17pyj1Yc/JDRjaiVTdUMdS9KoBQCuXXa0tdGCa6KTFY/tvEx
	hDW5LLag0IX1NzFAAvnwFmkObFttM/XdhTV82trN3A3ZKwiA02FgSVzWnfmrhuenUKcd6U
	NRJ76wWYvkEVnMXwMV/cnkeVCgPmH/o1C/xOp68Qh53H7r6aGjzs2vrN3gKODuBR75KLDt
	mYe7RzVry3Ykj1rmOb6q8mLtboN74uAbSpzg1x5LPRxrjX0usy28Hu/6ypX1kVZmZxG8jx
	dYkYN88AO5yP7QFCAWry1LfFJ3d+8d87huW/Htetfb2CeuDilARu3woXBqyL6Q==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 1ab5a8ae;
	Tue, 3 Mar 2026 02:03:43 +0000 (UTC)
Date: Tue, 3 Mar 2026 11:03:28 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Message-ID: <aaZBcFsVo7PZv4_V@codewreck.org>
References: <20260302160918.2520730-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>

Sasha Levin wrote on Mon, Mar 02, 2026 at 11:09:18AM -0500:
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response

That's a bit more patches than rc1 (thanks Barry K. Nathan for noticing)


> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 191be03a0d8a ("Linux 6.12.75-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
