Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9F121883E
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 11:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760182670; cv=none; b=BB1566CiPYKCLCUUs28CtFgNMfOOK/c/TEV+niDh/wtplxYUAbG8QIMgNff8zbzKRD1a9Xm/QRRKDelJ/vQO7LjsUlXgEpxXbnNPtLyjcwJwQYMUqjlIg9OqdIeVf0dfSijIbZrSQttGDSEG7LmFgGj/77Q3WkpjwYPeFDaKsZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760182670; c=relaxed/simple;
	bh=bRdrc/g9qQlktXDwT+VPM6NnLYJ3NloT0R97Z/JIeik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qBslpOPOZ04Neg1sYqAHKgqtDKTrg9afEONXkTJSQiwsciDHp4wSMku9qyRhPQREESQ4ab3AMedC/5HnRXEb/Tg3VqO3JwhCiZ0nyXzuG3tefNpakWQPXhKmY6bE3+l+mfWv9qNfYAYV9uT0SFHYm9OCCnFaevXTbl+Yj1rnUdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=JGGM1pd8; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="JGGM1pd8"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id 6xH1vQxpuv7247XuqvmbJh; Sat, 11 Oct 2025 11:37:36 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7XupvFvYowoI27XuqvyiCM; Sat, 11 Oct 2025 11:37:36 +0000
X-Authority-Analysis: v=2.4 cv=PZX/hjhd c=1 sm=1 tr=0 ts=68ea4180
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=VoBekJB99Y0dKvRsJJIA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+hJibs8dQk2A3ttBHAPuQzvPEqntnziRNoKw8ZyU7BI=; b=JGGM1pd8aEdr1yyvT165feRpp1
	RZWeoWja3503gY/HpUReO+LDgYK7aqBFeuNdABOVNJT7BnGuFeEw4cmOPpLAJFRGeQ7VcyJlhcFJI
	32aCbC5WyWe/asYI8wSlIglLtequsJ+4EZiTqBorFP+jRTPiiDtZscbTAdDnj1VIRcyyMb4XhQNVy
	BpMHUKFIdnVywhj3GmF89YBvMIoj9j66aqNgDkWul/EqwS2jBg7jLh6HMR8OUIyUtsMEGn8U01Ki+
	iNtt3TfUBhFyMTAFE916o50GKOuyjVBnoeqgSjiiU5zxSXWh67eotXv87IyuwC/V9eugYF0RrG14p
	fFOxXYZg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:53622 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v7Xup-00000000seB-0dTE;
	Sat, 11 Oct 2025 05:37:35 -0600
Message-ID: <ee159df6-ef77-486c-bf5e-5e6941d88a6f@w6rz.net>
Date: Sat, 11 Oct 2025 04:37:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251010131333.420766773@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1v7Xup-00000000seB-0dTE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:53622
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMYRr/WXFKbauLc2uYiTU3EW/ytHQdKw3ntzThfrukMVPGA7e13wwpC/E04vKoMqIHl+rm8CJRi/i89tRsts7uQ91x+byDEJ2gmuaEfccKH3LJwDJ0tv
 ekt/bCkXQQil9OrJ59rNvh2KAEZjRGEu2xjJfAyz1B+Lhf3ODjQwK97eHOJvBQ7z9Y3zWQ4zHDv5+g==

On 10/10/25 06:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

