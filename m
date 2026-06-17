Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD752848A8
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 04:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781668845; cv=none; b=uJZoEeAuSZ2ys4qTi3tY15HovX0kyXso/97e17c7AHNY09LKNPyMB3AF5n1K8of+dhJOYUFanOxVatng0qscuHOwCCIc7cm8Ysb8OEX5uhnyvzRzWs/oANvirrGu7QHaWExCa88XSM0gxGPWIhZPaGriSL5jEbYjNHxl3JNBBzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781668845; c=relaxed/simple;
	bh=+K1EOIXkhsOaF8sRkIdNEy65NlrlyeVce0zaoFdwb3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJ/vHnRxjzT8coX/32iGtI03097Mw1ZR38nL/gpgeRaLvY4I8uXfrO6Jf/k3i7b8YNXnpjdOCn61WP0x8og3LfG0kH9LVbatWVnWmHpA8MvZ8+zhPfhEjg1qdler5gRkVPpipMNTvGQ8pQdJ10PIHfUCiAa+RbUBO5oqf9QlnK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=0INKJmce; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="0INKJmce"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 0FAE614C2D6;
	Wed, 17 Jun 2026 06:00:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1781668834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEwdHMEss5+Rh53PMrDNjWUCJC3pKW8+7VEASOQsx+M=;
	b=0INKJmce/HnmR3qHZN8PYxjfmRMzoiDRvRsfnSc2AKppPzyoCzJCZyCB2JOxfDp5//A7Jx
	pcOW+2IJjsp6OmxoTBx6v3ANcJQe3sIwq5IZfeCzSANOeIKpBqgCZHRL0/Uu3obQSPHB0Q
	JMJx4HBVTk5wsZgZe+ZjOhghloKmO6MnqNAeVIIH5M+1+tDxDmVw52YUL/cHYCnFAoLmy4
	hKB4616MtGPlMjToIKN32TlzYkZeJr2pKZiTyKmX63poUFNJF2KX4Hzk8Q6PVeiPfkrMIY
	Y+9BXfh3sEII/5KtWpCDT521hA4hQ8OYFvnRSqLRRT4pOFtFT3+JgOEb+kATdQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id a125cda4;
	Wed, 17 Jun 2026 04:00:27 +0000 (UTC)
Date: Wed, 17 Jun 2026 13:00:12 +0900
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
Subject: Re: [PATCH 5.10 000/342] 5.10.259-rc1 review
Message-ID: <ajIbzAmnzOk5vsjB@codewreck.org>
References: <20260616145048.348037099@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Jun 16, 2026 at 08:24:56PM +0530:
> This is the start of the stable review cycle for the 5.10.259 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.259-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested b93100fe2cc0 ("Linux 5.10.259-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
