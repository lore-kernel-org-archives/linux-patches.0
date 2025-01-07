Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032E11DDC06
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 07:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233820; cv=none; b=uXsnuK72bI+kWYCkVpcI1ZzQN+IxUfAd9+sPyihD+MM4FVGqQLuV8VIVKxG1sT4kFRsv0cnB0Yh0OSfDgWXNp56HMpOgFBJdf4Vck06R8RpNN0PNgbeRKoqrTC/0GxO2/0mrR2UbwTms9jsan9qq9EVpP1g4FY6Dn7wVtfCtD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233820; c=relaxed/simple;
	bh=7Zphmnz3LMezieYWOaHieK2xW5iCtqfYP/qT/euE+50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DNuQ0cAFLA4TuYMcjIu1wjMRmMHnKslGJFId5xDrv00sj6/w1RS6bHYbLq2TmqD+nisPz2tQKP3M2k2bKWlTLcEg1HsEyUJKFYN4IwwaW5kq8DfDIdUHoFHJBlpbmZIbB7wHH1hG4AzlQKCYfu2CH3ciCYgkUh0ZsDblq0Pcbfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=dJXpYcO/; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="dJXpYcO/"
Received: from eig-obgw-6010a.ext.cloudfilter.net ([10.0.30.248])
	by cmsmtp with ESMTPS
	id Ulb5tcUUgjMK7V3jCtK3Sb; Tue, 07 Jan 2025 07:10:15 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id V3jCtGf5shs2qV3jCt7ey5; Tue, 07 Jan 2025 07:10:14 +0000
X-Authority-Analysis: v=2.4 cv=NeDg1XD4 c=1 sm=1 tr=0 ts=677cd356
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9j9uveJ0GrHUEOsm6y3z+rwLY4XtuBfQx/7bDQMRY1s=; b=dJXpYcO/2tDYeLgYSqqrWeLqOj
	oz1i4ZZn/Ni3/e0OGGJtcqb8CpOlZJ3lgmLIPklOvzl1gOQILQK/VaEa9xZ6HW0KkCx7YoWF0/zBJ
	9BD8yxurS5Xk1yN59Z93t7DEtrL2iw5mQfDJK8Pt3jf6wZRyDGkXWgzciMlpXTl8S0Ow+9U/8YRBc
	j4CAewuAFtlrJ/Mfd4ZVjF3nzIaEj0z9XC2yGxEO5PTSFUMVkkh5a/DHrvfi9emPURInlu60w+x7M
	HFDbHP5MtwGgsVkwsa1U6Y8yEORPvBqNs3vpvXA20PN9Z6kcZyD/v9ZPLZ5bzbNCBXuKgAMoZUHM3
	YmeWU9OQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:51688 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tV3jB-002klz-0N;
	Tue, 07 Jan 2025 00:10:13 -0700
Message-ID: <3d30ff74-4271-4f53-b830-b5b751047cef@w6rz.net>
Date: Mon, 6 Jan 2025 23:10:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/81] 6.1.124-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151129.433047073@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
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
X-Exim-ID: 1tV3jB-002klz-0N
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:51688
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJ+xEXDDDhUvo4M3GQp6fyEQMpeISsFJ3LSnTbUInL+Z6mO8kqZ1k0npBwbW10WXqGy5Q+xtAG1shpbU60iEqAItG/gDjM/RaKPXicJNQb2F0egPILX0
 PhvWaHoDPObDqAdrg5/eavGMVg3THMI16ji8rHI6fIWnBY6ySvIyXGUXqoJxSnrHdXE51rlXWyCSKg==

On 1/6/25 07:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.124 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

