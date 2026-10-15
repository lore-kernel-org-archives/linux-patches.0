Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0644845C6FD
	for <patches@lists.linux.dev>; Thu, 15 Oct 2026 06:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792045915; cv=none; b=Pgy3596N3mSScbRUmLMMZzYF/6hRUCeM1ynpjuvKil9LVD8nkJNwsbuibuW0wZEb1m3CA9PSZr32d1kR8fr6IGeRVyoHOvyiCkUDbk8N1FQ4LdQsNHweCAlah1V7n0QAjTmIjpGFLnV6MaFuQUUY7BX/ItBemyrjbIro4riZ+Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792045915; c=relaxed/simple;
	bh=AMNe4pAQnuFm1VbGb7njHfZH8CUQZVRe0MygYY3fnnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FsLCP+YXUYbbHtxpwYaZ+t7u46uTBOaorHJ2qVeuQYN46YcaW7w2OJO3Vjrumb+K6YUY1ePpXLAP1IpyHDNM8ME1pavkEMvC68U4serNQU9ppd5mB87EMQWAOSDgcOWfiFEiyKLma3HFyTdaLlHHHaN/xZSYl6R48c1RE8vVo8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=V/c2G73d; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="V/c2G73d"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 4DE9B14C2D6;
	Thu, 15 Oct 2026 08:31:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1792045901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMM1hyvQ7IECorDJyxaoZ1ePg+umKGhAYhAXl/7UtB8=;
	b=V/c2G73dJiqXzAtEgo5wOgnnLQ0024HCa63fQl5kh6ExGSnmI5BT6ff5fNC806S11tr7A0
	EYg+XvkghIR5y5XL9PieW5DRbJnaktheW1whHgitD8cBrXmSrbTOio8HZtWT1JCQmqVRWh
	nBJsZClxckHU/Yz5+ZzWyy+Xn7BU55cGK9sqscZWcuAAVh8PX5TsgoWKcaCOQIpTJtR8Rp
	vcP4c8wm5P5tF0fJxh0B9Ib7cYCwd30BlgkE+dxT0DFcYuCgqV2b5akFcWGixF08HKav8l
	1yexDBwZdUP2O74peIwcdjjLljdpqaGUckpC0An1M7IQLdZDsne9X9llhlG6Pw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 532a53bb;
	Thu, 15 Oct 2026 06:31:34 +0000 (UTC)
Date: Thu, 15 Oct 2026 15:31:19 +0900
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
Subject: Re: [PATCH 6.12 000/505] 6.12.113-rc2 review
Message-ID: <atBzN6pabpCTiCnb@codewreck.org>
References: <20261014123803.944920639@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261014123803.944920639@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Oct 14, 2026 at 02:50:30PM +0200:
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 505 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Oct 2026 12:37:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 4a8beb0f1e36 ("Linux 6.12.113-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
