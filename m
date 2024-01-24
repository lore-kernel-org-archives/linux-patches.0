Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64017559
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 08:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706083250; cv=none; b=YmisVIMl452lE0cPVZ0CdYrTVPPNQLEq/kBgA0uj8znSKzFklliiVAIz/15QPsjYeMfnhQeteYCr20mxP89KKUlcEa0hOuX07ZTUKI7/2+GKby40kGjMjpAOWLArClg+OU/4A/7aYaJyWzT3r54xfnnGIYhIyxExjjql+SVl2Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706083250; c=relaxed/simple;
	bh=1C3iXccwBlELRySptMNNC65TB3+3vd9/2gXCQ8/Ua1A=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=uI9yMy4+fxbz1kgc3Jas1m0d7fkMo26EKP6NSwyab6Rvgzj2ORXFgeUXeq8GMrFAmH7HNvkLkN+gQ+YU0mDjKOYIpk2UcuhRTqWzUzwjGJpKu1K6fg/tXLLab6B8WdPyHC4Z6mYXycC0hC8gCt1W3bnJtC8WwbeHztxFDe1t+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=S2JyumYA; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="S2JyumYA"
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
	by cmsmtp with ESMTPS
	id SVW6rkSDp8uLRSYBerh1py; Wed, 24 Jan 2024 08:00:42 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id SYBdrjpc9KleDSYBdrvMH8; Wed, 24 Jan 2024 08:00:42 +0000
X-Authority-Analysis: v=2.4 cv=KcbBDCUD c=1 sm=1 tr=0 ts=65b0c3aa
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dEuoMetlWLkA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=rqrlWO25EZKfsK9HbZwA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XwmudWvNzKZLFr3qZl5dYIxJ2vyxFylXBSTwDy/gKz8=; b=S2JyumYAlr9ZIIss2dZACAqJnd
	lU3PYxzkSShZ3vqdRmCIS4MhatoOQf+z/JjIPOt4mZIRgg7rARajEhuVmGFpHruvmhzRkPcdcjdKN
	b47iXKzaBr2a+Tv/+JKv9pc8KjwM7JGv5C1qe0FSeFkU1SZzj4ltCa2Biz/QrCDvUGsOpZWjKkWYM
	SYM4lR389qa+nXVGJ/iOgzDCfanmy7Ab/N86t0OpDGO1NefayiwvMWJTYdBoYiCGKsWwDM03lWVfC
	QiVEXJJzGEz8BtioQ04mzF1/Qj4X1nDoHly+1/ar7ooHasFMnAM0PvoaLn3KZtPlo8LOKa6IuyKBZ
	FBJIE37w==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:36736 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rSYBb-002QZq-0K;
	Wed, 24 Jan 2024 01:00:39 -0700
Subject: Re: [PATCH 6.6 000/580] 6.6.14-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240123174533.427864181@linuxfoundation.org>
In-Reply-To: <20240123174533.427864181@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <408b6d51-4bd2-920e-3b8e-abeb8e2beda8@w6rz.net>
Date: Wed, 24 Jan 2024 00:00:36 -0800
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
X-Exim-ID: 1rSYBb-002QZq-0K
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:36736
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCilotc4nHcELi9WrxNVdATJL9oAYcQ+dbOtBpl8+QQcTRely+hDq6xaJ2ePX+9xzAX6x3WffNmLqYyrEjtRa46mC6Joqgit6Ddh3tcf3yxj0ztvNkkF
 InjjY9L4IiQe/CuAbrYLt9F1w621yFE9qVF89lZAv5mqrWSRrzLSrb3ApRoatUzCKCUYqatjxXOmug==

On 1/23/24 9:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.14 release.
> There are 580 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jan 2024 17:44:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

