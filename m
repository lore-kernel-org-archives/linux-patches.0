Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3F8327C00
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 07:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772437701; cv=none; b=ZyvuAw6GYa/E4KvYXv5rjnLbgsD7bYLoioqzuLVfy55yFOPsfHhiqF16FFHdMyTrcvP0o0GAlOkGUu8JOiRYbcibqYjaoGZkHTFLdUQV61S2+4tlrOi0gjFguydvM37cPV/XkvE5KgU4esW1R0y61AQu7W3cD05DJ8lla7Pzf0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772437701; c=relaxed/simple;
	bh=pUjFAC2jnqWQSFYa6iXNsGGeyj3p/bSGH/BbEQg01/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwzV5Iw4G2sSFoz7ps3ioaT3Zr03RwODmv5E9opSJ/YRSzSNh2yUIeZdwDd+SxFgABBWG+4yhf3qcY6Bvorml01V2a4OPjIfHPUi5YJ44ijuHVaI9yarZm5XWVqBl56/6zQ1KjwVtYOsxNzh2Ot625ZrU7JK1HYfDfdBM8Up6lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=MJXT2bCo; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="MJXT2bCo"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 1622C14C2D6;
	Mon,  2 Mar 2026 08:48:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1772437691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1sVsgjypCSClzNU6Cl1AonhvtxjMR++OaRt3kFfVEN0=;
	b=MJXT2bCoCVTTS2zhpIYQndQ7wZVyX6SJEcyUeep3Sb37iEhqSHPL6EaUjB5n/iBVax1n3o
	T1elm5nYVYw7MvgmzrPKT6VSdBGxlIdPYhU4TnQACjHsaeeIy+htUr+E8+55xr0uYAcqQm
	SOwrVoAUkqDHd9O3x9IKQI3oYKpYxwuWHwkodnCFe3PUY13C930gTRIYlilxk6wns0O8pS
	3uwrFUa9qNWgevQZD95R1gDWgxicK9GyHeLiUra8BIoYBACbRuViK1XmS/5F3wE/KPKzkU
	BZ4GGyyESyowO31FRZOFbAWuan99IEJSqR6H9+w8IYrPmTz/enu4APvJNcdEuA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 37fbdc0e;
	Mon, 2 Mar 2026 07:48:04 +0000 (UTC)
Date: Mon, 2 Mar 2026 16:47:49 +0900
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
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
Message-ID: <aaVApYURKJAoxHoc@codewreck.org>
References: <20260228180001.1567994-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>

Sasha Levin wrote on Sat, Feb 28, 2026 at 01:00:01PM -0500:
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 385 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 05:59:55 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

We're now starting to use 6.12 too, so you'll see me on this version as
well :)
aarch64 board will also be tested later, but automated tests are not
quite ready yet.

----

Tested 37057c896e0b ("Linux 6.12.75-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 build test only

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
