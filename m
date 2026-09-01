Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DEE4A441F
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 23:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788305557; cv=none; b=A1wSfoKuYG6Rh1x1ZZDyKSpzWUrw64rvkgVhEp0d3mlYsHEekl1cpujEPSUZuUT6p+BW2M1YyzcUZbRu1nVmhQZuk+eTeqJAbYhRXRAjhNpNUChQhq6enxcxxgIw8+S3RaT36yvXiPY3xSczRp0tPk6URlcrvQFWbTODxg+G9J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788305557; c=relaxed/simple;
	bh=FMbI/25GzDYGGxci9kF8ed/er+IMLJeXVMzQZM97EAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j2VDeOVFxoIjXvoNs+YNMLGkL5s75nIRKqRcPydqA9H9I9DSCksmLsR6V+ImSMtUzZxd8RhlGHErakgSAabr01Eyx1nApi+7EHegMv73K8VA+jFuO8de+ZlxJCpyYlbaj2pFB2S0/zGzPI2xTZHZ1MevFJWZND01lF1NXqFcBtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=uyrQVk8Z; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="uyrQVk8Z"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id 1W5gxt8i8aC0U1XxvxO4cZ; Tue, 01 Sep 2026 23:32:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 1XxuxP0OrY4rX1XxuxGp5t; Tue, 01 Sep 2026 23:32:31 +0000
X-Authority-Analysis: v=2.4 cv=CI8qXQrD c=1 sm=1 tr=0 ts=6a97608f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=PCLrwS97tSc7yunOaPAA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=f8f/oDVPVdC8qr+c27zpM+APlRN1b0PP8SBOADOOCB8=; b=uyrQVk8ZLcWeCvnAXOEXbaS4wu
	DZbQ1Ws9iRrkJH80CJwsOLBaqf/28V6CXreITMi2voEviNM61yOI/d3EyXajmutZbfkd/mebHpf4a
	Jm1Jslb7jLyXtcVhXavCbWYuaVcsvSJGV3QQuG8ZjnXRvC31x6SjunoAoikPg1mSZvR9gkJSQDHT/
	Ca4mEaLgzpzNe/RHBEhFPjdAWmGlP2X5hzYhLQTUFfW4dM1qdSHVh39DpcDiUxxSkW7ZANy9LlQrQ
	/2cQYYWgAJR74mw17xBgCKijHCPRZFBNVmIt1JtIV7DEq9YQqZZiP9RmX/ii2IOv9uLYKZBRla5Wr
	WiobKDvQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:56868 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x1Xxu-00000002ZYd-03E6;
	Tue, 01 Sep 2026 17:32:30 -0600
Message-ID: <7581e3d8-d2bf-4950-98f8-079d3496be23@w6rz.net>
Date: Tue, 1 Sep 2026 16:32:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/69] 5.15.220-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133358.601894154@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
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
X-Exim-ID: 1x1Xxu-00000002ZYd-03E6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:56868
X-Source-Auth: re@w6rz.net
X-Email-Count: 98
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMD3fDo9hze+HaxavnoJ5dd2qvNnLFaGM5S5Sm9wCp95flutHmzH7sq0bc5DbFNZrMI7dplKeCYDb56FF4rEL+A1hCos+wrQqX1eAlsiUwK6XfQ9iMo4
 9T7PCshxiiKS+JWYUwsXLw36yab0VXPr3HgHGs3HGmvtMb7BkQoaU2N5UMGF9WZBWu7HNhey62zCkA==

On 8/31/26 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.220 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

