Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF33AD23
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 07:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748934122; cv=none; b=HPYMnbRppvdBNwqd1FEdEtLdJj4gqArDQHBNxjl58W6ZfXvASKK6hTb/H7v1EtnXUOJ55NOkR4hsXBUCFu6Vc+Sm8716lPGD3dvvU9t/pL6szQgBPndqKy3hrjqT83YQsLlS8DZHfhIqNDVfln0oWDg+BB25/Um6q2QxV6sSuBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748934122; c=relaxed/simple;
	bh=neMNioGQcMY/ThDZFH+CvN16qQngobk9skAxVe3CuBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HUL4+SUw277DXvwhSHX1UaSLEHiYdCcJW4xesUMqb1/hVQsDAgyZtuvgsI3er4N2XoHwJm5KFrHVBPm1Iqybz/LMnujcewvvKdzjKZ+CFTfFIdjoHytOy9s2YFVVCEr2tQ1AakiZ736mLv+npoa/Res9WqO4FI/78RSoc5GxTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=jf110Vpq; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="jf110Vpq"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id MDCOuP6SRXshwMLdGulQCn; Tue, 03 Jun 2025 07:00:23 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id MLdFuZM74Z6h1MLdGuMPjT; Tue, 03 Jun 2025 07:00:22 +0000
X-Authority-Analysis: v=2.4 cv=ergUzZpX c=1 sm=1 tr=0 ts=683e9d86
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=-Qcm0AZxhyoZnww38z8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=VGk5+FWq4dsiLV3+8wImbmAjQ0FM6wtq95qD7L+zx7k=; b=jf110Vpqxs5Xhxhf5+BFdSrtnl
	8ZFwQIJDpULaVGziH7UdSpfVh+L2jhH3kWM6dzSLO4UwDuZcO8eHOyBTrWyxaDtjO84+jJihS7Cq6
	VanT9fdEULfrndl2fGOEe5JweLVu/mP/lQRtj5XclmYj8uDnNgk8HkVBhacXutvWJSl1gpfQ6naNt
	NKpcEXqaPNlXQWaGYyGqir/ZtyWEKYKfxiyJD4zA112Dkh1YcQlDSM9Ex8pxG1+SnFXlTg5/R8H7H
	Qnh/wbZEBad6iDrMypxMEWfqfmLTjTViTMWCy4bt+I3nVSaORq5WTAMB2l1ONMhE9hGy/qRS5mb9T
	peMeZmbg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:34732 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uMLdD-00000001pAm-3aWd;
	Tue, 03 Jun 2025 01:00:19 -0600
Message-ID: <e3201002-8157-4fe4-9b21-39f3e5e5054a@w6rz.net>
Date: Tue, 3 Jun 2025 00:00:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/207] 5.15.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134258.769974467@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1uMLdD-00000001pAm-3aWd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:34732
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHIDGkeWxu2cXEKfmiDXyz3hz9rKcAL2htJxG9FeBFqWY1IAHq90bSNbybRN6LEe3Z1ZE8/n3T8Z2G4a9MVPYfUZ2GFUQCzsotnN/1KmyF9FTjuasByS
 HQdRt9aSC1tc55grTTwV76sKosvXQaAh9sx/dScTHQW3OJt5VjQ+yCBM0Yw8Xi4m2NiaLyEMotde3w==

On 6/2/25 06:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.185 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.185-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build failure on RISC-V.

drivers/clocksource/timer-riscv.c: In function 'riscv_timer_dying_cpu':
drivers/clocksource/timer-riscv.c:82:9: error: implicit declaration of 
function 'riscv_clock_event_stop' [-Werror=implicit-function-declaration]
    82 |         riscv_clock_event_stop();
       |         ^~~~~~~~~~~~~~~~~~~~~~

Caused by the patch "clocksource/drivers/timer-riscv: Stop stimecmp when 
cpu hotplug" commit 60a72ebfdd28510eee8f53a7aadecca1349d4603

The function riscv_clock_event_stop() wasn't added until v6.7-rc1, so 
this patch should be dropped.

