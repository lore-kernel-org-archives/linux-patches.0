Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF32848F83D
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 13:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788613947; cv=none; b=hchYV1uFTX8577Um/6/KjF++nhRRuH1ilPUs+r6kBKm4QJ9DYYt885M3xNI93wususYjb0EqWnVkQyas5K+4QreJ3/6UXg3ZE8OcjCb7F0EjR42UB+ntFyqiRHfKRmq+JvTqF30L2i+rf47dgJqQcASYSAS6UxHeC9Lc+u2bI5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788613947; c=relaxed/simple;
	bh=kwnn4sTn5Cldf97vXKcWVbajykhsC8F2JoDmZcdt/qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBQmwQYRwCH5g4lW8ZTrZ/Np+w4q0155fdFxBi5loMorhsUBb6UXQdd165MDtLoFh+ctEUUJw+dEWacl5H2LkEeph12jMYqx1IAZNJUNi0p8wxFwpWdhb2pOVfE5kQRyKdHVc3gjHuuN/BfnNAxvVyaNXUA0JOkgJjRvykjo2VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=0H1Uw4kN; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="0H1Uw4kN"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id C93D014C2D6;
	Sat,  5 Sep 2026 15:12:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1788613926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XyRsdovRMHItf9aJpZnZs9bfEU5mmrwrvk6U3SiUwDo=;
	b=0H1Uw4kNgxLw+P6exrsqFw2rqBbhHn8fLTtZ5i5g4WXUcVud5Vag2149nby6RowfBwyQ9i
	802mjHJgv6XAdQSoHhAKxrmaeMrI2GgmNL7YPGHcscGgXksgNv9FQUYRn04FJPJS+GtSxD
	BKTBklK/bcXVY/3SdCS/A/6evmvMBq/rLP1rohyLMYf09EHmLJyKx15J8VuTMurvzDZgI7
	QXORZz35zlfRg+/TnDOWhHlv7kl4+O692g5KbUNhK9S/bBaB8Nrjch73f4dv0n8+K0yoxy
	ipr+0T5cerweKwFW2peMdNJULZ7+SMuZ1Gs8v1dEAE0kSLOu62UCfa44J8o9nQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 1b11e4f0;
	Sat, 5 Sep 2026 13:11:59 +0000 (UTC)
Date: Sat, 5 Sep 2026 22:11:44 +0900
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
Subject: Re: [PATCH 6.12 000/400] 6.12.109-rc2 review
Message-ID: <apwVEISVg7ZeWDld@codewreck.org>
References: <20260905115627.670276262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260905115627.670276262@linuxfoundation.org>

Greg Kroah-Hartman wrote on Sat, Sep 05, 2026 at 01:58:50PM +0200:
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.109-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Thanks for the v2! Looks good to me.

Tested ffa41b797906 ("Linux 6.12.109-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
