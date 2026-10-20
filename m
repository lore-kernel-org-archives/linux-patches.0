Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533400;
	b=WyQ7R6PEyJ8jMSNxmqCqupH8sXZH1yDXTgDPoP5Z0tsRpVrUMhWDaLJdEvt1+t2U9a+S
	 RIQy7lR/4Oma8VCSivD1hEO2hT+mUwugqgYAApd5AABcwxKtLKXNJSwF1FlT7RzWaj8Er
	 7ITRy/oXnULyJCIEWvc/XB67SiVn4b2vNFzZUNLcv59TWs7NdoAgP43y9dU6q5IOgBy4c
	 /oqJZIMcCVfFh1yySCgR8yF0raH1HLk9iTl1W+XA5OYjAsqWNG8u8fmV3gIZRIXgsN14X
	 q/N9JRaml0UOVWnnqJEglxBzXPWF9oFtmmddG4xMEoupq57CZzv3HY0ou2fg9SGySGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533400;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=52iPltIhF2fGc3CBAkYS6Xkv/utcTNaQcV9LE1JX8fE=;
	b=5IF6eA0H5QchwM72rcDyNuXMXzYfAoyaUzbsgNOSsAnsiIXlBiD3Qm0amZNb7F5Z75qq
	 R5GxPC++MA3W2JmrfSyAFoWIyS1aZrFjtCboEpl22mdyYPk+m/U2R2QVIMVdmI63svbgl
	 liVt6b5cMcEc8Npa9IqFJyk2ocylX9tbXmj/21oRPPGy9QP2khp6KZE/NFjDZw7PgYIdx
	 1vnQ25+5/XJTPHQnKLmWSdTdGsoUs5A5jx4f1dw/Dtut//Uib8t+VE4F/4V4BSd3BHZqm
	 KYpABIe023asONjGKL91UcacoJvEAe2upClR7M3CTNjg0RRz2w85sAuUL1+FFoz+Ipw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=iFRbK4SA;
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15774606A31B
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 21:56:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15774606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=iFRbK4SA
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 738D814C2D6;
	Tue, 20 Oct 2026 23:56:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1792533389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52iPltIhF2fGc3CBAkYS6Xkv/utcTNaQcV9LE1JX8fE=;
	b=iFRbK4SACLMJfl0vDm0SabyGgozqFh3iTLRttfGvux233rzvslmhpzR7ly8H7oRtKB4jOq
	k+OzIrnEzIqDyVpMRV6beyddFstiyC+3ej5N5MZ6orEVovbX0X9shVfIt8QBdwxcGShnla
	5lnz0W4OehIB6vW2y2ncKhFCMS/w8Ztr/XYWNLP1gCyqlmG3QRUFc9Y+X1uv3nFDohOMS0
	Y5TfaPMm7+jVaR7uSTtIjfSRcaw6uWHZB3xlC4NvYyrr6dEWjEE+fxo+1rkTujcL4l7KsU
	Ep9TvIll8gV/sZWzR5cHVP2oM5fZp+Jd1kreyYHmA6PpwZgNhEWlvREhApVyiA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id f4cde85c;
	Tue, 20 Oct 2026 21:56:21 +0000 (UTC)
Date: Wed, 21 Oct 2026 06:56:06 +0900
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
Subject: Re: [PATCH 6.12 000/858] 6.12.114-rc2 review
Message-ID: <atfjdn7YLnWB7Kf9@codewreck.org>
References: <20261020075246.861837975@linuxfoundation.org>
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
In-Reply-To: <20261020075246.861837975@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Oct 20, 2026 at 09:57:31AM +0200:
> This is the start of the stable review cycle for the 6.12.114 release.
> There are 858 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Oct 2026 07:51:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.114-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 9fb48106e91d ("Linux 6.12.114-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
