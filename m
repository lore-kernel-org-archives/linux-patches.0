Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BB63B1EEF
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 08:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787731381; cv=none; b=jUX/hX3apLfTeFgtsxIT92efdzwpwjCHmEHryb2GbTEVe8J5DyOHUF9AvPGCCco6Hz0rbBCZ5RijSlv0CSrwf0b4pQaktNzBSS/sF0NqaUzSvwXK0ACZpqcHMWraEoK+huVszbgK+lJdQKZayULqGkLXkkIReWV5A5HHu2D5POA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787731381; c=relaxed/simple;
	bh=CqhMF/ImkGIcWajBz+CD7T3CsodcD0kdsdokyOTusug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MmKwYJgV+0hsf0lgrshnMXhQhjYACycKCQitk6RWM/rVN56SmXcREBqr1vDHj82Pr6DHaFLREgsW+rvgCH8KZEERzIK5DSMg33iLrpJzE9sVW65tgiyA9O4cpsF52C1l4tgZnYGeb02U8N7U8oW1y5lqgp0PX/OiShkOfieDoqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=3NtTJk5P; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="3NtTJk5P"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id AD26A14C2DF;
	Wed, 26 Aug 2026 10:02:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1787731378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C20BDlp42s5Ls4hxa5r30OpZbjGoCMvP24hPI/Kb9kc=;
	b=3NtTJk5Ph4nNPzkl/r3kGC+0RElsAJKk7o6yEGKphMKK0X7Hf3n4lXaapBlVJa6OLYwIJY
	bEqrcTstUMFOJ+Ar2XeFJOqxAcSbhYnY0SI/FQuNeOtgaq0LD7jToxzQ1Zy5V8Y+hQ8ACu
	d8dHDqnsR3clKkhLiUGAEv9pkkzIsbJQwUGmNYC311PPP/HUXKZ7tMSjrvQZsOy8fJSAK0
	JY4ohci11Uooq9rHaikw+bBVXulNDl0kg8kovvY9wxUAou5QVkzzdFRhHuORqAzqrSd+oO
	Km9mLge9l/0ZSIhIqtDaP/nMEa0Bwq++aivK9M8RoqKynubtWlqIns5Hsu8HiA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 16e85723;
	Wed, 26 Aug 2026 08:02:50 +0000 (UTC)
Date: Wed, 26 Aug 2026 17:02:35 +0900
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
Subject: Re: [PATCH 5.10 00/57] 5.10.267-rc1 review
Message-ID: <ao6dm0eXwCkEgwR4@codewreck.org>
References: <20260825132541.342390421@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Aug 25, 2026 at 03:26:22PM +0200:
> This is the start of the stable review cycle for the 5.10.267 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.267-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 8157cbcd6d36 ("Linux 5.10.267-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
