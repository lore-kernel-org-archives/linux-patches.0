Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB61814EC73
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756861012; cv=none; b=gv1o9M52tSrKlnrGKYnN/tAc0wezHiYo2anpX+Ec6o+PYANc4YbyH7t1TA0RlhMmmn67ZINkxA55KFaj5dT0+tL2kvrXKSdoMXcZwhn09HCy6LYfjmRf9zkz4N/GY9OjB0KvZzSpB+Lm8xZVFdx8T89lKMLRV+rZO3ZIvli6TF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756861012; c=relaxed/simple;
	bh=bnb/FeqKjRBg/dUuYxe+++vOPnfmLozx+PfvJ8Pfgrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GgaQpkVKGJig6pS3TPX0Yfw6KCLT225PFB2Z2xJln1RDup/UfqitNb0xhHJPgELUUnxfNGHWf9XionolULOnTZUpARXzk4cK6kZvhSLRBN6QZMl3YyueF3OzfpfBUAX0jjFcOtGkwXcPN2k2f4JFPlJnU8IBAFzTM9usSWXsYSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=XWVeHrDN; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="XWVeHrDN"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id E79B314C2D3;
	Wed,  3 Sep 2025 02:47:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1756860461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6hO7SAVNKzoGbYPMDy6Hdq3lygn8k+Jvik7fXD5P2VM=;
	b=XWVeHrDNp7liqYozzaAlDcFXHQt3zmBHMLesSF+uHxGIC10FNabO/JWtTUsCCls1xSpTeL
	9J8M/wzzvPchU1F7xHGAoTL4uxSzAZAofZaco++8FMl+e33DjHPUPntV+pRIi1kHJ9WOSp
	jQCtqrCOCyyETr4VI2WIPPmogJvGRhtyS4qNsbapxJ353njXROg444IBA9X2ssBRKBM6Ww
	sWfIneXYlQ8xTQy9Y64kFyA0H0rN7NQShMKBf5QL7j+pwjaJQmbzMfOV35Ew8Zy4edWmzs
	veXIoY/e4IVls7gqech+B0O8V9Us2GnQ4PcTAwHgk3AfIa0lXCgJu6EgkleSMQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id e25afc31;
	Wed, 3 Sep 2025 00:47:34 +0000 (UTC)
Date: Wed, 3 Sep 2025 09:47:19 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 5.10 00/34] 5.10.242-rc1 review
Message-ID: <aLeQF3gYiQKyaPsY@codewreck.org>
References: <20250902131926.607219059@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Sep 02, 2025 at 03:21:26PM +0200:
> This is the start of the stable review cycle for the 5.10.242 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.242-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 4576ee67df7a ("Linux 5.10.242-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
