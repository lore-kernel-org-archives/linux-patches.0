Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB18F36D51F
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 02:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784687538; cv=none; b=YPy0EtlHxOop7vhKa1tNAY5/I73ae+UO1vqXe1uQmsX7JoCLnZDxSkSu0k9syvzDGncWo7px2fsg3xG/JuJ0gBC3r7RUJnGJj4n5u7Eg+n1HEvaWcUv+6ZreDHAjcEA0pVrZgA/H6gWby+4U7JHqXn/Eehe9xt/zUJ/OM19W5fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784687538; c=relaxed/simple;
	bh=beWpPKKUZ48M/vLtKzqI+MzHBG2GRs+Y7sSkkFuwkoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cm9acSh2GLYEIjMJx4ObaWQ4IquJ35PCZFoYMpYcRZynB7Bc56eBPfqXyigUmxjQBEmAbuP/LFUzRW9Jy4YLm42BUpJWGJD+z2dgEso2feR1Phknbiu2+pZSjAxjnFq/2XyyPr1XQ2RnJV+hQe7fjNI4TB0tARm6wvBlfXwZUYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=i5IHumqN; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="i5IHumqN"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 8382C14C2D6;
	Wed, 22 Jul 2026 04:32:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1784687527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P0vjyyt1E4Uo/LIC92EJG4tT0yIneBibbqYRFycfh/8=;
	b=i5IHumqNXksSkatEF8LYaObsnqyxlMN+WLZm+RIlpBQZ6ZjVSKZB9g6S4Gl70x98llXwBP
	f/wXbTXXVyG3E+8N+/XutemnANN2jD7sASzn2no6OW73frHLjJlU7/LQqY9++Z+dJhfqXR
	IkYjOu7BU1T8PMOqAUpNB3XVEFwsPr6oSdgpNRO9CxO8J2PXC8k7sOFZzj/o8ZpmAjhwrF
	MHuWI7FbXncQPabP2VpB2R77L0LRqfOfuB013bP6UZUUsAQrjtpAKuP/RrybXfMurSvjzl
	awDYFw4dDooIc3QswdEn3O2veIrP0BQCHAzk5/xQuh/dsFY7nrhaM55VQSeEsA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id d7e7028a;
	Wed, 22 Jul 2026 02:32:00 +0000 (UTC)
Date: Wed, 22 Jul 2026 11:31:45 +0900
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
Subject: Re: [PATCH 5.10 000/699] 5.10.261-rc1 review
Message-ID: <amArkaHdBADQJ7IE@codewreck.org>
References: <20260721152355.667394603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Jul 21, 2026 at 05:15:59PM +0200:
> This is the start of the stable review cycle for the 5.10.261 release.
> There are 699 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 9067606e05eb ("Linux 5.10.261-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
