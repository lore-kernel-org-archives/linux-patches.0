Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.89.44.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795144504;
	b=Y7fWzSfhrcW12cb37bZb8GNi3BiCWh3zCojogXAbl7Upkqy9tcEa/BAIHZck72Haj9UN
	 oi5Jof1FzxH8YkMtccVWmfj7YSfupx/OH43V2bbIZQeDAcE9nFx9IoXF9cygR578vZrCv
	 9BmzYs6Xa1AdDmHLkVP+dyV8ZtlZJh1pSPstNKK89oV/gXQa72i1smH3xIsdsrMz/ntdU
	 olmzxm4S53eAuL7OSYJt+JalgmaPiUhXZ81PPhtFoCyB2/UbVZR9E9Z7UKQ9CNupPDQLw
	 dwBp3p8DsuZKXngSbUtAfHhXSdHl6D6KtIUgo+66nBFadUDG1JpbAVaKeYSTK1t1JcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795144504;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=sIt34kRTlhv3m0e1Tfl7/Dz6yo53/Myg2aIV0V/BzPY=;
	b=TUxVp7iVpjDGRg8qoGZ8Y/EruzCiD+hktPL9sPqD/fxCm7RXmkoyhZXF4+dwI3oGutnW
	 wimmV486sKCoj+SH9ev37gmr3wSzi8PmMI/cBvbDT17WAluAzKiRqGy6UOqX+W14yYnuf
	 jXun7VPfY+yFf6A3LeedPtzqeJu1JkNUTNiZD1RNURd85xYtr1Qxr8cC4WjPrCjuCQvpM
	 Qap67SSwZLOxpKP3K/hBllffa36k1zXIVG+FWymxhVzC8aeIQCs9nkaSv+gD6qiLsUORK
	 n1YOyiiWAjFpY3BH5MJHdrHAuVgIJFMOw4eAX8AlLVR3xrSF+JP4g2EL3UpVqUKS/Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=PvRNqu+x;
	arc=none smtp.remote-ip=35.89.44.39
Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555ED606A330
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 03:15:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 555ED606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=PvRNqu+x
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id UEr6x6AXAyb4YUF5WxT7Qu; Fri, 20 Nov 2026 03:14:58 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id UF5VxvE78uJrPUF5VxKGCP; Fri, 20 Nov 2026 03:14:57 +0000
X-Authority-Analysis: v=2.4 cv=WLZ/XmsR c=1 sm=1 tr=0 ts=6affbb31
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=B9BhxveEpzRwE-jvybsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sIt34kRTlhv3m0e1Tfl7/Dz6yo53/Myg2aIV0V/BzPY=; b=PvRNqu+xHfCL0FXt+aqRysimgk
	/HrN+J2kBb0T/hM8BKSOpZgCg2Z7Yw8CoDHLXVGH0xNsNJHOIFacu1G2Hw4v+1NiLhXTmdz38yuZR
	dRiFI9PVQtOjpHw1JUnwN3SMJXZzEXbvavhc+fkEtXx5FzFHS8pj55+t5jnf4qSzaZ9vzs7I9IVQK
	tqY4vfQDv1Q43ukfFo8Jvi3XEsetX0mAjgiH3SVpjVcLgV4K/ns6i7DICLYuxcMF1J7DlEcWgAej0
	kpPjw9cWY3xZwzQTbHB8Yg+/Bc739Wf12fsAUV9AFqJaNRiUTB+5zoB0IeGEWM0TL4D4hZUO9nNiD
	RdmL0GaA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:50260 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xUF5U-000000010vg-1CBA;
	Thu, 19 Nov 2026 20:14:56 -0700
Message-ID: <91bdf95e-74aa-4911-b874-cff75d92224d@w6rz.net>
Date: Thu, 19 Nov 2026 19:14:54 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150247.972732815@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
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
X-Exim-ID: 1xUF5U-000000010vg-1CBA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:50260
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFb5mZ1NVgXfqsi8UCGhdsouxJ+2tPf+I02JXZygM7tQvcJhM9kCDbCkQ5GmFh4rN7OJ5cwrMaRumMtq0MlFQbk7oagqIZm0VAg08s/8/xIKlxtWAjGD
 FazfUCaj4LmdnHG1kmLUuwWF5bJ7MxCiS+Xd1LaLHQAg7pZC8jWhiicPEC5L+HUxykOOCqpXtu37CQ==

On 11/18/26 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

