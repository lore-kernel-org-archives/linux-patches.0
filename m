Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DBC2AE95
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 04:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709614339; cv=none; b=P+WEnj4l44u1UH9LldhbreC2w4ylSvj00tIJQDaoB8V8BQg5Wk98/KdotCEO2gIzcqboaCuN9fDW8XzyTuCyOcoFkpKkKe+gQ9GMgCiX4MNx+UaWNMN3wBPCEOlp4K/wdjG4CH/vhzKyx8YyCu+UZb3qR6VA4upAW8zkhUdHCDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709614339; c=relaxed/simple;
	bh=w3O8uUX73BTEJvOPL+efjeBGcno32i6iKCcSt1GCKQg=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=rACM2m73IKMvfnxCTytXnfxdiM2Ehb0+N5C/XL2CcC1qPvb7CTPlcD2LigHnTQll30ZgbTQMUOyu/n+9KnKMJnaO8fXf7tHn9tHntcMrqwVTfxk7vQbRhEPeCK+9BhgRTYOQUCOPrScQ0IGQR0yP7Liy97FE5eLBcE+aqhzy41E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=hz/36iRT; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="hz/36iRT"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id hG2frUGpGPM1hhMmmrAEdI; Tue, 05 Mar 2024 04:52:16 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id hMmlrjRxl4W2PhMmmr7J9z; Tue, 05 Mar 2024 04:52:16 +0000
X-Authority-Analysis: v=2.4 cv=RYWWCUtv c=1 sm=1 tr=0 ts=65e6a500
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=K6JAEmCyrfEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=V1Xln7kK5ZI/Vh2KFk42k0Fn0oSg/W2AndNWe6uhYOs=; b=hz/36iRT9l3kg9AkHwwl2kwG5c
	VzIQQqCTOSa5K8+BY/xdlBPH7M2XRxUFBASB01wfqyNUU0bbseRGMy7mFLZ8o8WtvI0WKq1nMo7Zl
	n577i4GQh0jZ4pWNMQEVHT47cGXY0pdQjayu/nSCq0IGnHgjRJskd3um7Q23iTmDbQWrC8R3BQLXV
	wInDaxbJFxm2PG1r5lkKcBbflArZgbSsgKBWeCj8jKQGHmiyQmcyBPxZs9kpmn/3xy7E0/RbdPbAh
	uCrZ2e1zZUmmOxk9JqTOnBg1jTopxxlTmRbdfb1db7+IWX00BC0GhZ2VYHSqkmoz5gdsBuuTbclwQ
	CBcA+KtQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:49132 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rhMmk-0029v2-0g;
	Mon, 04 Mar 2024 21:52:14 -0700
Subject: Re: [PATCH 5.15 00/84] 5.15.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240304211542.332206551@linuxfoundation.org>
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <6a518ca3-aa91-2ffe-3ea1-c6dc5b594320@w6rz.net>
Date: Mon, 4 Mar 2024 20:52:11 -0800
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
X-Exim-ID: 1rhMmk-0029v2-0g
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:49132
X-Source-Auth: re@w6rz.net
X-Email-Count: 39
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMFGQ7YFnbGXAyCn3a8yuJfkW1Zbs4OtajICwv+dSFIyYJHWqJ1EddvNwWRvqpJXAd0e6yO7rsrDPEub0NxQWgXiViA6C6Vxw3y/lmxlwCjdNZDQ4WAc
 1mYZSRqpHrqZer+18E9CeBBsVZab9u1BENJ6U8dwFpMuNV4308Dd+eyCdDMNfTmaD+i0ERxahcnchw==

On 3/4/24 1:23 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.151 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.151-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

