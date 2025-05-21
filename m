Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6AB194124
	for <patches@lists.linux.dev>; Wed, 21 May 2025 01:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747790769; cv=none; b=ACPy7MKai7d0zRyPXI3KMa6TI8n9x31JiReQzCi1GERLwyr/BOcDE9GcM4p/d9pYC8CxDbLq1uBxFh25AVSkL9niDQW9ZNASRQtEaQ9spvMeal1LhrZGx9GBYJeuuxRY5xzzw1BJ4G3dqSbbh+Jgf9+VbR5NjyT3ywYtzMIlqGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747790769; c=relaxed/simple;
	bh=7QwfftoA4j5uvRIbqdfg10GeJqtkcsx7eM276hf1ueo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AShn2eL8XOKQvEqFcaVdepu60K5h7YIrc9hLs0z4cGvE9TRowl3P/s8oIXcgc/tnJ5L54zvlU2ZEwsvHEP5Q8M+kftmoqeLAaYXlaISqfL8M3YAazDQplCCu14u2geCskk73mchap4TCOnIkbmorMHQlX94K/dFMsHWCw93nENM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=DIm1HgXz; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DIm1HgXz"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id HV0GunCDUVkcRHYDeuWz8r; Wed, 21 May 2025 01:26:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id HYDcuf3SHSPIxHYDduI8ea; Wed, 21 May 2025 01:26:05 +0000
X-Authority-Analysis: v=2.4 cv=MdZquY/f c=1 sm=1 tr=0 ts=682d2bad
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=qfBMeBQ8Qh9mIwLNFBIA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WuMQeRygrW3RVlRP4YOXMSX3odtJw3dfHrbo3CA7HCg=; b=DIm1HgXzYfKB6TwZY1c4Fm1/lx
	/hOLtf2eY9B/TEBewqObc/H/FD7UaQBbdGDc/WnIF5NpJj6Eqm3RrctIZQd/MqXrAq3X7xGt5sSYl
	Nf1Jwl6bc3JNjIuJLLynPlCgvMstny6LTvedz1bT+6V/VNjV3t7eKoEzl3lL7ASyG0XTWdpH7qnSI
	H/GnlOHxLZpQOG1gPByuwC9y6oSLn8XY6gUytUVz6el2b7hhQAv7+CCd+1bjOgnWX++wQFDcy1W38
	AwniXDX7LRUwhEKlIv18moG7MjzHFhch8hGeSWNS63TjhsFacUd7+2aYBd4wMsXL2nqc6Jy9D0Myw
	JKTVDPag==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:34418 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uHYDa-00000000qu5-2ycI;
	Tue, 20 May 2025 19:26:02 -0600
Message-ID: <8132c38f-f0a7-4a7b-91bb-dee8ffb7409d@w6rz.net>
Date: Tue, 20 May 2025 18:25:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125810.535475500@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1uHYDa-00000000qu5-2ycI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:34418
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfG+In2JMg5r/ZHnR92DqBB19E000vBr8uANgbusux8uAZPugigBVdjXtJjMmh4ExjazuWdosoAaJegEXaAYvVUY+Cjjd0qqTyLSr40xmoS7osSgtFeWP
 IwsmB8D5dFg+ogBcakYds+IvOFQk1s/BXWpGcb5mRHJ1O37PWqFnDPChhp2+LN845ZgBgOnZd16E7g==

On 5/20/25 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

