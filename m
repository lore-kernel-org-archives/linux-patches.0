Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0F33CCFBD
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 03:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790221815; cv=none; b=pR4C8uBmw8Ofy34QR58RwLNsAk6lKRCX0T5i5prCM8+wSRqka28YP8A5GjFvIIkSSfnX9jX9LSRcwHOLSYhVw2Aoj2mDFsTCXcRhpSNTtjA6ACkywwTXu8jcvB8Dt6rU/jteP3MzjINxKtkJvyAWIxPDDmp2PdfCdyOQ4AdpWbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790221815; c=relaxed/simple;
	bh=SZ7GsHT8co1hYBRQ1MxrFpOyPv3QmJNstrzyBqgK8C0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=awbty5c0+3fNPlBmfC2dBS4fv34et3Mr55QQvuXe70pk8uDGThOgx6LXgcQcBdSp5ItExyD7hTuaepPI9b2I2iysFRlBD7v7csWRM9HcvpYiohmruItgluobuERO7eDD/PGD+kUCm+HvF5bjPWJ5i/hutPHQbhP9nncM/vpgZxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=4oQvTJFW; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="4oQvTJFW"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id 9Ngsxa6ifaC0U9aTNxIg7u; Thu, 24 Sep 2026 03:50:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 9aTMxUdtoFNcn9aTNx6Y4H; Thu, 24 Sep 2026 03:50:13 +0000
X-Authority-Analysis: v=2.4 cv=K+UiHzWI c=1 sm=1 tr=0 ts=6ab49df5
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sZU3/E8VcenRe+jpr4Zrh8hcTwdKL/4W/UpzOO1JkY8=; b=4oQvTJFWuPPxR2gEjhg6N60MvD
	1oxGQ+1CKC/AKUgI8XUcFHklZLl8NiQdcNXGQnHFxiC0FxBB5ZIUClmWgVrVk4QmZfgphIqrmT5aS
	TsPSnJYx1VnTqlChg/t/MetfMa+PTojj/at/9135RNuJWUlaQuMNG/Epy3c8UDQLiwozM+RKYy19y
	9LBUTfdLrFNgDxZe3zrdSiFAwEva3MNavUzeep2HnFwLvjYIxnPPIovTp9QquE9UGdXVh7+QlRhGv
	D+xNrRZVneSuVzesF0SLa8vtPCu+dEb+HKu6xlPTzrV+6pejKa59TCxVCk/D7p3ESYfcuOiZBsC94
	w33V3fWw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37000 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x9aTM-00000003pxf-0Wt2;
	Wed, 23 Sep 2026 21:50:12 -0600
Message-ID: <007efcf5-f2ed-447d-a6de-5bf8daca3076@w6rz.net>
Date: Wed, 23 Sep 2026 20:50:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/398] 6.18.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260923140643.441954610@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
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
X-Exim-ID: 1x9aTM-00000003pxf-0Wt2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37000
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfN2rQL49I5E+XWDGk8EwqDnKxpZNpd2wSUU3fKM5tNN8RaKZB/36ydtXVgACUhRA9GwfdGAE8JH5SHN3Vv/6Metpah/SyF/jjdWRb4bKzItfP9coWL28
 4qkXKqGM7krrzUmBGLlYq2g6ca/rZC0fcViI0JpYdgKcncML8U4cutZyQZ77vpRqePEJZwg29YUqHA==

On 9/23/26 07:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.54 release.
> There are 398 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Sep 2026 14:05:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

