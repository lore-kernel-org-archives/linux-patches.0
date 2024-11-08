Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF47A23AD
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 02:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731031854; cv=none; b=KoqDA5t3bT12tgnF0QRUoUkwtSlkXCOehKSQFFbgQXXDvG0pg4Gy341laLKckxlZ7RUvoudhgZUfqbJGTxkj97qL+JcnZcO9wZIpPm2Gds3PLyfqNhKclidzWqXNS/y0iNxne8D7GxwA7LHsecQEJxxNnBBvHmdnit3Ai4pLyss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731031854; c=relaxed/simple;
	bh=I84i66Xxwf/IacDgC84XOWnMKCmic4iuwv4weUi9Hv4=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=kDDsas/5HmIC0nNGjaTKQQYZPfSmMTJCJdtVLJqEuKGUySccZ+2hAqFvh6ff10R9oyMl9YCW5k9RFgfdl5l3Y7vHJS7yA3q9YXDKgQaQDy24fs1NjC7c20N2wEh5NApQJkMKhr3tWbd+RhQn6geJ1YgXdMdsmNyyDSHGudreNxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=mMwR4Fgp; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="mMwR4Fgp"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id 92gHtzN2QiA199ER1tRXYD; Fri, 08 Nov 2024 02:09:15 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 9ER0tDkdUl9Qc9ER1tQZfM; Fri, 08 Nov 2024 02:09:15 +0000
X-Authority-Analysis: v=2.4 cv=TpLghiXh c=1 sm=1 tr=0 ts=672d72cb
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CvRpyJ_MCFv3iDE1wTgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QP6ZiI+V8u+00WCFK2yKqoR4E4JF50VOfCgpa2dTl6s=; b=mMwR4FgpkEYWTApT5CI4lbiOwF
	vZ6REyRVau4cAYydz1XcGeTZGnduQ4HLgPek49hBkLbs28vL+w8n+o19cFqYxeUySO1qTbec1T9SN
	IblY3IHoBs0x1c0N9B4AIhBjnn+NpTgXXmDu6rDFq5A5uBGYL88bMRwPdzMU7PC8rQ7SIdYR113gO
	gT5s8bpbZYWafAuyx+Cq6+/Y4Qc+q7Y4AYMGqAGcGRftqwSJPvcaxnXgTGmPZSRU3HryhCXMkh8vu
	VHad42sZa0cDKQ12L/MxawRx/LgynLSM4mg5QANVehmm2YuRgbsEG6EtgCAvqzcEx/uZx3Sd/qhda
	ANfmStMQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:35490 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1t9EQy-001Pt3-1H;
	Thu, 07 Nov 2024 19:09:12 -0700
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241107064547.006019150@linuxfoundation.org>
In-Reply-To: <20241107064547.006019150@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <95db0e6f-b7db-269a-4f65-96c52a6a90b4@w6rz.net>
Date: Thu, 7 Nov 2024 18:09:09 -0800
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
X-Exim-ID: 1t9EQy-001Pt3-1H
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:35490
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfL5TohD5B6XrLfhCJvXkJEIYxRNdrTja3s6BxJRr4r/ZABOsxtibSECz64BtDVieOOFbcNiBx+LtTzd9FZAnhV8hDls2DK3TrS3Kx8ZGxIQWpiGtHy2c
 b71AvSJWtvIUqB5TXNvpPr+ey71gBSuTOYXDcDmziHl+tP8Tfd+8lvl1rIYSptCk1OS2Qr00Pe09uQ==

On 11/6/24 10:47 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 249 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Nov 2024 06:45:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

