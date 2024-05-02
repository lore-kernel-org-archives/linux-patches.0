Received: from submarine.notk.org (62-210-214-84.rev.poneytelecom.eu [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62672101E6
	for <patches@lists.linux.dev>; Thu,  2 May 2024 04:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714623437; cv=none; b=FOqzvPF5ZZhpdbr4CgUtUxPhOxgVnjIFtDvsMiz7cilN0599W3SsadE/TF+crtHRSVnwFMmdkU4MlE8XflTdPcPBBjHGkppc0MdZG1ewGhQae1NcmTYRZyqOhybPiGGJk1wZYv/uvCPmzGH0l4Avpv18JG3i0Jc6GWyP2ikdgHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714623437; c=relaxed/simple;
	bh=7enw3TgrUm6s1q6EZ76vT8AArzxFfakAenWWCecpFYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kpy7USsHIHYnUlpA7dqGkWtPJs94ZcgtE6wF24fwwj3gQ2Gjn78AbC8bTjaKEMdV5i91IDXl18cO80BrFNTcA9GvAEklBoA1O/ul7HLPyFPosx1JgiuGMCJfHuVXa6aHQ+sAvI4VmCfIK1kaQ6tPDnamUeXAxEcMgevDlex/Nsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=03sbbkhy; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="03sbbkhy"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id EFEC914C2D7;
	Thu,  2 May 2024 06:07:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1714622866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BxhnbEMYdyo/gkIHwPCI1uVhemd0gHqCGSpwgksrIhI=;
	b=03sbbkhykEwud2norN4uGRYUoA+b56S9cYeINdD42BsbsnbTcPFV3h5GFCrfoNAwnLx6qz
	1w9cJPEtKp99DY4mbQPTF5HOs5dYgIaktPIh/f2NFm/AUOuJXfFM1T8z8WJBCyq9HASwDb
	hJ1tS3hnoyKU/IcGc7D/88gv8XnwPBMem0tt4i0YbFfFR1sacjIWd4sDlFo23CFFX53pOo
	i+QmKKf58hfjbLSQsT2oMvGUCVf1SWrs1favInf0DISRkqo8FKKQ5dWnVOOWiLA77/bTDf
	cjyOGT1KcpXS78VvtUius/sGYPXf/DmKkW+TCcJVy2oodmg65epkiNc64D4VkQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 3e3ea492;
	Thu, 2 May 2024 04:07:36 +0000 (UTC)
Date: Thu, 2 May 2024 13:07:21 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/137] 5.10.216-rc2 review
Message-ID: <ZjMReaMNjx8WJSsW@codewreck.org>
References: <20240430134024.771744897@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240430134024.771744897@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Apr 30, 2024 at 03:43:17PM +0200:
> This is the start of the stable review cycle for the 5.10.216 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 13:40:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.216-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 4d39cb0f1c9c ("Linux 5.10.216-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

> Daisuke Mizobuchi <mizo@atmark-techno.com>
>     mailbox: imx: fix suspend failue

Sorry I didn't check after you replied, the commit message seems to
mostly have been updated to v2 but the 'failure' in the summary is still
'failue'.
That doesn't overly matter, so feel free to keep it that way if you want
to keep commits as they are.

-- 
Dominique Martinet | Asmadeus
