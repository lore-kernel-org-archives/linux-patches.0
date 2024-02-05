Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED3C134A5
	for <patches@lists.linux.dev>; Mon,  5 Feb 2024 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707124833; cv=none; b=iRNwiUSjAwCHSDBSXC+mY3bcaPFZUwUAep0vSwAGTJwcBo8Udq5NFUit/ZQYkMAWsZOpYxKj58aXPKvxcQvrxIUnTGGqnQ73fV6tF2/iC5R2BoRkIa+T/vIVarQSiZU7Gd8DivhOIqaBKW0agMtY/ivpRKBAO7/Gu0jnAEe+UyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707124833; c=relaxed/simple;
	bh=NwogaMO0Mscgp5dPQGXI6QGM5Bvcz7JNBKciEMJL4J0=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=stGu13CsiQBxI5X0JJlqFXTrcdRstpODKX77h8bkmRHw6uBt6uy/WneFtrgE9EskVCirq744fOnBN4IK7og/9Ud3MQjmLQkwCLiiI1m2p1uXKsCoW0bp/B7seWMkBb3oARaMlyoKepb9lZ0yrU6WYxLWTozYSEQsWyB2cT9LddM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=laPnRj03; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="laPnRj03"
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTPS
	id WfnBr74ld80oiWv9MrbnW8; Mon, 05 Feb 2024 09:20:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Wv9MrBBIp3S2EWv9MrTE63; Mon, 05 Feb 2024 09:20:24 +0000
X-Authority-Analysis: v=2.4 cv=foN/Z04f c=1 sm=1 tr=0 ts=65c0a858
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=k7vzHIieQBIA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LpCdqv870RknWCK0Tx5X1QgGvnqvpACA8xnj6UMA0I8=; b=laPnRj03pr/K8rLFEFooMnxpkO
	GLFhlyxQ7A9dsjjOxNi3Y8wnXzj+QgCgnBWVCnjl0RZwM1CqcMNbbbeve7vx//vsIhJJniI+/k4XL
	xIOvEd2kyghTWMhRKijf1ICkRJwT6+0ebIMgmcnEVeY2lQDsI/6MLaRYmUlCZ3DvVFo9H76BvBG1m
	IIXq+1dBskM0AIEmc25rClAXwxA6kepfBMeZzuGkSmu3U4cQ6HnkEaxI3uEfowJD2mmoutN1JSopk
	i/AZqdq+zjomgPk+7wD9dVHJMX6RMWyO3XT7DD+I1im40KGD6fvDanPcpzT5GNW1s/Q29RY24NeEn
	NvtIrQaw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:41072 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rWv9K-000tow-0Z;
	Mon, 05 Feb 2024 02:20:22 -0700
Subject: Re: [PATCH 6.1 000/221] 6.1.77-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240203174756.358721205@linuxfoundation.org>
In-Reply-To: <20240203174756.358721205@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <fd4114fc-6f4e-3688-10a7-44a6cc567676@w6rz.net>
Date: Mon, 5 Feb 2024 01:20:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1rWv9K-000tow-0Z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:41072
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfD8ywa73usJ4P7hLMAODzOZVJTBnsLr4wVWR/dh6kc37bDsjcfgu7y9uUgTxHQzI57Lfp1kiOaasd6nAEuAvgH4rCZmshuf1LRRbDlh9ykborJNebXYj
 /9NDSAYUxmQBsPBhZoW5nhAPQH1BcmkvfFi3dmK15HzuVva2D1srPdmUMrpRZ+bP5uhulpWersomTg==

On 2/3/24 9:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.77 release.
> There are 221 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.77-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

