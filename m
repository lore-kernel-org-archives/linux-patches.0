Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B6A2356A4
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 10:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741689540; cv=none; b=j0cx0L1Y3vTYGo/MdGWr8S+RNrjSnlsKxYCBFCEhkLthgqrQU/VEp2DuvtYnH2AH96xUq0gy5pZyCBX2hAj60MfQDn8o7JgFbYjR6KmR8wnwWNCyMp1ECdtFboCVEo5u3HRihzlqKwg8oatG6WgHSQ6MAQv9Kv/pg4zrxHTm/ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741689540; c=relaxed/simple;
	bh=oVd5XyQGciBFbDQHNaiEb+MTjGZgXL5/ydTtVz3t3GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p3t25OPi+jqqttB6ooSIOqiPS/zSNzmXQcTGKeJNLlAjzuYoThmCLInxE8KCYMvaw3y0QwZe3QXlYHNEmKd8MnyVnjlF4Qr5HsYjM0x2E477YkYfFQXODkEdRTqj5j0veWSve1DU4l0uei2MmVLG5Rz+3eaW2sljjN7hYmeptPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=L648o4N9; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="L648o4N9"
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTPS
	id rulUtfMYbf1UXrx0jt9bJv; Tue, 11 Mar 2025 10:38:57 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rx0it7iFP6czBrx0itu0D5; Tue, 11 Mar 2025 10:38:57 +0000
X-Authority-Analysis: v=2.4 cv=N+cvFX9B c=1 sm=1 tr=0 ts=67d012c1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=SoV1cWDepzK6XYGrUZ8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yIukXYU2O1RYqi6EvgEDl26+58TVpLDae3NfzcBMU/g=; b=L648o4N97+CGcvjR20dKpMY0s+
	OLvp1qRqsRoXzAQ+5RsFvAoS076vx9rAMdqyoG2QFfoMaCH/zMM1t7E95WDHdC5HeQZ3VRgNiIBcH
	Sc1QiYn9+Bon0B5KVPFGRj9CnASf63j/7o7LeaoszuoQxFPfRNbIcgqO5vapG248WBrjVEjeilCK3
	ME8u5LRXd/PF4S/OATrP4OLdaAU6d4rYWFRcUk8FIKq1JyvXZ2CtkB3mjapu57L5Npov5jx/vN1Ym
	CWsA7zh/VHWxtkns4g4tDG52Kp3oPR3RxiJ8CG3oVULfXTCHxoOfsm/xkfVp7ejYXV+DRoSWDBmqf
	fjbW7OHA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:36824 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1trx0g-00000001gMS-1zyb;
	Tue, 11 Mar 2025 04:38:54 -0600
Message-ID: <a97e013b-67cd-4db6-bb65-ba0319a4f38c@w6rz.net>
Date: Tue, 11 Mar 2025 03:38:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/620] 5.15.179-rc1 review
To: Jon Hunter <jonathanh@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250310170545.553361750@linuxfoundation.org>
 <65b397b4-d3f9-4b20-9702-7a4131369f50@rnnvmail205.nvidia.com>
 <07b8296d-ad04-4499-9c76-e57464331737@nvidia.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <07b8296d-ad04-4499-9c76-e57464331737@nvidia.com>
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
X-Exim-ID: 1trx0g-00000001gMS-1zyb
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:36824
X-Source-Auth: re@w6rz.net
X-Email-Count: 75
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNBEvfcmOZUBp+ESRAlyiWzTr4zunfzjjoAV7RrjwjZ5ktGVJErB7GoyDdJS9P2j642TSxaC1B2aVNQV4shfwjE1LFHeztp+hD2sp7qUPPyrDPXnxjNu
 90MtjMyy4BQEwyRf4FTMsbJoZVrAhUjSKfkH0tfnTeFn4Avz1wQv3CUi4GSSOYFpHiXGTJs8prQARA==

On 3/11/25 03:11, Jon Hunter wrote:
> Hi Greg,
>
> On 11/03/2025 10:02, Jon Hunter wrote:
>> On Mon, 10 Mar 2025 17:57:26 +0100, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.179 release.
>>> There are 620 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.179-rc1.gz 
>>>
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>>> linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Failures detected for Tegra ...
>>
>> Test results for stable-v5.15:
>>      10 builds:    10 pass, 0 fail
>>      28 boots:    28 pass, 0 fail
>>      101 tests:    100 pass, 1 fail
>>
>> Linux version:    5.15.179-rc1-gcfe01cd80d85
>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>>                  tegra210-p2371-2180, tegra210-p3450-0000,
>>                  tegra30-cardhu-a04
>>
>> Test failures:    tegra194-p2972-0000: boot.py
>
>
> With this update I am seeing the following kernel warnings for Tegra ...
>
>  WARNING KERN gpio gpiochip0: (max77620-gpio): not an immutable chip, 
> please consider fixing it!
>  WARNING KERN gpio gpiochip1: (tegra194-gpio): not an immutable chip, 
> please consider fixing it!
>  WARNING KERN gpio gpiochip2: (tegra194-gpio-aon): not an immutable
> chip, please consider fixing it!
>
> The above warning comes from commit 6c846d026d49 ("gpio: Don't fiddle 
> with irqchips marked as immutable") and to fix this for Tegra I 
> believe that we need commits bba00555ede7 ("gpio: tegra186: Make the 
> irqchip immutable") and 7f42aa7b008c ("gpio: max77620: Make the 
> irqchip immutable"). There are other similar patches in the original 
> series that I am guessing would be needed too.
>
> Thanks
> Jon

Also seeing this on RISC-V.

[    0.281617] gpio gpiochip0: (10060000.gpio): not an immutable chip, 
please consider fixing it!

