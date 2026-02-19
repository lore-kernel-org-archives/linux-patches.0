Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D70C285CB3
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 06:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771482443; cv=none; b=oHBH2/mPNg2+7u8YvdBIJrw05y76cYcFVGyq9c8pcFRzZ4wK5gF2YteGvhHlr7CkeZGnRNpnW2ksz+5jY93RL0Qz+OFL7CI0Z4buaGEpq/ApBV8aY18aoEloc9hRXH2bB/tjejxSstjmAo64yw6FgLrYTmQuRzqKVAgJV/sk2rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771482443; c=relaxed/simple;
	bh=xghWr+VNIfBvNYJa4m80q1w7Z3kgBiwS6eF3gmAye20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bZlQzW9Vxifkc1E+puvj+UGReWfLe31u4qjUVz0ILO2df51oXv1ZIXAXeyu8lVQyeyBBbEswMyYpbBPG8hpJCuhXCILIMzlJZfhnaYUdhUoiKo4eC0V2AW+vX3ydRDgHCpv+trfkJyrTRDJhd3njUbjVUGI9zlxOPzvS0oNSPl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=i0MS/sd9; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="i0MS/sd9"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id sqH3v0s10KXDJsxVRvhgY2; Thu, 19 Feb 2026 06:27:21 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id sxVQvEDvQ2l0ksxVQvjsQQ; Thu, 19 Feb 2026 06:27:20 +0000
X-Authority-Analysis: v=2.4 cv=UfRRSLSN c=1 sm=1 tr=0 ts=6996ad49
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=x6Ducos6UYMGwXt6jLcA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=e7YHDFgFMx+YHrQT/5YCTtKo0OSkgNIEFkGrrlkIp7k=; b=i0MS/sd9dh8uXfROuC82JT/4j3
	lgLPwoAFdKjqUpyZht8SHm7ZbxAxOsqQIHiMYLQUwbW8Gjwj7IFdeKPt2pA0PgBg8Fn+3I7gHNWTy
	zfPmJDyC5Wn9MlEknM+RivG5mKBI1Bo/D21jgQeLzuoizTa+b6FFJbldgvd0hSbTJbOcqucOkyz1W
	kgQYaN2p9QA8y56/7ArdKNFsJIVXXouyaUlIG/68B8lNtM1n3+K5FHjLgpdPe9iLiOWiDiNURaz1R
	oW+Ftb4ZXb3fdseraUrxwRDzUL2jmn4PnFhxNTokwG+N2Jv6eRGHWBAx8Vux1ZLtrUWUWdauTCuFo
	YgsdT1cQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:41194 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vsxVP-000000026bW-48VX;
	Wed, 18 Feb 2026 23:27:20 -0700
Message-ID: <a686351c-3791-45a6-a85f-be7d434fd2cc@w6rz.net>
Date: Wed, 18 Feb 2026 22:27:18 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200006.470920131@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
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
X-Exim-ID: 1vsxVP-000000026bW-48VX
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:41194
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGTD6XMkwiB+kS7DD4BLD+CrJDoD6smuscmNgGILsqZ1UyoQ6JqGFsafey8xHlky4yGNP/dSXWNyFKhquGFjPNInrkQE7jmJoX3GehmRNx1pPchyhasr
 wEvloeHm8NL+jNqTJg9ijmV/RwuDAFwHVmn9Q9qB+g9vTEIi7JML9HWVX2sAw0etutDuXFioikV7Dw==

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.13 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

