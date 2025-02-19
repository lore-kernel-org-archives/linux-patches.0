Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F822580D2
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 22:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740003212; cv=none; b=GK6d7GO6wLOOWKNIsm2oTRG0z3N8sNrc2/GSgSugol6n21cmdC2HGAwS7h8tAjuA0YPBOjcA0/6DKrYtLnlHnuQl/wjobDnSZk+F/TuWwCkMYK2Lxl+gy3QDyIXJGOjeKDLywNIoKNVT4EqCoBGOeRz0YSuDoPM9D1qkGewwqb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740003212; c=relaxed/simple;
	bh=vA6mdzm8NuSQe28CQfOFLEJI5uI+t+igmO9OTU9TzL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dr/OLBJQVs6lG2ZXd3buOkSI/2X6ydHeo5NkPkqZOdzmAtmh0ei/GegQVBAdnorudM3nimyaPLrTB799sk/MHFX0VNVKZhCcg0E+34JFUldR8kXDormN1eNXgA+7VAW/u25gs7K/JWL3qD7/ZtSWYw1GiRbj3JoPj4nRCeLzBH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=kBs/kHT2; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="kBs/kHT2"
Received: from eig-obgw-5002a.ext.cloudfilter.net ([10.0.29.215])
	by cmsmtp with ESMTPS
	id knmOtIyLwVkcRksJntitU0; Wed, 19 Feb 2025 22:13:23 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ksJmtxSkDdY0fksJmteJCY; Wed, 19 Feb 2025 22:13:22 +0000
X-Authority-Analysis: v=2.4 cv=NoUacNdJ c=1 sm=1 tr=0 ts=67b65782
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6WkSWjiA2VInZ2tCM20WUErMuf4eOZcrm4DvKHwteFE=; b=kBs/kHT2lwl1J9X9pzzLU7NwHG
	Elpop2R1ZyxdtI5FZTCI6lJcXfeSLe4eZVPGllBYSLGMsj8WrpJ0pFhJVI4p1t/m6MxHUQc+EKIYX
	nvAZ3ZANaXS3uEV3eskMVhYDC8zxRqODztQC9eSwzqIRYm4/CzkQtxvfEU7GiGPRw/Gvm9XvbMNTI
	f2L2fDtxh4YK4FXNWtjEt/d/ar8z1U42eUXijKxmFc57tS9+X37e1G3k02vBm3iFn7JoP/tUAVQJl
	n4IU/uLh5N0dDb0F/imT3k2R1acLDiuY6W+TcpV169vUnHnS+LN4K1UAwy0poXya43Up8s1Xn+uca
	0l5TaeWw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:37524 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tksJk-0005ob-0i;
	Wed, 19 Feb 2025 15:13:20 -0700
Message-ID: <435c502c-f010-49b5-ae04-e9786b053b96@w6rz.net>
Date: Wed, 19 Feb 2025 14:13:16 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250219082609.533585153@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
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
X-Exim-ID: 1tksJk-0005ob-0i
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:37524
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfK/wb2WK6o/hK7Yhyo9I72BpGYXu62iq3ox7WqoV2lYOlcHSWhVyQ2wk51F9It4iILIRreGhcE3ywzl+rNR0Ialc7WlKfwqnwsXUB15lX2ib4vSIAuMQ
 74KEkiPUIIy4qD2BKOwAPIKohMZALiA+GorqapYwTNaUWwkx5HzrtOaCv1xZy3btmz4KAwg/NpxyZg==

On 2/19/25 00:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 274 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

