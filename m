Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A88E17BB7
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717796166; cv=none; b=ZPyWaLejcPTc8kI/Hq5IpV4pa82WoWo4SVnccgSfiwROW484pGGyUvDpOx18xPw9ZfSdhWxbb3P3U8DuWdt55B93xdwac9Wu/upOLwMa84avRw38kCorbTgVeQyvypjFleNZVl6tWZ6aqGmZ8fxEXqH2DlDbKQXARULLg1nW6t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717796166; c=relaxed/simple;
	bh=xfNSsQUzNewVN/mboc6Q0xEqgOp4BA88MYFHp0Rzyi8=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=VqOgl1Hk2IJl6G41QJN5huYM9lqBkoyV2JFALSqYM6B+HYvWg81qRfRsnFk7zsf7CcinBJpCyUMxdk8Y7QpQ8Xovy5BUQVrenYg+GM6L0Zta6ZjTexgH5vqJZE2IMn2iWk31/PdQxZBwrivdjlKarYquoKrF4G+/vaLEXsugBcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=0Cua+W7a; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="0Cua+W7a"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id FeeKsZ0RkJXoqFhECsLpKD; Fri, 07 Jun 2024 21:34:28 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id FhEBshxkbXw7yFhEBssYey; Fri, 07 Jun 2024 21:34:28 +0000
X-Authority-Analysis: v=2.4 cv=LtSUyGdc c=1 sm=1 tr=0 ts=66637ce4
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T1WGqf2p2xoA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=3U1NTj930rUM-GEF0QgA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xS6YINBT7fbz6uzLiMSH6n3vsUox7c6GFJJbpYf/fSM=; b=0Cua+W7aRUDuBA939JItWF6TcY
	xB7dxFdkugngH5ApnAKbRywy2WV9u2z7LvMdH1y7qDaup3TuOpLK632OE33baKIB2f+dyjSBcjVOX
	pi1OVuI862KyU1QIog0UXe+ZCKO4PC0fmS2gAry8tL9ol93r7A2EBrStUCshOON6MaN6P6SLXT+28
	TJPvOKVITYskO3rjZDno10ToPYbO4T7C5AxC4TeaA1dx89gqHZuXw0edn/Xg+RfVSrFXK0ivoKBIY
	q77zoUFnyQYyEovzfzPjz3Hvv/6iFtaEjyiH2PvLjY549UBUjyDJO9G2Fv+fZZAi6P2xhe9K3YR0z
	ExWCIMLg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:42394 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sFhE6-000sT9-2r;
	Fri, 07 Jun 2024 15:34:22 -0600
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240606131659.786180261@linuxfoundation.org>
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <a5332a9b-092a-7aa5-dfc2-d28565167411@w6rz.net>
Date: Fri, 7 Jun 2024 14:34:17 -0700
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
X-Exim-ID: 1sFhE6-000sT9-2r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:42394
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOaRkiHwg+yTsJ0zp76wtTtgkcv8vlTEe3HnV+wZTGoFafrJMG2IkJchOEhGihZ1pR0X7S5wNB3Hhjrb4+kJWm+odhmPqL87dkxcce6xYVEFTOhuurZ8
 zNRmxa6xdeo0VAtp2mtsKiiqC7jzQn+1qe2HgU2GwMwTXyQ+0s68EepYWqjkgpwgv0x2b2vt6r9OlQ==

On 6/6/24 6:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

