Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310F14317D
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 04:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895821; cv=none; b=LNITjjF8jUWPJDiTFJvfMvsHdo3eZk2COWTlo0rjhblga6zrl1Zrlf8E54K5Ob9mx1v/gU2lWQoIIGOGIsm4kuElufiXLVq8Ky8u9Ezj7m3MYTqoFmSCuUwPweYKJ6Y83pAjxmm/afUSAMqCYPtaMzNeOc78ENkODB/Ik6HyZV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895821; c=relaxed/simple;
	bh=EPCU/gkeoqVDwEHvVum//UpxUdl+yg8t+ylF2Wjc/hM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bXbBuaJkwwE/CCpxbJeAQYvgfdUwL5Iv7ktuctGoPfHFKkTKzgDSosTrDitE9FxUXdjJ43U+ykaCfk10M6b/StGDtR1L5OSV7/zMrf0EBpyb7Jhd8zQl65UOApi4V5EHtYbcrz3RCvcZVrKkXI53MDu9S29Vc+mzrX9vVZaVHM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=GcmU92Au; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="GcmU92Au"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id 30V8wPPCKSkcf35KnwF5Ma; Thu, 19 Mar 2026 04:50:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 35KmwolFkN3K135KmwzvkS; Thu, 19 Mar 2026 04:50:12 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=69bb8084
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cSWGKpNVJteO5j7jKXfwRMyuLRaTwOqov0yGBPDcJqg=; b=GcmU92AuN42g15mEdK3Vjet8U3
	gFWG+ie6IKqGZF3Ub+K/Y4Dx/TwbuE/a1eigTmTZaITovz7zs5T4CROtuHlOAioLa00RFpMcMwyUp
	RtxclOJAKmu0lHgdjqrgsrqk163ex4xVG1/WPmIhPZ9/TEPOrPXZtVowuu8ia0FenO3FJ1Q9S+WXD
	8WUADGYhvUzUrk8u2qIj19agXw9oiy5zDntDjkmBftvzrbppmpZJIq9vEqcWNItM/ckDeYdftBV6e
	FQDgM+A5p2auFO6mMpLORtVJvrzQNIJNUOiVlcilIC09uawic+cs2NTLenyHM91KZcY0xS9rw4z6s
	AAsI3XHQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:46426 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w35Kl-00000003xGR-41x6;
	Wed, 18 Mar 2026 22:50:11 -0600
Message-ID: <247645cb-8e5a-4481-aa51-ce03f3e59914@w6rz.net>
Date: Wed, 18 Mar 2026 21:50:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260318122621.714862892@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1w35Kl-00000003xGR-41x6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:46426
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPWTJzOPtoVaft5mQdLCZZMbSyX2ZWTWatz6c1FV25XqnZPiGwcFRI6zQPQITM3Ogu0DuUHrriJNvix2GvP3lIz0glrWeLLa5xJHNPuiDXvEht1dy76U
 UadepIkBs0p2B+2t7rijTlNsSDYXzQrYyfWFchNPNZq8irq6pWuQsdXpv5J8I17OixtkdDvMKyD4vw==

On 3/18/26 05:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 335 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Mar 2026 12:25:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.19-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

