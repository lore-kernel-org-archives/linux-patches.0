Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958CF2BDC2B
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755122829; cv=none; b=TvObI1iWZn588cKFdn8zO5qdK7gaHy4uXuEhNK1HhXIqdZ3GpPzbGyNAA+XAILtw6NXGx0IcQFQMETKgOJqmFBjh2Sc8T2mWhp3LFjw8+pZYAI3BADKOQKGL+9EAinJyugXusznY+SMLEFQOnvHx/bH9FGa84chcDjDhvZ32BWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755122829; c=relaxed/simple;
	bh=uIzsmZKJwjDz2mWKOy1UhhgTLN5rtxD9iXozJmIimac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NzYHl12bGOvF585Gv9m/2ib2C03hyCT5m/cswmAencthEP2weRvYHKpOusRQzNGT4ayLLwDLgcbgS3SW4i6jWO2OhEM5YG4hmGcOStdBKy4WYXRnJqBLOZDgC/6GMavlrswMhlu1wVmngwGLceBVICath5nNiEZLaGYSoppYXoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=1A/2v9bi; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="1A/2v9bi"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id mEMWuOAJo3e9emJcguWQUS; Wed, 13 Aug 2025 22:07:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mJcfukTQ1wYTkmJcgubSXP; Wed, 13 Aug 2025 22:07:06 +0000
X-Authority-Analysis: v=2.4 cv=fYCty1QF c=1 sm=1 tr=0 ts=689d0c8a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=lNbMyd3QUhozLt4CxfMA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BR/6CPBiRno1n+Md2/FA/IKXYNPIeUH6VbPcs+affiU=; b=1A/2v9biSk6earIRCNEQDPaVtH
	v+8WNVg8qAM7Tkh8RZ9Qh4m0zsXklyrIYmOM6mWe6vGzSw/XnXdjIqp76PUXe38aOuz/uOEaT4uhc
	pwiqB+4Y79vjw8W7rs7r5jait/liTGYXb8Ledd1Axoi0TnyigngCyt9Vo8YHmqEwb7DcJVzojCYIs
	TLhEBZY2XZs18mQxga0LNk1LSCiDgYVBTUQyyNCxrdSqQ+u5MtRctbgziPyq94VGz6tyNMi1+r17r
	jTPgOFGZFEFhIZIekEebFm+mkUbWEPIvpR5E3lqXwSKIaOrgCJQxDl2o7uQ6PWeKcm3ws3+K+U9DU
	Ekao0QtQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:48018 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1umJcd-000000026Ve-3pLd;
	Wed, 13 Aug 2025 16:07:03 -0600
Message-ID: <55c94b4a-e3e8-4705-a314-f73dc33283b9@w6rz.net>
Date: Wed, 13 Aug 2025 15:07:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
To: Jon Hunter <jonathanh@nvidia.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
 hargar@microsoft.com, linux-kernel@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
References: <b892ae8b-c784-4e8c-a5aa-006e0a9c9362@rnnvmail205.nvidia.com>
 <20250813172545.310023-1-jonathanh@nvidia.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250813172545.310023-1-jonathanh@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1umJcd-000000026Ve-3pLd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:48018
X-Source-Auth: re@w6rz.net
X-Email-Count: 8
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAZKpXQu5t8DurjUNCoV39HIHl82JZvzdcJY6r5Kq5hlabt1I1b9V2YkaVltFZansgXIm6rZJ7zQ0gtNkYSvrWxRDF+ieEV9ZWs+tfUUMOFXL8f1HXnP
 Lc5qJKviM1BlSA4hu4bVm+LY+4175BrcjpWvbWJ2LvoJ0t4Cco1J3d/XFb9HFPAmNAo/wuCOuRBrxQ==

On 8/13/25 10:25, Jon Hunter wrote:
> On Wed, Aug 13, 2025 at 08:48:28AM -0700, Jon Hunter wrote:
>> On Tue, 12 Aug 2025 19:43:28 +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.15.10 release.
>>> There are 480 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>> Failures detected for Tegra ...
>>
>> Test results for stable-v6.15:
>>      10 builds:	10 pass, 0 fail
>>      28 boots:	28 pass, 0 fail
>>      120 tests:	119 pass, 1 fail
>>
>> Linux version:	6.15.10-rc1-g2510f67e2e34
>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>>                  tegra210-p2371-2180, tegra210-p3450-0000,
>>                  tegra30-cardhu-a04
>>
>> Test failures:	tegra194-p2972-0000: boot.py
> I am seeing the following kernel warning for both linux-6.15.y and linux-6.16.y …
>
>   WARNING KERN sched: DL replenish lagged too much
>
> I believe that this is introduced by …
>
> Peter Zijlstra <peterz@infradead.org>
>      sched/deadline: Less agressive dl_server handling
>
> This has been reported here: https://lore.kernel.org/all/CAMuHMdXn4z1pioTtBGMfQM0jsLviqS2jwysaWXpoLxWYoGa82w@mail.gmail.com/
>
> Jon

Seeing this kernel warning on RISC-V also.

