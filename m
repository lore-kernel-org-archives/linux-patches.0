Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63741A0B05
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724869496; cv=none; b=ImWO6LZHgZK7WrDz6Xsk+53mIVLjc01JZFvoamYJsww2YJZEqOd+fqv/9qp8NMogxuGs6yDRHLV7VyaOh2i4vm13koW/dYZSd7ytU5NQYT+hFjIfveAP58MTW4AwcWWBRiYlZiFJ86tdHTpf57Xlqc1e96mW988GSSGcKbnZnbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724869496; c=relaxed/simple;
	bh=JZQyHkKGKaDjs+iuMPlUS8vcpRWvOGmT1HsxA5FrRJM=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=I3Wo+9nNS8x4lA6yTjW4Y/Hz+DfAuySCpZcO1ACOASBkB/FDYDp+LBfqh3jJn5RiVdGTZo32NNwRQfWixm6z/N6UsYGphQeqdAqQMz1mpTdO2Zu8dM03rwoi6mORooanuDVwxTx8T2UmhQYp3RqHdtW2+5aJ37czyzYn8MyAzCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=b1o9T3fT; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="b1o9T3fT"
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTPS
	id jC8DsXxrSqvuojNLisexZI; Wed, 28 Aug 2024 18:24:54 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id jNLhsFQ1sJ5A8jNLhscs9W; Wed, 28 Aug 2024 18:24:54 +0000
X-Authority-Analysis: v=2.4 cv=U6iUD/ru c=1 sm=1 tr=0 ts=66cf6b76
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=pvbMRhK_gA1k-AccEgoA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0Mz/fo9T66swlgzJnoztxETkSOMafekBx6OnoI658Zw=; b=b1o9T3fTXG8GATLWPjVgqj8cfK
	/0zH1r/QQmn/tctpJmAYH1Epy56I6I6M4TFqJB8fgaspiKaisA0ZhdKCwFP0cX4Ipl3LI8BJ3rfGE
	OzidpG5wGFC1U1PUgH4QLp9s+fKRjazTYwDzgZXMsR41aGFSy+uZONp+8xWaei4RQnkl0xCnsOsCq
	ctaXNqLSkVOAttb7aFaUDJ+orihO3oQzfPGnlhiQQfJWUPFRFjRSCY8PV+/ZaLnFeufT7uKeGYLyh
	bYfrXwZAzgQ68b53v0QDvGbby4IUGJX36VrWhfzzxolc3Xn2z3bOFMTV4FGP0cmP3WnJoRa0h6Qrz
	l/8mge/A==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:37106 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sjNLb-001Lij-04;
	Wed, 28 Aug 2024 12:24:47 -0600
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240827143838.192435816@linuxfoundation.org>
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <4b745682-852e-bbbd-007a-04fd08ece60d@w6rz.net>
Date: Wed, 28 Aug 2024 11:24:41 -0700
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
X-Exim-ID: 1sjNLb-001Lij-04
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:37106
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfI5ENpd6uW79095/rE/WnhY8xpyDlX7e5v8D7lLQ4r/c54pPOaRvnz+5itFaiX+dcvhAH40TF3kOuBesG/LrQxNWTh22Gb2hst1jMxN9QYiZqPrOwkbM
 8JpYFpULcaOjf3OSrBykcaCFqpwP/vEZ0B2+G/WFYmPmWKyTzswzR7lxU984fDB2dQnmpNVt6qPoOA==

On 8/27/24 7:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.107-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

