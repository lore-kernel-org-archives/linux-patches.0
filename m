Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7336F1DC9BB
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 06:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739513383; cv=none; b=ureCn2easqbTnU7HF2ejZLjLBzRlUeEXUhANtPWW70yKC3h5X4HtKXdkhwsU5vGQm4BQWnSjaA1s3Zs1fj9WraUZJmRN42BfFDrHSjHuFWDa84yUGMTPswkgiinTaBsamwpchWysjn5TOjVfrlKNwlj9oQtFr2R1CK6VQmGvy94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739513383; c=relaxed/simple;
	bh=EpxQNILeQf4iHUHF9psqZqh37LlM3snSG06cnd2ZXVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TvqZlxIfgHyb1rQnkB4un1gqpFFAj70iv5i7GIhzA1L6OUuv/IDYc3HHtV/so5MfgZZgeNvf9bZGcjOJvhRA3ahc4U2aBsW5AsHpC3NJZBmdg+hRYu1FWFjmGv3T9jiGXKDLShmXtFlzzxWDFMtrkpQVlczDBg09TvnGSWXnILQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=DtQBJAsp; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DtQBJAsp"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id ilvwtrTjTVkcRiotIt1njZ; Fri, 14 Feb 2025 06:09:32 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id iotHt6AcM1aw3iotHtQlWQ; Fri, 14 Feb 2025 06:09:31 +0000
X-Authority-Analysis: v=2.4 cv=aeZnnwot c=1 sm=1 tr=0 ts=67aede1b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=4041MwwcWqwrnTXoSgMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hHhUPKIyS1IaI5YCk9QFOAYvzJTNPcTF17M8bgIhefM=; b=DtQBJAspRl58PPehvPSBt/e0f1
	bpLT5TqJiF8fvFOY7qXuVJDAcuRcIw9RDu17gL6XX0JYfnOhgeZqLZ+DlL8qnY47vidoh06/L8Zqz
	+9RYsv5E6kaki0lPyLiP5siIro/acUrfmCnr8uXI/ewUF+mxE72lpUwuALyCbYb3da93T6Z3wZr+v
	gdEvrvpCnEhPfQ7vJilCTvgNwOEvAa4e83Pu1evDbB09Nhs+FBO+mVnTALHrNNIcQFyZjTtOxNtoT
	+KQyXykLjxg1fIgOEnuIwZEGx7/ShhJjzTkza6BaMTNJgh1WCOYIbvpJIhoHzSvfxtNCQqxK0Vdpk
	+Yb+a4KQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:38664 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tiotF-003d6P-1k;
	Thu, 13 Feb 2025 23:09:29 -0700
Message-ID: <31805c47-3245-4b92-87c8-8bcd6a049ac3@w6rz.net>
Date: Thu, 13 Feb 2025 22:09:25 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250213142440.609878115@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
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
X-Exim-ID: 1tiotF-003d6P-1k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:38664
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfN31ETlFVHOf7WCycmYwYzqiLbA3imGj65MnzUBikToXEsNt1l+QpLFw26G/KdL1369hyqPwRNLxddyJrI+YY/9ZydWicA7PGhNWrngxpVPbMHBRd5zu
 gmKMon7tAPzcE5qHbcj5bmC3OVNgoxEzPnIWZToAIh/o47CLBsWt0JMV6Os8W5hO9edTHF67e6ne6A==

On 2/13/25 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

