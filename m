Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B5818C356
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 12:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723120842; cv=none; b=CpR4x+HXcqg1os4vjMFWRpFGHgYjX2qEiqmSO7ZygBSU/1tUi4owqihqUqypQPHJhWqj9JyKRjqb/qKhzfVac6/i/ptyAb6HXUvT8wNgT1L1zvPtX4IXaAnkICCzvMQogRFwr1KNYUk/GuwFqh7v7pbMwT+7obglExllwZICNs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723120842; c=relaxed/simple;
	bh=KsVV2fBPJDERdcfEPQFXxnrx85KBK8pNG8vcS6YeqRM=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=qGHsMCRBa90YV5BrkFH9uz5OGkzTvXESnr/IsgWnc/WksyoJZSjWzz4agyJo54w09mO74B7OLGd1i30nuVC+0/UIHHRqyCirtFCuw+wCUIAN19HT4yKIoaYDSrgjqwiMWmIotp7/1bDcmvu4prc7eYGKO15qxAIU3jHKkfG4LE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=D6EeQamn; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="D6EeQamn"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id c1oLsd63EiA19c2RbsECST; Thu, 08 Aug 2024 12:40:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id c2RZsmkFARBkMc2Rasdc5T; Thu, 08 Aug 2024 12:40:38 +0000
X-Authority-Analysis: v=2.4 cv=CbPD56rl c=1 sm=1 tr=0 ts=66b4bcc6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6mVBh0IM6vLBMp1B64k/EKQM9pXf/Sglzn44S2603HQ=; b=D6EeQamngAAD9b5isroyWWPvqL
	E00PIYpyCdvxjnKDhBHiAASoZ9vGr2PQmhpnLYb/ZJdWp977rm0GFXQWlFQoI0cf+NBeOpfUjD3og
	boAKVMSjI6TfRen2PRUzZRVsmUMgEJBP3uX3i+OJuop0YvN81rv7A8rcfotkDNUpueksa7aSX6lbX
	J/Y5f/LyRMkrlgy1iygXkypnIlrl7KPSk7UM6XFRqTrnoIug3P57/OrKjxQlEiJRoeqNsbUBNjWgs
	2oZWI/ri/E9tOeCsSC6/85lNBpBBIvHgmcBr8R2uXZ+X3YJ4g0IzQxDNStZdQISuvhYMyxOmcxGxT
	Oe5OSgAg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:33440 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sc2RV-0041Wh-1p;
	Thu, 08 Aug 2024 06:40:33 -0600
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240807150020.790615758@linuxfoundation.org>
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e8d1a5e9-3334-9a74-6049-5078295289bf@w6rz.net>
Date: Thu, 8 Aug 2024 05:40:27 -0700
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
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1sc2RV-0041Wh-1p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:33440
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFmyV/3F/K83b3fV6TRHfS5lZMMG7bGkfs66JCou8Ou2b0+XhQSbsQrcEw6EtkGBn3jbHFTur3ea4u8nHjd+F7jt5IKOkv7LjYFMHDiN0LXBQgbfX3PV
 tT09KWyySFkUYSg2EGjqjJsNUFMgPFd2LF2tC2Jyg1vG6JQmXlic4OSb7PEzFSgrwyIHC7zriN5mJw==

On 8/7/24 7:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

