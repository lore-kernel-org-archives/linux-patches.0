Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795189170;
	b=kmRnN0ThFukUf7vFhtktXjoHCAdi8+E8o2+0//EszXdhb2+bfE/eXFVz2Su3K/sAwc2w
	 srM9FJx9stC/9hl29ovS3DHNPIw3q9WV7mE0FsuD/yc1dX8AAB3Y7m7Jsv6XcHckvxGw7
	 ZUeIse8Rwqy16Dtz3+OqEDVr1JKHls6IUv2tKkocTgMKK9IbWw48hJ1kMI599OrBujZig
	 4cSfboo2iDeiWssE+ueIx1Dh47lz7rqlkCF1JvEKGo3WUmFhe6zaDAjoI8xBCEjwStPLj
	 JXWbBFKypgPbZOJ98EMbYUM+8qq5EYMZqwH4K6M/tdHen24SQZtNRM4sMI+4LYhuTqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795189170;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=HTgMkVBYsEBM7CElJpFJatZTczccK0gAHQJIDzZhy7E=;
	b=laJ7UOyIsUJjUuvEngKp+U4VNhuot2XBW07BQWB7XUcYkw0r3uR84E20PbVLUnPMpuz0
	 W2eAq+t0thXECSv/2+kusl2X755nqeCbeuPpQnWhGyDhcIPEaShVj9KqThTvGl1iyQmta
	 j4S1KRvNoeTa18nFC+TS7zqfvatIHPVcQOe9TnUOfpe9cy8LdXMhqs2jrXKR5wi+V+tEb
	 4TS0ukJM5V+31KE0Oyk9U6AFodT8jxEh2B59IPCy8iGWEASOSmrlD/49pCZJKUYzGApjt
	 ex1/itCkf+zfmDR6LYlhAgjfQYnWy2/2xhaoi2nBMkbEb503JOyo0BaQHjfPLnuAYmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=V0wuecp8;
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACF560A2600
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 15:39:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DACF560A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=V0wuecp8
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id ABC1B14C2D6;
	Fri, 20 Nov 2026 16:39:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1795189166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HTgMkVBYsEBM7CElJpFJatZTczccK0gAHQJIDzZhy7E=;
	b=V0wuecp8l1wXq3s2AcKjfonYkJI5LMTdjlixWnf3AC4bZYwJUtwcV4lNCdAmdhI6SlP08P
	HMT2fT99JjyRpwRsEx8/z5k/nnCC3kESK9Ev6ziO/B1yweUb9Vtt7Wz0FIMMFXA5HrwBdU
	BpAUsBLbHVBw9Rkx3+1pLoO2QnvnnRa0xlGfLU3rMvAXMpds1A3oFzVaU7rR2Au2gfEt9G
	+eat7vMobh4XXkLt1kKcJfrE0hE8TIIVrhmVhde387EHWBO35uuzfBENUKanMwqFSl2jVX
	Wu0W3F/ecjgThStSsL/32JVws6c3W3I3mp7O6yWpMm0lqiuIypH+oUrZ4usC2A==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 6e2e633e;
	Fri, 20 Nov 2026 15:39:18 +0000 (UTC)
Date: Sat, 21 Nov 2026 00:39:03 +0900
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
Subject: Re: [PATCH 5.10 0000/1811] 5.10.275-rc2 review
Message-ID: <awBplxZFyGYI4anh@codewreck.org>
References: <20261120054906.397973290@linuxfoundation.org>
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
In-Reply-To: <20261120054906.397973290@linuxfoundation.org>

Greg Kroah-Hartman wrote on Fri, Nov 20, 2026 at 06:56:51AM +0100:
> This is the start of the stable review cycle for the 5.10.275 release.
> There are 1811 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 878cb656641d ("Linux 5.10.275-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet

