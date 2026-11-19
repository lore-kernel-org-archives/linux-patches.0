Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795064187;
	b=2ZSxJwhSqzX97kdUJHfjzUu6q18FVPwEn6F7viXzsLcn8CiAUTB4fmjjy3okhPUMjcuP
	 R2JAhIJu9fdgnojINImFgdkKUfdGDlaP8kZvancBKtpP+2j6D3vbVaN3vtJrHyGkA3f7X
	 6gYviIJJsIhtvHd353roswJzAiN6EpIwOpVTv3e3/IdHvckZvnqOIMa6ji8SMaVeA4nHs
	 y3htshp/jhuIUmItXP6+5WAEDVZZf8EdrG0tw/AHkIJ4p+eqiQLD9yAv7mu2uvUua+3L4
	 +VvEVsHQCylvOMBDQg1BMEy7FER0UZwQ5dpMVB+qmY+tsZ0mWC5k02pneH1CLW+VE1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795064187;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=d9h+Cta04XamlGIw5edpGaYrhyhhNLchs78x/b9O70I=;
	b=c0GFDxD7tr9v++ua3Y0p8L7U1W/b68fv6gqi1D440ieu66hYfiueuUtzXwB5J7kzZY51
	 12fnTk2I7VXPhWc9y9SpgUKwHC2tq9ELAxQSlewwnWC+V1SjbHPgO8LY7jbiIh5bH1Hsj
	 p5xvGF8BplgdqoTY9uZ9HNjxmN8xOJNbVM5RAi68biQImeJknnYOAQBdO3j6wN5gulFDr
	 i3MHgLl4/nEL/JlKajqfex7bel87m78wSIwi0sW+j7aP0MIJzZX79r2NNYp1OLucUZUYU
	 uSZ6tiJ7uDVa5PmA7KJz5KjeLt2vOBdeBaqdShCxOZTJ63ZH/PK/Dj5K4WWirZB+9Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b="nn/R9yeS";
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF7C606A325
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 04:56:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AF7C606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=nn/R9yeS
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 026EE14C2D6;
	Thu, 19 Nov 2026 05:56:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1795064182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d9h+Cta04XamlGIw5edpGaYrhyhhNLchs78x/b9O70I=;
	b=nn/R9yeSx0KwukRwf3/VpjLBwdNlRtMXRLjYznjLVW1qrNq5ShdJvEHq0Xk4CLOkLhgKVJ
	cZfSYGVAOl4HaTT2GcL4wHi1Yc6hAJThGw52qWWh+ZnbmdKcIzWJ9d2SjuSz9ypp4vlsPN
	hdGoR3fojaHDR7Uau0fKB7gZWggwv17aXDLKhQ9SK4PU26ILwESPcJgW/SAMdJ7zZt8Nvf
	ixQvbsarFNKTzLGPARvtK+L4qirjzCAowvQ1fOFMc0ifOrsYnzOQdZPgdJRqto6xAqejjY
	hBkJ0WSkwFcx2GmSnU6P+ea9yM44ZYbP/Wvc4IORQetq0b9BianVx48zXZidLg==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 436a2700;
	Thu, 19 Nov 2026 04:56:15 +0000 (UTC)
Date: Thu, 19 Nov 2026 13:56:00 +0900
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
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
Message-ID: <av6BYKvHTvqjuPT6@codewreck.org>
References: <20261118145911.150052362@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Nov 18, 2026 at 03:33:58PM +0100:
> This is the start of the stable review cycle for the 5.10.275 release.
> There are 1848 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

After reverting commit f3edd3784bfa ("bpf: Update the SRH state if
End.B6 fails late") for the build failure reported a couple of times,
Tested 12d2575b30ab ("Linux 5.10.275-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No other obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
