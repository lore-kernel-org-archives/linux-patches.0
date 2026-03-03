Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA3F33F58C
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772539438; cv=none; b=dyYaefm0Or8c6FubabUQ/mjQhiqA5s6jMzeIAWJ19r1ui0M7x2Z00goKz53meghfZL+z/UEjKhuoQ6wVvD2RgQwxDVABPaE9JXF7etF8FbDyC0RFOUHLVMXWuLF/mfNUVrQi7XXE96kDzk6h1x6gk42FXyq2rj+i9arQOTrkh7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772539438; c=relaxed/simple;
	bh=CN7mgjM0C7K/hQSC/N6fmCpSI1LaqlPRAVmGfHYRDSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KwOGAM05T6NY1YS91JfRZr8s4vTkbhHaZ2i71uNfuVMtUzWeQx+uA3jFWZjP6wjF2wjc3S0ezTqg47u5/xUP6FErBoQGVsG8IMVAX6dk828BkXlSRXADxFf2mDVzexdZA/s/Scg3JLHwOuCYFKWGSJ0R0LOgItau+FiMNJqlelY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=2Xs3VDHB; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="2Xs3VDHB"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id xCF9vhEmJCxrGxOTjvO8kV; Tue, 03 Mar 2026 12:03:55 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xOTivM2x4PL32xOTiveDWr; Tue, 03 Mar 2026 12:03:54 +0000
X-Authority-Analysis: v=2.4 cv=MqhS63ae c=1 sm=1 tr=0 ts=69a6ce2b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IUP94lneZuUcqISsHhqQFSoUgncjV0Vo2s8AWCRmBds=; b=2Xs3VDHBxxZteVip0avn9Uy856
	ixxosgXf62+n2FiRh80bLFEwV+Xt0vSC9EfTcCsPU4XoaLQrwmuTtw3nmbYnte7zkUTPxPPCElb7Z
	RrgXuLVfIp8Tfy5yv4+hCx2LvKVMEn491GrZr9XTiivUG5EN1bjS7UXWjO9sYqLqyq2MB+bgtHXSX
	x2/+GpNmQM+W2UXv1UOJD6EWRiGlU4ED+Uq+HKNcuWfwC8rKyUKGIYQceuGfAtzQSNX9hmgsKKivC
	r6SvjjXBrf1GBLmuIATsE6Ce1NghT1+xKsSJD9VOKxbSGXqnSeUvBJnjHNZJe22UFd3TauV/cx4yF
	10t6sqLg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:38372 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vxOTh-00000000cVq-3bgL;
	Tue, 03 Mar 2026 05:03:53 -0700
Message-ID: <cf4bd8c5-ae9f-45d2-8137-d08f14284b65@w6rz.net>
Date: Tue, 3 Mar 2026 04:03:52 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160853.2519610-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
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
X-Exim-ID: 1vxOTh-00000000cVq-3bgL
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:38372
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLXHAflBhuXVUZTq6dNgG2FBv8okdkhDIsOM7o65lfo8L9eFsDtIp4N0Ybvqfu1WGvFW4cuDlG0PwWrrlIip00JWk9j5klcthnLzkthvBEZuk8q3kjvI
 TxDbxPIMZTEe0xhVqRZ0O3mSV3L8Ali3c0beKQ8xWQ+352wdb3vCfzlkh3QozeO+Iwj/XwN2lQQyaQ==

On 3/2/26 08:08, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:08:47 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

