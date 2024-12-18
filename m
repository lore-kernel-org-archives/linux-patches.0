Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71D1552E4
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 06:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504954; cv=none; b=GGrhtxxPrg0W74kj3O3UJkiVAq0PDKVNXJzbevJ6XvNJECfsJdHjVRVIvowaQiWQnYR7a1YdX9y1bwfjOjQRALjfONS1MZO934ZAbapWuE7qhZ1vfYaCgPcz5i9JO6x5Felt8AKisPTQLTHXs2B2B7PMFXc6hl9tEakkssxR+04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504954; c=relaxed/simple;
	bh=/APvVRoqnGOQhBToEXCdbIecsdA0mMnOsj2kUq9NI0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q5G0xV8pYXOUfFUZsvC/dfl+jJuwzIUw60B5JJf1l32rO7gn7GP0FfZPcSq4TA5SeXydctQNt9ZOxtp2n/Tfzj/TXaVSDtvqUU2C5FwK3q534FQi4dgOCJnAeRjrlLUIn4t1SFmqeNV77xbimC80jRTb+kUpuzTsA56Dl9ea7w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=s5ppcbtt; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="s5ppcbtt"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id NE1TtgRQ8umtXNnyJt5xe0; Wed, 18 Dec 2024 06:55:51 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id NnyItCaAz827nNnyItjy88; Wed, 18 Dec 2024 06:55:50 +0000
X-Authority-Analysis: v=2.4 cv=GeTcnhXL c=1 sm=1 tr=0 ts=676271f6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=HPvIB9lQppeJS2B-OsoA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cHobiw0FyoG6jWfHdQiYTqU0C41pXUPiKtBw1FAfh8k=; b=s5ppcbttAtc8p6VlQWo36ns3rW
	9/BfZEC9M4NWXb33EjWEiLZXRVT9PPh9ghfAMMg8NE2jvgEtxgGwVTpv9oPP3KNfkMYLe7ZpvzUHT
	K9dOn2I9TLUE8l2elI3rjUaCpiJTXJtRcQFc55K1xZly07ghqJodUKWfL0Dcs+gwWdE/YzkbiEoKA
	ZIe9cPkwQlx6mv138GZ/OXlMVr0YP+13ELc0pf0ZRzA4xeJe8/OU3lj5/hGNoXp93iIK7F5YkKsNX
	1MG1+udQkP5aUsTQ/W9898hRZXJthsVK2kUCjvvEu8+hP4cta52NNi4H5Zmc93U/G9UM1iNvc6/yb
	oallS2Ag==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:39870 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tNnyH-0008AV-0z;
	Tue, 17 Dec 2024 23:55:49 -0700
Message-ID: <688af702-eb18-4525-907d-81aff5ead49d@w6rz.net>
Date: Tue, 17 Dec 2024 22:55:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/76] 6.1.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170526.232803729@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
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
X-Exim-ID: 1tNnyH-0008AV-0z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:39870
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNblj7wCPNgMn6IL3TWaaRgfCc593P7afl4xpl3jyLbkC6OKlnqzQrCF1Y9ALxPnfr6oDph14uTz05bU5OqRM0qhEaYCxghtWrBX5qZ1AqxE+Fw3hbB2
 UsbDoTYX34ySDOItF2jFfsY1ExsV+n/ztUHTi3xeq6915J+hZx7WE5ExThYzj7i4kDVdg7BURxVKeA==

On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.121 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.121-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

