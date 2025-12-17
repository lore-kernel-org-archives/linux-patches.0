Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA001221F20
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 05:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765947932; cv=none; b=nyI7yjwlFpFR9+wJFuT+oU+6wuQnolq3PsGZu9pp6WOcFPfrWl4LTTolllOhhCjljGBeGSJfyB2nEybvo/G6MtMxbBmDNFpuHB2rJuS8CwATI9B2NZwZiZohbeOy75K+68CFyoZtDBDy5w8kmJSFQG599yqnWglKz2y53sGRu1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765947932; c=relaxed/simple;
	bh=yg5F6WdUG5kg2M6S2g+p6xuswLrbCQTfkLhaQyLpKQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BmkzitQD6IZrx8bOHV5ply2Zcj6pWfGoNMaxI/y/cSYiteGq/uOKKTBosCZnE5JDi6/g25E56KS8kecn+pkP2cHLeLs0mWrrHTKPWhOaU4g3w9qsxHqWT+TQI/0qWchBafBNcwoc6n10+1ZuNjLLK20TJq+YBR243egnmDJLT7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yuRiqmun; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yuRiqmun"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id VANsvx9lQKXDJVjj0voTrA; Wed, 17 Dec 2025 05:05:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id VjizvI5MavXvHVjj0vfweQ; Wed, 17 Dec 2025 05:05:22 +0000
X-Authority-Analysis: v=2.4 cv=e4IGSbp/ c=1 sm=1 tr=0 ts=69423a12
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=shKLvg-12WSsmoj5OQgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xSnCOqDoLiW3kXR0BfsKuf0OA7NHQQwi6c3KspOjaz0=; b=yuRiqmunWvKYAuLBa09vyUCmJf
	I0OjTeCMUtzKrRQgns0jZw9yt5qlPeKBmKwbdJ6FuF+20hvEz0X9nHkIzqUMq9PI7+q7JfJnVC9iZ
	V9iYUbLaDidCzOF2qxCxDu91X97bS5dx7+VF/hX0/uV4PV0JmgzvI9ekyKRuEudZT+QpKv2j+vqWS
	xnHm2132E98NNXwH1R4rDbKB4+Xyz8ROpIu6uvF11VyIF8/+Dx/l8dkTaeqG5Eh1ja9zWLrjAxJGl
	/bvw6M/nSLsT1yYmLhcgrCY/axkirHHEMsep1RNduPQTsohsRPnke0EdzgdxqX+kcjQKHCjPRqBd+
	5viuVoQw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:51870 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vVjif-000000003xe-2Oug;
	Tue, 16 Dec 2025 22:05:01 -0700
Message-ID: <f4064499-034c-4d8c-8600-708d49c8c1d0@w6rz.net>
Date: Tue, 16 Dec 2025 21:04:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111401.280873349@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
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
X-Exim-ID: 1vVjif-000000003xe-2Oug
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:51870
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFa7Pu7yjxhKuH+5ZhgH14FFI2cxsSEiX69yNNdlKaLHka72LP3JqDuQ+nSBah0rfCcU32j20f0paYfKThiJy5pLe0Zx2/r+QLUP2KDeWw1V21UJQWMW
 crWPi5401svGSr0Bj34AgDTfO9CUFNmyVndESF/kNgF4Szr+zt6rudaxm7Y7uYwDoWL8pYWXG+nKMQ==

On 12/16/25 03:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

