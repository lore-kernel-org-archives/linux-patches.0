Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148BA2147ED
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 10:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742466143; cv=none; b=n++L/cGMTrk5rXqdT/t6TN0lazN2a4UcJMFvAT3L9mV2kv2pf5G2H8zI94SC2fyGqbYMeLNXiXxFuyDyBhBRwrXUgYmnCxagSmjmZGsLaMkj+nDD03PSiecMb5XlG45FwMP4aFMfjjPMDS+npFvw9gsxenFasuYaH5Tj6x/Effs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742466143; c=relaxed/simple;
	bh=CZH8qRZ+aLhOTBwGExOsduZsgEMvMqe1mAKbAMcfpDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I4uf76buoxF60cGeGa/11BK0f7kZu1Yx4WfJ8xj+sBIP5KR/Cf6/H3QhKA3QxFZVvirpPorDXnMlHglMhGwu0DFiGijtRqJPdWN7raJIv4UFv3RdMs1ltJZyjlmymXCOKjbnva3G6arDJiLCo53V4nI8QcTKWPaMZrHxBY7XbRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=F8ejs6uY; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="F8ejs6uY"
Received: from eig-obgw-6010a.ext.cloudfilter.net ([10.0.30.248])
	by cmsmtp with ESMTPS
	id v8wltyT6RAfjwvD2atgNI4; Thu, 20 Mar 2025 10:22:20 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id vD2ZtB1CW8krvvD2atVMcS; Thu, 20 Mar 2025 10:22:20 +0000
X-Authority-Analysis: v=2.4 cv=PouVbRM3 c=1 sm=1 tr=0 ts=67dbec5c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=reHiijyVQGdWo19NHnG5Kjmh7PXe0ltjvIFYByZcWWY=; b=F8ejs6uYZv4A7dU7KdYbr31j3v
	d0ZI6S8yTNiZoiy5pAJ/FvfjjkT7r4S03F0+yyjSNLrEXNidBbKkpK+sEeaaOfiBdo1Hd/4ffZNOW
	E/qn0qoeaZn2/OAyvVQ6pZnzg22kWTeOpYS3ALIilV4TdV9a9Xu0B45jup7JCY+ptOy8QPxAW4bJC
	GQnNpjabwYeZMzdwb8aYhgoaMInLBMj7r48ji77ceRKBbMJYv8EGPxS6bnlwN98LrqQn8pYinqVNN
	QKhjWW4muGM1Xx4FAjR0kVwBdxV3lXfrpR0OWNbfdKAnvpnqBaA1Iq4OFtHV9xoCseUBuULj+9ffD
	WBpnrSPQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:49616 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1tvD2X-00000003M1R-3dTK;
	Thu, 20 Mar 2025 04:22:17 -0600
Message-ID: <bb37eb99-26d3-4a4d-a8d5-a71a21bca2ac@w6rz.net>
Date: Thu, 20 Mar 2025 03:22:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250319143026.865956961@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
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
X-Exim-ID: 1tvD2X-00000003M1R-3dTK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:49616
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBt3dBOXhpFgb0YisI43iNpq4WpK2iDBc/5wYHjNeF+7JBVPn7K1e64HW65uv44lphU+LwfA8sNDYvYlr33CO0hDGMk4HJqYU5eeacr15p/qkZ37W8BV
 ztNTADskWlRSWA2Ih8RY+216zj4hXHcM6E1MH02FZR5WBjkfar6yO6tvG1S/gu3IovQBGK0SQ0A+1g==

On 3/19/25 07:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.20 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

