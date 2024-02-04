Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCD910A09
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 08:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707034475; cv=none; b=m/qtg6nCzx0TmzPgQue5Yy+nTY4zXocfLd+0RGXeFV3wE29d3WuEeztGW69jEjLcLb5wplco59xeNYBwWPdStn2xCNvb3dJhiSvRBClI7KbpvmOV7Pom3CdIT0Xd8YouYi9plz1qANl0+P0vQlQcDC+vIRb0UPy9ft/2boFvPXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707034475; c=relaxed/simple;
	bh=rZoq6b5pkukaVG8jwnirhFvcRHGagrh51WlaI+SeVG4=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=HnJUwhIKC9pIIz4lZZYLe08odX/evpj+w3a0BLyMwKF9YbV4m2kMh/35wfP65I5q/odscZHeTPKLcEC5ZpXyzlWmG6x6dcY3EXXkfRRAGs3nzlbFCpe6RylsR+7uBXsp8OZayLvk4XXnZWtexJh3es0HXACGTqDQojkDkDFS3No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Ghkf/B8s; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Ghkf/B8s"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id WXQ3rfI9eCF6GWXcXrMFNs; Sun, 04 Feb 2024 08:12:57 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id WXcVrdKB82yCoWXcVrPG8t; Sun, 04 Feb 2024 08:12:56 +0000
X-Authority-Analysis: v=2.4 cv=EOGl0EZC c=1 sm=1 tr=0 ts=65bf4708
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=k7vzHIieQBIA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pHq7qycJMCxksKlQHHsrnLJ7JcU6CWtMAm4b1Bs4fcw=; b=Ghkf/B8snnPxdCMD5Ud/dyZ6E4
	+gad47o6/FS0nUOEMd+krH30sRsP7Q1YjfkeCapOk9+epJtWc041g1Dcg0eZO9hKWr8Rsh9LlMyUU
	SY0TsddWzLEjH7ve6q7McYV6X22dMpvLrlwGcO8HJuRcFf8gey+aWEujcHleYgCst4LT84o5+szFc
	ikMmgnjSYT8r2SBjHd1j8gmxDoxP6FYo1Lg3QnR/1wtRG1s57xQfzLwniYWZQOwcC2OFF1KcWx0Xq
	+H78x4KtAQTMi+tmalR53bVilkHPUuLZp/G1LJ+RI4oDMSu3MtU4VicCJHpesl4y2jD4FalQIqP+Y
	pkryFV4w==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:38136 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rWXcT-001HVN-1X;
	Sun, 04 Feb 2024 01:12:53 -0700
Subject: Re: [PATCH 6.7 000/355] 6.7.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240203174813.681845076@linuxfoundation.org>
In-Reply-To: <20240203174813.681845076@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <19dc547a-d718-351a-ae4d-4b91a239db18@w6rz.net>
Date: Sun, 4 Feb 2024 00:12:50 -0800
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1rWXcT-001HVN-1X
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:38136
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDb8ND5Agz9uQ6MmqwEIuFKiOhDUkEuEiHHWfmWB0FhQIITUH0CplAXDn5/IbE2te9cKoY6MVo7EGDjkQtQXQ9SepJgy7BuV7gI++1WHxtsgsuMC1TdK
 0WWWY1Xq56VypTVAqPqmMXoxgxF2WsWjR31clbM35IQc5c7tNn5jTSfvKiY8Ze1ZpXkQTTLfk9Rb0g==

On 2/3/24 9:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.4 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

