Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DD11A8F7B
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 23:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734131799; cv=none; b=sNWgW5J7RGYWExuDotAxGYcnxXMg1UihZjvuBC3G62yEXLi9R+L/Vbu6VaAKXIdznBDG6J2Xzx+oMuYcTtdEuBuCpUYzN2U+SmoLu5uYYVTsJMZd2g4cGYrb4TXlYnfMVOOo+yB3K1XywlxqtjFGXX127tOCQy0RUt/iGhb+QoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734131799; c=relaxed/simple;
	bh=xNxRKpfOs02EMDjuZ3koUj2W6hDdAMTZMIiIA+zlkJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FprcQ6bAbvve4etQgGFUh6oMApy+0zeWh2aDrA7U8ghLuQt4oKJZu0+H4QhNBQq91xs67bIsXX3rep7wytQIdIcy6zyA7jUNYsUqaSXBIpfTsg8LzqjS4ZkKqA5cejgwqZ+6KwwjWY6WlpMHdew2SFskAtOPxMU8IcuA3jKTmmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=pSianBng; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="pSianBng"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id M7SVt7vOUiA19MEtet0U1X; Fri, 13 Dec 2024 23:16:34 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id MEtdtZiAEfkSoMEtetUGo8; Fri, 13 Dec 2024 23:16:34 +0000
X-Authority-Analysis: v=2.4 cv=dtLdCUg4 c=1 sm=1 tr=0 ts=675cc052
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=U14AhigymTHLZSuqQ78A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=FKNmXPAdmJQmZuBEdIf4OPFee6r+8EHky2hhIjSp6Xg=; b=pSianBng9/QO/QLQ6sltX7d0JY
	KKAGRYwZUF+62c3rQFz3eMy6gWQausfd//0GsQyNtKOTT5yJgNT8wuUqm3T7UNUXrFCmkw/R5DBZe
	wxfqIRoLGfTkkaLPpWrgBT215vkEnSqa53uYurpoRb3kYOaLjVm9CRE1J3ECQNLoC6r0Tga3sYR2g
	UuP3DenQn/7SqxGf1TRi4IQxcOohWA0LyVZutN7AP5k2e4UNSDlycjTplDOrRCdt+CLhTWxZ5bUGZ
	OqZCPv4TxnYT5zI8wFPk5oA/P7TgARwJbtfue3voI6JZWTrz+SWypaw2nHP2UgipYr7ZiBJb1dO8j
	HLQWKl7A==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:49208 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tMEtc-002R0M-2V;
	Fri, 13 Dec 2024 16:16:32 -0700
Message-ID: <8ed97bf4-76d1-470d-bdb8-a1bd85eb6dd1@w6rz.net>
Date: Fri, 13 Dec 2024 15:16:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144244.601729511@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
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
X-Exim-ID: 1tMEtc-002R0M-2V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:49208
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfC93VnmzCRfllc3z61iAflBT9Y1Qrk54kVNpwmxVut7Rvtn+cUedRAUSfBqwVFpNV52ZiBfabzzKNcAJcGHOh8ZlbmqF50LwJq66SEp0FxXh8DeQSKvA
 NwMStiwAucDQbzMbaSbDe91g/J+XHs9TXRg1p+nkTFQjlupJh+gc+kemcPgcmxcuO9OiEpiphDGgdw==

On 12/12/24 06:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

