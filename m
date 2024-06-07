Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B074E1DD
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 21:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717795830; cv=none; b=qY9PmyjXNCgcomhM+NzUxR+qsHAITNSSwuEQrUfEsN7VtVE/NbqNjbjpi+9zR/+Z+6i6XCKkVCOKBd4FxmUQgils5IGJ+dyeYvZ3ep7zQIvOzNm2qrD7YGSRo8bnPwin+WZ9Lj1usRRyx/oDOJEaFXjFKGROC16kWPZcwKUyydA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717795830; c=relaxed/simple;
	bh=TIoPA6q0p2ZOZfGMaw3+O8QIjm/1136G45xQI5HRsbI=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=qdONERI6ZVMvj9sC126dPZ+HJNZafgJ24Yk7/RXUNPFcsWPZxFLlFBaCQ5GROmqUE/VNvIJN8xhY9xCeZCJtxdszeltOAvVuXqKmWgChleCDJvjwqWS9crEv/SmMf72Y3dJe4bX+ehG2O4+cmpiB9DT0g5/SJePnKni2gkPWjQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=h6AyQqOb; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="h6AyQqOb"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id FggvsNoBexs4FFhAEsaBC3; Fri, 07 Jun 2024 21:30:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id FhACs7EMOiKqRFhADsZFbO; Fri, 07 Jun 2024 21:30:21 +0000
X-Authority-Analysis: v=2.4 cv=I9quR8gg c=1 sm=1 tr=0 ts=66637bed
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
	bh=HYjfN92MdTz2EhYaVCHHc09qeB//bbnggyFPCAgGlXs=; b=h6AyQqObUFkPiK1q157qBg3Rj+
	VMl2FcUmqKcr9nzOexaMvkuAmVjMQmXN6rsSuCJrU4tUYFIOdx1i2zxvlO1bkU7x3lT0+LddovJsz
	2Clo6gn28bzCIYm3bKXjQoNZOeyQirMXufFHnFYLNL41H7eUG6qg1YBCPK6+hGb+26ogydi/HXzXN
	EOweH8t3EOO592UN+4IRtiPEPOMw/maRm2N5qXJjh8Ga+kbkLtcKOEevRnhS66dUXNBtpVh1qRNRh
	mt9bj/NIIaGrAkvHUOEIHMcpcvvb51aiU5n7F/9ELQN3bVDuFrZtx3l5Hcz89LGKx0q+fnFja4Sq4
	KhTGLS2Q==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:42390 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sFhA8-000r21-1H;
	Fri, 07 Jun 2024 15:30:16 -0600
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240606131732.440653204@linuxfoundation.org>
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e976da68-6315-5d98-921c-49d72c56dfcb@w6rz.net>
Date: Fri, 7 Jun 2024 14:30:05 -0700
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
X-Exim-ID: 1sFhA8-000r21-1H
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:42390
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFRLTbwxlyZRWRBBL2EMAGqCBLPkS9L3vETtLqu2mOTSyLGAtKC1gOPj4Q6mRk1MUgcOSKTk+myWj7+nczZWygpyIZCjA8xBefQSCvqIhdCgpZbghD1f
 XjZHWiEQZjBZTmuz+PLZ5E+X3RGoyljMUhw9YQQmERf2cH9HCkh0fT21YCQoTe86J13WwHPtc2NrXg==

On 6/6/24 6:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

