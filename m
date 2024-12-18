Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B3215574E
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 07:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734505439; cv=none; b=GYakJX3ieS5HsPgxrVTEGsh308BwXrwjUJvSlaVWOlyliGKytIH3kQxI4l4nj6Y/MZIM0wZ8x6H8TegNpg/XHW7ZzwZw7/4nq2SKLUn8j3j1azh2t9iOgB1OoZrQcdpwZvb3Z75j8fzySr/ycJnuTumsyorJ/B1Dd6HJaT2tHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734505439; c=relaxed/simple;
	bh=sUcBJUsNMeKQIIZkO3oTA6xEX5BgklADmyfNp2/njwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hHVsvk+we0dJGmRLCt1MM9r5rZmYisagscN+DxOWwzPo3+gs6vpEvZvGDgWIQpi1MIbeyZ9LpAH6P+KP6jAixuQ0hq/Bb0/bIa1GeMpTmzVh7gMbSb1sweHMNiQsPgPVZK0vDwB3tUdBUoMLIxXN/ydlWsAxim1JQV7du8Tc9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=CFRNXyMa; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="CFRNXyMa"
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
	by cmsmtp with ESMTPS
	id Njmit6qMZnNFGNo67tdQr6; Wed, 18 Dec 2024 07:03:55 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id No66tx2vRWvXpNo67tHDVq; Wed, 18 Dec 2024 07:03:55 +0000
X-Authority-Analysis: v=2.4 cv=LtdZyWdc c=1 sm=1 tr=0 ts=676273db
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=HPvIB9lQppeJS2B-OsoA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ITj9AQwEJVLEfP6hCL8kUAQ9IaOgMQ6NDvJ3Ar8BAi8=; b=CFRNXyMaU4u5v9x3n2Y/D63WwW
	kdOvwHNfUwUMQXSVcfVT1Ar6LvIRMT1yz6XoJRwzZ3Xr2jWL8HoGRXfrsZJmJHGxVI5Ok9bAWUlko
	cDCjyIP7b8Si994tq3EN16zbOrQaweg4duWiDCINAYeC+6FxsV5aXCFNbwsFwyq141Qp3lfsEGQTF
	gnB7q9Up/tLdHdEJobnVk3J75Fgtwx86BE0vDA9HZyorJ2jwUclpjtFwDhtx8T8JzI0d3cyqXM7pZ
	neKN1OlHnOEaraAF52EBdgjs8ivQjiwssD+q1VLmR/Tf609TANXozvD4+/OaVxiGCmwwa4Qt3XH2a
	zx1pw1rA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:32838 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tNo65-000C6c-30;
	Wed, 18 Dec 2024 00:03:53 -0700
Message-ID: <3fb2f3cc-2323-4cd1-8473-e17ab8a2efad@w6rz.net>
Date: Tue, 17 Dec 2024 23:03:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/51] 5.15.175-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170520.301972474@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
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
X-Exim-ID: 1tNo65-000C6c-30
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:32838
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLnh70RZMkijcTeNWsupafuKlGnw7sb7eNkUs4stXKElAlHsHIyD5rRHnFBg4elXQ7eBVVRKXJeYLTZmUCUBsrXgbszKgVGbkh+Zv0FQpxBPAxb7a20m
 AFxt93hkcHaxTgMfVR5M+PZ5WJWnoqnjIyXc+YgU38fKsFp55jGa/olA1fzQ7NKuC6l56uFNKbBSsw==

On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.175 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

