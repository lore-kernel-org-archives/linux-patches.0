Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B882B10F0
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 09:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784279412; cv=none; b=LQ7UFkgtGaNwv/S7AlGeYHWd7KiD805W6teL0CBOSHsKaxNkabzcMnwAGYHNo+L0SpG5HBb2zNFflmVU+bP9cWY1OiiVq+U//15TQlsInEj4ptPmwSoSfb0W1hCQev+UrKBSlBR/6/ZSyP8uckf+lIxtXn+eMM3s42fGBAOCQV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784279412; c=relaxed/simple;
	bh=hKsnA6sADSVlFatKWv3dmaVcBSbmEECwHYMhwIqODjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s9mUAUI6CzNIMUc0/HIXGiL+qNeMfv4Dv1ZDi2kInNWJ6HMc3FSMcSCIPzk5P3VD1wtCURFUj/IerpDMLsg3oZw0rznyeQXXh6PWDHFNqpcRx2g5hZXl4gtXJCkNRbo+i8aynz7jL4YSAmYHZb6DZE9uMgv6A8+ebOLVFZGVQrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=xoO1k0Q1; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="xoO1k0Q1"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id kMdAwuVO0uFzgkeYcwxY94; Fri, 17 Jul 2026 09:08:34 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id keYbwiUJSRY4IkeYbwYnxr; Fri, 17 Jul 2026 09:08:33 +0000
X-Authority-Analysis: v=2.4 cv=WNl/XmsR c=1 sm=1 tr=0 ts=6a59f112
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Nghn086io5pY4Qe7T5wA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=W452KQ49ORuGyDWTt93wAxvfGknLCKHwLMQ0kzWhsA4=; b=xoO1k0Q1HysxJ1kjgnRMbdFpz7
	9EQ3d51I3pKXB8sssnJsnfPPfD5aDyCC6j1b+uhlqafqWcrF9/Dy4XBepD3ds+fgJ3E68Wlkh06NP
	GOTKeltdYOLq4ZynZ0K+dK8CXYTL7EBdVu7ZjRNPrkXNzJrBLsa5TrychFg5KKz5+VC5S4M3hD+1Y
	9ZbexuI/F+ram47MH99wT4xT3fVfEEVQg1fQvSYDSz3Gxc24RuCgIi716CvAxPSbA89y/dlMfnk4W
	2WRFgcwCSCUjdDGbknML1FRLVyYVWhZxIgq17mXlduSWhTByUne+PEczm9xUJNSZA+l5x6mSnOYdq
	kOToycHQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:60528 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wkeYa-000000042cA-3vYB;
	Fri, 17 Jul 2026 03:08:32 -0600
Message-ID: <375d79dc-9dea-4c75-b5e1-19fd7e83038f@w6rz.net>
Date: Fri, 17 Jul 2026 02:08:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260716133047.772246337@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
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
X-Exim-ID: 1wkeYa-000000042cA-3vYB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:60528
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFrBLR0nAhB3Kx8iahRLb3qNrM+gZ6sdBDl4njfH6qhJIaEOsnPdiFkRewJJ8J0RRkUqksSAPkyV8/WyQ8R30MoShIj6cmBDOAplKANrKIeMAutSr6PR
 tLSZlCPK3AmlOlUF3/jQBLsGwcQGxucInU5W0YOppFSa6Ay33plWmUOSYpwlU7t/WQin0DAR8/Snvg==

On 7/16/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

